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
  of: did:key:zIssue42
  is: did:key:zAlice
  cause:
  	by: did:key:zHome
  	period: 3
  	moment: 7
```

## Semantic Layer

The semantic layer defines interpretation for the information in the associative layer. Tools operate here, modeling their problem domain and its inherent constraints. A concept is a composition of attributes sharing an entity: asserting a concept decomposes into asserting the claims it comprises; retracting it retracts those claims. Cardinality is one such constraint: a concept may declare that an attribute holds one value or many.

Two independently developed tools might define their concepts like this. Triage, a simple tool that assigns one person per issue:

```yaml
triage:
  Issue:
    with:
      description: issue/description
      status: issue/status
      assignee:
        the: issue/assignee
        as: Entity
```

Squad, a team-oriented tool that models the same domain as incidents with multiple assignees:

```yaml
squad:
  Incident:
    with:
      overview: issue/description
      status: issue/status
      assignee:
        the: issue/assignee
        as: Entity
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
  cause:
  	by: did:key:zHome
  	period: 3
  	moment: 9
```

When `cause` is absent, no succession is intended and the assertion is additive. When `cause` is present, the intent is to succeed the referenced claim and make the asserted value current.

The transactor resolves this by looking at all existing claims for the same entity-attribute pair.

#### Starting Condition

We will consider following as our starting condition for all the scenarios. Squad has assigned Alice, Bob, and Carol to the issue:

```yaml
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zAlice
  cause:
  	by: did:key:zSquad
  	period: 2
  	moment: 3
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zBob
  cause:
  	by: did:key:zSquad
  	period: 3
  	moment: 8
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zCarol
  cause:
  	by: did:key:zSquad
  	period: 4
  	moment: 2
```

### Already Current

Triage asserts Carol as assignee. It is redundant but Triage has not looked at latest assignee.

```yaml
assert!:
  the: issue/assignee
  of: did:key:zIssue42
  is: did:key:zCarol
```

Carol is already an assignee, so the assertion is redundant and no associations are made.

### Promote as Current

If the asserted value is already present but is not the latest, it gets promoted: retracted and re-asserted with a new provenance.

Triage sees Carol as the latest assignee and re-assigns issue to Bob. From Squad's perspective Bob is already an assignee even though not latest:

```yaml
assert!:
  the: issue/assignee
  of: did:key:zIssue42
  is: did:key:zBob
  cause:
  	by: did:key:zSquad
  	period: 4
  	moment: 2
```

Since assignment to Bob already exists but is not the latest, assignment gets promoted to latests:

```yaml
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zAlice
  cause:
  	by: did:key:zSquad
  	period: 2
  	moment: 3
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zCarol
  cause:
  	by: did:key:zSquad
  	period: 4
  	moment: 2
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zBob
  cause:
  	by: did:key:zTriage
  	period: 5
  	moment: 1
```

Triage sees Bob as assignee. Squad sees Alice, Carol, and Bob all as assignees. Promotion achieves the intent without unintentionally undoing an assignment to Carol that Squad asserted.

### New value, multiple claims

If the asserted value is not present and multiple claims exist, the new value is asserted without retraction.

Triage reads Carol as the latest and asserts Dana as an assignee, capturing provenance to latest assignment:

```yaml
assert!:
  the: issue/assignee
  of: did:key:zIssue42
  is: did:key:zDana
  cause:
  	by: did:key:zSquad
  	period: 4
  	moment: 2
```

Assignment for Dana does not exists, however multiple other assignments exist, so transactor asserts Dana without retracting Carol, despite causal relation:

```yaml
- the: issue/assignee
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zAlice
  cause:
  	by: did:key:zSquad
  	period: 2
  	moment: 3
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zBob
  cause:
  	by: did:key:zSquad
  	period: 3
  	moment: 8
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zCarol
  cause:
  	by: did:key:zSquad
  	period: 4
  	moment: 2
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zDana
  cause:
  	by: did:key:zTriage
  	period: 5
  	moment: 7
```

Triage sees Dana as assignee. Squad sees Alice, Bob, Carol and Dana as assignees. Retracting Bob would have accomplished Triage's intent, but would have undone Squad's assignment. Retracting Bob perhaps would not have being particularly confusing, however that was not Triage's intention it would have being side-effect of it's intention within the cardinality one constraint. If Triage's intent was to unassign Carol, that could have being accomplished through explicit retraction.

### New value, sole claim

If the asserted value is not present and `cause`al relation is to sole claim, it is retracted and the new value asserted in its place.

Here we consider different starting condition, where Squad has assigned Alice as the sole assignee:

```yaml
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zAlice
  cause:
  	by: did:key:zHome
  	period: 3
  	moment: 7
```

Triage sees Alice as assignee and reassigns issue to Bob:

```yaml
assert!:
  the: issue/assignee
  of: did:key:zIssue42
  is: did:key:zBob
  cause:
  	by: did:key:zHome
  	period: 3
  	moment: 7
```

Alice is the sole, causally linked, claim, therefor transactor retracts and asserts Bob as assignee:

```yaml
- the: issue/assignee
  of:  did:key:zIssue42
  is:  did:key:zBob
  cause:
  	by: did:key:zWork
  	period: 4
  	moment: 1
```

From Squad's perspective an assignee it added was replaced by Triage, which is arguably more disruptive than simply asserting without retraction. Still, behavior is within the reason and offers a fair compromise that allows keeping cardinality a semantic layer concern.

## Closing Thoughts

An alternative design could carry cardinality information into the associative layer and allow transactor to detect that the sole claim is asserted with cardinality-many and assert without retraction. This would make this case consistent with the multi-claim case, but at the cost of leaking cardinality into the associative layer. It also would introduce additional complexity with concurrent updates where multiple cardinality one assertions may exists, where it would not be obvious if new assertion would need to retract both or just assert new.
