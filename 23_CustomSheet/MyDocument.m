//
//  MyDocument.m
//  test1
//
//  Created by ???? on 07/05/03.
//  Copyright __MyCompanyName__ 2007 . All rights reserved.
//

/*
Sheet Programming Topics for Cocoa
http://developer.apple.com/documentation/Cocoa/Conceptual/Sheets/index.html


NSApplication
Managing sheets


*/
#import "MyDocument.h"

@implementation MyDocument

// Document modal sheet

- (IBAction)openMySheet:(id)sender
{
	NSLog(@"Cought the message 'openMySheet'.");
	NSApplication* myApp = [NSApplication sharedApplication];
	[myApp beginSheet: mySheet
		modalForWindow: [[[self windowControllers]lastObject]window]
		modalDelegate: self 
		didEndSelector: @selector(mySheetDidEnd:returnCode:contextInfo:)
		contextInfo: nil];
}

- (void) mySheetDidEnd: (NSWindow *) sheet 
			returnCode: (int) returnCode 
			contextInfo: (void *) contextInfo{
	NSLog(@"Cought the message 'mySheetDidEnd'.");
	[mySheet orderOut:self];
}

- (IBAction)closeMySheet:(id)sender
{
	NSLog(@"Cought the message 'closeMySheet'.");
	NSApplication* myApp = [NSApplication sharedApplication];
	[myApp endSheet: mySheet];
}
/*
- (IBAction)terminate:(id)dummy
{
	NSLog(@"Cought the message 'terminate'.");
	NSApplication* myApp = [NSApplication sharedApplication];
	[[myApp orderedDocuments] 
		makeObjectsPerformSelector:@selector(closeMySheet:) withObject:nil];
	[myApp terminate:dummy];
}
*/
// Application modal sheet
/*
- (IBAction)openMySheet:(id)sender
{
	NSLog(@"Cought the message 'openMySheet'.");
	NSApplication* myApp = [NSApplication sharedApplication];
	[myApp beginSheet: mySheet
		modalForWindow: [[[self windowControllers]lastObject]window]
		modalDelegate: self 
		didEndSelector: @selector(mySheetDidEnd:returnCode:contextInfo:)
		contextInfo: nil];
		
	[myApp endSheet: mySheet];
	[myApp runModalForWindow:mySheet];
}

- (void) mySheetDidEnd: (NSWindow *) sheet 
			returnCode: (int) returnCode 
			contextInfo: (void *) contextInfo{
	NSLog(@"Cought the message 'mySheetDidEnd'.");
}

- (IBAction)closeMySheet:(id)sender
{
	NSLog(@"Cought the message 'closeMySheet'.");
	NSApplication* myApp = [NSApplication sharedApplication];
	[myApp stopModal];
	[mySheet orderOut:self];
}
*/

- (id)init
{
    self = [super init];
    if (self) {
    
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
    
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

- (NSData *)dataRepresentationOfType:(NSString *)aType
{
    // Insert code here to write your document from the given data.  You can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.
    
    // For applications targeted for Tiger or later systems, you should use the new Tiger API -dataOfType:error:.  In this case you can also choose to override -writeToURL:ofType:error:, -fileWrapperOfType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.

    return nil;
}

- (BOOL)loadDataRepresentation:(NSData *)data ofType:(NSString *)aType
{
    // Insert code here to read your document from the given data.  You can also choose to override -loadFileWrapperRepresentation:ofType: or -readFromFile:ofType: instead.
    
    // For applications targeted for Tiger or later systems, you should use the new Tiger API readFromData:ofType:error:.  In this case you can also choose to override -readFromURL:ofType:error: or -readFromFileWrapper:ofType:error: instead.
    
    return YES;
}

@end
