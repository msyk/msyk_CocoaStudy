//
//  ViewController.m
//  TestSample
//
//  Created by Masayuki Nii on 2012/11/23.
//  Copyright (c) 2012年 net.msyk. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *seg;
@property (strong, nonatomic) IBOutlet UISegmentedControl *strongseg;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ttt;

@property (nonatomic, weak) IBOutlet UITextField *textField;

- (IBAction) pushButton:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog( @"%d", self.interfaceOrientation);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) pushButton:(id)sender
{
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog( @"$$$$");
}
@end
