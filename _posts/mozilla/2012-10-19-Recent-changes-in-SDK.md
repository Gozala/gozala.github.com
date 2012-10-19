---
layout: post
title: Recent changes in SDK
tags: jetpack sdk modules commonjs
published: false
---

There have being some [significant changes][layout changes] to Add-on
SDK lately, which is a step forward to landing and [shipping SDK in
Firefox][SDK in Firefox]. In this post I'll try to cover what the
changes are.

Probably the most important detail is that SDK no longer has notion
of packages. This was both mandatory since in a future where SDK
is in Firefox we won't be able to perform complicated [module search][]
at compile time and even more so at runtime. We also see it as great
improvement to current ambiguous behavior of `require`. Now SDK is just a
`lib`rary of modules. Once it's in Firefox, old-style addons will be able
to take advantage of individual parts. We also hope to empower other Mozilla
projects with [CommonJS][] so that new APIs & features cane be authored in de
facto standard [CommonJS][] module format. There for idiomatic way to require
SDK modules now is: `require("sdk/panel")`. Low level and usually less stable
APIs will have longer require paths: `require("sdk/window/utils")`.


To ensure that no addon's will be affected by this change we have
analyzed [all the module requirements][analyzes] of all [AMO][] hosted
addons and created a [mapping][module mapping] that maps module requirements
used to a new style. **CFX** - SDK's CLI tool uses this mapping to allow
backwards compatible behavior, while we have no plans on breaking backwards
compatibility in a visible future, we still would like to encourage authoring
new add-ons in idiamatic style this will make your code a lot more portable!



[sdk repo]:https://github.com/mozilla/addon-sdk
[SDK in Firefox]:https://github.com/mozilla/addon-sdk/wiki/JEP%20SDK%20in%20Firefox
[layout changes]:https://github.com/mozilla/addon-sdk/commit/9f596b54573b10a1cfe3fc8d1eccdd2eb049891c
[CommonJS]:http://wiki.commonjs.org/wiki/Modules
[AMO]:https://addons.mozilla.org/en-US/firefox/
[analyzes]:https://docs.google.com/spreadsheet/ccc?key=0ApEBy-GRnGxzdHlRMHJ5RXN1aWJ4RGhINkxSd0FCQXc#gid=0
[module mapping]:https://github.com/mozilla/addon-sdk/blob/master/mapping.json
[module search]:https://addons.mozilla.org/en-US/developers/docs/sdk/latest/dev-guide/guides/module-search.html
