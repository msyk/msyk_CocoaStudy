/* DBDataSource */

#import <Cocoa/Cocoa.h>
#import <QuickLite/QuickLite.h>

@interface DBDataSource : NSObject
{
@private QuickLiteDatabase* db;
@private QuickLiteCursor* cursor;
}
- (void)awakeFromNib;
- (void)initializeDB;

- (int)numberOfRowsInTableView:(NSTableView *)aTableView;
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex;
- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex;
@end
