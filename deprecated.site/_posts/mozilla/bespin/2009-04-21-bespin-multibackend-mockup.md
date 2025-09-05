---
layout: post
title: bespin multibackend mockup
tags: bespin mockup
---

Finally I forced myself to spend some time with photo editing software in 
order to make this mockup. As I mentioned in my recent post I had 
[pet project][gozellen] which was something like [bespin] is. When [bespin] 
was lunched, I had to kill my pet ;( I have to admit that I really like ideas
[Bespin] is build on, not to mention that my pet was far behind :) Anyway 
I had one interesting idea for my project which was not on a bespin's roadmap,
since I thought idea was cool I tried to promote it on [bespin mailing list].
I did not got much attention, guess because of a bad description, so I have
decided to write this post to show all the potential of it.

Personally, I thing that idea of having many [Bespin] instances on different
web servers and different backends is very wrong, cause most of the developers
including myself would like to have a single cloud based editor with all the 
setting and plugins configured, so that it's ready to be used it at office, 
at home for personal projects, for local files, etc...

I want to be able to use it from any computer I will have to work with, no 
matter if I'm online or not. Thinking of synchronizations of a settings, 
plugins etc.. between servers makes me think of the editors we've have today.
I do think bespin can be and should be different :) To ambitious, I know, but
lets brainstorm some ideas I have:

![bespin mock thumbnail]![lightbox][bespin mock]

This image shows how [bespin] dashboard can look like. In the first column 
you can see groups (Bespin, github, Private, local, work) containing projects.
Each of those groups is a representation of a connections with a hosts 
(bespin backend).  
Lets go through each group too see more details and examples.

- Connection: Bespin   
  
> ![online projects]  
  
> That's a connection with the server <https://bespin.mozilla.com/>. Projects 
> listed under this group are the projects which are hosted on 
> <https://bespin.mozilla.com/> server. Connection label **Bespin** is displayed
> in orange color, what means, that connection is in **online mode**.

- Connection: github  
  
> ![project settings]  
  
> That's a connection with the server <https://github.com/bespin/>. Projects 
> listed under this group (mozshell@lds.ge, seethrough_js, helma-ng) are 
> hosted on the github server. Here, as in previous example connection label
> is displayed in orange color, what means that connection is in **online 
> mode**. Unlike in previous image you can see fields (label, host, username,
> password) here. That's because user have opened settings for this 
> connection. I guess you're really confused now, but let me explain what I 
> mean. Idea is that user is able to create connections with a different 
> backends. Let's assume that github also hosts bespin. Adding connection to 
> github bespin account should be possible even if user is on the 
> <https://bespin.mozilla.com/> since bespin will know host for each project,
> when user will try to open a file from project under connection github, 
> `XMLHttpRequest` will be sent not to the <https://bespin.mozilla.com/> where
> bespin is loaded from, but to from <https://github.com/bespin/>. **(Lets 
> ignore xhr restrictions for now :).** In setting user can change the label
> for connection, or even host url and login info.

- Connection: private
  
> ![project flakymode]
  
> That’s a connection with the server <https://privatehost.local/>. Lets 
> suppose it’s a connection with host which is not accessible now. But using 
> gears / html 5 offline storage projects and files under this connection are
> still available, just like in gmail :). The Violette connection label means
> that host is in a flaky mode. User can edit files save changes, besically 
> do whatever he is able while being online and all the changes will be synced
> with a corresponding server when connection will go to online mode.

> ![project tosyncmode]

> Violate file titles mean that this files have local changes which will be 
> synced in **online mode**.

- Connection: local

> ![project minimized]

> That's a connection with the server <http://localhost:8080/>. There is no
> projects listed under this group, because connection group is folded. As you
> might noticed in all the rest images there was "-" sign in the right corner
> of the connection, meaning that you can fold this group. In this case there
> is "+" sign meaning that connection group is folded and it can be unfolded.
> Here, as in first 2 examples connection label is displayed in orange color,
> meaning that connection is in **online mode**.

- Connection: work

> ![project offline]

> That's a connection with server <https://intranet/>. Connection label is 
> displayed in gray and no projects are listed under. This means that host is
> unreachable and this connection is in **offline mode**. In 3rd example host
> was also unreachable, but connection was in **flaky mode**. Reason is that
> in that example host had support for local data caching and synchronizations.
> In this case host doesn't supports / restricts local data caching, there for
> no data is available when host is unreachable.


Hope that now whole picture and the idea is much clearer. Of course there's a
lot's of valid questions regarding how to implement this, but it's a totally 
different topic. There's already Cross-site HTTP requests in firefox 3.5 and
hope more browsers will follow this example. We could use gears or html 5
offline storage for working offline etc. But the idea of this post was to
suggest ideas and then start discussion around them.

[gozellen]:http://code.google.com/p/gozellen/ "web based code editor"
[Bespin]:https://bespin.mozilla.com/ "web based code editor"
[bespin mailing list]:http://groups.google.com/group/bespin

[bespin mock thumbnail]:/resources/images/bespin-mock-thumbnail.png
[bespin mock]:/resources/images/bespin-mock.png
[online projects]:/resources/images/onlineprojects-mock.png
[project settings]:/resources/images/editprojectsettings-mock.png
[project flakymode]:/resources/images/flakymode-mock.png
[project tosyncmode]:/resources/images/tosync-mock.png
[project minimized]:/resources/images/minimized-mock.png
[project offline]:/resources/images/offline-mock.png