---
layout: post
title: protocol based polymorphism
tags: clojure javascript modules library nodejs web commonjs
---

Not a long time ago I learned about [clojure]'s [polymorphism] constructs and
[protocols][clojure protocols]. I was so inspired by a porwer and flexibility
of [protocol based  polymorphism][Clojure polymorphism] that I decide to
[prototyped it for JS][JS protocol]. In this post I will try to give you a taste
of protocols and maybe even motivate you give them a try. 

# Rationale

In programing we usually write and consume various abstractions. Typically in
OOP languages abstractions are defined via (class / object) interfaces and
have a nasty expression problems. Imagine that you have  `A` and `B` sets of
abstractions and sets of implementations of those abstractions. `A` should be
able to work  with `B`'s abstractions, and vice versa **without modifications
of the original code**. While it may not sound as a problem at first, it
usually is in practice. Sometimes `A` can't use `B`, either because they were
not designed to work with each other as they were written by a different
authors or because one is newer than the other. Either way such cases require
code changes, which may be difficult because code is old, or complicated or
has a license restrictions and there could be millions of other reasons. Any
code hits these issue in some form and it's just matter of time. When that
happens we're left only with a few possible solutions:

#### Feature detection

Typically this is a code that is written not in terms of abstractions, but entities,
that do runtime branching by "feature detection". Which may be a type 
(`if (value instanceof Type)`) or shape
(`if (value && typeof(value.length) === 'number')`) based. This not only makes
code harder to read & reason about, but it also closed. In other words
every new abstraction will require rewrite of those entities, in order
to accumulate more conditions and branches.

#### Wrappers

Typically this means that entities implementing abstraction `A` need to be
wrapped by a "glue code" implementing abstraction from `B` and vice versa, if
consumption is bidirectional. Unfortunately this introduces lot's of incidental
complexity as wrappers ruin identity & don't compose (every new  abstraction
requires wrappers for all existing ones and vice versa). Finally problem and
required changes grow progressively with a number of abstractions used.

#### Monkey patching

Typically this means that implementation of `A` abstraction is patched
with a "glue code" implementing support for `B` abstraction. This still
introduces complexity by ruining namespacing (different abstractions may have
conflicting names). Again problem gets worth with an amount of code. Also in
some languages this is not even possible.

*Note: For more details I would recommend watching a  "A quick overview of
[clojure protocols]" by [Stuart Halloway]*.

# Protocols

In [Clojure polymorphism] is achieved using protocols. They provide a powerful
way for decoupling abstraction interface definition from an actual
implementation per type, without risks of interference with other libraries.
Protocols allow to add polymorphic behavior to things that already exist
without changing them. I'll go into more details on protocols, but for code
examples I will use my [JS prototype][JS Protocol] implementation instead of
clojure code.

There are several motivations for [JS protocol] library:

- Provide a high-performance, dynamic polymorphism construct as an alternative
to an existing object inheritance that does not provides any mechanics for
dealing with name conflicts.

- Provide the best parts of interfaces:

  - Specification only, no implementation

  - Single type can implement multiple protocols

- Allow independent extension of types, protocols and implementations
of protocols on types, by different parties.

## Define protocol

A protocol is a named set of functions and their signatures defined by calling
`protocol` function:

<pre>
<span class="Comment">/*jshint asi:true */</span>
<span class="Comment">// module: ./event-protocol</span>

<span class="Identifier">var</span> protocol <span class="Operators">=</span> <span class="Keyword">require</span><span class="Parens">(</span><span class="String">'protocol/core'</span><span class="Parens">)</span><span class="Operators">.</span>protocol

<span class="Comment">// Defining a protocol for working with an event listeners / emitters.</span>
module<span class="Operators">.</span><span class="Keyword">exports</span> <span class="Operators">=</span> protocol<span class="Parens">(</span><span class="Braces">{</span>
  <span class="Comment">// Function on takes event `target` object implementing</span>
  <span class="Comment">// `Event` protocol as first argument, event `type` string</span>
  <span class="Comment">// as second argument and `listener` function as a third</span>
  <span class="Comment">// argument. Optionally forth boolean argument can be</span>
  <span class="Comment">// specified to use a capture. Function allows registration</span>
  <span class="Comment">// of event `listeners` on the event `target` for the given</span>
  <span class="Comment">// event `type`.</span>
  on<span class="Operators">:</span> <span class="Braces">[</span> protocol<span class="Operators">,</span> <span class="Type">String</span><span class="Operators">,</span> <span class="Type">Function</span><span class="Operators">,</span> <span class="Braces">[</span> <span class="Type">Boolean</span> <span class="Braces">]</span> <span class="Braces">]</span><span class="Operators">,</span>

  <span class="Comment">// Function allows registration of single shot event `listener`</span>
  <span class="Comment">// on the event `target` of the given event `type`.</span>
  once<span class="Operators">:</span> <span class="Braces">[</span> protocol<span class="Operators">,</span> <span class="String">'type'</span><span class="Operators">,</span> <span class="String">'listener'</span><span class="Operators">,</span> <span class="Braces">[</span> <span class="String">'capture=false'</span> <span class="Braces">]</span> <span class="Braces">]</span><span class="Operators">,</span>

  <span class="Comment">// Unregisters event `listener` of the given `type` from the given</span>
  <span class="Comment">// event `target` (implementing this protocol) with a given `capture`</span>
  <span class="Comment">// face. Optional `capture` argument falls back to `false`.</span>
  off<span class="Operators">:</span> <span class="Braces">[</span> protocol<span class="Operators">,</span> <span class="String">'type'</span><span class="Operators">,</span> <span class="String">'listener'</span><span class="Operators">,</span> <span class="Braces">[</span> <span class="String">'capture=false'</span><span class="Braces">]</span> <span class="Braces">]</span><span class="Operators">,</span>

  <span class="Comment">// Emits given `event` for the listeners of the given event `type`</span>
  <span class="Comment">// of the given event `target` (implementing this protocol) with a given</span>
  <span class="Comment">// `capture` face. Optional `capture` argument falls back to `false`.</span>
  emit<span class="Operators">:</span> <span class="Braces">[</span> protocol<span class="Operators">,</span> <span class="String">'type'</span><span class="Operators">,</span> <span class="String">'event'</span><span class="Operators">,</span> <span class="Braces">[</span> <span class="String">'capture=false'</span> <span class="Braces">]</span> <span class="Braces">]</span>
<span class="Braces">}</span><span class="Parens">)</span>
</pre>

- No implementations are provided
- Code above returns a set of polymorphic functions and a protocol object
- Resulting functions dispatch on the argument with an index denoted in
  a signature via special `protocol` element.
-  Other array elements of the signature represent interface definition,
   and does not yet carry any special meaning. (You could use functions to
   highlight types or strings to highlight names or come up with something
   more creative).
- Protocol implementations can be provided at any time from any scope that
  has access to defined protocol.

## Implement protocol

Defined protocols can be implemented per type bases. Since everything in JS is
an `Object` protocol implementation for `Object` type can be though as a
default, since all values will automatically support protocol via that
implementation:

<pre>
<span class="Comment">/*jshint asi:true */</span>
<span class="Comment">// module: ./event-object</span>

<span class="Identifier">var</span> Event <span class="Operators">=</span> <span class="Keyword">require</span><span class="Parens">(</span><span class="String">'./event-protocol'</span><span class="Parens">)</span><span class="Operators">,</span> on <span class="Operators">=</span> Event<span class="Operators">.</span>on

<span class="Comment">// Weak registry of listener maps associated</span>
<span class="Comment">// to event targets.</span>
<span class="Identifier">var</span> map <span class="Operators">=</span> WeakMap<span class="Parens">()</span>

<span class="Comment">// Returns listeners of the given event `target`</span>
<span class="Comment">// for the given `type` with a given `capture` face.</span>
<span class="Function">function</span> getListeners<span class="Parens">(</span>target<span class="Operators">,</span> type<span class="Operators">,</span> capture<span class="Parens">)</span> <span class="Braces">{</span>
  <span class="Comment">// If there is no listeners map associated with</span>
  <span class="Comment">// this target then create one.</span>
  <span class="Statement">if</span> <span class="Parens">(</span><span class="Operators">!</span>map<span class="Operators">.</span>has<span class="Parens">(</span>target<span class="Parens">))</span> map<span class="Operators">.</span>set<span class="Parens">(</span>target<span class="Operators">,</span> <span class="Type">Object</span><span class="Operators">.</span>create<span class="Parens">(</span><span class="Keyword">null</span><span class="Parens">))</span>

  <span class="Identifier">var</span> listeners <span class="Operators">=</span> map<span class="Operators">.</span>get<span class="Parens">(</span>target<span class="Parens">)</span>
  <span class="Comment">// prefix event type with a capture face flag.</span>
  <span class="Identifier">var</span> address <span class="Operators">=</span> <span class="Parens">(</span>capture <span class="Operators">?</span> <span class="String">'!'</span> <span class="Operators">:</span> <span class="String">'-'</span><span class="Parens">)</span> <span class="Operators">+</span> type
  <span class="Comment">// If there is no listeners array for the given type &amp; capture</span>
  <span class="Comment">// face than create one and return.</span>
  <span class="Statement">return</span> listeners<span class="Braces">[</span>address<span class="Braces">]</span> <span class="Operators">||</span> <span class="Parens">(</span>listeners<span class="Braces">[</span>address<span class="Braces">]</span> <span class="Operators">=</span> <span class="Braces">[]</span><span class="Parens">)</span>
<span class="Braces">}</span>

Event<span class="Parens">(</span><span class="Type">Object</span><span class="Operators">,</span> <span class="Braces">{</span>
  on<span class="Operators">:</span> <span class="Function">function</span><span class="Parens">(</span>target<span class="Operators">,</span> type<span class="Operators">,</span> listener<span class="Operators">,</span> capture<span class="Parens">)</span> <span class="Braces">{</span>
    <span class="Identifier">var</span> listeners <span class="Operators">=</span> getListeners<span class="Parens">(</span>target<span class="Operators">,</span> type<span class="Operators">,</span> capture<span class="Parens">)</span>
    <span class="Comment">// Add listener if not registered yet.</span>
    <span class="Statement">if</span> <span class="Parens">(</span><span class="Operators">!</span>~listeners<span class="Operators">.</span>indexOf<span class="Parens">(</span>listener<span class="Parens">))</span> listeners<span class="Operators">.</span>push<span class="Parens">(</span>listener<span class="Parens">)</span>
  <span class="Braces">}</span><span class="Operators">,</span>
  once<span class="Operators">:</span> <span class="Function">function</span><span class="Parens">(</span>target<span class="Operators">,</span> type<span class="Operators">,</span> listener<span class="Operators">,</span> capture<span class="Parens">)</span> <span class="Braces">{</span>
    on<span class="Parens">(</span>target<span class="Operators">,</span> type<span class="Operators">,</span> listener<span class="Operators">,</span> capture<span class="Parens">)</span>
    on<span class="Parens">(</span>target<span class="Operators">,</span> type<span class="Operators">,</span> <span class="Function">function</span> cleanup<span class="Parens">()</span> <span class="Braces">{</span>
      off<span class="Parens">(</span>target<span class="Operators">,</span> type<span class="Operators">,</span> listener<span class="Operators">,</span> capture<span class="Parens">)</span>
    <span class="Braces">}</span><span class="Operators">,</span> capture<span class="Parens">)</span>
  <span class="Braces">}</span><span class="Operators">,</span>
  off<span class="Operators">:</span> <span class="Function">function</span><span class="Parens">(</span>target<span class="Operators">,</span> type<span class="Operators">,</span> listener<span class="Operators">,</span> capture<span class="Parens">)</span> <span class="Braces">{</span>
    <span class="Identifier">var</span> listeners <span class="Operators">=</span> getListeners<span class="Parens">(</span>target<span class="Operators">,</span> type<span class="Operators">,</span> capture<span class="Parens">)</span>
    <span class="Identifier">var</span> index <span class="Operators">=</span> listeners<span class="Operators">.</span>indexOf<span class="Parens">(</span>listener<span class="Parens">)</span>
    <span class="Comment">// Remove listener if registered.</span>
    <span class="Statement">if</span> <span class="Parens">(</span>~index<span class="Parens">)</span> listeners<span class="Operators">.</span>splice<span class="Parens">(</span>index<span class="Operators">,</span> 1<span class="Parens">)</span>
  <span class="Braces">}</span><span class="Operators">,</span>
  emit<span class="Operators">:</span> <span class="Function">function</span><span class="Parens">(</span>target<span class="Operators">,</span> type<span class="Operators">,</span> <span class="Keyword">event</span><span class="Operators">,</span> capture<span class="Parens">)</span> <span class="Braces">{</span>
    <span class="Identifier">var</span> listeners <span class="Operators">=</span> getListeners<span class="Parens">(</span>target<span class="Operators">,</span> type<span class="Operators">,</span> capture<span class="Parens">)</span><span class="Operators">.</span>slice<span class="Parens">()</span>
    <span class="Comment">// </span><span class="Todo">TODO</span><span class="Comment">: Exception handling</span>
    <span class="Statement">while</span> <span class="Parens">(</span>listeners<span class="Operators">.</span>length<span class="Parens">)</span> listeners<span class="Operators">.</span>shift<span class="Parens">()</span><span class="Operators">.</span>call<span class="Parens">(</span>target<span class="Operators">,</span> <span class="Keyword">event</span><span class="Parens">)</span>
  <span class="Braces">}</span>
<span class="Braces">}</span><span class="Parens">)</span>
</pre>

*Note: Implementing protocol for `Object` type is not a
requirement*.

## Extend existing types

Existing types (prototypes or constructors / classes) may be extended to
implement certain protocol by providing type specific implementation. For
example our protocol functions would work with [node.js]'s [EventEmitter]
objects, but in a funny way. Listeners registered by a standard API won't be
called when emitting events with protocol function and vice versa. To fix
that we can implement our protocol for the [EventEmitter] type:

<pre>
<span class="Comment">/*jshint asi:true */</span>
<span class="Comment">// module: ./event-emitter</span>

<span class="Identifier">var</span> EventProtocol <span class="Operators">=</span> <span class="Keyword">require</span><span class="Parens">(</span><span class="String">'./event-protocol'</span><span class="Parens">)</span>
<span class="Identifier">var</span> EventEmitter <span class="Operators">=</span> <span class="Keyword">require</span><span class="Parens">(</span><span class="String">'events'</span><span class="Parens">)</span><span class="Operators">.</span>EventEmitter

EventProtocol<span class="Parens">(</span>EventEmitter<span class="Operators">,</span> <span class="Braces">{</span>
  on<span class="Operators">:</span> <span class="Function">function</span><span class="Parens">(</span>target<span class="Operators">,</span> type<span class="Operators">,</span> listener<span class="Operators">,</span> capture<span class="Parens">)</span> <span class="Braces">{</span>
    target<span class="Operators">.</span>on<span class="Parens">(</span>type<span class="Operators">,</span> listener<span class="Parens">)</span>
  <span class="Braces">}</span><span class="Operators">,</span>
  once<span class="Operators">:</span> <span class="Function">function</span><span class="Parens">(</span>target<span class="Operators">,</span> type<span class="Operators">,</span> listener<span class="Operators">,</span> capture<span class="Parens">)</span> <span class="Braces">{</span>
    target<span class="Operators">.</span>once<span class="Parens">(</span>type<span class="Operators">,</span> listener<span class="Parens">)</span>
  <span class="Braces">}</span><span class="Operators">,</span>
  off<span class="Operators">:</span> <span class="Function">function</span><span class="Parens">(</span>target<span class="Operators">,</span> type<span class="Operators">,</span> listener<span class="Operators">,</span> capture<span class="Parens">)</span> <span class="Braces">{</span>
    target<span class="Operators">.</span>removeListener<span class="Parens">(</span>target<span class="Operators">,</span> type<span class="Parens">)</span>
  <span class="Braces">}</span><span class="Operators">,</span>
  emit<span class="Operators">:</span> <span class="Function">function</span><span class="Parens">(</span>target<span class="Operators">,</span> type<span class="Operators">,</span> <span class="Keyword">event</span><span class="Operators">,</span> capture<span class="Parens">)</span> <span class="Braces">{</span>
    target<span class="Operators">.</span>emit<span class="Parens">(</span>type<span class="Operators">,</span> <span class="Keyword">event</span><span class="Parens">)</span>
  <span class="Braces">}</span>
<span class="Braces">}</span><span class="Parens">)</span>
</pre>

Now this is cool, we managed to add support for our event abstraction
to a type that was not designed to work with it without changing a single
line of code. But this is just a tip of the iceberg, we could implement this
protocol for more types, let's try to do it for [DOM elements]:

<pre>
<span class="Comment">/*jshint asi:true latedef: true */</span>
<span class="Comment">// module: ./event-dom</span>

<span class="Identifier">var</span> Event <span class="Operators">=</span> <span class="Keyword">require</span><span class="Parens">(</span><span class="String">'./event-protocol'</span><span class="Parens">)</span>

Event<span class="Parens">(</span>Element<span class="Operators">,</span> <span class="Braces">{</span>
  on<span class="Operators">:</span> <span class="Function">function</span><span class="Parens">(</span>target<span class="Operators">,</span> type<span class="Operators">,</span> listener<span class="Operators">,</span> capture<span class="Parens">)</span> <span class="Braces">{</span>
    target<span class="Operators">.</span>addEventListener<span class="Parens">(</span>type<span class="Operators">,</span> listener<span class="Operators">,</span> capture<span class="Parens">)</span>
  <span class="Braces">}</span><span class="Operators">,</span>
  off<span class="Operators">:</span> <span class="Function">function</span><span class="Parens">(</span>target<span class="Operators">,</span> type<span class="Operators">,</span> listener<span class="Operators">,</span> capture<span class="Parens">)</span> <span class="Braces">{</span>
    target<span class="Operators">.</span>removeListener<span class="Parens">(</span>type<span class="Operators">,</span> listener<span class="Operators">,</span> capture<span class="Parens">)</span>
  <span class="Braces">}</span><span class="Operators">,</span>
  emit<span class="Operators">:</span> <span class="Function">function</span><span class="Parens">(</span>target<span class="Operators">,</span> type<span class="Operators">,</span> option<span class="Operators">,</span> capture<span class="Parens">)</span> <span class="Braces">{</span>
    <span class="Comment">// Note: This is simplified implementation for demo purposes.</span>
    <span class="Identifier">var</span> <span class="Keyword">document</span> <span class="Operators">=</span> target<span class="Operators">.</span>ownerDocument
    <span class="Identifier">var</span> <span class="Keyword">event</span> <span class="Operators">=</span> <span class="Keyword">document</span><span class="Operators">.</span>createEvent<span class="Parens">(</span><span class="String">'UIEvents'</span><span class="Parens">)</span>
    <span class="Keyword">event</span><span class="Operators">.</span>initUIEvent<span class="Parens">(</span>type<span class="Operators">,</span> option<span class="Operators">.</span>bubbles<span class="Operators">,</span> option<span class="Operators">.</span>cancellable<span class="Operators">,</span>
                      <span class="Keyword">document</span><span class="Operators">.</span>defaultView<span class="Operators">,</span> 1<span class="Parens">)</span>
    <span class="Keyword">event</span><span class="Operators">.</span>data <span class="Operators">=</span> option<span class="Operators">.</span>data
    target<span class="Operators">.</span>dispatchEvent<span class="Parens">(</span><span class="Keyword">event</span><span class="Parens">)</span>
  <span class="Braces">}</span>
<span class="Braces">}</span><span class="Parens">)</span>
</pre>

Think of all the different JS frameworks ([Backbone], [YUI], [Three.js],
[InfoVis], [Raphaël], [Moo Tools], ...) that have their own flavored API for
working with events, you could easily extend them to support our event protocol
and make their abstractions interchangeable through the rest of the codebase
(that makes use of protocols) without original code changes.

## Multiple protocols

All the examples above showed how support for a given protocol may be
added to a different types, but it's not only that, any type may be extended
to implement multiple protocols with absolutely no risks of naming conflicts.
Here is pretty dummy, but still an example illustrating this point:

<pre>
<span class="Comment">/*jshint asi:true latedef: true */</span>
<span class="Comment">// module: ./installable</span>

<span class="Comment">// Protocol for working with installable application components.</span>
<span class="Identifier">var</span> Installable <span class="Operators">=</span> protocol<span class="Parens">(</span><span class="Braces">{</span>
  <span class="Comment">// Installs given `component` implementing this protocol. Takes optional</span>
  <span class="Comment">// configuration options.</span>
  install<span class="Operators">:</span> <span class="Braces">[</span> protocol<span class="Operators">,</span> <span class="Braces">[</span> <span class="String">'options:Object'</span> <span class="Braces">]</span> <span class="Braces">]</span><span class="Operators">,</span>
  <span class="Comment">// Uninstall given `component` implementing this protocol.</span>
  uninstall<span class="Operators">:</span> <span class="Braces">[</span> protocol <span class="Braces">]</span><span class="Operators">,</span>
  <span class="Comment">// Activate given `component` implementing this protocol.</span>
  on<span class="Operators">:</span> <span class="Braces">[</span> protocol <span class="Braces">]</span><span class="Operators">,</span>
  <span class="Comment">// Disable given `component` implementing this protocol.</span>
  off<span class="Operators">:</span> <span class="Braces">[</span> protocol <span class="Braces">]</span>
<span class="Braces">}</span><span class="Parens">)</span>

Installable<span class="Parens">(</span><span class="Type">Object</span><span class="Operators">,</span> <span class="Braces">{</span>
  install<span class="Operators">:</span> <span class="Function">function</span><span class="Parens">(</span>component<span class="Operators">,</span> options<span class="Parens">)</span> <span class="Braces">{</span>
    <span class="Comment">// Implementation details...</span>
  <span class="Braces">}</span><span class="Operators">,</span>
  uninstall<span class="Operators">:</span> <span class="Function">function</span><span class="Parens">(</span>component<span class="Operators">,</span> options<span class="Parens">)</span> <span class="Braces">{</span>
    <span class="Comment">// Implementation details...</span>
  <span class="Braces">}</span><span class="Operators">,</span>
  on<span class="Operators">:</span> <span class="Function">function</span><span class="Parens">(</span>component<span class="Parens">)</span> <span class="Braces">{</span>
    component<span class="Operators">.</span>enabled <span class="Operators">=</span> <span class="Boolean">true</span>
  <span class="Braces">}</span><span class="Operators">,</span>
  off<span class="Operators">:</span> <span class="Function">function</span><span class="Parens">(</span>component<span class="Parens">)</span> <span class="Braces">{</span>
    component<span class="Operators">.</span>enabled <span class="Operators">=</span> <span class="Boolean">false</span>
  <span class="Braces">}</span>
<span class="Braces">}</span><span class="Parens">)</span>

module<span class="Operators">.</span><span class="Keyword">exports</span> <span class="Operators">=</span> Installable
</pre>

*Note:*  That even though both `Event` and `Installable` protocols define
functions `on` and `off`. Also `Object` implements both still protocols, but
there no conflicts arise and functions defined by both protocols can be used
without any issues!

# Summary

I hope you find this interesting & I'm looking forward to your feedback. All
the code examples from this post can be found in the [project repository][code 
examples]. At the moment library is tested and can be used on node.js &
browser, also there are no reasons why it would not work in other JS
environments.

I personally think that protocols are much better feet for a JS language than
redundant [classes][JS classes] and I really wish [ES.next] was considering
them instead!

[clojure protocols]: https://vimeo.com/11236603 "A quick overview of Clojure protocols by Stuart Halloway"
[Clojure polymorphism]: http://www.infoq.com/interviews/hickey-clojure-protocols "Rich Hickey explains Clojure polymorphism"
[clojure]: http://clojure.org/ "Dynamic programming language targeting JVM, CLR &  JS"
[Polymorphism]: http://en.wikipedia.org/wiki/Polymorphism_%28computer_science%29 "Wikipedia: Polymorphism (computer science)"
[JS protocol]: https://github.com/Gozala/protocol "Protocol based polymorphism for javascript"
[Stuart Halloway]: https://twitter.com/#!/stuarthalloway
[EventEmitter]: http://nodejs.org/api/events.html#events_class_events_eventemitter "EventEmitter API documentation"
[node.js]:http://nodejs.org/ "Platform for building fast, scalable network applications"
[Backbone]:http://backbonejs.org/#Events-trigger "Backbone for JS Apps with Models, Views, Collections, and Events"
[YUI]:http://yuilibrary.com/yui/docs/event/ "YUI Library"
[Three.js]:http://mrdoob.github.com/three.js/docs/48/#EventTarget "three.js - JavaScript 3D library"
[InfoVis]:http://thejit.org/static/v20/Docs/files/Options/Options-Events-js.html "JavaScript InfoVis Toolkit"
[Raphaël]:http://raphaeljs.com/reference.html#eve "Raphaël - JavaScript library for working with vector graphics on the web"
[Moo Tools]:http://mootools.net/docs/core/Types/DOMEvent "MooTools is a compact, modular, Object-Oriented JavaScript framework"
[private names]:http://wiki.ecmascript.org/doku.php?id=harmony:private_name_objects
[code examples]:https://github.com/Gozala/protocol/tree/master/examples "Code examples"
[ES.next]:http://wiki.ecmascript.org/doku.php?id=harmony:proposals "ECMAScript Harmony proposals"
[JS classes]:http://wiki.ecmascript.org/doku.php?id=harmony:classes "Classes proposal for ES.next"
[DOM Elements]:https://developer.mozilla.org/en/DOM/element
