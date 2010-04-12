---
layout: post
title: Picasa Photo Viewer (Linux port)
tags: linux
---

<span style="font-weight:bold;font-family:verdana;">Update

This post is out of date, if interested please <a href="http://rfobic.blogspot.com/2008/11/picasa-photo-viewer-linux-port-updated.html">look here</a>

Picasa Photo Viewer</span><span style="font-family:verdana;"> is a nice peace of software powered by Google.
It's included as a part of Picasa 3 (Beta). Public beta was announced few days ago but unfortunately it's only for the windows users. Well if you wonder whats new in this version here is a video by google about the new fea</span><span style="font-family:verdana;">tures.



Only thing that is missing in this video is new app included with Picasa called Picasa Photo Viewer. it can be set as default image viewer app in windows and since then all the images will be opened in a really nice & fast app, without starting Picasa or big loading process great interface and etc. (That's what I was missing for really long time since I moved to Linux. Picasa was great but I had to import images to library an only then I could open and .... )

As I really hate <span style="font-weight:bold;">eye of gnome</span> default photo viewer in Gnome, and I pretty much don't like the rest available in Linux, they</span><span style="font-family:verdana;"> are slow or ugly. So I decided to make a port of Picasa photo viewer to Linux. Maybe some of you knew that Linux version of picasa is in reality is package including wine and bit modified version of windows version of picasa. I decided to use the same technics to port it to Linux. only thing I had to do is to make some script which will convert file path from Linux to the path in wine. Basically that's it just few more tricks with wine profiling and deb packaging. Package is working fine tested on several machines running ubuntu (7.10 ~ 8.10 alfa). After install in the application/graphics you'll find Picasa Photo Viewer. Unfortunately you need few</span><span style="font-family:verdana;"> more manual steps to make it default image viewer app. You need to associate image mime types with this app. easiest way to do it select in nautilus any picture right click > open with > open with other application > Use custom command > PicasaPhotoViewer

P.S.: You have to associate it with all picture mime type's you need to use like *.jpg, *.png, *.raw ... (After first time adding a custom command it also should be available in the list of open with apps)

You can download deb package form the link below, it reqires wine >= 1.0
If you're wine out of date look for the link >> <a href="http://www.winehq.org/site/download">Get wine
</a>
Enjoy!!</span>
<span style="font-family:verdana;">
<a href="http://rapidshare.com/files/148998748/PicasaPhotoViewer.deb.html">Get Picasa Photo Viewer</a>

Upload to the web album & edit with picasa won't work unfortunataly I think I'll wait for <a href="http://picasa.google.com/linux/">Linux port by Google.</a>

Any way if you want to try add this functionality please comment I'll give you some tips how to do that, you can also add functionality to make it default image viewer automatically but it also requires some scripting if wonder how please ask in comments

Here how it looks like

</span><a href="http://1.bp.blogspot.com/_HPi35bf7O9Q/SN-hA4vEMGI/AAAAAAAAB_U/yOMZTw14Rys/s1600-h/Screenshot.png"><img style="float:left;cursor:pointer;margin:0 10px 10px 0;" src="http://1.bp.blogspot.com/_HPi35bf7O9Q/SN-hA4vEMGI/AAAAAAAAB_U/yOMZTw14Rys/s320/Screenshot.png" alt="" border="0" /></a>

<span style="font-family:verdana;">
</span>