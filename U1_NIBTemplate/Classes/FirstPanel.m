//
//  FirstPanel.m
//  NIBTemplate
//
//  Created by Masayuki Nii on 10/07/31.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TemplateController.h"
#import "NIBTemplateAppDelegate.h"
#import "FirstPanel.h"


@implementation FirstPanel

- (void) awakeFromNib{	// *****

	NSLog( @"Calling: FirstPanel#awakeFromNib" );

	UIApplication *currentApp = [UIApplication sharedApplication];
	NIBTemplateAppDelegate *appDelegate = currentApp.delegate;
	appDelegate.currentViewController = self;
	CGRect aRect = self.view.frame;
	aRect = aRect;
}

-(IBAction) tapButton:(id)sender	// *****
{
	NSLog( @"Calling: FirstPanel#tapButton:" );
	
}
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[oneButton setTitle: @"First" forState: UIControlStateNormal];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
