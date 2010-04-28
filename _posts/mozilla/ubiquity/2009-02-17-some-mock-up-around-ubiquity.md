---
layout: post
title: Some Mock-up around Ubiquity
tags: ubiquity mockup
---

In this post I am planing to talk about new Ubiquity command I'm working on 
currently & share some of my thought about:

- Ubiquity in general
- Problems I've faced during development
- Improvement ideas

![ubiquity][ubiquity thumbnail]![lightbox][ubiquity lightbox]

Not a long time ago I have realized that I've posted about several ubiquity
commands I developed, but I have never tried to share my opinions regarding
project itself. So I have decided to do so: I think that [Ubiquity] is just 
incredible way to increase usability of a browser on one hand and usability of
web itself on another. One more reason why I think [Ubiquity] is a really cool
project is it's unique 'command' development API that allows writing very 
complex 'commands' while preserving simplicity. I'm pretty sure that one hour
with [ubiquity] will be enough for any web developer to get started. Wiki has 
a nice [tutorial] to get you up to speed.

Before I will start talking about difficulties I've faced, I will describe
briefly the command itself:

Actually it's not a command, it's a set of commands for working with 
[Bugzilla]. As you might know [Bugzilla] has a standard API for external 
client applications. Methods can be accessed via [XML-RPC]. So I have decided 
to write [Bugzilla] client on top of [Ubiquity] API. Currently commands are 
under the development so there's not much functionality yet, but fell free to 
[play with it][bugzilla command] or [contribute][bugzilla command sourece].

You might could've guess that the command is quite complex. Actually that's 
one of the issues I've faced. While it's really simple to develop complex 
but 'targeted commands', it almost exponentially hard to develop generic ones.
By 'targeted commands' I mean commands that do one or maybe two tasks and 
accept only one or two modifiers. To give a better overview I will try to 
describe users requirements _(at least the way I see them)_.

- As a user I would like to use one command during the flow of a task. 
Technically speaking command should have kind of **namespace? / topic** used
for communication with [Ubiquity] while performing a task. It should be sort
of a keyword describing [target] against which I'm planning to take some 
[actions][action].
- As a user I want to have a set of verbs to describe what [actions][action] 
I am able to perform against [target].
- As a user I want to have a set of [modifiers][modifier] to describe what 
exactly [actions][action] have to do with a [target].
- To preserve simplicity, I would like to have more humanized interface 
where ubiquity remembers whatever I'm discussing with it. I mean that I don't
have to describe all the details (**modifiers**) every time I execute command.  
<u>Example</u>:  
> When I am discussing some [firefox][modifier] [bug][modifier] with a real 
> person which is only reproducible in [Linux][modifier], I don't repeat 
> details of a bug over and over again.  
> <u>I would never say</u>:  
> > "I have [commented][action] [firefox][modifier] bug, which occurs only on
> > [Linux][modifier], that [I was not able to reproduce it][data]".  
> <u>I would rather say</u>:  
> > "I have [commented][action] a bug that 
[I was not able to reproduce it][data]"
> cause I would expect that person I'm talking with still remembers topic of 
our discussion.

Here is another example with an actual thing I would like to have for 
[Bugzilla ubiquity commands][bugzilla command].

- I'd like to [get][action] [comments][modifier] about [bug][modifier] from 
bugzilla. (There can be several bugzilla systems of my interest. One from 
mozilla and another from KDE ...)
- I'd like to be able to store my [sessions][modifier] the way I'll be able 
to simply identify the origin of the [bug][modifier] I'm talking (mozilla or
KDE).
- [comment][action] a [bug][modifier] with some useful [information][data] 
*(again in particular bugzilla [session][modifier])*
- I'd like to [get][action] [information][data] about [user][modifier] *(can 
get user by [username][data] / [email][data]) again in particular bugzilla 
[session][modifier])

In the example above we have:

- **actions** : get, comment.
- **data**: information.
- **modifiers**: bug, session, user, username, email.

but the problem is that action [get][action] can handle two different 
modifiers [bug][modifier] and [user][modifier]. Lets assume that in case 
we mean [bug][modifier] its just a number / id, while in case of 
[user][modifier] it's bit more complicated, since it can take 
[username][data] or [email][data] as a value, besides it just needs one at a
time. One way to solve this is to add all of the modifiers to the get command.
Problem is that about it is that then you would have to calculate which
modifiers have been passed and based on that figure out weather user meant
to get info on a user or a bug. We should keep in mind that we can confuse 
users that way as well as they will see all this possible modifiers. One 
more problem is that confused user may type something like:

> **get 156 me@email.com**

Did user meant to find info on a bug or a user? Well obviously he's confused 
and typed something even more confusing, but we have to find out that. So we 
have to add some extra logic to parse user input more precisely.

Another example:

> **get bug 156 username me** 

Is user looking for a bug or user info? Should we suggest bugs with numbers 
starting with 156 or users with the names me or both ?

Think it's clear now that adding modifiers is a bad solution, besides in a 
real life it's way more complex, since you can find bug by: assignees, 
reporters, resolution, by report date, by target os and many other modifiers. 
It's a same with users, even worse, cause some of them may have modifiers like
[user_id][modifier] so if you'll search by assignees you're passing the 
[user_id][modifier] and you can do the same if you're looking for the users 
with the [user_id][modifier]. Sure it's possible to identify them with 
different names but for a complex commands it still a nightmare, and not a 
simple to use at all. 

Well there's another solution to use different names for actions, actually 
that what usually ubiquity command developers do (From what I noticed), but 
unfortunately here is a limitation as we can't use space separated names for 
actions. So the solution is to have two commands [get-user][action] and 
[get-bug][action] in this case most of the mentioned problems are solved, but 
it's not really a natural language. Besides names are quite generic and a lot
of commands might introduce them so in order to avoid conflicts we have to 
use [bugzilla-get-user][action], [bugzilla-get-bug][action]. Tendency is 
visible commands become less and less natural :(. I have to mention that in 
case of Bugzilla command[s] we would have to complicate command even more.

I was thinking about alternative solution, in order to keep things more 
natural and I think there is good potential in 'dynamic modifiers' - context 
aware modifiers that are capable of introducing additional modifiers.
Lets look at the flow below:

> **me:** Can you please [comment][action] on a bug ?  
> **ubiquity**: What should be the [comment][data] ?
> (requires additional input)  
> **me:** [I'm not able to reproduce it][data]  
> **ubiquity:** I suppose you mean [bug][additional modifier] [146][data] or 
> might be one of [846][data], [400][data], [8942][data] (assumes that I'm 
> talking about a bug we discussed previously, but it also reminds me some 
> other bugs we've discussed recently)  
> **me:** [bug][modifier] [846][data]  
> **ubiquity:** So you mean [bug][modifier] [846][data] in [mozilla][modifier]
> (verifies that I am talking about mozilla bugzilla cause we talked about 
> it last time)  
> **me:** and attach [screenshot][data] please  
> **ubiquity:** Do you like this one ??  
> **me:** perfect!  

No, no you don't have to type all this!! It's just a model of a conversation 
we're gonna create flow out of:

1. bugzilla co[nnect][# "suggested complition"] as there are two actions 
(1. connect 2. comment) targeting bugzilla command ubiquity completes input 
with "bugzilla connect" because [connect][action] is most recently used action
with bugzilla command. Ubiquity preselects auto-completed part so that user
can modify it while just keep typing. Ubiquity also adds [comment][action] 
action to a suggestions. In case if I'll press button:

	- right arrow / enter / tab  
	ubiquity will request / verify next modifier *(more details will follow
	in a next section)*

	 - down arrow
	in this case we'll see a picture described in the 2nd list item.

2. bugzilla comment [(text)][data]
	ubiquity will auto-complete word "comment" and will show that it expects 
	text input by adding and selecting "(text)" in case of active selection 
	selection will be used instead. If clipboard contains data it will be show
	up in suggestions. In case if I'll:
	
	- stop typing / will make a delay  
	I'll get a picture described in the 3nd list item.
	- press right arrow / enter / tab  
	I'll get a picture described in the 3nd list item.
	- press left arrow  
	action [comment][action] will be selected and the other bugzilla
	associated actions will be suggested. In the preview help for the 
	comment action will appear. In case of selecting other action all of 
	the following modifiers will disappear.
	- will press down arrow  
	in case of suggestions next one will get activated and all the input
	data will be adjusted accordingly.
	
3. bugzilla [comment][action] "[I’m not able to reproduce it][data]" on a 
[bug][modifier] [146][data]  
Ubiquity auto-completes with "on a bug 146" ("on a bug" is a prefix for 
modifier bug). Selecting "146" as it's a modifier bug accessed most recently,
ubiquity verifies that I’m still interacting with it, at the same time it 
still leaves ability to type the id manually. It adds other bugs into 
suggestions 846, 400, 8942 as they’ve been recently used. Ubiquity suggests 
everything it has in history as the whole modifier is selected in this case. 
In the preview information for the currently selected bug (146) is shown.

In case if I press button:

* 8  
Ubiquity will auto-complete it with "46" (as it’s was accessed more recently 
then 8946) and will select auto-completed part (46). In the suggestions only 
8942 will show up as it’s an only matching bug id from the history. In the 
preview information for the currently selected bug (846) is shown.
* right arrow / enter / tab  
In this case ubiquity will request / verify next modifier
* down arrow
In this case we'll have a picture described in the 4th list item (as the first
suggestion is 846).
* left arrow
input "I'm not able to reproduce it" will be selected in case of having 
selection, clipboard data they will be suggested.

4. bugzilla comment "I’m not able to reproduce it" on a bug 846 in session 
mozilla.  
Ubiquity auto-completes with "in the session mozilla" ("in the session " is a 
prefix for modifier-session). Ubiquity verifies that it needs to use mozilla 
as modifier-session as it was used most recently. It also adds all the available sessions in suggestions cause whole modifier is selected. (kde, eclipse) At the same time in preview it shows info for mozilla session. (user, url)

	in case if I press button:

	    * e
	      Ubiquity will auto-complete it with “eclipse” (it’s wasn’t accessed more
	      recently then kde but it allows to go on typing unlike “kde”) and will select auto-completed part (“clipse”). In the
	      suggestions only “kde” will show up as it’s an only matching session. In the preview information for the currently selected session
	      (eclipse) is shown.
	    * right arrow / tab
	      in this case ubiquity will put cursor in the end of the line and will show all possible (optional) modifiers in the suggestion.
	    * down arrow
	      will select “kde” as a session and will select only matching part of it “e”
	    * left arrow
	      modifier-bug “846″ will be selected in all possible suggestions will be suggested.
	    * enter
	      Will add a comment to the bug

5. bugzilla comment ” I’m not able to reproduce it” on a bug 846 and attach (data)
	I have typed at as I wanted to attach file with a comment. Ubiquity did not suggested attach-modifier as it’s an optional. but when I type “at”, it auto-completes it with “and attach (data)” where “and attach ” is a prefix for the attach-modifier. “(data)” got selected. Ubiquity suggests clipboard, screen-shot in the suggestions as that are the magic words which attach-modifier can take as an input.

What are the advantages of this kind of architecture:

* All the commands performing the actions against one target can be scoped by 
  the namespace. Actually it can be a one command.
* Command Modifiers can have their own modifiers, that makes it possible to 
  create better abstraction layer of the services on top of the Ubiquity.
* Modifiers have are ordered in a logical way, and some of them can be 
  optional, value of one modifier can automatically make useless use of 
  another modifier.
* Makes commands more closer to the natural language, cause in this model 
  modifier is modeled as a sentence. Use of prefixes, suffixes makes it much 
  easier to represent in more human way (it’s even more important in some 
  languages where suffix / prefix can change whole meaning of the sentence)
* Modifier is having step by step dialog with a user, keeping user focused 
  more on the step rather on the end result.
* Asks user for input only in case if there is no other way
* User types only the data no modifier names.
* Ubiquity uses history to make discussion more intuitive. (Actually it’s 
  possible to do it even now through commands but think it might have a sense
  to expose this functionality some in some standard manner to the developers)

[ubiquity thumbnail]:/resources/images/ubiquity-thumbnail.jpg
[ubiquity lightbox]:/resources/images/ubiquity.jpg
[Ubiquity]:https://mozillalabs.com/ubiquity/ "An experimental interface based on natural language input"
[tutorial]:https://wiki.mozilla.org/Labs/Ubiquity/Ubiquity_0.1_Author_Tutorial#The_Ubiquity_0.1_Command_Tutorial "Ubiquity command development tutorial"
[Bugzilla]:http://www.bugzilla.org/ "Mozilla bug tracking system"
[XML-RPC]:http://www.xmlrpc.com/spec "remote procedure call protocol using XML through HTTP"
[bugzilla command]:http://gozala.github.com/ubiquity/commands/bugzilla/ "Ubiquity command for working with bugzilla"
[bugzilla command source]:http://gozala.github.com/ubiquity/commands/bugzilla/
[action]:#action "verb to describe what action command performs against target"
[target]:#target "Object against which action is performed"
[modifier]:#modifiers "Details what exactly action should perform against target"
[data]:#data "Data used in performing an action on a target"
[additional modifier]:#additional_modifier "Additional details required by dynamic modifier"