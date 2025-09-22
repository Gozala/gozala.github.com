---
title: Paradigm Shift
date: 2025-09-16
---

# Paradigm Shift

Database architecture and today's software infrastructure rest on a fundamental assumption: predict access patterns, then optimize for them. Large Language Models (LLMs) enable the opposite: open-ended exploration without knowing what questions will be asked. These incompatible paradigms signal a broader shift in computing.

When LLMs interact with current infrastructure, they're constrained by systems designed for the contrary purpose - predetermined structure rather than exploratory flexibility.

## Service-Oriented Paradigm

Today's software ecosystem is service-oriented. You visit Gmail, Notion, or Spotify - each service controls both interface and data, requiring users to adapt to predetermined workflows.

Software creation has been curation: consider diverse user needs, reconcile with business incentives, develop compromise solutions with carefully crafted interaction patterns. Systems adapt to changing requirements through controlled release cycles, making database rigidity tolerable because changes happen infrequently and at scale. This service-oriented approach extends to data infrastructure - databases aggregate information from large numbers of users around each service, optimizing for predictable access patterns within service boundaries.

## Emerging Paradigm

> Assume LLMs accelerate software creation and democratize who can build.

This enables a shift from services you visit to tools - whether agentic LLM assistants or programmatic functions - that operate on your data, adapting to your context rather than forcing you to context-switch between services.

When development costs approach near-zero, curation becomes the primary remaining expense - planning and distilling requirements across diverse user needs. The economic logic shifts: why maintain expensive compromise solutions when personalized alternatives become dramatically cheaper to create?

### Personalization

Your goals, interests, and personality influence tool selection, which determines what information exists in your computing environment. If you don't prioritize nutrition, ingredient data remains unconnected to health information. If you manage dietary restrictions, the same ingredients become richly associated with allergies, meal planning, and nutritional goals.

Information relationships depend on your tool ecosystem. What's queryable for you differs fundamentally from what's queryable for others based on your specific tool combinations and the data relationships they establish.

Current databases require predetermined access patterns and static structural relationships. Personalization requires discovering relevant relations across all available information regardless of its origin.

## Disruption

The collision between paradigms manifests in three ways:

### Disorientation

Current infrastructure is fundamentally disoriented for personalized computing. Systems are oriented around services - aggregating information from large numbers of users around each service's database. But personalization requires the opposite orientation: accumulating information across all tools around you rather than distributing it across service silos.

This disorientation creates cascading problems. Service-centric coordination requires `n²` complexity - each service potentially needs integration with every other service. This becomes unmanageable: which services does each user have? How do tools discover relevant APIs for each user's unique combinations? How is overlapping data managed across service boundaries?

The disorientation runs deeper than coordination complexity. Each tool would need to learn every other tool's interface and data model, consuming computational resources on integration rather than domain problems. Systems designed to orient around services cannot efficiently orient around users without fundamental restructuring.

### Economic Rebalancing

Service-oriented platforms profit through isolation and extraction - capturing users within walled gardens and monetizing their data through advertising and behavioral manipulation. This model worked when software creation was expensive and users had limited choice.

Democratized software creation undermines this entirely. When abundant, specialized tools can cooperate on user-owned substrates, isolation becomes a competitive liability. Why accept platforms that extract value when alternatives provide better integration, stronger privacy, and aligned incentives?

User-centric systems gain decisive advantage: they eliminate the trade-offs users were forced to accept. The economic logic inverts - software abundance makes isolation and extraction unsustainable business models.

### Foundation Erosion

Service-oriented architecture relies on three economic foundations that democratized tool creation systematically undermines. High development costs historically justified aggregating millions of users to amortize expenses - but if domain experts can create specialized tools in hours, this advantage disappears. Network effects that made platforms valuable become liabilities when users access better-integrated tool ecosystems. Switching costs that trapped users become irrelevant when personalized alternatives offer superior functionality without requiring workflow abandonment.

Each eroded foundation accelerates the others. As development costs plummet, competitors recreate service functionality while offering better integration. As users gain specialized alternatives, network effects weaken. As switching becomes easier, platforms lose captive audiences that justified extraction-based business models.

This creates architectural instability rather than mere inefficiency. Service-oriented systems become competitively unsustainable as their economic supports dissolve. The architecture becomes actively disadvantaged against systems designed for software abundance rather than scarcity.

## Renaissance

Disruption creates favorable conditions and opportunity for a different user-oriented paradigm to emerge, one that aggregates tools around users displacing one that aggregates users around services.

This requires a personal knowledge substrate - a unified information environment where facts and concepts exist independently of any specific tool. It enables tools to discover and contribute information without requiring knowledge of other tools in the ecosystem.

### User-Centric Architecture

A personal knowledge substrate enables entirely different architectural relationships. With user-centric organization, tools become stateless relative to each other. Each tool queries the user's substrate for relevant information without discovering other tools. Instead of `n²` service integrations, this creates `n` relationships: each tool interfaces with the user's substrate.

### Beyond Prediction

The paradigm operates on observe-and-customize rather than predict-and-optimize. When access patterns are unknowable -  they are with open-ended exploration - systems must adapt based on emerged usage patterns rather than predetermined optimization. This fundamental shift from prediction to observation aligns with how personalized tools actually need to work.

The Personal Computing Renaissance isn't about rejecting connectivity - it's about inverting control from services extracting value to systems serving users. Dialog is an attempt to implement such a knowledge substrate and user-oriented infrastructure, demonstrating how user-controlled systems can enable true tool cooperation in practice.
