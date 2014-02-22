//
//  Document.m
//  SampleTextEditor
//
//  Created by Masayuki Nii on 11/10/08.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Document.h"

@implementation Document

@synthesize textView = _textView;
@synthesize string = _string;

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        // If an error occurs here, return nil.
        self.string = [[NSAttributedString alloc] initWithString: @""];
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib: aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    [[self.textView textStorage] setAttributedString: self.string];
    
    NSWindowController *wc = [self.windowControllers objectAtIndex:0];
    [wc.window setCollectionBehavior: NSWindowCollectionBehaviorFullScreenPrimary];
}

//    [[NSApplication sharedApplication] setPresentationOptions: NSApplicationPresentationFullScreen];

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (BOOL)readFromData: (NSData *)data ofType: (NSString *)typeName error: (NSError **)outError
{
    BOOL readSuccess = NO;
    NSAttributedString *fileContents = [[NSAttributedString alloc]initWithData: data 
                                                                       options: NULL 
                                                            documentAttributes: NULL 
                                                                         error: outError];
    if ( fileContents ) {
        readSuccess = YES;
        self.string = fileContents;
    }
    return readSuccess;
}

- (NSData *) dataOfType: (NSString *)typeName error:(NSError **)outError
{
    
    self.string = [self.textView textStorage];
    NSMutableDictionary *dict 
    = [NSDictionary dictionaryWithObject: NSRTFDTextDocumentType
                                  forKey: NSDocumentTypeDocumentAttribute];
    [self.textView breakUndoCoalescing];
    NSData *data = [[self string] dataFromRange: NSMakeRange(0, self.string.length)
                             documentAttributes: dict 
                                          error: outError];
    return data;
}

@end
