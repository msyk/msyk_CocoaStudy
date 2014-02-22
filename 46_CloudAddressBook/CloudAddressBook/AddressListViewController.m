//
//  AddressListViewController.m
//  CloudAddressBook
//
//  Created by Developer on 11/05/06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddressListViewController.h"
#import "CloudAddressBookAppDelegate.h"
#import "CloudCommincation.h"
#import "AddressDetailViewController.h"
#import "CloudAddressBookAppDelegate_iPad.h"

@implementation AddressListViewController

@synthesize detail = _detail;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    com = ((CloudAddressBookAppDelegate *)
           ([UIApplication sharedApplication].delegate)).cloudCom;
    
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake( 320.0, 600.0 );
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [com sortAddressData];
    [self.tableView reloadData];
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

- (IBAction)tapEditButton
{
    [self.tableView setEditing: ! self.tableView.editing animated: YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//   NSLog( @"Calling: tableView:numberOfRowsInSection:" );
    return [com.addressData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog( @"Calling: tableView:cellForRowAtIndexPath:" );
    NSInteger index = [indexPath indexAtPosition: 1];
    NSString *cellIdentifier = [NSString stringWithFormat: @"Cell%d", index];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1
                                       reuseIdentifier: cellIdentifier] autorelease];
    }
    NSDictionary *currentRecord = [com.addressData objectAtIndex: index];
    NSString *familyname = [currentRecord objectForKey: @"familyname"];
    NSString *givenname = [currentRecord objectForKey: @"givenname"];
    NSString *telephone = [currentRecord objectForKey: @"telephone"];
    cell.textLabel.text = [NSString stringWithFormat: @"%@ %@", familyname, givenname];
    cell.detailTextLabel.text = [NSString stringWithFormat: @"Tel:%@", telephone];

    return cell;
}

- (BOOL)        tableView:(UITableView *)tableView 
    canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)    tableView:(UITableView *)tableView 
   commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [com deleteRow: [com.currentAddress objectForKey: ITEM_KEY]];
        [com.addressData removeObject: com.currentAddress];
        
        [self.tableView deleteRowsAtIndexPaths: [NSArray arrayWithObject:indexPath] 
                              withRowAnimation: UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

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

- (void)      tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSRange iPadStrRange = [[UIDevice currentDevice].model rangeOfString: @"iPad"];
    if ( iPadStrRange.location == NSNotFound )   {
        com.selectedIndex = [indexPath indexAtPosition: 1];
        [self.navigationController pushViewController: self.detail animated:YES];
    } else {
        com.selectedIndex = [indexPath indexAtPosition: 1];
        CloudAddressBookAppDelegate_iPad *appDelgate
         = ((CloudAddressBookAppDelegate_iPad *)
            ([UIApplication sharedApplication].delegate));
        [appDelgate.detailPanel viewWillAppear: YES];
    }
}


@end
