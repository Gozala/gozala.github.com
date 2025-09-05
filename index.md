---
title: Irakli Gozalishvili
---

<div class="vcard">
	<img class="photo" src="./gozala.jpg" />
  <p>
    <strong class="fn">Irakli Gozalishvili</strong>
    <a class="nickname" href="https://github.com/gozala" target="_blank">gozala</a>
  </p>
</div>
Senior research engineer with particular interest in [local-first software principles][local-first], [peer to peer][p2p] technologies and the [end-user programming][] _(slightly biased for [functional paradigm][functional])_.

[Add me to your address book](./gozala.vcf "My Virtual Contact File")

----

## Local First

Asymmetry of traditional server/client architectures creates a power disbalance. Power is exercised by trapping user's data for profit. P2P/Distributed/Decentralized technologies have a symmetric architecture (every peer is both server and client) and that leads to a different data ownership model. I devoted last years of my career at Mozilla enabling such technologies.  

#### Libdweb

Identifying gaps of the web platform and filling those in Firefox to bring those technologies was project [libdweb](./libdweb). Through collaboration with [IPFS][], [Dat][] and [SSB][] communities missing primitives were recognized, which I have implemented as an experimental Firefox extension APIs. This lead to several successes:

- [IPFS Protocol support in Firefox](./ipfs).
- [Dat protocol support for Firefox](./dat) (Compatible with [Beaker][] browser) and [Cliqz][]. 
- [Cliqz concept mobile browser](./dat-mobile) with Dat protocol support.
- [WebTorrent concept browser](./wtp)

#### Lunet

The goal of [Lunet](./lunet) project was enabling symmetric systems but within the constraints of existing web platform. It (ab)used range of web capabilities _([ServiceWorkers][], [Sandboxed iframe][sandoxed-iframe] and [Content Origin Policies][])_ to create a sandboxed web runtime in which applications work offline, operate on user data and are unable to track / silo users. 

It also opportunistically leveraged companion native application to use capabilities unavailable in web platform, proposing [progressive peer-to-peer web application (PPWA)](./ppwa "Progressive peer-to-peer web applications (PPWA)") architecture. [Read full story](./lunet)

#### Content addressable data feeds

Inspired by developments of IPFS, Dat, SSB protocols I have [drafted a concept][ipdf] of content addressable data feeds that enable collaborative applications adherence to [Zero Knowledge Architecture (ZKA)][ZKA]. [Shared this research with community][ipfs-camp-ipdf] and through continued collaboration with Textile team converged on design of new [Threads Protocol][threads_v2].

## User Interface

Reimagining medium for the web, The True User Agent (and not a client acting on servers behalf) had been an objective of the three people [browser.html](./browserhtml) team at Mozilla. Empowered by [user research][], we have developed several concept browsers to create a user interface for the new generation web engine [Servo][].

#### Frame free web

A **website art-directing the experience** was the future in which browser is an OS in disguise _(a.k.a [Firefox OS][])_. There was no place for ugly frame around the web, so we developed minimal chrome that like chameleon would adapt and blend in with the the content. [Read full story](./frame-free-web)

#### Web User Interface

Empowering users to (re)shape their User Agent was the vision, which is why user interface of this browser was just an HTML file hosted in the cloud. For different interface just point to a different HTML file. [Read full story](./graphene)

#### Web Cards

Concept reimagined tab strip (a.k.a Needle in a Haystack) as neatly organized, filterable list of cards, each capturing essence of the page. [Read full story](./web-cards)

#### Web Clips

Web clips reimagined replacement for bookmarks (the long list of addresses) as **cards clipping most valuable content** from the web, thus building a web heat map. [Read full story](./web-clips)

#### Web Highlighter

Highlighter concept was an attempt to fill the need of **collecting and sharing content** on the web. Allowing user to capture any selection from the web page into a catalog that could be annotated and shared. [Read full story](./web-highlighter)

#### Perspective UI

Introduction of [3D touch][] inspired us to explore a new dimension. We completely redesigned user interface and pushed browser chrome into a third dimension [Read full story](./perspective-ui)

#### Lossless Web Navigation with Trails

Trails concept was an attempt to evolve problematic user interface concepts like tabs, navigation history, bookmarks into unified concept that visualized a user’s journey through the web. Implementation mapped active browsing sessions (tabs), corresponding histories (session history) and past sessions (browser history) to navigation trails by visualizing it through rows  as expandable stacks of cards. [Read full story][trails]

#### Spacial User Interface of the Web

We set out to enhance existing browser workflows such that they felt familiar & more effective. Special user interface with added dimension and pressure sensitive [3D touch][] were applied across all interactions and views to convey rich, yet intuitive mental model. [Read full story][spacial-ui]

## Runtimes / Frameworks

Performant spacial user interface in 3D space using web platform was a challenge and a journey that has unfolded in parallel.

#### Graphene

Designed to be thinnest possible layer for the web for rapid concept browser development. A web engine with a user interface that is just an HTML file in the cloud. [Read the full story](./graphene)

#### Starling

To take an advantage of modern hardware and parallel [servo][] engine we have designed a new concurrent runtime inspired by Erlang [Actor Model][]. Actors were represented via async functions that communicated through read/write streams and were dispatched onto the thread pool. Implementation of actors could be seamlessly switched between JS or Rust allowing greater optimizations. [Read full story](./starling)

#### Dominion

Running complex JS UI logic in the UI thread meant dropping a frame sooner or later. This inspired my work on Virtual DOM library, that moved that logic to the worker thread(s). It represented Virtual DOM tree and changes to it via byte code. This made possible to program UI in worker thread and transfer all updates without copying.  [Read full story](./dominion)

#### Decoders

Running UI logic in the worker thread(s) required mechanism for event handling. Inspired by [parser combinators][] in functional languages I came to a solution that represented event handlers _(in the worker thread)_ via declarative event serializer. They were represented as a (part of Virtual DOM) byte code, run on events to capture & transfer required details for worker thread. [Read full story](./decoders)

#### TomTom UI Toolkit

I have designed and implemented high performance JS framework with reactive data bindings to powering [TomTomGo Live 1000][] user interface. Hardware limitations required an aggressive and at times creative optimizations to deliver smooth experience. [Read full story](./tomtom-webkit-ui)

#### Narwhal XULRunner

Toolkit for building **cross-platform desktop apps with JS, HTML, and CSS** predating [ElectronJS][] and [NodeJS][]. Project was a port of [NarwhaJS](./narwhal) _(JS Server runtime predating [NodeJS][])_ to Mozilla [XULRunner][] that provided APIs for building cross-platform UI apps with HTML and native toolkits. [Read full story](./narwhal-xulrunner)

#### Firebox

Application runtime for running [Firefox OS Apps][firefoxos-apps] across multiple desktop platforms. It was used in an initial prototypes of [browser.html](./browserhtml) project.

## Other

#### TomTom Home (in the Cloud)

This project replaced [TomTom Home][tomtom-home] desktop application _(Primarily map marketplace)_ with a web application. Novel idea _(at a time prior to internet connected devices)_ entailed putting HTTP server with REST API on the device so that web application _(Cloud based marketplace)_ could use to install purchased content. [Read full story](./tomtom-home-cloud).



[Beaker]:https://beakerbrowser.com/ "Experimental browser fo the peer-to-peer Web"
[Cliqz]:https://cliqz.com/ "Secure browser with built-in quick search"
[ipfs-camp-ipdf]:https://www.youtube.com/watch?v=KBwR0I7i4Wg&feature=youtu.be
[threads_v2]:https://blog.textile.io/introducing-textiles-threads-protocol/
[ZKA]:https://medium.com/@vixentael/zero-knowledge-architectures-for-mobile-applications-b00a231fda75 "Zero Knowledge Architecture (ZKA)"
[IPFS]:https://ipfs.io/ "A peer-to-peer hypermedia protocol"
[Dat]:https://dat.foundation/ "Protocol for sharing data between computers"
[Servo]:https://servo.org/ "Servo is a modern, high-performance browser engine"
[Firefox OS]:https://en.wikipedia.org/wiki/Firefox_OS "Discontinued open-source web based operating system by Mozilla"
[iPhone 3G]:https://en.wikipedia.org/wiki/IPhone_3G	"Second generation iPhone"
[TomTomGo Live 1000]:https://www.engadget.com/2010/04/27/tomtom-go-1000-live-to-offer-capacitive-touchscreen-webkit-brow/
[ElectronJS]: https://electronjs.org/ "Build cross-platform desktop apps with JavaScript, HTML, and CSS"
[NodeJS]:https://nodejs.org/ "JS runtime built on Chrome's V8 JavaScript engine."
[XULRunner]:https://en.wikipedia.org/wiki/XULRunner "Cross platform desktop application development platform by Mozilla"
[firefoxos-apps]:https://developer.mozilla.org/en-US/Marketplace/Options/Packaged_apps
[tomtom-home]:http://us.support.tomtom.com/app/answers/detail/a_id/5122/~/installing-tomtom-home
[local-first]:https://www.inkandswitch.com/local-first.html "Local-first softwareYou own your data, in spite of the cloud"
[p2p]:https://en.wikipedia.org/wiki/Peer-to-peer "Peer-to-peer (P2P) networking architecture"
[functional]:https://en.wikipedia.org/wiki/Functional_programming

[SSB]:https://scuttlebutt.nz/ "Decentralized secure gossip platform"

[ServiceWorkers]:https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API
[sandoxed-iframe]:https://www.html5rocks.com/en/tutorials/security/sandboxed-iframes/
[Content Origin Policies]:https://developer.mozilla.org/en-US/docs/Web/Security/Same-origin_policy
[3D touch]:https://developer.apple.com/design/human-interface-guidelines/ios/user-interaction/3d-touch/
[Actor Model]:https://en.wikipedia.org/wiki/Actor_model
[parser combinators]:https://en.wikipedia.org/wiki/Parser_combinator
[user research]:https://github.com/browserhtml/browserhtml/releases/tag/0.15.0
[trails]:https://medium.freecodecamp.org/lossless-web-navigation-with-trails-9cd48c0abb56
[spacial-ui]: https://medium.com/free-code-camp/lossless-web-navigation-spatial-model-37f83438201d
[ipdf]:https://github.com/gozala/ipdf/
[end-user programming]:https://www.inkandswitch.com/end-user-programming.html