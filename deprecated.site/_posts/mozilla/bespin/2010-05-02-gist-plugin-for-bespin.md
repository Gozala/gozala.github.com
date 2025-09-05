---
layout: post
title: Gist plugin for Bespin
tags: bespin
---

As it was announced on a [Bespin blog] recently, plugin development got a lot
easier and it's really so. Today I am happy to share a [gist plugin] I've 
developed. It allows users to list / create / open gists, all from the editor.
Enough with a words!! It's always better to see, so I've put together a
screencast, that demos some of the plugin features. It's my debut [BTW], so
please be gentle with a feedback.
    
<object classid='clsid:d27cdb6e-ae6d-11cf-96b8-444553540000' 
    codebase='http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,115,0'
    width='560' 
    height='345'>
    <param name='movie' value='http://screenr.com/Content/assets/screenr_1116090935.swf'/>
    <param name='flashvars' value='i=66914'/>
    <param name='allowFullScreen' value='true'/>
    <embed src='http://screenr.com/Content/assets/screenr_1116090935.swf' 
        flashvars='i=66914'
        allowFullScreen='true'
        width='560'
        height='345'
        pluginspage='http://www.macromedia.com/go/getflashplayer'>
    </embed>
</object>

Hope you're inspired now and will give it a try!! My favorite part about
plugin is that it's only JavaScript without any backend dependency. It means
that it's possible to bundle plugin with an embedded version of Bespin and I
hope this will encourage third parties to do some crazy stuff with it!!
Anyway, give it a try and post me a feedback!!

###Technical details###

Plugin is basically adapter of my [CommonJS] based [github library] that
provides access to a Github API's. I'm not going to go into details, since 
there will be another, dedicated post about it. I will mention though, that
library relays on [YQL] & [cross-origin resource sharing] on browser.
Unfortunately there is an **[issue]** on [YQL] side that makes it impossible
to use HTTP POST with Firefox. This means that gist size is limited, but only
on Firefox and temporary, cause [YQL] folks are super fast, and are planning
to get a fix into next release.

[Bespin blog]:http://mozillalabs.com/bespin/2010/04/29/bespin-0-7-3-released-usability-improvements-docs-and-fixes/ "Bespin 0.7.3 released"
[gist plugin]:http://github.com/downloads/Gozala/github/gist-v0.1.1.zip "URL used to install a plugin"
[YQL]:http://developer.yahoo.com/yql/ "Yahoo Query Language"
[CommonJS]:http://commonjs.org/ "JavaScript ecosystem for web servers, desktop, command line, and browser"
[github library]:http://github.com/Gozala/github/ "CommonJS library for accessing GitHub API"
[cross-origin resource sharing]:http://www.w3.org/TR/cors/
[issue]:http://developer.yahoo.net/forum/?showtopic=5199

[BTW]:#btw "By the way"