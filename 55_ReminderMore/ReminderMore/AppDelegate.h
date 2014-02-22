//
//  AppDelegate.h
//  ReminderMore
//
//  Created by Masayuki Nii on 2012/09/13.
//  Copyright (c) 2012年 Masayuki Nii. All rights reserved.
//

@interface AppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet ReminderItems *items;

@end
