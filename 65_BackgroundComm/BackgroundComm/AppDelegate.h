//
//  AppDelegate.h
//  BackgroundComm
//
//  Created by Masayuki Nii on 2014/03/31.
//  Copyright (c) 2014年 msyk.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (copy) void (^downloadCompletionHandler)();

@end
