---
layout: post
title: bespin chromend
tags: bespin mockup
---

This post is kind of extension, to the idea described in the previous post, 
so if you have not seen it yet it's better check it out. This idea is not only
extension to the previous idea but it's also an extension to a firefox :) 
Basically it's a bespin backend implemented on the chrome side as an extension
to the mozilla toolkit.

Not sure if you ever wrote some code for firefox or any other xulrunner 
application, but if you have this experience I'm sure you'll agree that 
biggest problem with it is a lack of good tools. 
_(This doesn't applies to the Emacs users :)_I think big potential in bespin 
to change all this, I will try to describe how.

Not sure if you ever heard or might even used [mozrepl], firefox extension 
which lets you program Firefox and other xulrunner based applications from the
inside :) Extension listens to a port, once it get's input from connected 
client it evaluates input in the scope of an active window and streams back 
results. Cool thing about [mozrepl] is that it has a support for a custom 
'interactors', this means that you can plug your own interpreter into and 
do whatever with an input. I had a [project][mozshell] with a goal of building
a client for [mozrepl] inside komodo edit. It already had a custom interactor 
for mozrepl capable to reply to XMLHttpRequests. It would be pretty simple to 
modify interactor the way that it will act as a bespin backend :) The hardest
part here is to implement all the User, Project, File etc.. models defined in
current python backend. Guess what ? As I am already working on a port of 
backend to JavaScript all this work could be reused without any modifications
in extension as well. Only thing that would have to be done, would be an 
implementation of File API defined by ServerJS using xpcom's, which won't be a
big deal anyway. Afterwards all this could be packaged as a nice extension and
then ..... 0_o

Just imagine to open bespin inside firefox, with a project firefox inside. 
There you'll be able to modify any file, which will actually modify the source
of firefox, and changes will be available on the fly in the firefox where 
bespin wll be running :) So does this blows up you're mind ? Not yet ? Ok then
imagine being able to open a page source on view-source in bespin inside 
firefox instead of the regular source viewer window !! Hmmm still not enough ?
Ok then imagine being able to set a breakpoints in the bespin inside firefox 
to the source of the firefox in order to debug it :D And remember it doesn't
really has to be you're local firefox it can be even on a different machine on
a different platform or planet as long as you have internet connection there :)

Hope I got you exited, as all this will be something I'm going to focus on as
soon as JS port will be finished. Well debugging part won't be as easy as the
rest, but hope you are able to smell the future of xulrunner development using
bespin!!

[mozrepl]:http://wiki.github.com/bard/mozrepl "MozRepl lets you program Firefox and other Mozilla-based applications from the inside"
[mozshell]:http://code.google.com/p/mozshell/ "MozShell - Komodo extension for remote debugging of xunrunner based appications"
[bespin]:https://bespin.mozilla.com/ "web-based code editor"