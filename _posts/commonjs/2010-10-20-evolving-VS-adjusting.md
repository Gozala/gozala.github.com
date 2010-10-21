---
layout: post
title: Evolving VS Adjusting
tags: [commonjs, javascript]
---

[Asynchronous Module Definition] is the hottest topics on the [CommonJS]
[mailing list] this days and I think it deserves a lot of attention, specially
because outcome may be harmful for entire javascript community.

I would divide participants of this discussion in to two camps:

1. Believers that [CommonJS modules][modules 1.0] are not well suited for in
browser usage (suggesting alternative, "browser friendly" syntax).
2. Believers that [CommonJS modules][modules 1.0] can be perfectly used in
browser without any changes.

I'm one among few others who uses CommonJS modules both on the server and in
browser already. Obviously it's not easy to convince me, that change of
well established standard is absolutely necessary.

### Issues with a current modules ###

There were many arguments why current modules are not suited for in browser
usage, but unfortunately I did not managed to convince enough people to make a
list of them so I'll try to summarise them as: "Non of the existing module
loading techniques provides perfect debugging experience across the different
browsers without involvement of a server component or building step."

### Different view on this issues ###

- Debugging story is not that bad actually, yes sometimes strange issues
  occur, but rarely. In any case that's an issues with debuggers not with
  a modules. I'm also pretty confident that [firebug] team is going to make
  their best, to make debugging experience as good as possible. Just report
  a bug if you run into one and incorporate to get it fixed.
- Dismissing a server as a show stopper is also inadequate, since there are
  other things like [Offline Application Caching] that would depend on that
  component anyway and won't work without. That being said, it's also seems
  quite reasonable to run one simple command before starting development.
  For instance to hack on jetpack you need to run `source bin/activate` and
  I believe it did not stopped any developer.

### Issues with proposed changes ###

- Some people will argue with this statement, but there is nothing in common
  between proposed [Asynchronous Module Definition] and existing
  [module][modules 1.0] specs, other then the CommonJS label. This of course
  will be a source of confusion and community fragmentation. To illustrate this
  point better, I wrote exactly the same module according to this two different
  specs.

  Asynchronous definition:

  <script src="http://gist.github.com/636422.js?file=asincdefinition.js">
        define("foo", ["bar"], function (bar) {
            return {
              doAnotherThing: function() {
                return bar.doSomething() + 2;
              }
            };
        });
  </script>

  CommonJS module:

  <script src="http://gist.github.com/636422.js?file=commonjs-module.js">
        var bar = require("bar");
        exports.doAnotherThing = function() {
          return bar.doSomething() + 2;
        }
  </script>

- Asynchronous definition encourages handwritten boilerplate. What puzzles me
  is, why would any programmer prefer writing a boilerplate code by hand over
  writing a program that would do that for him. Yes it's nice to refresh
  browser and be ready to go without any build step, so let's write programs
  that will supports that work flow.
- Most important issue is that, new proposal suggests to adjust to an
  unpleasant situation we are at with browsers and what's even worth brings
  this mess to the servers. Adjustment to a broken tooling is only going to
  prevent innovation! I truly believe, that if we've had such a big adoption of
  CommonJS modules few years ago we would've had perfect debugging story today
  (well maybe not in all browsers :). I'm also of an opinion, that CommonJS
  modules highlight problem that javascript needs modules and in fact now we
  might even get them in harmony. And you know what, once we'll get them no
  magic will happen, as it did not happened when Web Workers arrived. It will
  take some time to get a decent tooling support, but again it will happen only
  if we'll try to innovate instead of trying to adjust code and new exciting
  platforms to a broken mess.

### Innovating ###

I think that building a good tools addressing issues with current module
loaders is only way to evolve. With that in mind I'm planning to put a lot of
effort in [teleport], tool that I wrote some time ago, which allowed few
projects to share CommonJS modules across server and client. I don't believe
there is any perfect solution to all problems, but each problem can have
solution and hope that's what [teleport] will be a set of solutions to a set
of problems. [The list of tasks] I wrote is probably a best way to get a better
idea what's it all about. Feel free to fork me, suggest other ideas or just
comment.


[Offline Application Caching]:http://www.w3.org/TR/offline-webapps/#offline
[CommonJS]:http://www.commonjs.org/
[modules 1.0]:http://wiki.commonjs.org/wiki/Modules/1.0 "Modules/1.0 - CommonJS Spec"
[RequireJS]:http://requirejs.org/ "Asynchronous js module loader optimized for in-browser use"
[mailing list]:http://groups.google.com/group/commonjs "CommonJS mailing list"
[Asynchronous Module Definition]:http://wiki.commonjs.org/wiki/Modules/AsynchronousDefinition
[firebug]:http://getfirebug.com/
[list of tasks]:http://github.com/Gozala/teleport/issues

