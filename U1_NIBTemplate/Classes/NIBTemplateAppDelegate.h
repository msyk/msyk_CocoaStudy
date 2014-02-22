//
//  NIBTemplateAppDelegate.h
//  NIBTemplate
//
//  Created by Masayuki Nii on 10/07/31.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NIBTemplateAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UITabBarController *tabBar;
	
	UIViewController *currentViewController;	// *****
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBar;

@property (nonatomic, retain) IBOutlet UIViewController *currentViewController;	// *****

@end

