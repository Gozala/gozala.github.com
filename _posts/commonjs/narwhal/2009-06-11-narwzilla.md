---
layout: post
title: narwzilla
tags: commonjs
---

As you might noticed from my last blog posts I'm quite passion on ServerJS. 
So ? So I have new pat now, BTW it's my favorite one so far.. :P I mentioned 
in one of my previous blog posts that I would like to have a bespin as 
firefox extension and I had a thought that it will be very simple to port it 
from jack once I will finish the port from python. Well I was wrong !! 
What does that mean ? It means bye to *xpcom* and hello to *require.* From 
now on you can have exactly same code running on your js beased server or in 
your browsers extension. I have implemented a new platform for narwhal which 
is firefox, any xulrunner based app, or a xulrunner itself. After all my 
experience with xulrunner and xpcom I feel like switching from bike to a 
Ferarri. Feel free to take 
[my Ferrari][narwhal-xulrunner] for a ride and let me know what do you think!!

Only thing you would have to do would be an installation of extension. After 
it's done you have to do. 

<script src="http://gist.github.com/369718.js">Components.utils.import('resource://narwzilla/narwhal.js');</script>

once you've done line above feel self in narwhal and enjoy the ride !!

[narwhal-xulrunner]: http://github.com/Gozala/narwhal/downloads "XULRunner engine for Narwhal"