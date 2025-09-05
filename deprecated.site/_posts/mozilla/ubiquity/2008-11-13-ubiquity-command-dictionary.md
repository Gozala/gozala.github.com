---
layout: post
title: ubiquity command dictionary
tags: ubiquity
---

Another nice command for ubiquity !!!

Well the verb = command is called dictionary and it can handle selection or 
just typed text and will translate it to language specified from the language
specified. Well almost the way like built in translate command works. You can
ask then why do we need another one ??

Well the thing is that [google translate] is pretty nice with translation of the
text, while it sucks if you want to translation just a one word. You will fill
it even more if the word is technical or scientific one. In that case ordinary
dictionaries are much better like [lingvo], [stardict] etc.. They also suggest 
several options again unlike google. At least my sweet angel had this problem
so I have decided to make this verb for her.

The second reason is as I am a Georgian and google translate not (hopefully 
yet) support that language it makes sense to me, to have a Georgian  ➥ English,
English  ➥ Georgian dictionaries. There's really nice Georgian web resource 
<http://translate.ge> which is an online dictionary with a nice API.

Because of all this reasons I decided to create this verb. Unfortunately API 
of <http://translate.ge> and <http://www.lingvo.com/> were very different and 
I had to implement two different approaches and switch between them depending
on language of text to be translated from / to. It even get worth cause unlike
<http://translate.ge> <http://www.lingvo.com/> returns whole html page with
bunch of garbage that needs to be filtered :(

Anyway command is ready for use. Probably there still are some issues, and a
room for improvements, but still it's works so please give it a try and post
some me some feedback!!

Some Tips
---------

By the default verb translates from english to georgian, but it's possible to
change default. (for example to make it from french to russian). If you need 
to do so just navigate to [about:config][about:config] and add two new 
preferences. 

Perform right click  ➥ choose New  ➥ String in the popup  ➥ add

Preference name : ubiquity.commands.Dictionary.from
value : (can be any from ) georgian, english, russian, german, french, 
italian, spanish

Then almost the same same

Preference name : ubiquity.commands.Dictionary. to
value : (can be any from ) georgian, english, russian, german, french, 
italian, spanish

P.S.: Keep in mind that currently you can translate from georgian to english
and other way round or from russian to any from the ones mentioned above and
other way round.

[lingvo]:http://www.lingvo.com/ "Dictionaries for PC and Mobile devices"
[stardict]:http://stardict.sourceforge.net/ "Open source cross-platform international dictionary Software"
[google translate]:http://translate.google.com/ "Google translation service"