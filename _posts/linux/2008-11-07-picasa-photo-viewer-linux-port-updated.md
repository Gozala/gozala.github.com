---
layout: post
title: Picasa Photo Viewer (Linux port) - Updated
tags: linux
---

Some of you tried to use [Picasa Photo Viewer Which I have posted Previously].
Some of you even had a problems with installation. The thing is that Google 
also realize port for [Picasa 3 Beta for Linux] which you can 
[get here](http://picasa.google.com/linux/). Great news but only sad thing 
about it is that they did not ported **Picasa Photo Viewer** which is a great 
peace of Software by it's own (At least I think so). Even more as I expected 
that the port of **Picasa Photo Viewer** would happen the same time with as 
**Picasa 3** by google I marked my package non compatible with it. 
(To avoid useless garbage on your HDD). Well as some of you are having some 
problems with installation and I wanted to use Edit with Picasa button which 
was broken in the previous build I decided to make another port which will use
an actual Picasa Photo Viewer in the Picasa 3 Package with google. It means no
garbage on HDD, no dependency on wine (Well Picasa has a modified wine itself),
not compatible with Picasa > 3.0. It also should replace previous installation,
if was one. Of course it requires Picasa 3.

I would definitely advice everyone who used this package before or Picasa 2, 
to move to the Picasa 3.

![alt screenshot](http://1.bp.blogspot.com/_HPi35bf7O9Q/SN-hA4vEMGI/AAAAAAAAB_U/yOMZTw14Rys/s320/Screenshot.png "screenshot")

**Updated **

_I received several questions on how to set Picasa Photo Viewer as a default 
photo viewer. As most of the people use KDE or GNOME the instructions can be 
different._

If you are **KDE** user it's reasonably easy. You have to go to

**System Settings** ➥ **Advanced** (tab) ➥ **File Associations**

_There you can set default app per file type_

If you are the **GNOME** user not sure if there some GUI to set default apps 
for file types, but another simple way can be right click on the file 
(with file type you want to associate with Picasa Photo Viewer), in the pop-up 

**Open with** ➥ **Open with other application...** ➥ **Use a custom command** ➥ **PicasaPhotoViewer**

__Unfortunately that's the step to repeat for each file type you want to 
associate__

[Picasa Photo Viewer Which I have posted Previously]:http://jeditoolkit.com/2008/09/28/picasa-photo-viewer-linux-port.html#post
[Picasa 3 Beta for Linux]:http://googlephotos.blogspot.com/2008/10/picasa-3-beta-for-linux.html
[Picasa 3 for Linux]:http://picasa.google.com/linux/
