//
//  CloudAddressBookAppDelegate_iPad.h
//  CloudAddressBook
//
//  Created by Developer on 11/05/05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CloudAddressBookAppDelegate.h"

@class AddressDetailViewController;

@interface CloudAddressBookAppDelegate_iPad : CloudAddressBookAppDelegate {
    
}

@property (nonatomic, retain) IBOutlet UISplitViewController *split;
@property (nonatomic, retain) IBOutlet AddressDetailViewController *detailPanel;

@end
