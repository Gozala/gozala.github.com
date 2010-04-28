---
layout: post
title: Google App Engine + Helma = geekcloud
tags: commonjs helma
---

Lets suppose you are a web developer playing with Server Side JavaScript. It's
pretty obvious that you would like to have some JS hosting :) Right that's me,
and I'm happy to post, that since 15th of April, there is a nice option for 
us !! This option is [Google App Engine]. Hosting by Google that provides 
500MB of persistent storage and enough CPU and bandwidth for about 5 million 
page views a month without billing enabled.

I won't spend lot's of lines here, trying to explaining how to make all this 
possible, cause there is nice [post on helma-ng wiki] describing all the 
necessary steps. Unfortunately there are some restrictions on app engine side 
preventing access to the file system, and as the default persistence module in
helma is implemented using filestore it was a problem. Well not anymore as 
there is [early implementation](http://github.com/hns/helma-ng/blob/master/modules/helma/googlestore.js) 
of persistence module based on app engine data store.

So... back to me, as you might guess I have started experimenting :) Have not 
done much there yet, as I have dedicated most of my free time to bespin port. 
But still there's a [link to check out](http://geekcloud.appspot.com/).
*geekCloud* is going to be my new home!!! but for now it's just a way how my 
future pet might look like :) Honestly it's nothing more then a template 
generation, with a broken links inside. Page is ported from my old but never 
finished web site. _(Don't tell anybody but I was implementing it using 
<span style="font-size:xx-small;">php</span> :)_ I mentioned template 
generation, so I will add some more detail, I don't use 
[helma build-in template engine]. Instead I have decided to use alternative 
extensible template engine [seethrough_js] written by [Massimiliano Mirra]. 
I'm going to push helma-ng webapp to github as soon as I will get something 
meaningful and I promise it won't be yet another CMS!!

[Google App Engine]:http://code.google.com/appengine/
[post on helma-ng wiki]:http://dev.helma.org/ng/Running+Rhino+and+Helma+NG+on+Google+App+Engine/
[helma build-in template engine]:http://dev.helma.org/ng/helma.skin/
[seethrough_js]:http://wiki.github.com/bard/seethrough_js
[Massimiliano Mirra]:http://hyperstruct.net/