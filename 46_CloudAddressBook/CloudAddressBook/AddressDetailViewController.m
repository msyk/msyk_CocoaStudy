//
//  AddressDetailViewController.m
//  CloudAddressBook
//
//  Created by Developer on 11/05/06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddressDetailViewController.h"
#import "CloudAddressBookAppDelegate.h"
#import "CloudCommincation.h"
#import "CloudAddressBookAppDelegate_iPad.h"
#import "AddressListViewController.h"

@implementation AddressDetailViewController

@synthesize toolbar = _toolbar;
@synthesize tableView = _tableView;
/*
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/
- (void)dealloc
{
    [fields release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)createNewRecord
{
    NSLog( @"Calling: createNewRecord" );
    NSMutableDictionary *newRecord =[NSMutableDictionary 
                                     dictionaryWithObject: com.idForNewRecord
                                     forKey: ITEM_KEY];
    [com.addressData addObject: newRecord];
    for ( NSString *field in fields )   {
        [newRecord setObject: @"" forKey: field];
    }
    com.selectedIndex = [com.addressData count] - 1;
    [self.tableView reloadData];
    NSRange iPadStrRange = [[UIDevice currentDevice].model rangeOfString: @"iPad"];
    if ( iPadStrRange.location != NSNotFound )   {
        CloudAddressBookAppDelegate_iPad *appDelgate = ((CloudAddressBookAppDelegate_iPad *)
                                                        ([UIApplication sharedApplication].delegate));
        [appDelgate.addressList.tableView reloadData];
    }
}

- (void)tapSaveButton
{
    NSLog( @"Calling: tapSaveButton" );

    [com updateRowWithData: com.currentAddress];
    [com sortAddressData];

    NSRange iPadStrRange = [[UIDevice currentDevice].model rangeOfString: @"iPad"];
    if ( iPadStrRange.location == NSNotFound )   {
        [self.navigationController popViewControllerAnimated: YES];
    } else {
        CloudAddressBookAppDelegate_iPad *appDelgate
        = ((CloudAddressBookAppDelegate_iPad *)
           ([UIApplication sharedApplication].delegate));
        [appDelgate.addressList viewWillAppear: YES];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    fields = [ALL_FIELDS_ARRAY retain];
    com = ((CloudAddressBookAppDelegate *)
           ([UIApplication sharedApplication].delegate)).cloudCom;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog( @"Calling: viewWillAppear:" );
    [super viewWillAppear:animated];
    
    NSRange iPadStrRange = [[UIDevice currentDevice].model rangeOfString: @"iPad"];
    if ( iPadStrRange.location == NSNotFound )   {
        self.navigationItem.title = [NSString stringWithFormat: @"%@ %@",
                                     [com.currentAddress objectForKey: @"familyname"],
                                     [com.currentAddress objectForKey: @"givenname"]];
        UIBarButtonItem *saveButton 
        = [[[UIBarButtonItem alloc] 
            initWithBarButtonSystemItem: UIBarButtonSystemItemSave
            target: self
            action: @selector(tapSaveButton)] autorelease];
        self.navigationItem.rightBarButtonItem = saveButton;
    } else {
    }

    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog( @"Calling: tableView:numberOfSectionsInTableView:" );
    return [fields count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
    NSLog( @"Calling: tableView:numberOfRowsInSection:" );
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog( @"Calling: tableView:cellForRowAtIndexPath:" );
    NSInteger index = [indexPath indexAtPosition: 0];
    UITableViewCell *cell = [[[UITableViewCell alloc] 
                              initWithStyle: UITableViewCellStyleDefault
                            reuseIdentifier: nil] autorelease];
    if ( index < [fields count] )  {
        NSString *thisKey = [fields objectAtIndex: index];
        cell.textLabel.text = [com.currentAddress objectForKey: thisKey];
    } else {
        UIButton *newButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        [newButton setTitle: NSLocalizedString( @"New Record", nil )
                   forState: UIControlStateNormal];
        [newButton addTarget: self 
                      action: @selector(createNewRecord)
            forControlEvents: UIControlEventTouchUpInside];
        newButton.frame = CGRectMake( 0.0, 0.0, 150.0, 28.0 );
        newButton.center = cell.contentView.center;
        [cell.contentView addSubview: newButton];
        }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView 
titleForHeaderInSection:(NSInteger)section
{
    NSLog( @"Calling: tableView:titleForHeaderInSection:" );
    if ( section == [fields count] )  {
        return NSLocalizedString( @"Create New Record", nil );
    }
    NSString *field = [fields objectAtIndex: section];
    return NSLocalizedString( field, nil );
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog( @"Calling: tableView:didSelectRowAtIndexPath:" );
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    if ( [indexPath indexAtPosition: 0] < [fields count] ) {
        editingCell = [tableView cellForRowAtIndexPath: indexPath];
        CGRect itemRect;
        NSRange iPadStrRange = [[UIDevice currentDevice].model rangeOfString: @"iPad"];
        if ( iPadStrRange.location == NSNotFound )   {
            itemRect = CGRectMake(20.0, 12.0, 280.0, 28.0);
        } else {
            itemRect = CGRectMake(54.0, 12.0, 280.0, 28.0);
        }
        UITextField *textField = [[[UITextField alloc] 
                                   initWithFrame: itemRect] autorelease];
        textField.delegate = self;
        textField.text = editingCell.textLabel.text;
        textField.tag = [indexPath indexAtPosition: 0];
        textField.backgroundColor = [UIColor whiteColor];
        [editingCell addSubview: textField];
        [textField becomeFirstResponder];
    }
}

#pragma mark - Text field delegate

- (BOOL)            textField:(UITextField *)textField 
shouldChangeCharactersInRange:(NSRange)range 
            replacementString:(NSString *)string
{
    NSLog( @"Calling: textField:shouldChangeCharactersInRange:replacementString:" );
    NSString *replaced = [textField.text stringByReplacingCharactersInRange: range
                                                                 withString: string];
    NSString *field = [fields objectAtIndex: textField.tag];
    [com.currentAddress setObject: replaced forKey: field];
    editingCell.textLabel.text = replaced;
 
    NSRange iPadStrRange = [[UIDevice currentDevice].model rangeOfString: @"iPad"];
    if ( iPadStrRange.location != NSNotFound )   {
        CloudAddressBookAppDelegate_iPad *appDelgate = ((CloudAddressBookAppDelegate_iPad *)
                                                        ([UIApplication sharedApplication].delegate));
        NSArray *params = [NSArray 
                           arrayWithObject: [NSIndexPath 
                                             indexPathForRow: com.selectedIndex 
                                             inSection: 0]];
        [appDelgate.addressList.tableView 
         reloadRowsAtIndexPaths: params
               withRowAnimation: UITableViewRowAnimationFade];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog( @"Calling: textFieldShouldEndEditing:" );
//    [textField removeFromSuperview];
    return YES;
}

#pragma mark - Split view support

- (void)splitViewController:(UISplitViewController *)svc 
     willHideViewController:(UIViewController *)aViewController 
          withBarButtonItem:(UIBarButtonItem *)barButtonItem 
       forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = @"Address List";
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
}

// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController:(UISplitViewController *)svc 
     willShowViewController:(UIViewController *)aViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
}


@end
