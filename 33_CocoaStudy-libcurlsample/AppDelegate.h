//
//  AppDelegate.h
//  CocoaStudy-libcurlsample
//
//  Created by Masayuki Nii on 09/04/04.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AppDelegate : NSObject {
	NSTextView *message;
}
@property (retain, nonatomic) IBOutlet NSTextView *message;

- (IBAction)Sample1_SimpleHTTP:(id)sender;
- (IBAction)Sample2_HTTPPost:(id)sender;
- (IBAction)Sample3_HTTPS:(id)sender;
- (IBAction)Sample4_HTTPAuth:(id)sender;

@end
