# MediaKeys

A small headless Cocoa App, which responds to the MediaKeys on Apple Wireless keyboards.

### Notes

* This app directly calls Shell commands for macports mpd / mpc (Music Player Daemon)

* You may change these commands to call your own preferred music player / media player.

* Supports 10.6+ (Snow Leopard) or later only. But you can make support for 10.4-10.5.

* Sudo isnt needed if can avoid `/usr/bin/sudo /opt/local/bin/port load mpd`

The XCodeProject builds a number of app bundles. 

* `MediaKeys` is the persistent one which you should put in your StartupItems.

* The other variants eg `MediaKeysPause` can be executed on a 1 time bases. Those ones each just perform 1 specific operation and then exit immediately. Useful for hooking up the same functionality to another program, eg RemoteBuddy behaviour or Aurora.

## MPD Configuration

	# 1. Passwordless sudo (needed for starting the mpd daemon)
	username ALL=(ALL) NOPASSWD: ALL
	
	# 2. install macports
	
	# 3. install mpd
	sudo port install mpd
	sudo port install mpc

	# 4. Edit the sample mpd.conf and point to your iTunes library
	mate MediaKeys/mpd.conf
	sudo cp -f MediaKeys/mpd.conf /opt/local/etc/mpd.conf
	
	# 5. Initialize mpd database
	cp MediaKeys/mpd.conf /opt/local/etc/mpd.conf
	mpd --create-db --stdout /opt/local/etc/mpd.conf
	
	# Start the mpd Server
	sudo port load mpd

	# 6. Write a playlist named "all shuffle"
	mpc ls | mpc add
	mpc shuffle
	mpc save "all shuffle"

## Links

[http://discussions.apple.com/thread.jspa?threadID=2122639&start=0&tstart=0](http://discussions.apple.com/thread.jspa?threadID=2122639&start=0&tstart=0)

[http://www.macosxhints.com/article.php?story=20021202054815892](http://www.macosxhints.com/article.php?story=20021202054815892)

[http://www.musicpd.org/forum/index.php?action=printpage;topic=2029.0](http://www.musicpd.org/forum/index.php?action=printpage;topic=2029.0)

[http://www.musicpd.org/forum/index.php?action=profile;u=1208;sa=showPosts](http://www.musicpd.org/forum/index.php?action=profile;u=1208;sa=showPosts)

[http://www.rogueamoeba.com/utm/2007/09/29/apple-keyboard-media-key-event-handling/](http://www.rogueamoeba.com/utm/2007/09/29/apple-keyboard-media-key-event-handling/)

[http://en.wikipedia.org/wiki/MPD_%28Music_Player%29](http://en.wikipedia.org/wiki/MPD_%28Music_Player%29)

[http://mpd.wikia.com/wiki/Music_Player_Daemon_Wiki](http://mpd.wikia.com/wiki/Music_Player_Daemon_Wiki)


## Other issues (recommended to read)

* Before using MediaKeys you should rename the BundleIdentifier string in the iTunes package. (the BundleIdentifier is stored in the info.plist). This is a workaround because iTunes will launch whenever you hit the Play/Pause key. This will disable the use of the special media keys in iTunes.

* There are the Bundle Identifiers for various other popular Music Players / Media Players. These are used for an "ignore list". Its likely that some other apps which also respond to the media keys aren't listed there. Add the relevant Bundle Ids to the list and re-compile. In case of problem, fire up the XCode Debugger to see whats happening.

* Its not really known yet how to block or intercept these media key events higher up in the AppKit / windowserver level. Certain keys (like volume up, volume down, and Expose key) will open a System Preferences Pane, or do other things when used in conjunction with a modifier key. You may try the iTunes trick again here and rename the relevant bundle identifiers.

* MediaKeys.app has LSUIElement == true, they are not visible in the User Interface. Just `ps -ax | grep MediaKeys` to get the PID # or `killall -9 MediaKeys` to quit.

Enjoy!


Copyright (c) 2010 dreamcat4
