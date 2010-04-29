---
layout: post
title: Picasa Photo Viewer (Linux port)
tags: linux
---

[Picasa Photo Viewer] is a nice software from Google and it is included as
a part of [Picasa 3 (Beta)][Picasa]. Public beta was announced few days
ago but unfortunately it's only for the windows users. If you wonder whats
new in this version here is a video by google about the new features.


<object width="640" height="385">
	<param name="movie" value="http://www.youtube.com/v/rskC6c_5L1M&color1=0xb1b1b1&color2=0xd0d0d0&hl=en_US&feature=player_embedded&fs=1"></param>
	<param name="allowFullScreen" value="true">	</param>
	<param name="allowScriptAccess" value="always"></param>
	<embed src="http://www.youtube.com/v/rskC6c_5L1M&color1=0xb1b1b1&color2=0xd0d0d0&hl=en_US&feature=player_embedded&fs=1" type="application/x-shockwave-flash" allowfullscreen="true" allowScriptAccess="always" width="640" height="385"></embed>
</object>


Only thing that is missing in this video is new application included with
[Picasa] called / [Picasa Photo Viewer]. it can be set as default image
viewer application in windows and after all images will be opened in a
nice & fast tool, without starting Picasa and long loading process + great
interface etc. That's something I was missing for a long time, since I
moved to Linux. [Picasa] is great but it's a photo manager not a viewer
and importing images to library and only after accessing them is not for
me.

As I really hate [Eye of Gnome], default photo viewer of [Gnome], and pretty 
much all the other available photo viewers on linux, since I think they are 
slow and ugly. So I've decided to make a hacking session, and try to port of
[Picasa photo viewer] to linux. Some of you might know, that linux version of
[Picasa] is just package with preconfigured [Wine] and slightly modified 
windows version of Picasa. I thought I could do the same trick to port
[Picasa photo viewer]. Only thing I had to do was a wrapper script converting
image path to a windows paths in a preconfigured wine. Well and few more
tricks to configure wine and package all this as a ".deb" package. Result
works surprisingly well on several different [Ubuntu]*(7.10 ~ 8.10 alfa)* 
installations on different machines. After installing a package you'll find 
it in **application ➥ graphics ➥ Picasa Photo Viewer**. Unfortunately you need
to make few manual steps to make it default image viewer cause I have not 
found any way to do automatically. Anyway if you want to use it by default 
you need to associate image mime types with it and easiest way to do so is to:

- Select any picture
- Right click on it & select open with other application
- Select "Use custom command"
- type `PicasaPhotoViewer`

P.S.: You have to associate it with all picture mime-type's you want to
use it with *(.jpg, .png, .raw ...)* After adding a custom command once you should be able to select it from a list in the 'open with'

You can download a deb package [form here][picasa photo viewer for linux].
It requires [wine] >= 1.0.

Enjoy!!

Upload to the web album & edit with picasa won't work unfortunately but I hope I'll motivate google to make a proper port this way. 

And finally that's how it looks like:

![thumbnail][preview thumbnail]![lightbox][preview lightbox]

[Picasa]:http://picasa.google.com/ "Free photo editing software from Google"
[Picasa Photo Viewer]:# "Quick image viewer shipped with Picasa"
[Eye of Gnome]:http://projects.gnome.org/eog/ "Official image viewer for the GNOME Desktop environment"
[Gnome]:http://www.gnome.org/ "The Free Software Desktop Project"
[Wine]:http://www.winehq.org/ "Software that lets you run Windows applications on other operating systems"
[Ubuntu]:http://www.ubuntu.com/ "Ubuntu is an open-source Linux based alternative to Windows"
[picasa photo viewer for linux]:/resources/files/PicasaPhotoViewer.deb
[preview thumbnail]:/resources/images/picasa-photo-viewer-thumbnail.jpg
[preview lightbox]:/resources/images/picasa-photo-viewer.png