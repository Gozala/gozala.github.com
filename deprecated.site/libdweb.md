---
Title: Experimental web-extension APIs for implementing P2P systems
---

# libdweb

Mozilla [project libdweb][libdweb] was an attempt to bridge the gaps in the web platform and enable new protocols like [IPFS][], [Dat][], [SSB][] within the Firefox. In collaboration with corresponding protocol authors I have identified set of missing  capabilities and implemented those as an experimental Firefox extensions APIs.

#### Protocol API

Protocol API provided a mechanism for adding custom protocol implementation to Firefox. I mostly followed [ServiceWorker][] API, but in unlike that API registration happens against a protocol scheme (e.g. `dat://`) instead of an origin and a path.

#### Service Discovery API

API provides DNS-Based Service Discovery API as per [rfc6763][]. It allows user to broadcast / discover available services on the local network.

#### UDPSocket API

Implementation provides raw UDP Socket access and I mostly followed [W3C UDP Socket specification][w3c-sockets]. To simply adoption I have also implemented [NodeJS][]  [dgram][] API adapter [@libdweb/dgram-adapter][dgram-adapter].

#### TCPSocket API

Implementation provides access to TCP client and server sockets. I mostly following [W3C TCP Socket specification][w3c-sockets]. [@substack][] developed [NodeJS][] [net][] API compatibility [adapter][net-adapter].

#### FileSystem API

Implementation provided API to provide access to an OS file system, restricted to a user chosen directory. However later API was dropped in favor of non-standard [IDBMutableFile][] Web API.

I have also implemented [random-access-idb-mutable-file][] providing [random-access-storage][] backed by [IDBMutableFile][] to make [hypercore][] usable from with-in [protocol](#Protocol_API) handler.





[libdweb]:https://github.com/mozilla/libdweb
[IPFS]:https://ipfs.io/ "A peer-to-peer hypermedia protocol"
[Dat]:https://dat.foundation/ "Protocol for sharing data between computers"
[SSB]:https://scuttlebutt.nz/ "Decentralized secure gossip platform"
[rfc6763]:https://tools.ietf.org/html/rfc6763
[dgram-adapter]:https://github.com/libdweb/dgram-adapter
[Response]:https://developer.mozilla.org/en-US/docs/Web/API/Response
[ServiceWorker]:https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API
[w3c-sockets]:https://www.w3.org/TR/tcp-udp-sockets/
[dgram]:https://nodejs.org/api/dgram.html
[net-adapter]:https://gist.github.com/substack/7d694274e2f11f6925299b01b31b2efa
[@substack]:https://substack.net/
[IDBMutableFile]:https://developer.mozilla.org/en-US/docs/Web/API/IDBMutableFile
[random-access-storage]:https://github.com/random-access-storage
[random-access-idb-mutable-file]:https://github.com/random-access-storage/random-access-idb-mutable-file
[hypercore]:https://github.com/mafintosh/hypercore
[NodeJS]:https://nodejs.org/
[net]:https://nodejs.org/api/net.html

