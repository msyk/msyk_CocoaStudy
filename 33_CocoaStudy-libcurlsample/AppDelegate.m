//
//  AppDelegate.m
//  CocoaStudy-libcurlsample
//
//  Created by Masayuki Nii on 09/04/04.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "libcurlsample.h"

@implementation AppDelegate

@synthesize message;

- (IBAction)Sample1_SimpleHTTP:(id)sender	{
	char *receivedStr = malloc( 1024*128 );
	simpleHTTP( "http://msyk.net/index.html",  receivedStr );
	[message insertText:[NSString stringWithCString: receivedStr encoding: NSUTF8StringEncoding]];
	free( receivedStr );
}

- (IBAction)Sample2_HTTPPost:(id)sender	{
	char *receivedStr = malloc( 1024*128 );
	char *postStr ="10,20,35,67";
	httpPost( "http://msyk.net/macos/cocoastudy.php", postStr, receivedStr );
	[message insertText:[NSString stringWithCString:receivedStr]];
	free( receivedStr );
}

- (IBAction)Sample3_HTTPS:(id)sender	{
	char *receivedStr = malloc( 1024*128 );
	https( "https://msyk.net", receivedStr );
	[message insertText:[NSString stringWithCString:receivedStr]];
	free( receivedStr );
}

- (IBAction)Sample4_HTTPAuth:(id)sender	{
	char *receivedStr = malloc( 1024*128 );
	httpAuth( "http://msyk.net/macos/cocoastudy/", "test1", "test1", receivedStr );
	[message insertText:[NSString stringWithCString:receivedStr]];
	free( receivedStr );
}

@end
