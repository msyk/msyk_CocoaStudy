/* DBAccess */

#import <Cocoa/Cocoa.h>

@interface DBAccess : NSObject
{
    IBOutlet id dataSource;
    IBOutlet id listTable;
}
- (IBAction)testRun:(id)sender;
@end
