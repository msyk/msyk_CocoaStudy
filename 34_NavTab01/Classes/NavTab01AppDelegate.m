//
//  NavTab01AppDelegate.m
//  NavTab01
//
//  Created by Masayuki Nii on 09/02/03.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "NavTab01AppDelegate.h"

@implementation NavTab01AppDelegate

@synthesize window, tabBarController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    // Override point for customization after application launch

	[window addSubview: tabBarController.view];
	[window makeKeyAndVisible];
} 


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
