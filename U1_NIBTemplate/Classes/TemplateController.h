//
//  TemplateController.h
//  NIBTemplate
//
//  Created by Masayuki Nii on 10/07/31.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TemplateController : UIViewController {
	UIButton *oneButton;
}

@property (retain, nonatomic) IBOutlet UIButton *oneButton;

-(IBAction) tapButton:(id)sender;

@end
