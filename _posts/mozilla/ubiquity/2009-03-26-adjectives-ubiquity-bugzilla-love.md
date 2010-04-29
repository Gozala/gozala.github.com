---
layout: post
title: Adjectives | Ubiquity + Bugzilla love
tags: ubiquity bugzilla
---

Finally I got a new laptop and a weekend to play with something interesting !!
As I mentioned in one of my previous blog posts I had some discomfort with 
Ubiquity while trying to work on a complex commands. I also mentioned some 
ideas how I thought the things could be improved. Unfortunately I have not got
any support from Ubiquity side so I decided to try to implement whatever I had
in my mind. (If interested check my previous posts). You might noticed  link
on my home page pointing to the feed with a set of Ubiquity Commands for 
Bugzilla. Well development process is in it’s alpha period right now, but 
still I would be happy if you’ll give it a try and of course any feedback is 
more then welcome. It won’t kill your browser or PC in the worst case scenario
you can just unsubscribe from the command feed.

So in this post I want to touch several topics

1. Current state of Bugzilla commands
2. View from the inside – Adjectives, way to extend nouns
3. Problems / Plans


Current state of Bugzilla commands  
----------------------------------

Currently feed contains several commands:

- **bugzilla-connection-add**

- **bugzilla-connection-remove**

> The idea behind these commands is to make user able to configure several 
> Bugzilla connections. For most of the users I can imagine there will be only
> one connection for Bugzilla, but there will be some people (For example) who
> would need to have several of them. I personally use 
> <https://bugzilla.mozilla.org> and <https://bugs.kde.org>, so not being able
> to use Bugzilla commands on any of thous is unacceptable.

> Ideally you won’t be able to use Bugzilla command until you’ll set up at 
> least one connection. In order to do so all you need is to type

> **[bugzilla-connection-add][command]** [name][modifier] [mozilla][data] 
> [url][modifier] [https://bugzilla.mozilla.org][data] [user][modifier]
> [USER][data] [password][modifier] [PASSWORD][data]

> ![bugzilla connect thumbnail]![lightbox][bugzilla connect]

> Please change the [USER][data] with the real user which should be your email
> address and [PASSWORD][data] with whatever your password is. In the end it
> should look like picture above. (In case if you don’t have a user / password
> you can register and get them otherwise you can type some random words) 
> Currently none of the commands use user / pass data.

> Name of the connection in the example above – mozilla, is the name you’ll 
> use to tell ubiquity, which bugzilla system are you talking about... (There
> will be more details below).

- **bugzilla-info-version**

> This is simple command which will show the version of the Bugzilla system on
> the server. Nice part here is that Ubiquity knows that we have only one 
> connection so it automatically uses that one. Typing command itself should 
> be enough to see:

> ![bugzilla version thumbnail]![lightbox][bugzilla version]

- **bugzilla-get**

> This one is the last one, so far, but it’s a sweetest on as well !! Yes it 
> returns the info for the bug by it’s id. This nice pat takes input of, bug
> numbers separated by white-space character(s) and uses async calls to get 
> the data from Bugzilla xmlrpc service. Well it’s better to look at the 
> picture below:

> ![bugzilla get 1 thumbnail]![lightbox][bugzilla get 1]

> Important points are not that visible yet. As you can see in the 
> screen-shot’s ubiquity always adds string “in mozilla” to the command 
> suggestions. It’ trivial cause we have only one connection and we called it
> mozilla so what’s a big deal about it ?… Well lets add one more connection 
> by running command:

> **[bugzilla-connection-add][command] [name][modifier] [kde][data] 
> [url][modifier] [https://bugs.kde.org][data] [user][modifier] [USER][data] 
> [password][modifier] [PASSWORD][data]**

> Now we have when we have two connections one for Mozilla and another for KDE
> we can look at few more pictures.

> Ubiquity will search bug 4234 in the KDE Bugzilla system, still not a big 
> deal I agree, but since you started discussion with ubiquity about KDE it 
> remembers it like if it was a human

> ![bugzilla get 2 thumbnail]![lightbox][bugzilla get 2]

> In this screen we can see that Ubiquity automatically suggests to search for
> a Bug in the KDE Bugzilla as I started typing in kde

> ![bugzilla get 3 thumbnail]![lightbox][bugzilla get 3]

> In this screen I just typed the bug number, but as I was talking with 
> ubiquity about bugs in KDE it assumes that I still talk about KDE so I don’t
> need to retype that part again

> ![bugzilla get 4 thumbnail]![lightbox][bugzilla get 4]

> In this case I just typed command without specifying nor connection nor bug 
> id.  As I mentioned bug 9876 in the KDE bugzilla ubiquity still assumes that
> I’m talking about the same things and that’s the way we act while discussing
> something with humans. We assume that person we are talking with 
> understands, that we are talking about the same topic unless we changed it.
> So I tried to bring the same approach here ubiquity remembers whatever you
> said and assumes that next command is related to previous one so you don’t
> need to repeat all the details. Ubiquity stores this data across the
> sessions so even week after the last command you can still go on with it.
> Benefits of this approach will be much more visible when the next command 
> bugzilla-comment  will be fired where you’ll be able to specify only comment
> (connection & bug will be resolved automatically)

View from the inside – Adjectives, way to extend nouns
------------------------------------------------------

So below is the code which adds a function `CreateAdjective` to the `CmdUtils` 
that can be used inside the command feed. Function itself extends normal 
ubiquity nouns to so called “adjectives“. Basically it function takes noun as
an argument and adds some useful functions, getters, properties. Lets take a 
look at each of the features:

- dependency resolution
Lets talk about the command bugzilla-get which was demoed in the first part. 
Command takes bug id and connection. Each of those two arguments are nouns 
first one BugById and second one Connection. As the first one populates data 
from server it makes no sense at all if there is no connection to server from 
which this data could be populated. Logically BugById depends on Connection. 
Connection itself populates data from the preferences which at some point was
stored by user, so logically Connection depends on the existence of 
(lets assume) X preference. Of course this could be easily checked by the 
command on preview with some if / else closes, but if we’ll look a bit forward
into command bugzilla-comment which will take a comment, which depends on the
bug, which depends on a connection we have even more closes in the commands,
this closes are often shared between the commands... Code gets messy and I am
sure you could think of even more complicated situations here.
Function adds getter reliable to the noun which returns `true` in case if all
the dependencies were reliable. Basically it checks reliable property of each
dependency. Dependencies are the members of the array which is property 
"dependencies" of the noun. In case if noun has no dependencies it is 
automatically reliable. In our case BugById has member 
`dependencies = [Connection]`. While Connection has member 
`dependencies = [{get reliable() { /* check of the existence of the preference */}}]`

- delay before suggestions
As mentioned above noun BugById populates it’s data / suggestions from the 
server, basically it means that it sends user input to the server and 
generates suggestions from the server response data. Unfortunately it means 
that on each key-press noun makes request to the server which takes traffic 
slows down ubiquity itself, while the idea is to send a user input when the 
input is done. In this particular case if I want to get info for a bug 1768 
there will be for requests (1, 17, 176, 1768) while I just need the last one.
If noun had a property delay and noun got extended to an Adjective. suggest 
function of the noun will be fired only after user stops typing for `{delay}` 
milliseconds.

- History control
One of the nice features in the demo above was that ubiquity was assuming the
values of the modifiers that have not been specified by user. Simply Assuming
that value is the one which user has specified last time. Actually there could
be case were ubiquity would need more then just last value. In the BugById 
it's necessary to get the info from server but there could be the cases where
the caching data locally could be much better option. Also this data should be
stored between the sessions. Doing all this history control flow soon becomes
complex (Initially I tried that way :)
So noun extended to the Adjective will get function history which takes 
optional argument to specify how many suggestions from history should be 
taken, if noun had property cache with value true history will be populated 
from the local store. if not it will just get a text and will use suggest 
function of the noun to rebuild data as if it was users input. function can 
take second optional argument for callbacks in case if data should be 
retrieved from the server  in async manner. In that case callback will be 
called for each suggestion. This way the last suggestion could be accessed 
with `history(1)[0]` or full history by `history()`. If noun has a property 
memory, it's a number of the suggestions that can be stored in the history if
no memory member exists in noun memory will be `10`.  History can be added 
from the command itself by calling addHistory() and passing modifier and 
particular element from history can be removed as well by calling 
`removeHistory`. Unfortunately  there is no way to automate this process as 
noun doesn't knows which suggestion was selected by user.

I believe a lot can be still improved in this schema (Like storing suggestion
in the SQLite instead of prefs), but that's how it looks now.

<script src="http://gist.github.com/384296.js"> </script>
<noscript><a href='http://gist.github.com/384296'>source</a></noscript>

Problems / Plans
----------------

- Ubiquity had a regression recently so I had to introduce workaround to a 
[bug 484615](https://bugzilla.mozilla.org/show_bug.cgi?id=484615).

- Bugzilla API is not really seems to be designed for this so changes there 
will be more then welcome (As you might noticed in the screen-shots there are 
fields like component product reporter where you can see id’s, while just 
textual description is much better, making the separate calls for all this 
fields could be expensive and it will make code more complex => hard to 
maintain). Max Kanat-Alexander – Added nice comment suggesting help in this 
direction. Max unfortunately I have no idea how to contact you, so if you're 
reading this post I’ll be happy to have a chat with you about it.

- Lack of time !!!!

- I’ll be happy to contribute `CreateAdjective` to Ubiquity, I don’t mind to
change it the way that it can fit the rest code-base, just let me know if 
there is any interest in this direction.

- I’m going to implement full featured client for Bugzilla, (don’t know about 
admin part think it’s too crazy)

- Next command that will be added to this Bugzilla collection will be 
bugzilla-comment

Wow I wrote a lot !!! Hope you’re still enjoying reading this post. As always
any feedback is more then welcome!!

[bugzilla connect thumbnail]:/resources/images/bugzilla-connection-add-thumbnail.png
[bugzilla version thumbnail]:/resources/images/bugzilla-info-version-thumbnail.png
[bugzilla get 1 thumbnail]:/resources/images/bugzilla-get-1-thumbnail.png
[bugzilla get 2 thumbnail]:/resources/images/bugzilla-get-2-thumbnail.png
[bugzilla get 3 thumbnail]:/resources/images/bugzilla-get-3-thumbnail.png
[bugzilla get 4 thumbnail]:/resources/images/bugzilla-get-4-thumbnail.png
[bugzilla connect]:/resources/images/bugzilla-connection-add.png
[bugzilla version]:/resources/images/bugzilla-info-version.png
[bugzilla get 1]:/resources/images/bugzilla-get-1.png
[bugzilla get 2]:/resources/images/bugzilla-get-2.png
[bugzilla get 3]:/resources/images/bugzilla-get-3.png
[bugzilla get 4]:/resources/images/bugzilla-get-4.png

[command]:#command
[modifier]:#modifier
[data]:#data
[additional modifier]:#additional_modifier "Additional details required by dynamic modifier"