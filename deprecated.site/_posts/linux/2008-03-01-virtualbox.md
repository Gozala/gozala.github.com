---
layout: post
title: VirtualBox
tags: linux
---

This post is about a great free & open source program [virtualbox]

Unfortunately sometimes it is bit complicated to get USB working. I made some 
investigation on how to mount USB devices inside virtual machines on my 
Ubuntu 7.10. If you experience same issues this post is certainly for you.

1. First of all you have to install non open source version 
[from here](http://www.virtualbox.org/wiki/Downloads/)

2. Open terminal and type
<script src="http://gist.github.com/369738.js?file=gistfile2.sh"> </script>
<noscript>sudo gedit /etc/init.d/mountdevsubfs.sh</noscript>
uncomment lines below
<script src="http://gist.github.com/369738.js?file=mountdevsubfs.sh"> </script>
<noscript>#mkdir -p /dev/bus/usb/.usbfs \n #domount usbfs "" /dev/bus/usb/.usbfs -obusmode=0700,devmode=0600,listmode=0644 \n #ln -s .usbfs/devices /dev/bus/usb/devices \n #mount —rbind /dev/bus/usb /proc/bus/usb</noscript>
and save file

3. Open terminal and type
<script src="http://gist.github.com/369738.js?file=gistfile3.sh"> </script>
<noscript>sudo gedit /etc/fstab</noscript>
sudo gedit /etc/init.d/mountdevsubfs.sh
add line below
<script src="http://gist.github.com/369738.js?file=fstab"> </script>
<noscript># usbfs \n none /proc/bus/usb usbfs devgid=46,devmode=664 0 0
</noscript>
and save

4. Restart computer

5. Enable in the setting of virtualbox support for usb and have a fun.

[virtualbox]:http://www.virtualbox.org/ "Powerful x86 and AMD64/Intel64 virtualization software"