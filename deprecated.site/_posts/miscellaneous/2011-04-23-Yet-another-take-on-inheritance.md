---
layout: post
title: Yet another take on inheritance
tags: library oop class inheritance javascript
---

Every now and then you need to use inheritance in JavaScript. When you do, you
suffer, because there's just too many ways to do that and regardless of your
choice, syntax noise will make your eyes bleed! Well you may consider saving
your eyes by using a library, but this is not going to save you as you'll be
drown in an ocean of endless choices!

Choice is good, but when it's in manageable quantities. Anyway only reasonable
solution is: Yet another new library that does exact same thing in a slightly
different fashion.

That's a short story of how [extendables] micro-library started. It is super
minimalistic. Function `Extendable` is only thing it exports, which is just
like built-in `Object`. Only difference is `extend` own property that behaves
similar to [backbone]'s `Model.extend`.

`Extendable.extend` may be called with an object containing properties that will
be defined on the resulting constructor's `prototype`. Which by the way, will
inherit from the target function's (function who's `extend` was called)
`prototype`. In addition all own properties of a target will be copied to the
resulting constructor.

That's actually all of what this library does! In contrast to backbone, library
is built with ES5 in mind, which makes it aware of new goodies: non-enumerable,
non-writable and non-configurable properties. This also means that it requires
ES5 engine to run. But don't get broken hearted yet, as you still can use it
on IE6 (Please note that you'll burn in hell if you do!) and friends, with a
help of another micro-lib [es5-shim].

Library is known to work in browsers via AMD loaders, in [jetpack] and in
[nodejs]. Likely it's going to work on any other CommonJS compliant platform
as well. Finally here is a [jsfiddle] and source [gist] showing it off
with a few examples:

<pre>
<span class="Comment">/* vim:set ts=2 sw=2 sts=2 expandtab */</span>
<span class="Comment">/*jshint asi: true undef: true es5: true node: true devel: true</span>
<span class="Comment">         forin: true latedef: false supernew: true */</span>
<span class="Comment">/*global define: true */</span>


define<span class="Parens">(</span><span class="String">'demo'</span><span class="Operators">,</span> <span class="Function">function</span><span class="Parens">(</span><span class="Keyword">require</span><span class="Operators">,</span> <span class="Keyword">exports</span><span class="Operators">,</span> module<span class="Operators">,</span> <span class="Keyword">undefined</span><span class="Parens">)</span> <span class="Braces">{</span>

<span class="String">'use strict'</span><span class="Operators">;</span>

<span class="Identifier">var</span> Extendable <span class="Operators">=</span> <span class="Keyword">require</span><span class="Parens">(</span><span class="String">&quot;<a href="https://github.com/Gozala/extendables/raw/v0.1.2/lib/extendables.js">https://github.com/Gozala/extendables/raw/v0.1.2/lib/extendables.js</a>&quot;</span><span class="Parens">)</span><span class="Operators">.</span>Extendable

<span class="Identifier">var</span> Base <span class="Operators">=</span> Extendable<span class="Operators">.</span>extend<span class="Parens">(</span><span class="Braces">{</span>
  inherited<span class="Operators">:</span> <span class="Function">function</span> inherited<span class="Parens">()</span> <span class="Braces">{</span>
    <span class="Statement">return</span> <span class="String">&quot;inherited property&quot;</span>
  <span class="Braces">}</span><span class="Operators">,</span>
  overridden<span class="Operators">:</span> <span class="Function">function</span> overridden<span class="Parens">()</span> <span class="Braces">{</span>
    <span class="Statement">return</span> <span class="String">&quot;property to override&quot;</span>
  <span class="Braces">}</span><span class="Operators">,</span>
  <span class="Comment">// No supers by default, use prototype and be proud, but if you really want</span>
  <span class="Comment">// super get one!</span>
  _super<span class="Operators">:</span> <span class="Function">function</span> _super<span class="Parens">()</span> <span class="Braces">{</span>
    <span class="Statement">return</span> <span class="Type">Object</span><span class="Operators">.</span>getPrototypeOf<span class="Parens">(</span><span class="Type">Object</span><span class="Operators">.</span>getPrototypeOf<span class="Parens">(</span><span class="Keyword">this</span><span class="Parens">))</span>
  <span class="Braces">}</span>
<span class="Braces">}</span><span class="Parens">)</span>
<span class="Comment">// Adding static method.</span>
Base<span class="Operators">.</span>implement <span class="Operators">=</span> <span class="Function">function</span> implement<span class="Parens">(</span>source<span class="Parens">)</span> <span class="Braces">{</span>
  <span class="Comment">// Going through each argument to copy properties from each source.</span>
  <span class="Type">Array</span><span class="Operators">.</span><span class="Keyword">prototype</span><span class="Operators">.</span>forEach<span class="Operators">.</span>call<span class="Parens">(</span><span class="Keyword">arguments</span><span class="Operators">,</span> <span class="Function">function</span><span class="Parens">(</span>source<span class="Parens">)</span> <span class="Braces">{</span>
    <span class="Comment">// Going through each own property of the source to copy it.</span>
    <span class="Type">Object</span><span class="Operators">.</span>getOwnPropertyNames<span class="Parens">(</span>source<span class="Parens">)</span><span class="Operators">.</span>forEach<span class="Parens">(</span><span class="Function">function</span><span class="Parens">(</span>key<span class="Parens">)</span> <span class="Braces">{</span>
      <span class="Comment">// If property is already owned then skip it.</span>
      <span class="Statement">if</span> <span class="Parens">(</span><span class="Type">Object</span><span class="Operators">.</span><span class="Keyword">prototype</span><span class="Operators">.</span>hasOwnProperty<span class="Operators">.</span>call<span class="Parens">(</span><span class="Keyword">this</span><span class="Operators">.</span><span class="Keyword">prototype</span><span class="Operators">,</span> key<span class="Parens">))</span> <span class="Statement">return</span> <span class="Keyword">null</span>
      <span class="Comment">// Otherwise define property.</span>
      <span class="Type">Object</span><span class="Operators">.</span>defineProperty<span class="Parens">(</span><span class="Keyword">this</span><span class="Operators">.</span><span class="Keyword">prototype</span><span class="Operators">,</span> key<span class="Operators">,</span>
                            <span class="Type">Object</span><span class="Operators">.</span>getOwnPropertyDescriptor<span class="Parens">(</span>source<span class="Operators">,</span> key<span class="Parens">))</span>
    <span class="Braces">}</span><span class="Operators">,</span> <span class="Keyword">this</span><span class="Parens">)</span>
  <span class="Braces">}</span><span class="Operators">,</span> <span class="Keyword">this</span><span class="Parens">)</span>
<span class="Braces">}</span>

<span class="Identifier">var</span> b1 <span class="Operators">=</span> <span class="Operator">new</span> Base
<span class="Keyword">console</span><span class="Operators">.</span>log<span class="Parens">(</span>b1 <span class="Operator">instanceof</span> Base<span class="Parens">)</span>              <span class="Comment">// -&gt; true</span>
<span class="Keyword">console</span><span class="Operators">.</span>log<span class="Parens">(</span>b1 <span class="Operator">instanceof</span> Extendable<span class="Parens">)</span>        <span class="Comment">// -&gt; true</span>
<span class="Keyword">console</span><span class="Operators">.</span>log<span class="Parens">(</span>b1<span class="Operators">.</span>inherited<span class="Parens">())</span>                  <span class="Comment">// -&gt; &quot;inherited property&quot;</span>

<span class="Identifier">var</span> b2 <span class="Operators">=</span> Base<span class="Parens">()</span>                             <span class="Comment">// -&gt; Works same as without `new`</span>
<span class="Keyword">console</span><span class="Operators">.</span>log<span class="Parens">(</span>b2 <span class="Operator">instanceof</span> Base<span class="Parens">)</span>             <span class="Comment">// -&gt; true</span>
<span class="Keyword">console</span><span class="Operators">.</span>log<span class="Parens">(</span>b2 <span class="Operator">instanceof</span> Extendable<span class="Parens">)</span>       <span class="Comment">// -&gt; true</span>
<span class="Keyword">console</span><span class="Operators">.</span>log<span class="Parens">(</span>b2<span class="Operators">.</span>inherited<span class="Parens">())</span>                 <span class="Comment">// -&gt; &quot;inherited property&quot;</span>


<span class="Identifier">var</span> Decedent <span class="Operators">=</span> Base<span class="Operators">.</span>extend<span class="Parens">(</span><span class="Braces">{</span>
  <span class="Keyword">constructor</span><span class="Operators">:</span> <span class="Function">function</span> Decedent<span class="Parens">(</span>options<span class="Parens">)</span> <span class="Braces">{</span>
    <span class="Keyword">this</span><span class="Operators">.</span>name <span class="Operators">=</span> options<span class="Operators">.</span>name<span class="Operators">;</span>
  <span class="Braces">}</span><span class="Operators">,</span>
  overridden<span class="Operators">:</span> <span class="Function">function</span> override<span class="Parens">()</span> <span class="Braces">{</span>
    <span class="Comment">// I'd rather copied `overridden` with a diff name overriddenBase for</span>
    <span class="Comment">// example or used `Base.prototype.overridden.call(this)`</span>
    <span class="Comment">// But this works as well :)</span>
    <span class="Statement">return</span> <span class="String">&quot;No longer &quot;</span> <span class="Operators">+</span> <span class="Keyword">this</span><span class="Operators">.</span>_super<span class="Parens">()</span><span class="Operators">.</span>overridden<span class="Operators">.</span>call<span class="Parens">(</span><span class="Keyword">this</span><span class="Parens">)</span>
  <span class="Braces">}</span><span class="Operators">,</span>
  <span class="Comment">// overriddenBase: Base.prototype.overridden</span>
<span class="Braces">}</span><span class="Parens">)</span>
Decedent<span class="Operators">.</span>implement<span class="Parens">(</span><span class="Braces">{</span>
  bye<span class="Operators">:</span> <span class="Function">function</span> bye<span class="Parens">()</span> <span class="Braces">{</span>
    <span class="Statement">return</span> <span class="String">&quot;Buy my dear &quot;</span> <span class="Operators">+</span> <span class="Keyword">this</span><span class="Operators">.</span>name
  <span class="Braces">}</span>
<span class="Braces">}</span><span class="Parens">)</span>

<span class="Identifier">var</span> d1 <span class="Operators">=</span> <span class="Operator">new</span> Decedent<span class="Parens">(</span><span class="Braces">{</span> name<span class="Operators">:</span> <span class="String">&quot;friend&quot;</span> <span class="Braces">}</span><span class="Parens">)</span>
<span class="Keyword">console</span><span class="Operators">.</span>log<span class="Parens">(</span>d1 <span class="Operator">instanceof</span> Decedent<span class="Parens">)</span>       <span class="Comment">// -&gt; true</span>
<span class="Keyword">console</span><span class="Operators">.</span>log<span class="Parens">(</span>d1 <span class="Operator">instanceof</span> Base<span class="Parens">)</span>           <span class="Comment">// -&gt; true</span>
<span class="Keyword">console</span><span class="Operators">.</span>log<span class="Parens">(</span>d1 <span class="Operator">instanceof</span> Extendable<span class="Parens">)</span>     <span class="Comment">// -&gt; true</span>
<span class="Keyword">console</span><span class="Operators">.</span>log<span class="Parens">(</span>d1<span class="Operators">.</span>inherited<span class="Parens">())</span>               <span class="Comment">// -&gt; &quot;inherited property&quot;</span>
<span class="Keyword">console</span><span class="Operators">.</span>log<span class="Parens">(</span>d1<span class="Operators">.</span>overridden<span class="Parens">())</span>              <span class="Comment">// -&gt; No longer a property to override</span>
<span class="Keyword">console</span><span class="Operators">.</span>log<span class="Parens">(</span>d1<span class="Operators">.</span>bye<span class="Parens">())</span>                     <span class="Comment">// -&gt; &quot;Bye my dear friend&quot;</span>

<span class="Braces">}</span><span class="Parens">)</span>
<span class="Keyword">require</span><span class="Operators">.</span>main<span class="Parens">(</span><span class="String">&quot;demo&quot;</span><span class="Parens">)</span>
</pre>

Finally, if you are a [coffee] fan like me, you'll love the fact that regular
coffee class syntax may be used to extend `Extendable` and it's decedents. Also
all coffee classes that extend `Extendable` can be extended further from
javascript.

[extendables]:https://github.com/Gozala/extendables
[backbone]:http://documentcloud.github.com/backbone/
[es5-shim]:https://github.com/kriskowal/es5-shim
[jetpack]:https://jetpack.mozillalabs.com/
[nodejs]:http://nodejs.org/
[jsfiddle]:http://jsfiddle.net/gh/gist/jquery/edge/937354/
[gist]:https://gist.github.com/937354
[coffee]:http://jashkenas.github.com/coffee-script/
