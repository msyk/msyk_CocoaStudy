//
//  CloudAddressBookAppDelegate.h
//  CloudAddressBook
//
//  Created by Developer on 11/05/05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CloudCommincation;
@class AddressListViewController;

@interface CloudAddressBookAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CloudCommincation *cloudCom;
@property (nonatomic, retain) IBOutlet AddressListViewController *addressList;
@property (nonatomic, retain) IBOutlet UINavigationController *navigation;

@end
