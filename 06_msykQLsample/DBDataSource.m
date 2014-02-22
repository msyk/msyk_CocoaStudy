#import "DBDataSource.h"

@implementation DBDataSource

- (void)awakeFromNib
{
	[self initializeDB];
}

- (void)initializeDB
{
	NSString* dbPath = @"~/testdb";

    db = [QuickLiteDatabase databaseWithFile: dbPath];
    [db open];
	cursor = [db performQuery: @"SELECT * FROM TEST1;"];
}

- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [cursor rowCount];
}

- (id)tableView:(NSTableView *)aTableView 
	objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex
{
	NSString* val;
	[self initializeDB];
	NSString* columnName = [[aTableColumn headerCell] stringValue];
	QuickLiteRow* row = [cursor rowAtIndex: rowIndex];
	if (row != nil)
		val = [row stringForColumn: columnName];
	else
		val = @"";
	[db close];
	return val;
}

- (void)tableView:(NSTableView *)aTableView 
	setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex
{
}

@end
