//
//  AddressListViewController.h
//  CloudAddressBook
//
//  Created by Developer on 11/05/06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CloudCommincation;
@class AddressDetailViewController;

@interface AddressListViewController : UITableViewController {
    CloudCommincation *com;    
}

@property (nonatomic, retain) IBOutlet AddressDetailViewController *detail;

- (IBAction)tapEditButton;

@end
