# Modeling Cardinality

*How Dialog DB handles concurrent writes from tools with different cardinality assumptions.*

------

Sharing information across tools typically implies consensus on a data model. The [Cambria](https://www.inkandswitch.com/cambria/) project explores what happens as tools evolve independently and that consensus breaks down, proposing composable schema migrations as a way to bridge diverging representations.

Dialog takes a different approach: tools translate to and from a universal representation automatically, derived from their schema definitions. Cross-domain mapping between tools can be added as rules to the substrate by anyone, without either tool needing to anticipate the other.

## Semantic Layer

The semantic layer accretes information in the form of asserted and retracted relations stored in an indexed probabilistic search tree. It imposes no interpretation on those relations. The only constraint is that relations conform to `{ the, of, is, cause }` format. It exposes an interface to query, assert, and retract relations.

```rust
pub struct Relation {
    /// Asserted attribute (a.k.a predicate)
    pub the:   (Namespace, Name),
    /// The entity (subject) of the relation
    pub of:    Entity,
    /// The value (object) of the relation
    pub is:    Value,
    /// Logical timestamp establishing partial order
    pub cause: Occurrence,
}

pub struct Occurrence {
    /// DID of the site where this occurrence happened.
    pub site: Did,
    /// Coordinated time component, last synchronization cycle.
    pub period: usize,
    /// Uncoordinated local time component, moment within a period.
    pub moment: usize,
}
```

Every relation is linked to an `Occurrence` capturing when and where it was asserted. The `site` is a unique replica identifier. The `period` component reflects synchronization with other replicas; the `moment` component captures local ordering within a period. Together they establish a partial order across the distributed system.

```yaml
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zAlice
  cause: { site: did:key:zHome, period: 3, moment: 7 }
```

## Conceptual Layer

The conceptual layer defines interpretation for the information in the semantic layer. Tools operate here, modeling their problem domain and its inherent constraints. A concept is a map describing a set of relations: asserting a concept decomposes into asserting the relations it comprises; retracting it retracts those relations. Cardinality is one such constraint: a concept may declare that an attribute holds one value or many.

Two independently developed tools might define their concepts like this. Triage, a simple tool that assigns one person per issue:

```yaml
triage:
  Issue:
    where:
      description: issue/description
      status: issue/status
      assignee:
        namespace: issue
        assert: Entity
```

Squad, a team-oriented tool that models the same domain as incidents with multiple assignees:

```yaml
squad:
  Incident:
    where:
      overview: issue/description
      status: issue/status
      assignee:
        namespace: issue
        assert: Entity
        cardinality: many
```

Both concepts map onto the same underlying attribute in the semantic layer. The difference in cardinality is purely a conceptual-layer concern. Neither tool was designed with the other in mind, yet they read and write to the same substrate.

This separation enables tools with divergent conceptual models to cooperate on shared information without consensus. But it surfaces a question: when independently developed tools disagree about cardinality and write concurrently, how can Dialog carry out each tool's intent without undermining the other.

## The Problem

When Triage wants to change the assignee, it reads the latest value and asserts a new one. But "the latest value" is a conceptual-layer idea. The semantic layer holds a set of relations with no notion of which is authoritative. If Triage retracts everything, it silently destroys assignees Squad added. If it retracts nothing, values accumulate indefinitely.

The problem is that a write needs to express intent: specifically which prior relation it means to succeed.

## Causal Assertions

An assertion may carry an optional `cause` field: a causal reference to the `Occurrence` of a prior relation this assertion intends to succeed.

```yaml
assert!:
  the:   issue/assignee
  of:    did:key:zIssue42
  is:    did:key:zDana
  cause: { site: did:key:zHome, period: 3, moment: 9 }
```

When `cause` is absent, no succession is intended and the assertion is additive. When `cause` is present, the intent is to succeed the referenced relation and make the asserted value current.

The transactor resolves this by looking at all existing relations for the same entity-attribute pair.

### Already Current

If the asserted value is already present and is already the latest, nothing changes.

Squad has assigned Alice, Bob, and Carol to the issue:

```yaml
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zAlice
  cause: { site: did:key:zHome, period: 3, moment: 7 }
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zBob
  cause: { site: did:key:zHome, period: 3, moment: 8 }
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zCarol
  cause: { site: did:key:zHome, period: 3, moment: 9 }  # ← latest
```

Squad promotes Carol — she just accepted the task — by asserting her with `cause` pointing to her current occurrence:

```yaml
assert!:
  the:   issue/assignee
  of:    did:key:zIssue42
  is:    did:key:zCarol
  cause: { site: did:key:zHome, period: 3, moment: 9 }
```

Carol is already the latest, so the assertion is redundant and nothing changes.

### Promoted to Current

If the asserted value is already present but is not the latest, it is promoted: retracted and re-asserted at a new occurrence.

Triage reads Dana as the latest assignee and reassigns to Bob, who is already present but not current:

```yaml
assert!:
  the:   issue/assignee
  of:    did:key:zIssue42
  is:    did:key:zBob
  cause: { site: did:key:zWork, period: 4, moment: 1 }
```

Bob exists but is not the latest, so he is promoted and Dana is retracted:

```yaml
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zAlice
  cause: { site: did:key:zHome, period: 3, moment: 7 }
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zCarol
  cause: { site: did:key:zHome, period: 3, moment: 9 }
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zBob
  cause: { site: did:key:zWork, period: 4, moment: 2 }  # ← latest; dana retracted
```

Triage sees Bob as current. Squad sees Alice, Carol, and Bob. Promotion achieves the intent without unintentionally undoing an assignment made by Squad.

### New value, multiple relations

If the asserted value is not present and multiple relations exist, the new value is asserted without retraction.

Triage reads Carol as the latest and reassigns to Dana:

```yaml
assert!:
  the:   issue/assignee
  of:    did:key:zIssue42
  is:    did:key:zDana
  cause: { site: did:key:zHome, period: 3, moment: 9 }
```

Dana is new and multiple relations exist, so she is asserted without retracting Carol:

```yaml
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zAlice
  cause: { site: did:key:zHome, period: 3, moment: 7 }
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zBob
  cause: { site: did:key:zHome, period: 3, moment: 8 }
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zCarol
  cause: { site: did:key:zHome, period: 3, moment: 9 }
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zDana
  cause: { site: did:key:zWork, period: 4, moment: 1 }  # ← latest
```

Triage queries the latest and gets Dana. Squad sees all four assignees. Retracting Carol would have accomplished Triage's intent but also undone an assignment Squad made intentionally. If Triage wants to explicitly remove an assignee, it can do so through retraction.

### New value, sole relation

If the asserted value is not present and `cause` is the only relation, it is retracted and the new value asserted in its place.

Squad has assigned Alice as the sole assignee:

```yaml
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zAlice
  cause: { site: did:key:zHome, period: 3, moment: 7 }  # ← only relation
```

Triage reads Alice as the latest and reassigns to Bob:

```yaml
assert!:
  the:   issue/assignee
  of:    did:key:zIssue42
  is:    did:key:zBob
  cause: { site: did:key:zHome, period: 3, moment: 7 }
```

Alice is the only relation, so she is retracted and Bob asserted in her place:

```yaml
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zBob
  cause: { site: did:key:zHome, period: 3, moment: 8 }  # ← latest; alice retracted
```

From Squad's perspective an assignee it added was replaced by Triage, which is arguably more disruptive than simply asserting without retraction. Still, the behavior is within reason and offers a fair compromise keeping cardinality a conceptual layer concern.

An alternative would carry cardinality into the semantic layer so the transactor could detect that the sole existing relation was asserted with cardinality-many and proceed without retraction. This would make this case consistent with the multi-relation case, but at the cost of leaking cardinality into the semantic layer — precisely what the two-layer design is meant to avoid.