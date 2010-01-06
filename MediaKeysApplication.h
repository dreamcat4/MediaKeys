//
//  MediaKeys.h
//  MediaKeys
//
//  Created by id on 06/01/2010.
//  Copyright 2010 dreamcat4. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <IOKit/hidsystem/ev_keymap.h>

@interface MediaKeysApplication : NSApplication
{
}
- (BOOL)ignoreKey;

@end
