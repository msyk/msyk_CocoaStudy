/* MyDocument */

#import <Cocoa/Cocoa.h>

@interface MyDocument : NSDocument
{
    IBOutlet NSWindow *mySheet;
}
- (IBAction)openMySheet:(id)sender;
- (IBAction)closeMySheet:(id)sender;
- (IBAction)terminate:(id)dummy;
@end
