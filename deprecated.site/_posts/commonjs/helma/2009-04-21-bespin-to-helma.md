---
layout: post
title: Bespin to Helma
tags: commonjs bespin
---

Finally I manage to take my hands off the keyboard, in order to stop coding 
and to blog about that instead. Yes I know what are you thinking, I should try
to get a life instead :)

Recently I got a fare remark, that my posts are usually too long to keep 
reader interested, so I will try to keep them shorter from now on!!

What do you do, when one day you find out that Mozilla has new experiment, 
project concurring with your pat project ?

- You get really upset. How much it's absolutely proportional on time you 
have spend on it.
- You realize that you have no chance to compete !!
- You are deleting [your project](http://code.google.com/p/gozellen/)
- Finally you realize that you don't have to compete as it's a chance to 
realize you're dream faster!! you can just contribute !!
- You still think that name "Jedi Workshop" was so much cooler :P

So after I went through all this steps above, I have decided to start 
learning internals of bespin, there for I started porting [bespin] backend to 
pure JavaScript. I have chosen [helma-ng] for that. Choice was based on my 
past experience with [helma 1.x] and on a good feedback for NG from people I
trust. Besides in NG we have much more JavaScript then Java, unlike it was 
back in [helma 1.x]. Apparently I have underestimated the speed and amount of
work to be done. Basically I have ported part of the python code, but most of
the time I ended up just applying changes from the last commits to already 
ported code instead of porting more of it. _(Lack of free time on the one 
hand and the lightning speed of the bespin team on the other hand :)_. So if 
someone feels self like want's to jump in, feel free to fork 
[bespin-helma-backend] and annoy me with a questions, you are more then 
welcome!!

Thanks to [Kevin Dangoor] who kicked out [ServerJS] group, cause it seems that
soon we'll be able to write a webapp for helma / any other server side 
javascript environment with ability to deploy it on a completely different 
environment which implementing standard web JSGI interface. That also means 
that bespin backend port will be nicely deployable among variety of Server JS
environments.

That's it!! Was short as promised :)
I'll post more details & some of cool ideas regarding bespin in future posts 
so stay tuned!!

[bespin]:https://bespin.mozilla.com/ "web-based code editor"
[helma-ng]:http://dev.helma.org/ng/ "server-side Javascript environment and web application framework"
[helma 1.x]:http://dev.helma.org/ "Next Generation Helma built from the ground up"
[bespin-helma-backend]:http://github.com/Gozala/bespin-helma-backend/
[Kevin Dangoor]:http://www.blueskyonmars.com/2009/01/29/what-server-side-javascript-needs/
[ServerJS]:http://groups.google.com/group/serverjs
[jack]:http://jackjs.org/