---
layout: post
title: Evolving VS Adjusting
tags: [commonjs, javascript]
---

We often make choices between adjusting to a conditions and paying a price for
improving them. Usually it's safer to adjust, but still we have to be very
careful to don't miss an opportunity to improve. Probably the best way to do
that is to compare the price and improvements.

[Asynchronous Module Definition] is the hottest topics on the [CommonJS]
[mailing list] this days. Unfortunately my impression is that most of the
participants of this debates forget to measure price VS improvement and this
can be harmful.

I believe there are two camps:

1. People that believe that [CommonJS modules][modules 1.0] are not well suited
for in browser usage (suggesting alternative, "browser friendly" syntax).
2. People who believes that [CommonJS modules][modules 1.0] are perfectly usable
with in browser without any changes.

I'm one among few others who uses CommonJS modules both on the server and in
browser already. With that in mind it's not easy to convince me, that change
in well established standard is absolutely necessary.

### Issues with a current modules ###

There were many arguments why current modules are not suited for in browser
usage, but unfortunately I did not managed to convince enough people to make a
list of them, so I'll summarise them as: "Non of the existing module loading
techniques provides perfect debugging experience across the different browsers
without involvement of a server component or a building step."

### Different view on this issues ###

- Debugging story is not that bad actually (much better than it used to be not
  a long time ago), but it's true, rarely, but still strange issues occur. In
  any case those are bugs in debuggers not with a modules. Only way to fix
  bugs is by report them. I'm pretty confident that [firebug] team is going to
  make their best, to make debugging experience as good as possible. I also hope
  that it's true for a web inspector.
- Dismissing a server as a show stopper is also inadequate IMO, since there are
  few other things like [Offline Application Caching] that would still depend
  on it and won't work without. And in the end it just matter of running one
  simple command before starting development.
  For instance to hack on jetpack you need to run `source bin/activate` and
  I believe it was show stopper for anyone.

### Issues with proposed changes ###

Proposed changes are not perfect either:

- Some people will argue with this statement, but there is nothing in common
  between proposed [Asynchronous Module Definition] and existing
  [module][modules 1.0] specs, other then the CommonJS label. This will be a
  source of confusion and community fragmentation.
  
  Below you can find a simple module being rewritten according to two different
  specs:

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

- Asynchronous definition seem to encourage handwritten boilerplate, what is
  puzzling here is, why would any programmer prefer writing a boilerplate code
  by hand over writing a program that would do that for him. Yes it's nice to
  refresh browser and be ready to go without any build step, but nothing
  prevents us form writing programs that will supports this work flow.
- Most important issue is that, new proposal suggests to adjust to an
  unpleasant situation we are at with browsers now and what's even worth brings
  this mess to the server. Adjustment to a broken tooling is only going to
  delay innovation! I truly believe, that if we've had such a big adoption of
  CommonJS modules few years ago, we would've had perfect debugging story today
  (well maybe not in all browsers :). I also do think that wide adoption
  of CommonJS modules already triggered some innovation and partially that is
  the reason why we might get native modules in in harmony. And you know what ?
  Once we'll get them, no magic will happen, as it did not happened when Web
  Workers arrived. It will take some time to get a decent tooling support.
  Again we should not stop innovation by trying to adjust new amazing platforms
  to the mess we are at with browsers.

### Evolving ###

I think only sane thing to do now, is to bring the innovation that happens in
server side javascript back to the browser without compromising anything. With
that in mind I'm planning to put a lot of effort in [teleport], tool that I
wrote some time ago. It allowed few projects to share CommonJS modules across
server and client. I don't believe there is any perfect solution to all
problems, but each problem has a solution and hope that [teleport] will be
a set of solutions addressing CommonJS module loading problems.
The [list of tasks] I'll be working on, is probably a best way to get a better
idea what's it all about. Feel free to fork me, suggest new ideas or just
comment.

[Offline Application Caching]:http://www.w3.org/TR/offline-webapps/#offline
[CommonJS]:http://www.commonjs.org/
[modules 1.0]:http://wiki.commonjs.org/wiki/Modules/1.0 "Modules/1.0 - CommonJS Spec"
[RequireJS]:http://requirejs.org/ "Asynchronous js module loader optimized for in-browser use"
[mailing list]:http://groups.google.com/group/commonjs "CommonJS mailing list"
[Asynchronous Module Definition]:http://wiki.commonjs.org/wiki/Modules/AsynchronousDefinition
[firebug]:http://getfirebug.com/
[list of tasks]:http://github.com/Gozala/teleport/issues
