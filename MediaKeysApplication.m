//
//  MediaKeys.m
//  MediaKeys
//
//  Created by id on 06/01/2010.
//  Copyright 2010 dreamcat4. All rights reserved.
//

#import "MediaKeysAppDelegate.h"
#import "MediaKeysApplication.h"

@implementation MediaKeysApplication

BOOL mpd_started()
{
	return ! system("/opt/local/bin/mpc &> /dev/null");
}

void mpd_start()
{
	if( ! mpd_started() )
	{
		int rv;
		rv=system("/usr/bin/sudo /opt/local/bin/port load mpd");
		printf("%i\n",rv);
		sleep(0.5);
		system("/opt/local/bin/mpc load all\\ shuffle");
		system("/opt/local/bin/mpc shuffle");
	}
}

void mpd_stop()
{
	if( mpd_started() )
	{
		system("/opt/local/bin/mpc stop");
		system("/opt/local/bin/mpc shuffle");
	}
}

void mpd_play()
{
	system("/opt/local/bin/mpc play");
}

void mpd_pause()
{
	system("/opt/local/bin/mpc pause");
}

void mpd_toggle()
{
	system("/opt/local/bin/mpc toggle");
}

void mpd_next()
{
	system("/opt/local/bin/mpc next");
}
void mpd_prev()
{
	system("/opt/local/bin/mpc prev");
}

- (BOOL)ignoreKey
{
	// 10.6+ Only, this won't compile on earlier versions
	// You can use NSWorkspace for 10.5, 10.4
	int retval = false;

	// Suppress our MediaKey events only when one of these othe apps is "active" (focussed)
	NSArray* cabis = [NSArray arrayWithObjects:
		@"org.videolan.vlc",
		/* when these don't support media keys: */
		@"at.justp.Theremin",
		@"com.doubleTwist.desktop",
		/* when we expect you have diabled iTunes MediaKeys 
		  by renaming it's BundleIdentifier (info.plist) */
		@"com.apple.iTunes",
		nil];
	
	for(NSString* bi in cabis) 
	{
		NSArray* ras = [NSRunningApplication runningApplicationsWithBundleIdentifier:bi];
		if([ras count])
		{
			for(NSRunningApplication* ra in ras)
			{
				if(ra.active)
				{
					NSLog(@"%@", [ra description]);
					retval = true;
				}
			}
		}
	}

	// Supress our MediaKey events whenever these other apps are running
	NSArray* rabis = [NSArray arrayWithObjects:
		@"com.spotify.client",
		@"org.cogx.cog",
		@"org.songbirdnest.songbird",
		@"com.pixiapps.Ecoute",
		@"com.apple.QuickTimePlayerX",
		nil];
	
	for(NSString* bi in rabis) 
	{
		NSArray* ra = [NSRunningApplication runningApplicationsWithBundleIdentifier:bi];
		if([ra count])
		{
			NSLog(@"%@", [[ra objectAtIndex:0] description]);
			retval = true;
		}
	}
	
	return retval;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

	[self ignoreKey];
	NSString* appName = [[NSBundle mainBundle] bundleIdentifier];

	if([appName isEqualToString:@"MediaKeys"])
	{
		printf("%s\n","============ Starting MediaKeys =============");
		mpd_start();
		return;
	}

	if([appName isEqualToString:@"MediaKeysPlay"])
	{
		printf("%s\n","============ mpd_play =============");
		mpd_start();
		mpd_play();
	}

	if([appName isEqualToString:@"MediaKeysPause"])
	{
		printf("%s\n","============ mpd_pause =============");
		mpd_pause();
	}

	if([appName isEqualToString:@"MediaKeysToggle"])
	{
		printf("%s\n","============ mpd_toggle =============");
		mpd_start();
		mpd_toggle();
	}

	if([appName isEqualToString:@"MediaKeysPrev"])
	{
		printf("%s\n","============ mpd_prev =============");
		mpd_prev();
	}

	if([appName isEqualToString:@"MediaKeysNext"])
	{
		printf("%s\n","============ mpd_next =============");
		mpd_next();
	}
	
	exit(0);
}

- (void)mediaKeyEvent: (int)key state: (BOOL)state repeat: (BOOL)repeat
{
	switch( key )
	{
		case NX_KEYTYPE_PLAY:
			if( state == 0 )
			{
				; //Play pressed
				if( ! [self ignoreKey])
				{
					mpd_start();
					mpd_toggle();
				}
			}
			break;
			
		case NX_KEYTYPE_NEXT:
		case NX_KEYTYPE_FAST:
			if( state == 0 )
			{
				; //Next pressed or held
				if( ! [self ignoreKey])
				{
					mpd_next();
				}
			}
			break;
			
		case NX_KEYTYPE_PREVIOUS:
		case NX_KEYTYPE_REWIND:
			if( state == 0 )
			{
				; //Previous pressed or held
				if( ! [self ignoreKey])
				{
					mpd_prev();
				}
			}
			break;

		case NX_KEYTYPE_EJECT:
			if( state == 0 )
			{
				; //Eject pressed
				if( ! [self ignoreKey])
				{
					mpd_stop();
				}
			}
			break;

		case NX_KEYTYPE_MUTE:
			if( state == 0 ) printf("%s\n","NX_KEYTYPE_MUTE");
			break;

		case NX_KEYTYPE_SOUND_UP:
			if( state == 0 ) printf("%s\n","NX_KEYTYPE_SOUND_UP");
			break;

		case NX_KEYTYPE_SOUND_DOWN:
			if( state == 0 ) printf("%s\n","NX_KEYTYPE_SOUND_DOWN");
			break;


		// These don't seem to work for Apple Wireless Keyboard (rev1)
		// Not sure about Apple Wireless keyboard revision 2
		// Some might respond specifically on certain MBP models only
		// Try them out in the XCode Debugger and see.
		case NX_KEYTYPE_CONTRAST_UP:
			printf("%s\n","NX_KEYTYPE_CONTRAST_UP");
			break;
		case NX_KEYTYPE_CONTRAST_DOWN:
			printf("%s\n","NX_KEYTYPE_CONTRAST_DOWN");
			break;
		case NX_KEYTYPE_LAUNCH_PANEL:
			printf("%s\n","NX_KEYTYPE_LAUNCH_PANEL");
			break;
		case NX_KEYTYPE_VIDMIRROR:
			printf("%s\n","NX_KEYTYPE_VIDMIRROR");
			break;
		case NX_KEYTYPE_ILLUMINATION_UP:
			printf("%s\n","NX_KEYTYPE_ILLUMINATION_UP");
			break;
		case NX_KEYTYPE_ILLUMINATION_DOWN:
			printf("%s\n","NX_KEYTYPE_ILLUMINATION_DOWN");
			break;
		case NX_KEYTYPE_ILLUMINATION_TOGGLE:
			printf("%s\n","NX_KEYTYPE_ILLUMINATION_TOGGLE");
			break;
		case NX_KEYTYPE_HELP:
			printf("%s\n","NX_KEYTYPE_HELP");
			break;
		case NX_POWER_KEY:
			printf("%s\n","NX_POWER_KEY");
			break;
		case NX_KEYTYPE_NUM_LOCK:
			printf("%s\n","NX_KEYTYPE_NUM_LOCK");
			break;
	}
}

- (void)sendEvent: (NSEvent*)event
{
	if( [event type] == NSSystemDefined && [event subtype] == 8 )
	{
		int keyCode = (([event data1] & 0xFFFF0000) >> 16);
		int keyFlags = ([event data1] & 0x0000FFFF);
		int keyState = (((keyFlags & 0xFF00) >> 8)) ==0xA;
		int keyRepeat = (keyFlags & 0x1);
		
		[self mediaKeyEvent: keyCode state: keyState repeat: keyRepeat];
	}
	
	[super sendEvent: event];
}
@end
