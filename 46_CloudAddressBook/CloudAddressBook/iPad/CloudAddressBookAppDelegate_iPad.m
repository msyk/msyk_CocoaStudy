//
//  CloudAddressBookAppDelegate_iPad.m
//  CloudAddressBook
//
//  Created by Developer on 11/05/05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CloudAddressBookAppDelegate_iPad.h"
#import "AddressListViewController.h"
#import "CloudCommincation.h"
#import "AddressDetailViewController.h"

@implementation CloudAddressBookAppDelegate_iPad

@synthesize split = _split;
@synthesize detailPanel = _detailPanel;

- (void)dealloc
{
	[super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    self.window.rootViewController = self.split;
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    NSBlockOperation *updateTable = [NSBlockOperation blockOperationWithBlock: ^(void)  {
        [self.addressList.tableView reloadData];
        UIBarButtonItem *button = [self.detailPanel.toolbar.items objectAtIndex: 0];
        [button.target performSelector: button.action
                            withObject: nil 
                            afterDelay: 0];
    
    }];
    [self.cloudCom downloadData: updateTable];
    NSLog( @"##### %@" , [UIDevice currentDevice].model );
}


@end
