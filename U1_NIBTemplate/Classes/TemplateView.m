//
//  TemplateView.m
//  NIBTemplate
//
//  Created by Masayuki Nii on 10/07/31.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NIBTemplateAppDelegate.h"
#import "TemplateView.h"


@implementation TemplateView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {	// *****

	NSLog( @"Calling: TemplateView#initWithCoder:" );

    if ((self = [super initWithCoder:decoder])) {
		UIApplication *currentApp = [UIApplication sharedApplication];
		NIBTemplateAppDelegate *appDelegate = currentApp.delegate;
		NSArray *loadedObjects 
			= [[NSBundle mainBundle] loadNibNamed: @"TemplateController" 
											owner: appDelegate.currentViewController 
										  options: nil];
		if ( [loadedObjects count] > 0 )	{
			[self addSubview: [loadedObjects objectAtIndex: 0]];
		}
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
