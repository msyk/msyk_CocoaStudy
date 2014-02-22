#import "DBAccess.h"

//フレームワーク化したQuickLiteをインポート
#import <QuickLite/QuickLite.h>

@implementation DBAccess

- (IBAction)testRun:(id)sender
{
    long i;
	NSString* dbPath = @"~/testdb"; //データベースファイル

    QuickLiteDatabase* db = [QuickLiteDatabase databaseWithFile: dbPath];
		//データベースファイルをもとにしたデータベースオブジェクトを構築する
        
    [db open];  //データベースを開く
	NSArray* tableArray = [db tables];  //テーブルの個数を参照
	for (i = 0; i < [tableArray count]; i++)	//とりあえずテーブルをすべて消す
		[db dropTable: [tableArray objectAtIndex: i]];
    
	[db performQuery: @"CREATE TABLE TEST1(id INTEGER PRIMARY KEY, str1, str2);"];
		//テーブルを作成するクエリーを発行する

	[db performQuery: NSLocalizedString( @"SQL1", @"" ) ];  //INSERTのクエリーを発行
	[db performQuery: NSLocalizedString( @"SQL2", @"" ) ];
	[db performQuery: NSLocalizedString( @"SQL3", @"" ) ];
	[db performQuery: NSLocalizedString( @"SQL4", @"" ) ];
	[db performQuery: NSLocalizedString( @"SQL5", @"" ) ];
	[db performQuery: NSLocalizedString( @"SQL6", @"" ) ];
	[db performQuery: NSLocalizedString( @"SQL7", @"" ) ];
	[db performQuery: NSLocalizedString( @"SQL8", @"" ) ];
	[db performQuery: NSLocalizedString( @"SQL9", @"" ) ];
	[db performQuery: NSLocalizedString( @"SQL10", @"" ) ];

	QuickLiteCursor* cursor = [db performQuery: @"SELECT * FROM TEST1;"];
		//テーブルのレコードをすべて取り出す
    long rowCount = [cursor rowCount];  //レコード数を求める
	if (rowCount > 0) {
        for (i = 0; i < rowCount; i++) {	//それぞれのレコードについて
			QuickLiteRow* row = [cursor rowAtIndex: i]; //行データを参照し
			
			if (row != nil) {   //各フィールドの値を取り出す
				NSLog(@"%@: %@", @"id", [row stringForColumn: @"id"]);
				NSLog(@"%@: %@", @"str1", [row stringForColumn: @"str1"]);
				NSLog(@"%@: %@", @"str2", [row stringForColumn: @"str2"]);
			}
        }
    }
    [db close]; //データベースを閉じる
}

@end
