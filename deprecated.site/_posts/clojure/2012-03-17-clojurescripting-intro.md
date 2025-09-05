---
layout: post
title: (clojurescripting :intro)
tags: clojure clojurescript cljs
---

This is a first in a series of posts I'm planning to write about my
[clojurescript] learning experience. If you have not heard of clojurescript
yet, it's a [lispy] programing language and a flavor of pretty popular [clojure]
that compile targets JS.

You can find a many impressive [demos][cljs one] and [blog posts][cljs overtone]
about clojurescript, but most of them assume you're coming from clojure. Even
though I read a [book][Programming Clojure] and have watched all the [clojure
screencasts], I never managed to dive into it. Now with clojurescript it's
even more tempting, so I decided to start over again and document every
iteration.

## Objectives

#### 1. Reduce dependencies to minimum

Most of the JS developers are spoiled by using a language that has a brilliant
runtime, it requires absolutely nothing to get started. Also, nature of JS
(everything usually comes over the wire) makes us pretty picky when it comes to
introducing dependencies. No matter if it's a library or tool we'd like to
avoid it, unless absolutely necessary. So in order to be comfortable hacking
with **clojurescript** my first objective is to [reduce dependencies] I'll use
to an absolute minimum.

#### 2. Write "Hello world"

Another objective is of course "hello world" application, which in this case
will mean writing a clojurescript program that writes "hello world" into an
html document.

## Start a package

First of all we need to create a project / package. Assuming you know and
love [npm] first thing you will consider doing is finding an equivalent for a
given language, which turned out to be a [leiningen]! There are multiple ways
one can install it. I used `brew install leiningen` since [homebrew] is
a package manager of my choice. Once leiningen is installed,
`lein new clojurescripting` can be run to generate a blank package. Generated
[project.clj] file is a package descriptor containing package metadata,
equivalent of [package.json] in JS. After some tweaking I ended up with
something like this:

<pre>
<span class="Special">(</span>defproject clojurescripting <span class="String">&quot;1.0.0-SNAPSHOT&quot;</span>
  <span class="Operator">:description</span> <span class="String">&quot;Learning clojurescript&quot;</span>
  <span class="Operator">:url</span> <span class="String">&quot;<a href="http://documentup.com/gozala/clojurescripting/">http://documentup.com/gozala/clojurescripting/</a>&quot;</span>
  <span class="Operator">:license</span> <span class="Special">{</span> <span class="Operator">:name</span> <span class="String">&quot;MIT&quot;</span>
             <span class="Operator">:url</span> <span class="String">&quot;<a href="http://jeditoolkit.com/LICENSE">http://jeditoolkit.com/LICENSE</a>&quot;</span> <span class="Special">})</span>
</pre>

## Write some code

The most basic thing I could think of was an `alert` dialog with "Hello World"
message in it. Note that it requires calling JS function out from the
clojurescript, which turned out to be trivial:

<pre>
<span class="Special">(</span><span class="PreProc">ns</span> clojurescripting.core<span class="Special">)</span>

<span class="Special">(</span>js/alert <span class="String">&quot;Hello World!&quot;</span><span class="Special">)</span>
</pre>

## Compile to JS

Now that the code is there, we need to compile it to JS. Clojurescript [quick
start][cljs quick start] document describes how to do that manually, but
luckily there is a [lein-cljsbuild] plugin for [leiningen] which can be used to
automates this process. To do that you need to configure
[project.clj][project.clj cljsbuild] accordingly:

<pre>
<span class="Special">(</span>defproject clojurescripting <span class="String">&quot;1.0.0-SNAPSHOT&quot;</span>
  <span class="Operator">:description</span> <span class="String">&quot;Learning clojurescript&quot;</span>
  <span class="Operator">:url</span> <span class="String">&quot;<a href="http://documentup.com/gozala/clojurescripting/">http://documentup.com/gozala/clojurescripting/</a>&quot;</span>
  <span class="Operator">:license</span> <span class="Special">{</span> <span class="Operator">:name</span> <span class="String">&quot;MIT&quot;</span>
             <span class="Operator">:url</span> <span class="String">&quot;<a href="http://jeditoolkit.com/LICENSE">http://jeditoolkit.com/LICENSE</a>&quot;</span> <span class="Special">}</span>
  <span class="Operator">:plugins</span> <span class="Special">[[</span>lein-cljsbuild <span class="String">&quot;0.1.2&quot;</span><span class="Special">]]</span>
  <span class="Operator">:cljsbuild</span> <span class="Special">{</span> <span class="Operator">:builds</span> <span class="Special">[{</span> <span class="Operator">:source-path</span> <span class="String">&quot;src&quot;</span>
                          <span class="Operator">:compiler</span> <span class="Special">{</span> <span class="Operator">:output-to</span> <span class="String">&quot;lib/app.js&quot;</span>
                                      <span class="Operator">:optimizations</span> <span class="Operator">:whitespace</span>
                                      <span class="Operator">:pretty-print</span> <span class="Boolean">true</span> <span class="Special">}}]})</span>
</pre>

Once project is configured we need to tell leiningen to install all the
dependencies by running `lein deps`. The best way to compile cljs to JS is by
running `lein cljsbuild auto` which will watch source files and automatically
recompile to JS on changes. This way ergonomics of refresh-driven development
is preserved when working in clojurescript.

Unfortunately I had to straggle for some time before I figured out why JS
file was not generated. The problem is that `lein new` generates `core.clj`
which is a clojure file not a clojurescript one, so one needs to make sure
to rename it to `core.cljs` instead.

## Play

In order to play with a result I needed an html page, so I've created most
basic [index.html][HTML document] in the root of the project directory:

<pre>
<span class="Function">&lt;</span><span class="Statement">body</span><span class="Function">&gt;</span><span class="Identifier">&lt;/</span><span class="Statement">body</span><span class="Identifier">&gt;</span>
<span class="Function">&lt;</span><span class="Exception">script</span><span class="Function"> </span><span class="Type">src</span><span class="Function">=</span><span class="String">./lib/app.js</span><span class="Function">&gt;</span><span class="Identifier">&lt;/</span><span class="Exception">script</span><span class="Identifier">&gt;</span>
</pre>

As you would expect opening it in a browser displayed alert dialog. But since I
wanted to write more clojurescript code I have decided to advance my example
just a little bit so it writes "Hello World" into document body:

<pre>
<span class="Special">(</span><span class="PreProc">ns</span> clojurescripting.core<span class="Special">)</span>

<span class="Special">(</span><span class="Define">defn</span> set-html
  <span class="String">&quot;Sets `.innerHTML` of the given tagert element to the give `html`&quot;</span>
  <span class="Special">[</span>target <span class="Special">&amp;</span> html<span class="Special">]</span>
  <span class="clojureParen1">(</span><span class="Function">set!</span> target.innerHTML <span class="clojureParen2">(</span><span class="Function">apply</span> <span class="Function">str</span> html<span class="clojureParen2">)</span><span class="clojureParen1">)</span><span class="Special">)</span>

<span class="Special">(</span><span class="Define">defn</span> set-text
  <span class="String">&quot;Sets `.textContent` of the given `tagret`  to the given `text`&quot;</span>
  <span class="Special">[</span>target <span class="Special">&amp;</span> text<span class="Special">]</span>
  <span class="clojureParen1">(</span><span class="Function">set!</span> target.textContent <span class="clojureParen2">(</span><span class="Function">apply</span> <span class="Function">str</span> text<span class="clojureParen2">)</span><span class="clojureParen1">)</span><span class="Special">)</span>

<span class="Comment">;; Ineject &quot;Hello world!&quot; into document body.</span>
<span class="Special">(</span>set-html document.body
          <span class="String">&quot;&lt;div style='background: black; color: white;'&gt;&quot;</span>
          <span class="String">&quot;&lt;p&gt;Hello world!&lt;/p&gt;&quot;</span>
          <span class="String">&quot;&lt;/div&gt;&quot;</span><span class="Special">)</span>
</pre>

Just a refresh and changes are applied! In fact, clojurescript has a better
alternative than page refresh but that's topic of the next post!

# Summary

Overall I'm pretty happy with amount of tooling I had to use in order to write
this basic clojurescript powered page. I also really liked [leiningen]'s plugin
system and I hope [npm] will get something similar at some point in a future.
Working with pure JS and DOM on the page is seamless and ergonomics of
refresh driven development is preserved!
On the flip side, I found leiningen to be a painfully slow (as it's written in
clojure and runs on JVM). Hopefully they will speed it up by switch to
[clojurescript on node.js] or [clojure on bare metal] sometime in a future.

Code used in this post can be found under my [clojurescripting] repository on
github.

[npm]:http://npmjs.org/ "Node package manager"
[clojurescript]:https://github.com/clojure/clojurescript
[clojure]:http://clojure.org/
[lispy]:http://en.wikipedia.org/wiki/Lisp_%28programming_language%29
[reduce dependencies]:https://github.com/emezeske/lein-cljsbuild/blob/eefe08fe165d6e998a235b20672ec108820abc44/example-projects/simple/project.clj#L4-8
[cljs one]:http://clojurescriptone.com/ "Build single-page, single-language app without refreshes from repl"
[cljs overtone]:http://www.chris-granger.com/2012/02/20/overtone-and-clojurescript/ "Overtone controller in ClojureScript"
[Programming Clojure]:http://pragprog.com/book/shcloj/programming-clojure "Programming Clojure by Stuart Halloway"
[clojure screencasts]:http://blip.tv/clojure "Screencasts, talks and tutorials on the Clojure programming language."
[leiningen]:https://github.com/technomancy/leiningen "Leiningen is for automating Clojure projects without setting your hair on fire."
[homebrew]:http://mxcl.github.com/homebrew/ "The missing package manager for OS X"
[package.json]:http://package.json.nodejitsu.com/ "CommonJS package descriptor"
[project.clj]:https://github.com/Gozala/clojurescripting/blob/889645f22b67a9f4c9e421e13cd081b2f24bce2f/project.clj "Simple package manifest"
[project.clj cljsbuild]:https://github.com/Gozala/clojurescripting/blob/043befbc8b73d7506a6742ad9b2fdc2e26830efe/project.clj#L6-10 "Configuration for lein-cljsbuild"
[cljs quick start]:https://github.com/clojure/clojurescript/wiki/Quick-Start "ClojureScript quick start wiki page"
[lein-cljsbuild]:https://github.com/emezeske/lein-cljsbuild "Leiningen plugin to make ClojureScript development easy."
[HTML document]:https://github.com/Gozala/clojurescripting/blob/intro/index.html
[clojurescript on node.js]:https://github.com/clojure/clojurescript/wiki/Quick-Start "Running ClojureScript on Node.js"
[clojure on bare metal]:https://github.com/takeoutweight/clojure-scheme "Clojure to Scheme to C to the bare metal."
[clojurescripting]:https://github.com/gozala/clojurescripting/tree/intro

