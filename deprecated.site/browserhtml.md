# Browser.html

This was an ambitious project at Mozilla, an attempt to design a **True User Agent** for the next generation web engine [Servo][]. [User research][] clearly indicated that tabs, bookmarks, history were inadequate solutions for the web that has grown from days of linked documents to an operating system in disguise.




![browser.html](browserhtml.gif)

<center>User interface that was shipped in Servo nightly builds</center>



We have designed and implemented many different concept browsers and learned something new from each iteration, kept what worked and discarded what had not.

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



![](./present-browserhtml.png)

<center>Me showing off spacial UI with navigation trails at Mozilla All Hands</center>



Turns out building cutting edge, performant interfaces on engine in development is not an easy task which led us to also develop runtimes and UI toolkits.

#### Reflex

Initial prototype of browser.html was written in plain JS, but as scope grow it started to be unmanageable. [React][] was new hotness, which we have explored but were disappointed by performance and a difficulty of working with non-standard web components. This lead me to develop [reflex][] that featured swappable view drivers (doing virtual/real DOM diff/patch) and was heavily inspired by [The Elm Architecture][elm-architucture].



#### Dominion

Running complex JS UI logic in the UI thread meant dropped frame sooner or later. This inspired my work on Virtual DOM library that moved that logic to the worker thread(s). By representing Virtual DOM tree and changes to it via byte code it became possible to program UI in worker thread, transfer all updates without copying.  [Read full story](./dominion)



[Servo]:https://servo.org/
[user research]:https://github.com/browserhtml/browserhtml/releases/tag/0.15.0
[React]:https://reactjs.org/
[reflex]:https://github.com/mozilla/reflex
[elm-architucture]:https://guide.elm-lang.org/architecture/
[trails]:https://medium.freecodecamp.org/lossless-web-navigation-with-trails-9cd48c0abb56
[spacial-ui]: https://medium.com/free-code-camp/lossless-web-navigation-spatial-model-37f83438201d
[3D touch]:https://developer.apple.com/design/human-interface-guidelines/ios/user-interaction/3d-touch/