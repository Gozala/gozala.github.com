---
layout: post
title: Recent changes in SDK
tags: jetpack sdk modules commonjs
published: false
---

There have being some [significant changes][layout changes] to the Add-on
SDK lately, which is a step forward to landing and [shipping SDK in
Firefox][SDK in Firefox]. In this post I'll try to cover what the
changes are.

Probably the most important detail is that SDK no longer uses packages. 
This is an improvement for two reasons:

1. once SDK is in Firefox we won't be able to perform complicated [module search][]
at compile time and even more so at runtime. 
1. We also see it as great improvement to current ambiguous behavior of `require`. 
Now SDK is just a `lib`rary of modules. Once it's in Firefox, all addons will be able
to load any SDK module without needing to convert completely to an SDK-style project. 
1. We also hope to empower other Mozilla projects with [CommonJS][] so that new APIs 
& features can be authored in de facto standard [CommonJS][] module format. 

Going forward, the idiomatic way to require an SDK modules now is: `require("sdk/panel")`. 
Low level and usually less stable APIs will have longer require paths: `require("sdk/window/utils")`.

To ensure that addons built using the old layout are affected by this change we have
analyzed [all the module requirements][analyzes] of all [AMO][] hosted
addons and created a [mapping][module mapping] that maps module requirements
used to a new style. **CFX** - SDK's CLI tool uses this mapping to allow
backwards compatible behavior, while we have no plans on breaking backwards
compatibility in a visible future, we still would like to encourage authoring
new add-ons in idiamatic style this will make your code a lot more portable!

This new layout is currently on the Master branch and is scheduled to be released on 
December 11 as version 1.12. 

[sdk repo]:https://github.com/mozilla/addon-sdk
[SDK in Firefox]:https://github.com/mozilla/addon-sdk/wiki/JEP%20SDK%20in%20Firefox
[layout changes]:https://github.com/mozilla/addon-sdk/commit/9f596b54573b10a1cfe3fc8d1eccdd2eb049891c
[CommonJS]:http://wiki.commonjs.org/wiki/Modules
[AMO]:https://addons.mozilla.org/en-US/firefox/
[analyzes]:https://docs.google.com/spreadsheet/ccc?key=0ApEBy-GRnGxzdHlRMHJ5RXN1aWJ4RGhINkxSd0FCQXc#gid=0
[module mapping]:https://github.com/mozilla/addon-sdk/blob/master/mapping.json
[module search]:https://addons.mozilla.org/en-US/developers/docs/sdk/latest/dev-guide/guides/module-search.html