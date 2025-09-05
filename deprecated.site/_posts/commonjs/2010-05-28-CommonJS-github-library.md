---
layout: post
title: CommonJS based Github library
tags: commonjs
---

This post is about [CommonJS Package], a library, allowing consumers to list,
read, write, delete & comment private / public gists. Library employs v2 & v1
Github API's in combination with some dirty hacks to make this possible. 

Main target platform is a browser, but it can run on any other platform that
will provide implementation of XMLHttpRequests. Since browsers have many
limitations in comparison to other platforms this idea was a challenge form a
beginning. The first thing and probably something you already have in mind is
[same origin policy]. Luckily all modern browsers today implement [W3C]
standard for [cross-origin resource sharing]. Unfortunately though, only a few
websites employ this technique and reply client with 
`Access-Control-Allow-Origin` headers. Believe me or not, [Github] is not one
of those!! Actually [convincing them][github issue] to start useing this
standard was not as easy either...

I did not want to give up, so I have decide to implement this library anyway
with accompany of two proof of concept experiments demoed in previous posts. I
really hope this way I'll get enough attention from Github folks and they will
see a value of improved browser friendly Gist API's :)

As you could've guessed I found a workaround, actually not, I'll better call
it an elegant solution :) Anyway solution to this problem was [YQL]. If you
don't know yet, it's a very cool service from [Yahoo] and likely easiest way
to make [rest] services + all in JavaScript, you should definitely check
it out!! After some hacking I've managed to put together several
["YQL Open Data Tables"][tables] with an access to data that can't be
retrieved with a current Github API's. Most importantly allowing users to
select and insert **private** gists. Since [YQL] puts 
`Access-Control-Allow-Origin` headers, same origin policy problem was solved,
as a side effect it also allowed some optimizations by moving several
operations from client to server.

Unfortunately it's not the end of the story neither it was end of the issues
I had to run into. After a while I discovered that firefox sends `HTTP OPTONS`
request, before sending desired `HTTP POST` on which [YQL] replies without
necessary `Access-Control-Allow-Origin` header. With `HTTP GET` everything is
fine since `HTTP OPTIONS` are not send in that case. Other browsers don't have
issues nor with `GET` nor with `POST` since they don't seem to send 
`HTTP OPTIONS`. I have reported about this [issue] to [YQL] folks and they
were super fast with picking it up, they plan to have a fix in for a next
release, which I hope will be anytime soon.

After all the efforts [github library] is ready to be forked!! So please give
it a try and lets make some amazing stuff to show Github folks that, 
###we need a better Gist API's!!###

[github issue]:http://support.github.com/discussions/gist/148-gist-api
[W3C]:http://www.w3.org/ "The World Wide Web Consortium"
[same origin policy]:http://en.wikipedia.org/wiki/Same_origin_policy
[CommonJS Package]:http://wiki.commonjs.org/wiki/Packages/ "Cohesive wrapping of a collection of modules, code and other assets into a single form"
[YQL]:http://developer.yahoo.com/yql/ "Yahoo Query Language"
[CommonJS]:http://commonjs.org/ "JavaScript ecosystem for web servers, desktop, command line, and browser"
[github library]:http://github.com/Gozala/github/ "CommonJS library for accessing GitHub API"
[cross-origin resource sharing]:http://www.w3.org/TR/cors/
[issue]:http://developer.yahoo.net/forum/?showtopic=5199
[tables]:http://github.com/Gozala/github/tree/gh-pages/resources/
[Yahoo]:http://www.yahoo.com/
[Github]:https://github.com/ "Popular web-based hosting service for projects that use the Git revision control system"
[rest]:http://en.wikipedia.org/wiki/Representational_State_Transfer "RESTful web services"
[BTW]:#btw "By the way"