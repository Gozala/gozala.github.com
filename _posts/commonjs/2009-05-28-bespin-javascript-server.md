---
layout: post
title: bespin - JavaScript Server
tags: commonjs helma bespin
---

I was very very very very busy during these days of silence. But finally I 
have decide to post about what I was busy with during all this time. So there 
will be as series of posts following this one.

I just realized, that last I have posted here, I was still working on bespin 
backend port to helma. Well things change and opinions as well. I've being 
communicating with [Kevin Dangoor](http://www.blueskyonmars.com/) about a port
to helma I was working on, who in the end convinced me to use jack instead. 
The main point, that made me to change my mind was, that you are able to run 
jack apps on the helma-ng so having bespin as jack app automatically would 
mean helma backend as well. So I've forked the Kevin's repo who was working on
jack backend and started pushin there stuff which I already had in helma. On 
the way I have faced some problems, like: I have discovered that there is no 
persistence module in jack yet, so I've ported helma's filestore as it was the
quickest way to go with. I had to downgrade my JS code from 1.8 to 1.6. There 
was some thing which did not made me happier, but I'm not going to write about
them in order to keep this post short, but Kevin have created this nice 
[wiki page](https://wiki.mozilla.org/Labs/Bespin/DesignDocs/JSServer/) where 
you can find about this and much more on a bespin's ServerJS backend. It also 
contains links to all the repos's which have been mentioned above.

Unfortunately nowadays my limited free time is booked with by other things I 
have to do so this is temporary on hold. As far as I know Kevin is also really
busy with other things on bespin, but feel free to jump in or fork me on 
github any help with that is more then welcome!!