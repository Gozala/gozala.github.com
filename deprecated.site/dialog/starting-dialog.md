---
title: Dialog - Personal Substrate for Cooperative Computing
date: 2025-09-05
---

# Dialog - Personal Substrate for Cooperative Computing

You're planning dinner for friends this weekend. Your calendar knows who's coming. Your contacts know Sarah's gluten-free, Tom's vegetarian. As you open a meal planner, it suggests recipes everyone can enjoy, portions adjusted for your group. Your shopping list populates with needed ingredients.

No configurations. No authorizations. No information retrieval from corporate silos. Your tools cooperate through a shared substrate - each deriving insights and contributing new understanding. They complement each other, becoming true [bicycles for your mind][].

Why don't we already have this? Perhaps because cooperation requires coordination, and companies producing software need to know their effort will pay off for them and their investors. Unless it's something the majority of customers need, it can't be justified over features that majority demands. This is why software is largely "one size fits all."

## Current Barriers to Cooperation

Today's tools cooperate through these limited coordination models:

**Corporate suites** (Google Workspace, Microsoft Office) work together because one company controls everything.

**Limited integrations** where companies choose which APIs to expose. Slack decides who to integrate with, not you. You can't message Signal friends from WeChat.

**Manual coordination** for everything else - you copy data between tools, maintain consistency, context-switch endlessly.

Your contacts live in one app, dietary preferences in another, calendar events in a third. You are the integration layer.

> Users clearly want something better as evidenced by the popularity of screenshotting, web clippers, and endless copy-paste workflows.

What if you didn't need a software company to come along just to connect your meal planner with your shopping list? What if you could do it yourself without a computer science degree? And once you create that connection, you could share it with colleagues and friends so they can improve their workflows too.

## The Coming Paradigm Shift

Large Language Models (LLMs) enable just-in-time (JIT) integrations, tools and adapters, democratizing software creation. Anyone can translate their domain expertise directly into specialized tools. A food blogger creates a meal planner. A fitness coach builds a nutrition tracker. Each speaks its own language. We're moving from the "one size fits all" software industrial complex to micro-farming - from dozens of major platforms to thousands of specialized tools.

This renders existing cooperation models completely inadequate:
- No corporation controls thousands of indie tools (hopefully)
- Too many tools for each one to integrate with the rest
- Manual coordination becomes impossible

Data fragmented across silos prevents emergent cooperation and requires concerted effort from all parties just to connect basic workflows.

Meanwhile, existing software deployment tools and infrastructure are designed for the industrial complex - they offer tractors when you need a hoe. It's easy to vibe code a tool for yourself, but deployment infrastructure assumes you're building product for customers, not a tool for your family and friends.

This creates both opportunity and demand for a personal knowledge substrate where you can bring tools to garden your data, adapt them to your needs, create missing connections, and share those adaptations with others.

> Some integrations may not be DIY projects - you might hire an expert for complex "remodeling", just like bringing pants to a tailor for alterations. You don't need to convince the factory to make pants in your uncommon size; you adapt what exists to fit your needs.

## The Making of Dialog

We are building [Dialog] as knowledge substrate - **your** [semantic](https://en.wikipedia.org/wiki/Semantic_memory) _(facts, concepts)_ and [episodic](https://en.wikipedia.org/wiki/Episodic_memory) _(events, observations)_ memory that tools can derive insights from _(query)_ and contribute back to.

> You could also describe Dialog as an embeddable database embodying [local-first] principals and emphasis on emergent cooperation.


### Beyond Schemas

Instead of forcing tools to cherry-pick data from rigid schemas _(à la [GraphQL](https://graphql.org/))_, Dialog mirrors how humans organize knowledge - disconnecting the format in which information was acquired from how it gets used.

Schemas partition and hierarchically organize data for specific access patterns. This forces you to adapt to the tool rather than the tool adapting to your needs.

> It's like learning Spanish vocabulary in alphabetical order, then struggling to order food because the restaurant menu isn't organized alphabetically.

In Dialog tools define the concepts and query memory to find corresponding facts. A meal planner stores recipes while a health tracker stores food allergies - cooperation emerges when the concepts overlap:



```yaml
# each tool can define concept under their namespace in fairly
# abstract way
diy.cook:
  # Describes concept of the recipe tool is working with in terms
  # of an entity and set of facts related to it.
  Recipe:
    # By convention `this` represents an entity. It is implied but for
    # clarity it is presented here.
    this:
      # Description of the relation that is stored by dialog allowing
      # others to find relations.
    	the: Meal recipie
    # The recipe concept has notion of a title.
    title:
    	the: The name of this recipie
    	# Titile is expected to be a Text, which is built-in concept and
    	# is effectively a string.
    	as: Text
    # The recipe has related ingredients, unlike title it may have
    # multiple ingredients associated with it. Concept does not define
    # any constraint on what related value should be, usually this
    # implies that it is another entity.
    ingredient:
      the: Ingredients of the recipe
      cardinality: many

    # The recipe has an associated steps.
    steps:
      the: Steps of the cooking process
    	cardinality: many
    	# Steps are considered associated if they meet definition of the RecipeStep concept
    	as: RecipeStep
  
  Ingredient:
    this:
      the: The meal ingredient
    name:
    	the: Name of this ingredient
    	as: Text
    quantity:
      the: Quantity of the ingredient
      as: Integer
    unit:
      the: The unit of mesurement for the ingredient
      # bascially an enum
      as: [tsp, mls]
      
  RecipeStep:
    this:
      the: The cooking step
    after:
      the: Step to perform this after
      as: RecipeStep
      # The `after` RecipeStep is optional
      optional:
    instruction:
    	the: Insturctions for this step
    	as: Text

    
  diy.health:
    Allergy:
      this:
      	the: The allergy peson has
      person:
      	the: Person having an allergy
      substance:
      	the: Substance person has an allergy for
      	as: Text
  
  diy.planner:
    Event:
      this:
    	  the: Event being planned

      title:
        the: Title of the event
        as: Text

      time:
        the: Time of the event
        as: Text

    Meal:
      this:
        the: The plan for the meal
      attendee:
        the: The meal attendee
      recipe:
        the: The meal recipe
      occasion:
        the: The occasion of for the meal
        as: Event


# Namespace does not really matter
user.rules:
  # Name of the rule also does not matter mostly there
  # to be able to refer to behavior rule define
	respect-dietary-restrictions:
	  # Rule concludes/realizes `diy.meal-planner/Meal` concept
	  assert:
	    diy.meal-planner/Meal:
	      # You could leave out variables and instead refer them in
	      # premises by names `attendee` and `recipe`. But we use
	      # local variables for clarity
        attendee: ?person
        recipe: ?recipe
        occasion: ?occasion

    # Premises that need be held up to reach a conclusion
    when:
      # Finds all `Recipe` concepts that have `?recipe` and `?ingredient`
      # relations.
      - diy.cook/Recipe:
        this: ?recipe
        # Could omit irrelevant attributes instead of `_` explicitly ignoring
        # but using here for clarity
        title: _
        ingredient: ?ingredient
        instructions: _

      # Find names for the recipie ingridients
      - diy.cook/Ingredient:
        this: ?ingredient
        name: ?substance
        quantity: _
        unit: _

    # Negation - Premises that need not to be true to reach a conclusion,
    # basically eliminating meals if the attendee has allergy to the
    # ingredient
    unless:
      - diy.healt/Allergy:
        this: _
        person: ?person
        substance: ?substance


diy.cook:
  Recipe:
  	this: 
    	the: A meal recipe

    title:
      the: title of the recipe
      as: text

    ingredient:
       the: set of ingredients needed
       cardinality: many

    instructions:
       the: preparation instructions
       cardinality: many
       as: text
  
  ingredient:
    the: An ingredient of the recipe

    name:
      the: name of the ingredient
      as: text

    quantity:
      the: The quantity of an ingredient
      as: integer

    unit:
    	the: The unit of measurement of the ingredient
    	as: [tsp:, ml:]

diy.health:
    allergy:
      the: Allergy person has
      person:
         the: Person that has food allergy
      substance:
         the: A substance person has an allergy for
         as: Text

diy.meal-planner:
  meal:
    attendee:
      the: Person attending a meal
    recipe:
       the: Recipie for this meal
    occasion:
       the: Occasion for the gathering


rules:
	- diy.meal-planner/meal:
	  conclude:
      attendee: ?person
      recipe: ?recipe
      occasion: ?occasion

    when:
      - diy.cook/recipe:
        the: ?recipe
        title:
        ingredient: ?ingredient
        instructions:

      - diy.cook/ingredient:
        the: ?ingredient
        name: ?ingredient-name
        quantity:
        unit:

    unless: 
      - diy.healt/allergy:
        person: ?person
        substance: ?inngredient
```



```clojure
(concept :diy.vibes.food/recipe
   :this Entity 
   :title String 
   :ingredient Entity 
   :instructions Entity)

(concept :diy.meals.plan/dinner-suggestion
  :guest Entity
  :recipe Entity)

(rule :meal/planner
  (food/recipie :this .recipie :title _ :ingredient ?ingredient :instructions _)
  (food/ingredient :this ?inngredient :name ?name :quantity _ :unit _)
  (not (health/food-allergy :guest .guest :name ?name)))

(concet food/recipe
   this :Entity
   title :String
   ingredient :Entity
   instructions :Entity)

(concept food/ingredient
   this :Entity
   name :String
   quantity :UnsignedInteger
   unit :String)

(concept food/allergy
   person :Entity
   ingredient :String)

(concept meal-planner/dinner-suggestion
   this :Entity
   guest :Entity
   )

(rule (dinner-meal-suggestion :guest guest :recipe recepie)
   (food/recepie :this recipe :title _ :ingredient ?ingredient :instructions _)
   (food/ingredient :this ?ingredient :name ?name :quantity _ :unit _)


```



```prolog
% Concepts defined by meal planner

concept FoodReceipe = { this: Entity, title: String, ingredient: Entity, instructions: Entity }

food_recipe(
  % food recipe
  this: entity,
  % name of the recipe
  title: string,
  % set of ingredients needed
  ingredient: entity,
  % preparation instructions
  instructions: entity
).

food.ingredient(
  % food ingredient
  this: entity,
  % name of the ingredient
  name: string,
  % quantity of this ingredient required by the recipe
  quantity: i32,
  % unit of measurement for the ingredient
  unit: string
).

% Concepts defined by health tracker
food_allergy(
  % person with food allergy
  person: entity,
  % ingredient that causes allergy
  ingredient: string
).

% Concept defined by meal planner
dinner_meal_suggestion(
  % meal suggestion
  this: entity,
  % guests that will be eating the meal
  guest: entity,
  % recipe that will be served
  recipe: entity,
  % occasion for the gathering
  occasion: entity
).
```

When concepts don't align, **you** can define rule(s) to bridge them and share with others:

```smarty
% Rule that excludes recipes that contain allergens
dinner_meal_suggestion(guest: entity, recipe: entity) :-
  % ingredients of the recipe
  food_recipe(recipe, _, ingredient, _),
  % name of the ingredient
  food_ingredient(ingredient, name, _, _),
  % guests should not have allergies to the ingredients
  not food_allergy(guest, name).
```

### Distributed Version Control System (DVCS)

Like Git, Dialog supports branching, forking, and selective collaboration. Every idea (session) can be explored in an independent branch and later integrated through [memory consolidation](https://en.wikipedia.org/wiki/Memory_consolidation). Every fact traces to the episodes that affirmed it - you can fork any idea (session) and explore contradictory views without poisoning shared context.

No schemas, no migrations - just interrelated semantic facts conceptualized at recall. Tools focus on what information they need, not on how to organize it.

Integrating conflicting observations requires deliberation, but the experience can resemble visually guided logical reasoning rather than merging text files.

Local yet ubiquitous - like Git, Dialog replicates through remotes. Unlike git, dialog remotes are end-to-end encrypted blob stores _(S3, R2, IPFS)_, enabling privacy-preserving collaboration on commodity infrastructure.

> Start local, add a remote to go global, switch providers at will.

### The Technical Foundation

Dialog embodies [local-first] principles by synthesizing decades of computer science research:

- **Semantic data model** (from Datomic) lets tools focus on concepts without worrying about access patterns _(schemas, indexes, migrations)_
- **[Probabilistic Search Trees]** enable efficient, query-guided partial replication
- **Datalog rules** replace brittle integrations with flexible pattern matching - define relationships and map concepts as needs evolve
- **Commodity blob storage** prevents vendor lock-in by reducing cloud providers to encrypted pipes that never see unencrypted data
- **Web Assembly Component model** eliminates platform dependencies through secure, language-agnostic sandboxed computation

_Your data, your rules_ - semantic facts stored in your database, datalog rules governing how concepts emerge. Tools operate in your sandbox and see only what your rules allow them to.

## Why This Moment Matters

LLMs democratize tool creation - thousands of specialized tools will emerge from domain experts. But existing coordination models can't scale to this future.

This creates unprecedented opportunity for personal, user owned, knowledge substrates: gardens where individual insights intertwine into collective understanding. Not something you plan upfront, but an evolving system you nurture.

---

*If this vision resonates - if you see seamless tool cooperation as inevitable and necessary - I want to hear from you. Whether you're a developer tired of silos, a funder who sees the shift coming, or someone who believes software should serve its users, let's talk.*

[bicycles for your mind]: https://www.youtube.com/watch?v=KmuP8gsgWb8
[Probabilistic Search Trees]: https://g-trees.github.io/g_trees/
[local-first]:https://www.inkandswitch.com/essay/local-first/
[Dialog]:https://github.com/dialog-db/
