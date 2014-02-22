//
//  CloudCommincation.h
//  CloudAddressBook
//
//  Created by Developer on 11/05/05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AWS_ACCESS_KEY @"AKIAJZ6KBTPPRMGJA6VA"
#define AWS_SECRET_KEY @"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"
#define AWS_ENDPOINT @"sdb.ap-northeast-1.amazonaws.com"
#define AWS_DOMAIN @"CloudAddressBook"
#define ITEM_KEY @"ItemName"
#define URL_ESCAPE (CFStringRef)@"!*'();:@&=+$,/?%#[]"
#define ALL_FIELDS_ARRAY [NSArray arrayWithObjects: @"familyname", @"givenname", @"familyname_yomi", @"givenname_yomi", @"telephone", @"cellphone", @"email", @"birthday", @"zip", @"pref", @"city", @"address", @"blood", nil]

@interface CloudCommincation : NSObject <NSXMLParserDelegate> {
    BOOL isCollectingString;
    BOOL isAttribute;
    NSInteger maxIdNumber;
    BOOL isUpdateAddressList;
}

@property (nonatomic, retain) NSMutableArray *addressData;
@property (nonatomic, retain) NSMutableArray *parsedData;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, readonly, getter = getCurrentAddress) NSMutableDictionary *currentAddress;
@property (nonatomic, readonly, getter = getIdForNewRecord) NSString *idForNewRecord;
@property (nonatomic, retain) NSOperation *doAtEndOfTask;

@property (nonatomic, retain) NSMutableData *receivedData;

@property (nonatomic, retain) NSMutableString *currentString;
@property (nonatomic, retain) NSString *currentFieldName;
@property (nonatomic, retain) NSMutableDictionary *currentRecord;
@property (nonatomic, retain) NSString *currentItemName;
@property (nonatomic, retain) NSString *errorMessage;

- (void)sortAddressData;
- (void)downloadData: (NSOperation *)doAtEndOfCommunication;
- (void)updateRowWithData: (NSDictionary *)dict;
- (void)deleteRow: (NSString *)itemName;
- (void)accessSimpleDB: (NSString *)action with:(NSDictionary *)addingParams;
-(NSString *)escape: (NSString *)str;

@end
