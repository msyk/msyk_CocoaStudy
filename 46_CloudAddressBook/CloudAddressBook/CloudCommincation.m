//
//  CloudCommincation.m
//  CloudAddressBook
//
//  Created by Developer on 11/05/05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CloudCommincation.h"
#import <CommonCrypto/CommonHMAC.h>

bool Base64Encode( const uint8_t *in_buffer, size_t in_len, uint8_t **out_buffer, size_t *out_len )   {
    char convert[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    size_t resultSize = ((in_len - 1) / 3 + 1) * 4;
    uint8_t *outb = malloc(resultSize);
    *out_buffer = outb;
    if ( *out_buffer == NULL )   {
        return false;
    }
    *out_len = resultSize;
    size_t outPointer = 0;
    size_t lastIndex = -1;
    for ( size_t i = 2; i < in_len ; i+=3 )  {
        outb[outPointer    ] = convert[(in_buffer[i-2] & 0xFC) >> 2];
        outb[outPointer + 1] = convert[(in_buffer[i-2] & 0x03) << 4 
                                       | (in_buffer[i-1] & 0xF0) >> 4];
        outb[outPointer + 2] = convert[(in_buffer[i-1] & 0x0F) << 2 
                                       | (in_buffer[i  ] & 0xC0) >> 6];
        outb[outPointer + 3] = convert[(in_buffer[i  ] & 0x3F)];
        lastIndex = i;
        outPointer += 4;
    }
    switch ( in_len - (lastIndex + 1))   {
        case 1:
            outb[outPointer    ] = convert[(in_buffer[lastIndex + 1] & 0xFC) >> 2];
            outb[outPointer + 1] = convert[(in_buffer[lastIndex + 1] & 0x03) << 4];
            outb[outPointer + 2] = '=';
            outb[outPointer + 3] = '=';
            break;
        case 2:
            outb[outPointer    ] = convert[(in_buffer[lastIndex + 1] & 0xFC) >> 2];
            outb[outPointer + 1] = convert[(in_buffer[lastIndex + 1] & 0x03) << 4 
                                           | (in_buffer[lastIndex + 2 ] & 0xF0) >> 4];
            outb[outPointer + 2] = convert[(in_buffer[lastIndex + 2] & 0x0F) << 2];
            outb[outPointer + 3] = '=';
            break;
    }
    return true;
}

@implementation CloudCommincation

@synthesize addressData = _addressData;
@synthesize parsedData = _parsedData;
@synthesize selectedIndex = _selectedIndex;

@synthesize receivedData = _receivedData;
@synthesize doAtEndOfTask = _doAtEndOfTask;

@synthesize currentString = _currentString;
@synthesize currentFieldName = _currentFieldName;
@synthesize currentRecord = _currentRecord;
@synthesize currentItemName = _currentItemName;
@synthesize errorMessage = _errorMessage;

- (id)init
{
    if ( (self = [super init]) )  {
        self.addressData = nil;
    }
    return self;
}

- (void)dealloc
{
    self.addressData = nil;
    [super dealloc];
}

- (NSDictionary *)getCurrentAddress
{
    if ( self.selectedIndex >= [self.addressData count] 
        || self.addressData < 0 )   {
        return nil;
    }
    return [self.addressData objectAtIndex: self.selectedIndex];
}

- (NSString *)getIdForNewRecord
{
    return [NSString stringWithFormat: @"%d", maxIdNumber];
    maxIdNumber++;
}

- (void)sortAddressData
{
    [self.addressData sortUsingComparator: ^(id obj1, id obj2) {
        NSString *yomi1 = [obj1 objectForKey: @"familyname_yomi"];
        NSString *yomi2 = [obj2 objectForKey: @"familyname_yomi"];
        return [yomi1 compare: yomi2];
    }];
    maxIdNumber = -1;
    for ( NSDictionary *oneRecord in self.addressData ) {
        NSInteger idNum = [[oneRecord objectForKey: ITEM_KEY] integerValue];
        if ( maxIdNumber < idNum )  {
            maxIdNumber = idNum;
        }
    }
    maxIdNumber++;
    NSLog( @"Max ID Number = %d", maxIdNumber );
}

- (void)downloadData: (NSOperation *)doAtEndOfCommunication
{
    self.doAtEndOfTask = doAtEndOfCommunication;
    
    NSString *selectExp = [NSString stringWithFormat: @"select %@ from %@",
                           [ALL_FIELDS_ARRAY componentsJoinedByString: @","],
                           AWS_DOMAIN];
    isUpdateAddressList = YES;
    [self accessSimpleDB: @"Select" 
                    with: [NSDictionary dictionaryWithObject: selectExp
                                                      forKey: @"SelectExpression"]];
}

- (void)updateRowWithData: (NSDictionary *)dict
{
    NSInteger ix = 1;
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    for ( NSString *key in dict )   {
        if ( ! [key isEqualToString: ITEM_KEY] )  {
            NSString *keyForKey = [NSString stringWithFormat: @"Attribute.%d.Name", ix];
            NSString *keyForValue = [NSString stringWithFormat: @"Attribute.%d.Value", ix];
            [paramDict setObject: key
                          forKey: keyForKey];
            [paramDict setObject: [dict objectForKey: key] 
                          forKey: keyForValue];
            ix++;
        }
    }
    [paramDict setObject: [dict objectForKey: ITEM_KEY] forKey: @"ItemName"];
    [paramDict setObject: AWS_DOMAIN forKey: @"DomainName"];
    isUpdateAddressList = NO;
    [self accessSimpleDB: @"PutAttributes" 
                    with: paramDict];
}

- (void)deleteRow: (NSString *)itemName
{
    isUpdateAddressList = NO;
    [self accessSimpleDB: @"DeleteAttributes" 
                    with: [NSDictionary dictionaryWithObjectsAndKeys: 
                           AWS_DOMAIN, @"DomainName", itemName, @"ItemName", nil]];
}

- (void)accessSimpleDB: (NSString *)action with:(NSDictionary *)addingParams
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    [dateFormatter setTimeZone: [NSTimeZone timeZoneWithAbbreviation: @"UTC"]];
    NSString *timestamp= [dateFormatter stringFromDate: [NSDate date]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys: 
                                   action, @"Action", 
                                   @"HmacSHA256", @"SignatureMethod", 
                                   @"2", @"SignatureVersion", 
                                   timestamp, @"Timestamp", 
                                   @"2009-04-15", @"Version", nil];
    [params addEntriesFromDictionary: addingParams];
    NSArray *sortedKeys = [[params allKeys] sortedArrayUsingComparator: 
                           ^(id obj1, id obj2) { return [obj1 compare: obj2]; }];
    NSMutableString *accessParams = [NSMutableString stringWithFormat: 
                                    @"AWSAccessKeyId=%@", AWS_ACCESS_KEY];
    for ( NSString *key in sortedKeys ) {
        NSString *escaped = [self escape: [params objectForKey: key]];
        [accessParams appendFormat: @"&%@=%@", key, escaped];
     }
    NSString *getMessage = [NSString stringWithFormat: 
                            @"GET\n%@\n/\n%@", AWS_ENDPOINT, accessParams];
    
    NSData *message = [getMessage dataUsingEncoding: NSUTF8StringEncoding];
    NSData *key = [AWS_SECRET_KEY dataUsingEncoding: NSUTF8StringEncoding];
    uint8_t buffer[CC_SHA256_DIGEST_LENGTH] = {0};
    CCHmacContext context;
    CCHmacInit( &context, kCCHmacAlgSHA256, [key bytes], [key length] );
    CCHmacUpdate( &context, [message bytes], [message length] );
    CCHmacFinal( &context, buffer );
    uint8_t *out_buffer;
    size_t out_len;
    Base64Encode( buffer, CC_SHA256_DIGEST_LENGTH, &out_buffer, &out_len );
    NSString *sign = [[[NSString alloc] initWithBytes: out_buffer 
                                               length: out_len 
                                             encoding: NSUTF8StringEncoding] autorelease];
    free( out_buffer );
    
    NSString *urlString = [NSString stringWithFormat: 
                           @"https://%@/?%@&Signature=%@", 
                           AWS_ENDPOINT, accessParams, [self escape: sign]];
    NSURL *url = [NSURL URLWithString: urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL: url];
    
    NSLog( @"urlString = %@", urlString );
    NSLog( @"url = %@", url );
    NSLog( @"urlRequest = %@", urlRequest );
    
    self.receivedData = [NSMutableData data];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest: urlRequest 
                                                                  delegate: self];
    if ( connection == nil )    {
        // ERROR
        NSLog( @"ERROR: NSURLConnection is nil" );
    }
}

-(NSString *)escape: (NSString *)str
{
    NSString *escapedStr 
    = (NSString *)CFURLCreateStringByAddingPercentEscapes (NULL, 
                                                           (CFStringRef)str, 
                                                           NULL, 
                                                           URL_ESCAPE,
                                                           kCFStringEncodingUTF8);
    return [escapedStr autorelease];
}

#pragma -
#pragma NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection 
    didReceiveData:(NSData *)data
{
    NSLog( @"Calling: connection:didReceiveData:" );
    [self.receivedData appendData: data];
}

- (void)connection:(NSURLConnection *)connection 
  didFailWithError:(NSError *)error
{
    NSLog( @"Calling: connection:didFailWithError: %@", error );
    self.receivedData = nil;    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog( @"Calling: connectionDidFinishLoading:" );
    [connection release];
    isCollectingString = NO;
    isAttribute = NO;
    self.parsedData = [NSMutableArray array];
    self.currentString = nil;
    self.currentFieldName = nil;
    self.currentRecord = nil;
    self.currentItemName = nil;
    self.errorMessage = nil;

//    NSLog( @"receivedData = %@", [[[NSString alloc] initWithData: self.receivedData 
//                                         encoding: NSUTF8StringEncoding] autorelease] );

    NSXMLParser *parser = [[NSXMLParser alloc] initWithData: self.receivedData];
    [parser setDelegate: self];
    if ( [parser parse] == NO ) {
        //ERROR
        NSLog( @"ERROR: NSXMLParser couldn't parse." );
    }
    [parser release];
    self.receivedData = nil;
    NSLog( @"parsedData = %@", self.parsedData );
    NSLog( @"errorMessage = %@", self.errorMessage );
    
    if ( isUpdateAddressList )  {
        self.addressData = self.parsedData;
        self.parsedData = nil;
        [self sortAddressData];
    }
    [self.doAtEndOfTask main];
}


#pragma -
#pragma NSXMLParser Delegate Methods

- (void)    parser:(NSXMLParser *)parser 
   didStartElement:(NSString *)elementName 
      namespaceURI:(NSString *)namespaceURI 
     qualifiedName:(NSString *)qualifiedName 
        attributes:(NSDictionary *)attributeDict
{
//    NSLog( @"Calling: parser:didStartElement: %@", elementName );

    if ( [elementName isEqualToString: @"Item"] )    {
        self.currentRecord = [NSMutableDictionary dictionary];
    } else if ( [elementName isEqualToString: @"Name"] )    {
        isCollectingString = YES;
        self.currentFieldName = nil;
        self.currentString = [NSMutableString string];
    } else if ( [elementName isEqualToString: @"Attribute"] )    {
        isAttribute = YES;
    } else if ( [elementName isEqualToString: @"Value"] )    {
        isCollectingString = YES;
        self.currentString = [NSMutableString string];
    } else if ( [elementName isEqualToString: @"Message"] )    {
        isCollectingString = YES;
        self.currentString = [NSMutableString string];
    }
}

- (void)    parser:(NSXMLParser *)parser 
   foundCharacters:(NSString *)string
{
//    NSLog( @"Calling: parser:foundCharacters: %@", string );
    
    if ( isCollectingString )   {
        [self.currentString appendString: string];
    }
}

- (void)    parser:(NSXMLParser *)parser 
     didEndElement:(NSString *)elementName 
      namespaceURI:(NSString *)namespaceURI 
     qualifiedName:(NSString *)qName
{
//    NSLog( @"Calling: parser:didEndElement: %@", elementName );

    if ( [elementName isEqualToString: @"Item"] )    {
        [self.currentRecord setObject: self.currentItemName forKey: ITEM_KEY];
        [self.parsedData addObject: self.currentRecord];
    } else if ( [elementName isEqualToString: @"Name"] )    {
        isCollectingString = NO;
        if ( isAttribute )  {
            self.currentFieldName = self.currentString;
        } else {
            self.currentItemName = self.currentString;
        }
    } else if ( [elementName isEqualToString: @"Attribute"] )    {
        isAttribute = NO;
    } else if ( [elementName isEqualToString: @"Value"] )    {
        [self.currentRecord setObject: self.currentString forKey: self.currentFieldName];
        isCollectingString = NO;
    } else if ( [elementName isEqualToString: @"Message"] )    {
        self.errorMessage = self.currentString;
        isCollectingString = NO;
    }
}

@end
