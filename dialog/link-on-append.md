---
title: Link on Append (LOA)
date: 2025-07-09
---

# Link On Append


Dialog DB is designed to work like an immutable data structure, every edit produces a new revision that shares a lot with the original yet original remains intact. This is also how git works, providing many useful workflows that we aspire to replicate. Rich Hickey describes Datomic as persistent data structure with durability, ~~Dialog is to Datomic what SQLite is to PostgreSQL or at least aspires to.~~

## Copy on Write (COW)

Making performant immutable data like ones in Clojure language requires representing those via [specialized tree structures][CHOMP], optimized for, among other things, path copying, so that when you edit data structure you end up copying and slightly editing minimal set of nodes. Technique broadly can be described as copy on write.

> This also fundamentally how Dialog works every time you commit new facts it will create new search tree revision that shares most with tree before without a commit.

## Append Only

Simplest immutable data structure available in many languages is [Linked List][], it is super simple because you can only accrete data, so you can just write without having to deal with any copying. Append only logs are not really a data structure but still relevant due to inherent properties - You can always write append some content and you can use log size  like a revision or head (in git terms) reading `n` bytes from head will always return same content, yet we can append `m` more bytes and now we structurally shared first `n` bytes with new `n + m` revision.

> [Hyperbee][] is a very interesting project that builds [B-Tree][] structure on top of append only log.

### Content Addressed Log

 [Blake3][[] is streaming cryptographic hashing function that maps input into `1KiB` chunks and builds up [BAO][]  [Merkle tree][]. [Iroh][] took advantage of the underlying structure to [moved lot of bytes][Moving the bytes with bao] peer-to-peer while providing cryptographically variable guarantees that moved bytes are part of requested byte stream.

## Link on Append (LOA)

What if we synthesized ideas from append only logs and COWs to get something uniquely useful for Dialog. Before I dive in let me provide some context.

#### Shallow Trees require Large Nodes

Unlike traditional databases that optimize for disk I/O, Dialog DB optimizes for network IO where latency dominates. This fundamental difference has profound implications for our search tree design:

- **Shallow trees are critical**: Each level requires a network round trip. Reducing depth can improve response times significantly

- **Larger nodes can be beneficial**: A single 64KB fetch might be faster than four 16KB fetches due to round-trip overhead

However large nodes has downsides also, that means when we perform any change we have to copy (on write) large chunks of mostly identical data.

#### Changes as Appends

One idea that has being simmering in my head for a while is - what if we could represent nodes as append-only logs. In fact we are already exploring [Fressian][] inspired encoding which deduplicates data as you append so has some overlap. But what if we took it further by a notch and edits to the node were also represented as appends ? This may seem complicated but not terribly so if we consider the fact index nodes are effectively a set of references to child nodes and their corresponding key boundary. Adding a child could involve just appending some bytes with key and a child hash. Removing a child seems trickier, but not really if we simply tag appends as inclusion or exclusion from set. If we do so we can get best of both in place mutation without invalidation as long as we also know the size corresponding to individual revisions.

> It is worth calling out that this would weaken  [history independence][] of our search tree, but only tiny bit. Logical structure is still history independent because as we decode node we'll sort children by key and produce exact same structure, but on disk representation may vary by insertion.

It is also worth noting that with [Blake3][] we could address individual revisions of the node within same append-only log buffer, we could even reuse underlying [BAO][] by leveraging streaming.

#### Linking Revisions

On every new node we could allocate fixed size buffer giving it some unique identifier like hash of current tree revision (hash of hash) we will call this a **page**. When we edit a node instead of performing copy on write we can append bytes to a page and create [symbolic link][] to the page. We will name it by a hash of the currently utilized page slice. Idea here is that instead of copying page each time we simply append bytes and link. When reading from symbolic link we'll only read slice that matches a hash disregarding what else had being added to the page. This has potential to significantly reduce disk usage especially if we our nodes end up going wide.

> This also works fairly well over the wire, consumer can request content by hash and provider can simply resolve link and forward relevant slice potentially caching on CDN.

#### History Independence

We could actually avoid weakening [history independence][] if are willing to tolerate some additional indirection. Idea here is equivalent to [merkle reference][]s - addressing by hash of the structure and not by serialization. What I mean here is that instead of hashing slice of the page we could instead hash canonical representation of the structure in encodes - meaning serialize node and hash that instead.

This would hinder incremental verification as you now need to read, canonicalize and only after you can verify but that may be a reasonable compromise.

#### Novelty

One other thing in the works is a novelty buffer for dialog. It is not new idea [datomic utilizes](https://tonsky.me/blog/unofficial-guide-to-datomic-internals/) it to amortize read / write performance and [hitchhiker tree][] adds novelty buffer to every node to amortize flushing. Both seem ideal fit for LOA

[Chomp]:https://michael.steindorfer.name/publications/oopsla15.pdf
[Linked List]:https://en.wikipedia.org/wiki/Linked_list
[Hyperbee]:https://docs.pears.com/building-blocks/hyperbee
[B-Tree]:https://en.wikipedia.org/wiki/B-tree
[Blake3]:https://github.com/BLAKE3-team/BLAKE3/
[BAO]:https://github.com/oconnor663/bao
[Merkle tree]:https://en.wikipedia.org/wiki/Merkle_tree
[Iroh]:https://www.iroh.computer/
[Moving the bytes with bao]:https://www.youtube.com/watch?v=bK9KDJxCfzI&list=PLvsg-fc7APc1W7rxwSdORL3HiXn9VLp2e&index=3
[Fressian]:https://github.com/Datomic/fressian
[history independence]:https://dl.acm.org/doi/10.1007/s00453-004-1140-z
[symbolic link]:https://en.wikipedia.org/wiki/Symbolic_link
[merkle reference]:https://github.com/Gozala/merkle-reference/blob/main/docs/spec.md
[hitchhiker tree]:https://github.com/datacrypt-project/hitchhiker-tree
