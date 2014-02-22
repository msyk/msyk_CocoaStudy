//
//  AddressDetailViewController.h
//  CloudAddressBook
//
//  Created by Developer on 11/05/06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CloudCommincation;

@interface AddressDetailViewController : UIViewController <UITextFieldDelegate> {
    UITableViewCell *editingCell;
    CloudCommincation *com;
    NSArray *fields;
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (void)createNewRecord;
- (IBAction)tapSaveButton;

@end
