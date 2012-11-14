---
layout: post
title: interactivate
tags: repl interactive live code web editor
published: true
---

I have made a little live-coding experiment that is primarily inspired by
[Mathematica][] notepad, Bret Victor's [Inventing on Principle][] and has
being pioneered by othe cool projects like [light table][].

I do write JS & HTML every single day and I can't even imagine doing that
without a [REPL][]. Although [scratchpad][] made me realized how I hate
**loop** part of [REPL][]! Another problem is an amount of time one needs to waste,
while being inspired, to get a glimpse of an idea, live on a
screen. Creating HTML, JS files wiring them with each other, page refreshes,
etc... I'm sure we can do better than that, here is a little demo of what I
think it should be like:


<iframe src="http://player.vimeo.com/video/53311490?badge=0" width="500" height="341" frameborder="0" webkitAllowFullScreen="true" mozallowfullscreen="true" allowFullScreen="true">
</iframe>


You can [give it a try][interactivate] yourself or check out the code
[on github][repo].

This expreiment was done in a couple of hours, so it's far from being
stable. It has bunch of known bugs than I need to fix, but I still hope
it was worth sharing.

Making this would have being impossible without awesome open source
projects like [codemirror][] & [browserify][] who'm I wish to give a
good credit.


Finally I really hope to see [Scratchpad][] picking up some of this soon!


[Inventing on Principle]:https://vimeo.com/36579366
[Mathematica]:http://www.wolfram.com/mathematica/
[light table]:http://www.lighttable.com/
[repl]:http://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop "Read Eval Print Loop"
[Scratchpad]:https://developer.mozilla.org/en-US/docs/Tools/Scratchpad
[interactivate]:http://jeditoolkit.com/interactivate/
[repo]:https://github.com/Gozala/interactivate
[codemirror]:http://www.codemirror.net/
[browserify]:https://github.com/substack/node-browserify