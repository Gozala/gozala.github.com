---
layout: post
title: Packageless modules
tags: modules commonjs library nodejs web
---

# Packages #

Every time I write code in javasciprt for jetpack or [nodejs] I question
myself: "Do we really need packages ?". Even with amazing package manager like
[npm] it still feels wrong to me for a few reasons:

### 1. Size and scope ###

Writing code for the web taught us keeping line numbers tight, to a bare
minimum. It could be a platform limitation, but more importantly it's a
[best practice] that has multiple advantages:

 - You never overgeneralize by trying to solve each and every problem.
 - You reduce a surface for bugs, less lines => less bugs.
 - You build reusable building blocks, with a focus on one thing only. Also,
   such blocks are easy to mix and match.
 - Faster to download, parse, execute.

Most of the modern js libraries / frameworks consist of one file, solve one
problem and do it well. [MicroJS] started a great job of promoting this trend
by building a nice spot for discovering fantastic micro frameworks and
libraries!

Package definition, on the other hand, implies wrapping collection of things
into a single form. So no matter how great package manager is, packages will
tend to grow in size attempting to solve bigger set of tasks.

### 2. Explicitness ###

Looking at source should be enough to understand what program does, what
it depends on, etc.. Unfortunately this is not the case with packages as
it requires looking at the package descriptors and understanding non trivial
module search logic. To put it other way
<pre>bar <span class="Operators">=</span> <span class="Keyword">require</span><span class="Parens">(</span><span class="String">'foo/bar'</span><span class="Parens">)</span></pre>
expression depends on too many things: requirer module, package descriptor,
existence of various files in various places. In jetpack [module search] logic
ended up being very complex. NodeJS has a better story, but still there more
than two axis involved. It should be simple & straight forward.

### 3. Simplicity ###

When I find some useful & well maintained module on the web, I just want to be
able to use it straight away, without downloading and bundling with my code, or
even worth creating a package out of it publishing into some centralized
registry in order to finally be able to require it! And when I want to alter
some functionality in third party module I don't want to go through change /
rename / publish routine, I just want to fork on github and require!

### 4. Interoperability ###

Packages are not for browsers, because they have dependencies that have
their own dependencies etc.. All this dependencies are expressed in a separate
`package.json` files and it's impossible to interpret `require` without reading
package descriptor or knowledge of a requirer and I won't even go into details
of search paths and dependency duplications. Only visible solution for using
packages in browsers requires build step on each file change or a server that
does this at runtime. It's a big compromise to make even though we do builds
before deployments.

### 5. Far from harmony ###

No packages are in harmony, just a [simple modules] with compile-time resolution
and linking. Hopefully very soon, I heard that by end of this year, we will
have a first class modules in JavaScript and that will be the ultimate way to
distribute building blocks with built-in support from js engines, so closer we
stick to the model cheaper will be migration.

# Alternative #

Web is awesome, it's cross platform, fully distributed, yet connected via
links / URLs.

I think we should be building ecosystem for building web, with a same spirit:
cross-platform interoperable modules, that are fully distributed across the web,
still connected via URLs. Each doing one thing only, but doing it well. No need
for complicated module search logic or central authority for distribution!
I'm very happy that, [that's exactly how modules][remote modules] are thought
to work in Harmony.

# Solution #

In my spare time I have prototyped a tool called [graphquire] that makes it
possible to write and use such modules, that will work across different
platforms including: jetpack, nodejs and browsers. Unfortunately different
platforms limitations made it impossible to require modules with an actual
URLs, but it very close:

<pre>
<span class="Comment">// Relative</span>
<span class="Keyword">require</span><span class="Parens">(</span><span class="String">'./foo/bar'</span><span class="Parens">)</span>
<span class="Keyword">require</span><span class="Parens">(</span><span class="String">'./bla.js'</span><span class="Parens">)</span>
<span class="Keyword">require</span><span class="Parens">(</span><span class="String">'../baz'</span><span class="Parens">)</span>

<span class="Comment">// Absolute</span>
<span class="Keyword">require</span><span class="Parens">(</span><span class="String">'http!foo.org/bar'</span><span class="Parens">)</span>
<span class="Keyword">require</span><span class="Parens">(</span><span class="String">'https!bla.org/baz.js)</span>

</pre>


You might have some constraints:

1. Long require statements:


   Can be solved in many ways, starting from URL shortening services, finished
   with a private module registries, similar to [MicroJS].

2. Updating require statements more than 1 place:


   Not really an issue with right set of tools like [replace] for example, also
   editors and even [graphquire] might get build-in support for this. In any
   case that's something we will have to face in harmony.

3. Content under URL can change:


   This is true, but same can happen in package registries. We just need to make
   sure to require modules from URLs that are guaranteed to have the same
   content: modules under version tags, registries, own servers.


Please let me know what you think!

[nodejs]:http://nodejs.org/ "Evented I/O for V8 JavaScript"
[npm]:http://npmjs.org/ "NodeJS package manager"
[MicroJS]:http://microjs.com/ "Fantastic Micro-Frameworks and Micro-Libraries for Fun and Profit"
[best practice]:http://en.wikipedia.org/wiki/Best_practice "Methods or processes that have proven themselves over time"
[module search]:https://github.com/mozilla/addon-sdk/blob/master/static-files/md/dev-guide/addon-development/module-search.md
[graphquire]:https://github.com/Gozala/graphquire/
[simple modules]:http://wiki.ecmascript.org/doku.php?id=harmony:modules "Modules proposal for ES.next"
[remote modules]:http://wiki.ecmascript.org/doku.php?id=harmony:modules_examples#remote_modules_on_the_web_1 "Remote module loading examples"
[replace]:https://github.com/harthur/replace
