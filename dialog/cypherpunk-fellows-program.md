---
title: Cypherpunk Fellows Program Application
date: 2025-09-23
---

# Cypherpunk Fellows Program Application

## Project Overview

[Dialog](https://github.com/dialog-db/dialog-db) is a working proof-of-concept local-first database designed to address critical gaps in the local-first ecosystem while providing infrastructure privacy by default.

**Problem:** Current local-first solutions have limitations:

- CRDT libraries (Automerge/Yjs) are memory-constrained, limiting dataset sizes to what fits in RAM
- They lack query capabilities beyond document traversal
- Sync services (Replicache/Zero) require trusting service providers with user data and custom sync infrastructure

**Solution:** Dialog provides:

- **Unlimited dataset sizes** through efficient indexing and query-driven partial replication
- **Schema-on-read semantics** eliminating [complex migrations](https://www.inkandswitch.com/cambria/) and pre-partitioning
- **Infrastructure privacy by default** - all data syncs through encrypted blobs on commodity storage (S3/R2)
- **Local query execution** - queries run on-device, never exposing unencrypted data to remote servers

Applications built with Dialog automatically inherit these privacy properties. Storage providers see only encrypted blobs, making censorship and surveillance impossible at the infrastructure level.

## Technical Design

Dialog combines proven database technologies with privacy-preserving sync:

**Core Architecture:**

- **Semantic Data Model**: Triple-based facts instead of documents enable flexible queries without schema coordination between applications
- **Datalog Query Engine**: Declarative queries with powerful rule system, all executing locally on user devices
- **Probabilistic Search Trees**: Content-addressed indexing structure enabling efficient partial replication while maintaining convergence
- **Encrypted Blob Sync**: Client-side encryption before storage ensures infrastructure providers cannot access data

**Implementation Plan:** Current proof-of-concept demonstrates feasibility. Grant funding will produce:

- Rust library for performance and memory efficiency
- WASM bindings for web deployment
- Encrypted storage backends for S3/R2
- Query-driven replication protocol

**Privacy by design:**

- No query servers - all computation happens locally
- Data encrypted before leaving device
- UCAN integration for capability-based access control without central authorities

## User Feedback and Adoption Plan

**Target Users:**

- Teams using CRDTs hitting memory constraints with large datasets
- Developers needing query capabilities beyond document traversal
- Privacy-focused applications requiring infrastructure isolation
- Projects seeking alternatives to centralized sync services

**Adoption Strategy:**

- Direct outreach to CRDT users experiencing limitations
- Integration examples for popular UI libraries like React
- Participation in local-first community events

**Early Feedback:** Through building Noosphere/Subconscious and discussions with local-first developers, we've identified Dialog's approach as addressing real pain points. Teams want CRDT-like collaboration without memory constraints and with proper query capabilities.

## Schedule and Budget

**Timeline:** 4 months (October 2025 - January 2026)

**Budget:** $40,000 USD for full-time development effort

**Deliverables:**

- Rust library with WASM bindings
- Encrypted sync via S3/R2
- Developer documentation

## Qualifications of Team

**Irakli Gozalishvili**

- Decade at Mozilla developing P2P browser primitives (libdweb) bringing P2P capabilities to Firefox
- Core contributor to web3.storage (now Storacha) architecture at Protocol Labs
- Co-author of [UCAN](https://github.com/ucan-wg/spec) specification for decentralized authorization
- Creator of [ucanto](https://github.com/storacha/ucanto) library for UCAN-based RPC services

**Chris Joel**

- Former CTO of Subconscious, architect of Noosphere protocol - a local-first protocol with similar sovereignty principles
- Deep expertise in distributed systems and local-first architectures
- UCAN Working Group participant
- Successfully raised and delivered on Protocol Labs grants

Both team members have extensive experience building privacy-preserving, decentralized systems and understand the technical and adoption challenges in this space. Currently self-funding Dialog development as proof of commitment.