//
//  Document.h
//  SampleTextEditor
//
//  Created by Masayuki Nii on 11/10/08.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Document : NSDocument  {
}

@property(retain, nonatomic) IBOutlet NSTextView *textView;
@property(retain, nonatomic) NSAttributedString *string;

@end
