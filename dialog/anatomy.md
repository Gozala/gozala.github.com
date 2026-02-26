---
title: Anatomy of Dialog
date: 2026-02-25
---

# Anatomy of Dialog

A working draft describing Dialog's design through its core terminology. Dialog is an information substrate composed of three layers: the [associative layer](#associative-memory), which stores and replicates information, the [semantic layer](#semantic-interpretation), which interprets it, and the [reactive layer](#reactive-behavior), which responds to it.

## Layers

### Associative (Memory)

The memory layer of the information substrate. Accretes all [claims](#claim) as an immutable, append-only history. What you work with locally is a working subset of a conceptually vast pool of information, replicated on demand. The associative layer consists of two regions:

- **Replicated region**: [Claims](#claim) replicated on demand across peers. New data is pulled in as queries and operations require it.
- **Ephemeral region**: A local, session-bound overlay for [claims](#claim) that do not need to survive beyond the current session.

[Claims](#claim) are indexed in two ways:

- **Operative indexes** (EAV/AVE/VAE): Provide the current state of the world. [Retractions](#assertion--retraction) evict assertion-claims from these indexes, giving a live view of what is presently true.

- **Temporal index**: Preserves the complete history, including [retractions](#assertion--retraction). Nothing is ever lost here.

  > ℹ️ "Never lost" is conceptual: an owner may choose to erase portions of the temporal index, denying access to that history.

The associative layer is self-describing: the primitives used to model a domain are themselves [claims](#claim) (replicated or ephemeral), content-addressed by the hash of their structure.

### Semantic (Interpretation)

The interpretation layer of the information substrate. Operates at query time, reading domain modeling primitives from the [associative layer](#associative-memory) and resolving them to produce [conclusions](#conclusion). [Assertions](#assertion--retraction) made at this layer are interpreted and decomposed into [claims](#claim) in the [associative layer](#associative-memory). Tools operate here, modeling their problem domain and its inherent constraints using semantic layer primitives.

### Reactive (Behavior)

The behavioral layer of the information substrate. Where the [semantic layer](#semantic-interpretation) interprets what is in the [associative layer](#associative-memory), the reactive layer responds to it. Processes in the reactive layer observe [concepts](#concept) and [relations](#relation), and in response produce new [claims](#claim) that get [asserted](#assertion--retraction) back into the [associative layer](#associative-memory). This shifts from modeling the interpretation of data to modeling the behavior of the system, how it evolves over time in response to what it observes.

## Associative layer primitives

### Claim

An [assertion or retraction](#assertion--retraction) that has been incorporated by the transactor. Claims are the fundamental unit of the [associative layer](#associative-memory). A claim is composed of:

- **of**: The entity this claim is about.

- **the**: The [relation](#relation), identifying the kind of association being established. Comprised of a `domain/name` pair.

- **is**: The value being linked to the entity through this [relation](#relation).

- **cause**: The provenance of this claim, describing who produced it and when. A provenance captures:

  - **by**: The DID of the operator or session authority that produced the claim.
  - **period**: A coordinated time component denoting the last synchronization cycle.
  - **moment**: A local, uncoordinated time component denoting the moment within a period at which the claim was produced.

  This construction, inspired by [Hybrid Logical Clocks](https://sergeiturukin.com/2017/06/26/hybrid-logical-clocks.html), establishes causal relations between claims, allowing Dialog to resolve conflicts.

Every claim is permanent in the temporal index: [retractions](#assertion--retraction) do not destroy assertion-claims, they evict them from the operative indexes while the temporal index retains everything. Transactions themselves are also captured as claims, recording all the [assertions and retractions](#assertion--retraction) they incorporated.

## Shared primitives

### Relation

Relations categorize [claims](#claim) into groups by the kind of association being established.

In the [associative layer](#associative-memory), a relation corresponds to the **the** component of a [claim](#claim), comprised of a nominal **domain** (scoping the relation to a specific problem area) and **name** (identifying the specific kind of association within that domain), denoted as `domain/name`.

The [semantic layer](#semantic-interpretation) denotes relations through [attributes](#attribute), which further refine categories by type and cardinality.

### Assertion / Retraction

Proposed changes submitted to the transactor. An assertion proposes that a [relation](#relation) holds; a retraction proposes that it no longer does. Assertions and retractions also operate at the [semantic layer](#semantic-interpretation): asserting or retracting a [conclusion](#conclusion) (a materialized [concept](#concept)) is translated by the semantic layer into the corresponding [claim](#claim) assertions and retractions.

## Semantic layer primitives

The building blocks of the [semantic layer](#semantic-interpretation). All are [claims](#claim) in the [associative layer](#associative-memory) (replicated or ephemeral), identified by entities derived from the hash of their structure.

### Attribute

A [relation](#relation) elevated with domain-specific invariants. An attribute extends a relation's `domain/name` identifier with cardinality and type constraints, specifying what kind of values the association admits and how many.

### Concept

A composition of [attributes](#attribute) sharing an entity. A concept describes the shape of a thing in terms of its [relations](#relation), much like a type or class in a programming language, but realized through schema-on-read rather than schema-on-write. Concepts are the primary unit of domain modeling.

#### Conclusion

A realized [concept](#concept) instance, assembled from [claims](#claim) matching the [attributes](#attribute) described by the concept. [Conclusions](#conclusion) are what the [semantic layer](#semantic-interpretation) produces when it resolves [concepts](#concept) against [claims](#claim).

#### Bidirectional mapping

A concept acts as a bidirectional mapping (a lens) into the [associative layer](#associative-memory). In one direction, querying a concept composes matching [claims](#claim) into [conclusions](#conclusion). In the other, [asserting](#assertion--retraction) a concept instance decomposes into asserting the individual [claims](#claim) for each of its constituent [attributes](#attribute).

### Formula

A pure computation, similar to formulas in a spreadsheet. Formulas are effectively built-in [rules](#deductive-rule): given bound input fields, a formula derives output fields. Formulas can be used within [rules](#deductive-rule) and queries to compute values, filter matches, or transform data without leaving the query engine.

### (Deductive) Rule

An advanced form of composition that goes beyond stitching [attributes](#attribute) together. Rules can impose additional constraints, compute derived values using [formulas](#formula), and follow transitive paths across [relations](#relation). A rule's body is a set of premises; its conclusion is a [concept](#concept) instance. Rules are unidirectional, because a conclusion may distill or aggregate information from its premises in ways that cannot be undone (for example, a sum of two values cannot be reversed into the exact numbers it was computed from). A set of rules can offer bidirectionality, but only when the mapping is inherently non-lossy. Rules are resolved at query time by the [semantic layer](#semantic-interpretation).

## Reactive layer primitives

### (Inductive) Rule

A rule evaluated within the system, grounded in the theory of [Dedalus](https://www2.eecs.berkeley.edu/Pubs/TechRpts/2009/EECS-2009-173.pdf), a Datalog dialect that extends [deductive rules](#deductive-rule) with a temporal dimension. Where [deductive rules](#deductive-rule) interpret what is already in the [associative layer](#associative-memory), inductive rules react to it: they produce [conclusions](#conclusion) that get [asserted](#assertion--retraction) back as new [claims](#claim).

Inductive rules have been prototyped but are not yet fully implemented. See the [prototype](https://app.radicle.xyz/nodes/seed.radicle.garden/rad%3Az2goHmaCGxnXXxZ3hMJSN9jeEFv3w/tree/test/render.spec.js).

### Effect

An external behavior. Where [inductive rules](#inductive-rule) run inside the system, effects are processes outside the system boundary that observe [concepts](#concept) and [relations](#relation), and in reaction run computation externally. Effects can produce new [assertions](#assertion--retraction) back into Dialog, connecting external systems and side effects to the information substrate.

A user interface is a natural example of an effect: it observes [conclusions](#conclusion) and renders them to screen, while user interactions assert [concepts](#concept) back into Dialog.
