//
//  SecondViewController.m
//  NavTab01
//
//  Created by Masayuki Nii on 09/02/04.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"
#import "NavTab01AppDelegate.h"


@implementation SecondViewController

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationController.navigationBarHidden = YES;
	
	NSLog(@"###");
}

- (IBAction) goAnother	{
	UIApplication *app = [UIApplication sharedApplication];
	NavTab01AppDelegate *appDel = app.delegate;

	appDel.tabBarController.selectedIndex = 0;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
