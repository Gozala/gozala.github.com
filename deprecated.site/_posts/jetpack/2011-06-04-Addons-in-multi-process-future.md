---
layout: post
title: Addons in multi process future
tags: oop jetpack electrolysis
---

The most frequently asked questions on jetpack mailing list concern
content scripts. It's not obvious for users why these scripts are powerless,
why modules don't have access to the content's dom and why they need to
communicate between them by message passing. The short answer is:
Mozilla platform is moving towards a model were separate processes are used for
chrome, content and add-ons. Therefore SDK modules were designed with
[Electrolysis] in mind, to guarantee painless transition to a new model.
Much more details about
this may be found in the [documentation of content scripts].

Even though we won't ship 1.0 with support for [Electrolysis], some of us
([Atul][E10S-atul], [Alex][E10S-alex] and [me][E10S-me]) have explored some
ideas, but until few month ago I was still unsure we were heading a right
path.

Several month ago I was reading Peter Michaux's blog post about [MVC Architecture
for JavaScript Applications] from which I'd like to quote following description
of "Real MVC":

> "In a nutshell the classic MVC architecture works like this. There is a model
> that is at the heart of the whole thing. If the model changes, it notifies
> its observers that a change occurred. The view is the stuff you can see and
> the view observes the model. When the view is notified that the model has
> changed, the view changes its appearance. The user can interact with the
> view (e.g. clicking stuff) but the view doesn’t know what to do. So the view
> tells the controller what the user did and assumes the controller knows what
> to do. The controller appropriately changes the model. And around and
> around it goes."

Even though I've been writing apps with [MVC] architecture for a while, it never
occurred to me to look at jetpack in MVC.

### Light side ###

Ironically, most of Add-on SDK APIs provide access to the things that are
basically models, associated with a different views of the browser UI (like
[windows], [tabs], [widgets]). Also, low level modules can be seen as
controllers of two types:

 1. Model observers that propagate changes to the associated views.
 2. View observers that update associated models.

Such perspective also makes whole multi-process architecture switch way more
simple. All we need to do is to move models to the other process and make sure
that changes on views and models are synchronized via controllers.

### Dark side ###

Unfortunately big part of the code base was not written with such MVC
perspective, or in other words we don't have a strict separation between models
and outlined controller types.

### Technical side ###

This part of the blog is probably too technical to enjoy, unless you plan to
hack jetpack itself, so feel free to skip :)

Overall, everything boils down to few key components:

1. Pipe for delivering messages across processes, something like `port` on our
   worker objects.
2. Models that are serializeable and fully reconstructible via JSON. This is
   important as models are going to live in add-on processes. Model
   synchronization logic can be encapsulated in one function that just emits
   events on the port.
3. Controllers observing views, or in other words, event listeners that extract
   and serialize interesting data from events and emits to the pipe so that
   models can react.
4. Controllers observing model changes, via listeners on the pipe and updating
   views.

Outlined strong separation of roles is a good practice anyway, so I tried to
stick to it to make transition to E10S easier.

1. Models that can be serialized / recreated:
[hotkey](https://github.com/mozilla/addon-sdk/blob/master/packages/addon-kit/lib/hotkeys.js)

2. Controllers that emit events on view (Browser UI) changes:
[tabs/observer](https://github.com/mozilla/addon-sdk/blob/master/packages/api-utils/lib/tabs/observer.js),
[keyboard/observer](https://github.com/mozilla/addon-sdk/blob/master/packages/api-utils/lib/keyboard/observer.js),
[windows/observer](https://github.com/mozilla/addon-sdk/blob/master/packages/api-utils/lib/windows/observer.js)

3. I don't have examples of controllers that update views on model changes.

Finally here is a link to "in progress" [implementation of models] that I hope to get
into jetpack in a future.

[documentation of content scripts]:https://jetpack.mozillalabs.com/sdk/latest/docs/dev-guide/addon-development/web-content.html
[Electrolysis]:https://wiki.mozilla.org/Electrolysis "The Mozilla platform that uses separate processes to display browser UI, web content, and plugins."
[E10S-atul]:https://github.com/toolness/jetpack-e10s "Jetpack + Electrolysis Integration Package"
[E10S-alex]:https://github.com/ochameau/jetpack-oop "Experimental use of Out-Of-Process capabilities in firefox 4"
[E10S-me]:https://github.com/Gozala/vats "Prototype implementation of vats for Jetpack"
[MVC]:http://en.wikipedia.org/wiki/Model-view-controller "Model View Controller"
[MVC Architecture for JavaScript Applications]:http://peter.michaux.ca/articles/mvc-architecture-for-javascript-applications "I really reccomnd to read this"
[windows]:https://jetpack.mozillalabs.com/sdk/latest/docs/packages/addon-kit/docs/windows.html "Windows module documentation"
[tabs]:https://jetpack.mozillalabs.com/sdk/latest/docs/packages/addon-kit/docs/tabs.html "Tabs module documentation"
[widgets]:https://jetpack.mozillalabs.com/sdk/latest/docs/packages/addon-kit/docs/widget.html "Widget module documentation"
[implementation of models]:https://github.com/Gozala/models/blob/master/lib/models.js "M form MVC "
