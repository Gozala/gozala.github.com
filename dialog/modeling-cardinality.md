---
title: Modeling Cardinality
date: 2026-02-20
---

# Modeling Cardinality

*How Dialog DB handles concurrent writes from tools with different cardinality assumptions.*

------

Sharing information across tools typically implies consensus on a data model. The [Cambria](https://www.inkandswitch.com/cambria/) project explores what happens as tools evolve independently and that consensus breaks down, proposing composable schema migrations as a way to bridge diverging representations.

Dialog takes a different approach: tools translate to and from a universal representation automatically, derived from their schema definitions. Cross-domain mapping between tools can be added as rules to the substrate by anyone, without either tool needing to anticipate the other.

## Associative Layer

The associative layer accretes information in the form of asserted and retracted claims stored in an indexed probabilistic search tree. It imposes no interpretation on those claims. The only constraint is that claims conform to `{ the, of, is, cause }` format. It exposes an interface to query, assert, and retract claims.

```rust
pub struct Claim {
    /// The relation, identifying the kind of association being established.
    pub the:   (Domain, Name),
    /// The entity this claim is about.
    pub of:    Entity,
    /// The value being linked to the entity through this relation.
    pub is:    Value,
    /// Provenance of this claim, describing who produced it and when.
    pub cause: Provenance,
}

pub struct Provenance {
    /// DID of the operator or session authority that produced the claim.
    pub by: Did,
    /// Coordinated time component, last synchronization cycle.
    pub period: usize,
    /// Uncoordinated local time component, moment within a period.
    pub moment: usize,
}
```

Every claim is linked to a `Provenance` capturing when and where it was asserted. The `by` field identifies the producing authority. The `period` component reflects synchronization with other replicas; the `moment` component captures local ordering within a period. Together they establish a partial order across the distributed system.

```yaml
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zAlice
  cause: { by: did:key:zHome, period: 3, moment: 7 }
```

## Semantic Layer

The semantic layer defines interpretation for the information in the associative layer. Tools operate here, modeling their problem domain and its inherent constraints. A concept is a composition of attributes sharing an entity: asserting a concept decomposes into asserting the claims it comprises; retracting it retracts those claims. Cardinality is one such constraint: a concept may declare that an attribute holds one value or many.

Two independently developed tools might define their concepts like this. Triage, a simple tool that assigns one person per issue:

```yaml
triage:
  Issue:
    where:
      description: issue/description
      status: issue/status
      assignee:
        domain: issue
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
        domain: issue
        assert: Entity
        cardinality: many
```

Both concepts map onto the same underlying attribute in the associative layer. The difference in cardinality is purely a semantic-layer concern. Neither tool was designed with the other in mind, yet they read and write to the same substrate.

This separation enables tools with divergent semantic models to cooperate on shared information without consensus. But it surfaces a question: when independently developed tools disagree about cardinality and write concurrently, how can Dialog carry out each tool's intent without undermining the other.

## The Problem

When Triage wants to change the assignee, it reads the latest value and asserts a new one. But "the latest value" is a semantic-layer idea. The associative layer holds a set of claims with no notion of which is authoritative. If Triage retracts all values for assignee, it silently reverts assignees Squad added. If it retracts nothing, values accumulate indefinitely.

The problem is that a write needs to express intent: specifically which prior claim it means to succeed.

## Causal Assertions

An assertion may carry an optional `cause` field: a causal reference to the provenance of a prior claim this assertion intends to succeed.

```yaml
assert!:
  the:   issue/assignee
  of:    did:key:zIssue42
  is:    did:key:zDana
  cause: { by: did:key:zHome, period: 3, moment: 9 }
```

When `cause` is absent, no succession is intended and the assertion is additive. When `cause` is present, the intent is to succeed the referenced claim and make the asserted value current.

The transactor resolves this by looking at all existing claims for the same entity-attribute pair.

### Already Current

If the asserted value is already present and is already the latest, nothing changes.

Squad has assigned Alice, Bob, and Carol to the issue:

```yaml
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zAlice
  cause: { by: did:key:zHome, period: 3, moment: 7 }
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zBob
  cause: { by: did:key:zHome, period: 3, moment: 8 }
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zCarol
  cause: { by: did:key:zHome, period: 3, moment: 9 }  # ← latest
```

Squad promotes Carol — she just accepted the task — by asserting her with `cause` pointing to her current claim's provenance:

```yaml
assert!:
  the:   issue/assignee
  of:    did:key:zIssue42
  is:    did:key:zCarol
  cause: { by: did:key:zHome, period: 3, moment: 9 }
```

Carol is already the latest, so the assertion is redundant and nothing changes.

### Promoted to Current

If the asserted value is already present but is not the latest, it is promoted: retracted and re-asserted with a new provenance.

Triage reads Dana as the latest assignee and reassigns to Bob, who is already present but not current:

```yaml
assert!:
  the:   issue/assignee
  of:    did:key:zIssue42
  is:    did:key:zBob
  cause: { by: did:key:zWork, period: 4, moment: 1 }
```

Bob exists but is not the latest, so he is promoted and Dana is retracted:

```yaml
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zAlice
  cause: { by: did:key:zHome, period: 3, moment: 7 }
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zCarol
  cause: { by: did:key:zHome, period: 3, moment: 9 }
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zBob
  cause: { by: did:key:zWork, period: 4, moment: 2 }  # ← latest; dana retracted
```

Triage sees Bob as current. Squad sees Alice, Carol, and Bob. Promotion achieves the intent without unintentionally undoing an assignment made by Squad.

### New value, multiple claims

If the asserted value is not present and multiple claims exist, the new value is asserted without retraction.

Triage reads Carol as the latest and reassigns to Dana:

```yaml
assert!:
  the:   issue/assignee
  of:    did:key:zIssue42
  is:    did:key:zDana
  cause: { by: did:key:zHome, period: 3, moment: 9 }
```

Dana is new and multiple claims exist, so she is asserted without retracting Carol:

```yaml
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zAlice
  cause: { by: did:key:zHome, period: 3, moment: 7 }
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zBob
  cause: { by: did:key:zHome, period: 3, moment: 8 }
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zCarol
  cause: { by: did:key:zHome, period: 3, moment: 9 }
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zDana
  cause: { by: did:key:zWork, period: 4, moment: 1 }  # ← latest
```

Triage queries the latest and gets Dana. Squad sees all four assignees. Retracting Carol would have accomplished Triage's intent but also undone an assignment Squad made intentionally. If Triage wants to explicitly remove an assignee, it can do so through retraction.

### New value, sole claim

If the asserted value is not present and `cause` is the only claim, it is retracted and the new value asserted in its place.

Squad has assigned Alice as the sole assignee:

```yaml
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zAlice
  cause: { by: did:key:zHome, period: 3, moment: 7 }  # ← only claim
```

Triage reads Alice as the latest and reassigns to Bob:

```yaml
assert!:
  the:   issue/assignee
  of:    did:key:zIssue42
  is:    did:key:zBob
  cause: { by: did:key:zHome, period: 3, moment: 7 }
```

Alice is the only claim, so she is retracted and Bob asserted in her place:

```yaml
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zBob
  cause: { by: did:key:zHome, period: 3, moment: 8 }  # ← latest; alice retracted
```

From Squad's perspective an assignee it added was replaced by Triage, which is arguably more disruptive than simply asserting without retraction. Still, the behavior is within reason and offers a fair compromise keeping cardinality a semantic layer concern.

An alternative would carry cardinality into the associative layer so the transactor could detect that the sole existing claim was asserted with cardinality-many and proceed without retraction. This would make this case consistent with the multi-claim case, but at the cost of leaking cardinality into the associative layer — precisely what the two-layer design is meant to avoid.
