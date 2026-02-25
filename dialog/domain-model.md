- # Domain Modeling

  > ℹ️ Different tools may expose different interfaces for working with dialog. This document is focused on YAML notation.

  Dialog organizes domain modeling across two layers. The **semantic layer** accretes information as immutable Entity-Attribute-Value (**EAV**) relations, the record of everything that has been asserted or retracted, growing over time but never losing history. The **conceptual layer** sits on top, providing an interpretation of that underlying information, introducing attributes that constrain and give meaning to relations, concepts that group attributes into structured views over entities, and rules that derive conclusions from existing information. The same information can be interpreted through different conceptual lenses without changing what is recorded below. The two layers are not separate systems; the conceptual layer is always defined in terms of the information in the semantic layer, and that boundary is always transparent.

  ```mermaid
  block-beta
    columns 1
    block:conceptual
      columns 3
      Attribute["Attributes"] Concept["Concepts"] Rule["Rules"]
    end
    space
    block:semantic
      columns 2
      Assert["Assertion"] Retract["Retraction"]
    end
    conceptual --> semantic
    semantic --> conceptual
  ```


  ## Semantic Layer

  The semantic layer accretes information. Asserting and retracting relations are both additive operations that append to an ever-growing record and nothing is lost. The layer makes no assumptions about structure or shape beyond the basic EAV relation and imposes no invariants. Conflicting assertions for the same entity and attribute can coexist side by side. Interpretation is a concern of the conceptual layer above.

  ### Relations

  An EAV relation is an immutable assertion *(or retraction)* that some entity has some attribute with some value:

  ```yaml
  the: diy.cook/quantity
  of: carrot
  is: 2
  ```

  Relations can be asserted or retracted without having to define those relations in advance, keeping the semantic layer open-ended. The layer simply accretes; it does not validate, enforce, or interpret.

  ### Entities

  An entity is a stable identifier representing a thing in the world: a person, a recipe, an event, anything. Entities have no intrinsic structure or type; what an entity *is* emerges from the relations asserted about it. The same entity can accumulate relations from multiple namespaces over time without any prior declaration. Two entities are the same if and only if their identifiers are the same; identity is the only thing an entity brings to the table.

  Entity identifiers are always derived from information about the entity itself, typically a cryptographic hash of the state at genesis. This means the same information introduced independently in two different places will converge onto the same identifier, which is a useful property in a distributed setting.

  > ℹ️ Some deliberation is required in practice, because sometimes origin is itself part of what makes something unique. A measurement taken twice under identical conditions may warrant two distinct entities; the same recipe published in two places probably does not. Deciding what subset of information captures the identity of a thing is a modeling choice, not a technical one.


  ## Conceptual Layer

  The conceptual layer provides an interpretation of the information accreted in the semantic layer. It introduces **attributes** that constrain and give meaning to relations, **concepts** that group attributes into structured views over entities, and **rules** that derive conclusions from existing information. Where the semantic layer simply accretes, the conceptual layer decides what that accumulation means: which entities qualify as a `Recipe`, what it means to assert an `Ingredient`, how an `AllergyConflict` is derived from the relations that exist.

  ### Attributes

  An attribute is a description that a relation either satisfies or does not. Its namespace, name, type, and cardinality together define a category of EAV relations that fall under it. In interpreting relations this way the conceptual layer introduces its first invariant: **cardinality**.

  > ℹ️ In YAML notation, attributes are defined under a namespace key. The label under which an attribute is defined implies its name, and the enclosing namespace key implies its namespace — so `title` defined under `diy.cook` becomes `diy.cook/title`.

  ```yaml
  diy.cook:
    title:
      the: The name of this recipe
      assert: Text
  
    quantity:
      the: Quantity of the ingredient
      assert: Integer
  ```

  The `the` field is a human readable description stored as information alongside the attribute and queryable like any other. The `assert` field declares what kind of value the relation carries; `Text` and `Integer` are scalar types from the `dialog` namespace.

  Some attributes have values drawn from a fixed set of symbols rather than an open scalar type:

  ```yaml
  diy.cook:
    unit:
      the: The unit of measurement
      assert: [:tsp, :mls]
  ```

  `[:tsp, :mls]` means the value must be one of those symbols in fully qualified form, `diy.cook/tsp` or `diy.cook/mls` respectively.

  Attributes can also reference concepts as their value type, expressing that the relation points to an entity satisfying a given concept:

  ```yaml
  diy.cook:
    ingredient:
      the: An ingredient in a recipe
      assert: .Ingredient
  ```

  `.Ingredient` resolves to `diy.cook/Ingredient` within the current namespace. We will define what `Ingredient` means as a concept in the next section.

  #### Cardinality

  Cardinality governs what happens when a new relation is asserted for an attribute an entity already has a value for. With `cardinality: many`, the new relation is added alongside existing ones:

  ```yaml
  diy.cook:
    ingredient:
      the: An ingredient in a recipe
      assert: .Ingredient
      cardinality: many
  ```

  With `cardinality: one`, the default when omitted, asserting a new value retracts the prior relation so at most one value can exist at a time. The semantic layer beneath is indifferent to both; it is the conceptual layer that decides what to do with prior relations before asserting new ones.

  ```mermaid
  sequenceDiagram
      participant App
      participant Conceptual
      participant Semantic
  
      Note over Semantic: { of: carrot, the: diy.cook/quantity, is: 2 }
  
      App->>Conceptual: assert quantity: 5 (cardinality: one)
      Conceptual->>Semantic: retract { of: carrot, the: diy.cook/quantity, is: 2 }
      Conceptual->>Semantic: assert { of: carrot, the: diy.cook/quantity, is: 5 }
      Note over Semantic: { of: carrot, the: diy.cook/quantity, is: 5 }
  
      App->>Conceptual: assert ingredient: pepper (cardinality: many)
      Conceptual->>Semantic: assert { of: recipe, the: diy.cook/ingredient, is: pepper }
      Note over Semantic: { of: recipe, the: diy.cook/ingredient, is: carrot }<br/>{ of: recipe, the: diy.cook/ingredient, is: pepper }
  ```

  #### Identity and References

  An attribute's identity is its components: `(namespace, name, type, cardinality)`. They don't *derive* an identifier, they *are* the identifier. The label under which an attribute is defined and the path used to reference it are distinct from that identity; they are just how you address it.

  By default the label implies the name and the enclosing namespace key implies the namespace, but both can be overridden explicitly. This makes it possible to define two attributes with the same namespace and name but different types in the same file:

  ```yaml
  diy.cook:
    quantity-int:
      name: quantity
      the: Quantity as a whole number
      assert: Integer
  diy.cook:
    quantity-float:
      name: quantity
      the: Quantity as a decimal
      assert: Float
  ```

  Both define an attribute named `quantity` in `diy.cook` but with different types, making them distinct. They are referenceable as `diy.cook/quantity-int` and `diy.cook/quantity-float`; the label becomes the path segment used to address them, not the name component of their identity.

  Attributes defined inline within a concept follow the same rules. The label implies the name and the namespace is derived from the concept's own path:

  ```yaml
  diy.cook:
    quantity:
      assert: Integer
  
    Example:
      where:
        name:
          assert: Text
  ```

  expands to:

  ```yaml
  diy.cook:
    quantity:
      assert: Integer
  
    Example:
      where:
        name: diy.cook.example/name
  
  diy.cook.example:
    name:
      assert: Text
  ```

  `name` defined inline inside `diy.cook/Example` lives at `diy.cook.example/name` and can be referenced from anywhere by that path.

  ### Concepts

  A concept is a named set of attributes grouped by entity, the primary means of combination in dialog. Where an attribute interprets a single relation, a concept combines multiple attributes into a structured view over an entity, giving meaning to a collection of relations that belong together. The conceptual layer uses this structure to decide which entities qualify: an entity is an `Ingredient` if and only if it has all the relations the concept requires.

  ```yaml
  diy.cook:
    Ingredient:
      the: The meal ingredient
      where:
        name: .ingredient-name
        quantity: .
        unit: .
  
    RecipeStep:
      the: A cooking step
      where:
        instruction: .
      option:
        after:
          the: Step to perform this after
          assert: .RecipeStep
  
    Recipe:
      the: A meal recipe
      where:
        title: .
        ingredient: .
        steps: .recipe-step
  ```

  Fields under `where` are required; an entity must have all those relations to match the concept. Fields under `option` are optional; the entity may or may not have those relations and will still match if all required fields are present.

  > ℹ️ In Rust optional attributes translate to optional fields like `after: Option<RecipeStep>`. In TypeScript they translate to `after?: RecipeStep`.

  `.` is shorthand for "same name, current namespace" so `quantity: .` expands to `quantity: diy.cook/quantity`. Attributes defined inline inside `where` or `option` follow the same label and namespace rules; `after` defined inside `RecipeStep` lives at `diy.cook.recipe-step/after`.

  A concept provides a bidirectional mapping between the conceptual and semantic layers. Querying a concept finds all entities whose relations satisfy its fields and realizes them as structured values. Asserting a concept translates each field into the corresponding EAV relation and asserts it; retracting a concept retracts each relation. The underlying relations are an implementation detail; callers work entirely in terms of the concept:

  ```mermaid
  flowchart LR
      subgraph Conceptual
          I["Ingredient\n────────\nname: carrot\nquantity: 2\nunit: tsp"]
      end
  
      subgraph Semantic
          F1["{ of: carrot-entity\n  the: diy.cook/ingredient-name\n  is: 'carrot' }"]
          F2["{ of: carrot-entity\n  the: diy.cook/quantity\n  is: 2 }"]
          F3["{ of: carrot-entity\n  the: diy.cook/unit\n  is: diy.cook/tsp }"]
      end
  
      I -->|assert| F1
      I -->|assert| F2
      I -->|assert| F3
      F1 -->|query| I
      F2 -->|query| I
      F3 -->|query| I
  // asserting a concept asserts exactly the relations it declares
  tx.assert(Ingredient {
      this: carrot,
      name: ingredient::Name("carrot".into()),
      quantity: ingredient::Quantity(2),
      unit: ingredient::Unit(Unit::Tsp),
  });
  ```

  A concept's identity, like an attribute's, is structural, derived from the sorted set of its constituent attribute identifiers. The name is a human-readable pointer to that identity, like a branch name in git. Unnamed concepts exist naturally in the system and can be discovered and named as needed. A concept name can also be repointed to a different set of attributes in the future while the original concept continues to exist and remains reachable by its identifier; concepts evolve non-destructively.

  Declaring an attribute asserts a `dialog/Attribute` concept, defined as:

  ```yaml
  dialog:
    Attribute:
      where:
        namespace:
          the: Namespace of the attribute
          assert: Text
        name:
          the: Name of the attribute
          assert: Text
        type:
          the: Type of the attribute value
          assert: Symbol
        cardinality:
          the: Cardinality of the attribute
          assert: [:one, :many]
        description:
          the: Human readable description of the attribute
          assert: Text
  ```

  This means attribute definitions are information like any other, queryable through the same engine as everything else. You can ask "find all attributes in namespace `diy.cook`" or "find all attributes whose description mentions 'ingredient'" as ordinary queries.


  ## Rules

  Rules are the underlying tissue that both attributes and concepts are built on. They are the deductive mechanism of the system, a way to derive conclusions from the information accreted in the semantic layer. Where attributes and concepts describe the shape of information, rules reason over it, deriving new relations from existing ones through pattern matching, computation, and logical composition.

  ### Conjunction

  A concept definition is effectively a rule with an implied `when`. The `Ingredient` concept desugars into:

  ```yaml
  diy.cook:
    Ingredient:
      assert:
        Ingredient:
          this: ?this
          name: ?name
          quantity: ?quantity
          unit: ?unit
      when:
        - diy.cook/ingredient-name:
            of: ?this
            is: ?name
        - diy.cook/quantity:
            of: ?this
            is: ?quantity
        - diy.cook/unit:
            of: ?this
            is: ?unit
  ```

  The `when` body is a conjunction; every pattern must be satisfied by the same variable bindings for the rule to produce a result. This is what makes required fields in a concept work: an entity that has a `name` and `quantity` but no `unit` will not match `Ingredient`.

  Rules give you direct access to this conjunction when you need more control than a concept alone provides, joining across entity boundaries, applying formulas, or adding constraints that don't fit the concept structure.

  ### Disjunction

  Where a concept's `where` clause is always a conjunction, rules can express disjunction by defining multiple rules that derive the same concept head. Any rule can produce a match independently of the others:

  ```mermaid
  flowchart TD
      R1["Rule: employee-from-person\nwhen: Person matches"]
      R2["Rule: employee-from-contractor\nwhen: Contractor matches"]
      E["Employee"]
  
      R1 -->|derives| E
      R2 -->|derives| E
  org:
    employee-from-person:
      assert:
        org/Employee:
          this: ?this
          name: ?name
          role: ?role
      when:
        - org/Person:
            this: ?this
            name: ?name
            title: ?role
  
    employee-from-contractor:
      assert:
        org/Employee:
          this: ?this
          name: ?name
          role: ?role
      when:
        - org/Contractor:
            this: ?this
            name: ?name
            position: ?role
  ```

  Because disjunction is expressed by separate named rules rather than inline syntax, a new rule deriving an existing concept can be added from a different namespace or file without touching the original definitions. Two domains can cooperate by writing bridging rules that remap one conceptual model onto another's relations.

  This applies at the attribute level too. Rather than adding disjunctive rules to every concept that uses `user/name`, a single attribute-level rule can derive `user/name` from `person/name`, and all concepts that require `user/name` benefit automatically:

  ```yaml
  user:
    name-from-person:
      assert:
        user/name: ?value
      when:
        - person/name:
            of: ?entity
            is: ?value
  ```

  ### Exclusion

  `unless` filters out matches where a given pattern holds. If the pattern can be satisfied, the result is excluded:

  ```yaml
  diy.planner:
    respect-dietary-restrictions:
      assert:
        diy.planner/SafeMeal:
          attendee: ?person
          recipe: ?recipe
          occasion: ?occasion
      when:
        - diy.planner/Meal:
            attendee: ?person
            recipe: ?recipe
            occasion: ?occasion
      unless:
        - diy.planner/AllergyConflict:
            person: ?person
            recipe: ?recipe
  ```

  A meal is only safe if no `AllergyConflict` can be derived for that person and recipe. If one can be derived by any rule, from any namespace, the meal is excluded. This reflects the closed-world assumption: if something cannot be derived from what is known, it is treated as absent.

  ### Attributes as Rules

  An attribute is a rule in its simplest form, a rule that matches a single raw `Relation` pattern and asserts a typed value. The shorthand:

  ```yaml
  diy.cook:
    title:
      the: The name of this recipe
      assert: Text
  ```

  desugars into a rule that bottoms out in a primitive `Relation` pattern, the base-level EAV relation the query engine operates on directly:

  ```mermaid
  flowchart LR
      A["title:\n  the: The name of this recipe\n  assert: Text"]
      R["assert: Text: ?value\nwhen:\n  - Relation:\n      namespace: diy.cook\n      name: title\n      of: ?entity\n      is: ?value"]
      A -->|desugars to| R
  ```

  This means constrained types are expressed in the same form, just with additional `when` clauses:

  ```yaml
  diy.cook:
    Email:
      the: A valid email address
      assert:
        Text: ?address
      when:
        - Like:
            source: ?address
            pattern: "*@*.*"
  ```

  `Email` behaves like any other attribute; it can appear in concept definitions, be queried directly, be referenced from rules, but its values are constrained by the pattern.

  ### Formulas

  Formulas are pure computations that participate in a rule body alongside pattern matching. Given bound inputs a formula derives output values that can be used in subsequent patterns within the same rule:

  ```yaml
  diy.cook:
    coerce-quantity:
      assert:
        Relation:
          namespace: diy.cook
          name: quantity
          type: Float
          of: ?entity
          is: ?float
      when:
        - Relation:
            namespace: diy.cook
            name: quantity
            type: Integer
            of: ?entity
            is: ?int
        - formula/ToFloat:
            of: ?int
            is: ?float
  ```

  Built-in formulas cover arithmetic (`Sum`, `Difference`, `Product`, `Quotient`, `Modulo`), string operations (`Concatenate`, `Length`, `Uppercase`, `Lowercase`), type coercions (`ToString`, `ParseNumber`), and logic (`And`, `Or`, `Not`).


  ## Namespace Resolution

  - Unqualified references (`Text`, `Integer`) implicitly reference the `dialog` namespace; `Text` is shorthand for `dialog/Text`
  - `.name` prefixed references implicitly reference the current namespace; `.Ingredient` resolves to `diy.cook/Ingredient` when used inside `diy.cook`
  - Fully qualified references (`diy.cook/Recipe`) explicitly cross namespace boundaries
  - The label under which an attribute is defined implies its name; the enclosing namespace key implies its namespace; both can be overridden explicitly
  - Attributes defined inline within a concept derive their namespace from the concept's own path; `after` inside `diy.cook/RecipeStep` lives at `diy.cook.recipe-step/after`