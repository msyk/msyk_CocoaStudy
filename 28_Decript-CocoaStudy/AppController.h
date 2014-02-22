//
//  AppController.h
//  Decript-CocoaStudy
//
//  Created by 新居雅行 on 08/03/28.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#include <openssl/evp.h>

@interface AppController : NSObject {

	IBOutlet NSTextView* originalText;
	IBOutlet NSTextView* decriptedText;
	
}

@end
