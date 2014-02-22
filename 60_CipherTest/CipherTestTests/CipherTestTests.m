//
//  CipherTestTests.m
//  CipherTestTests
//
//  Created by Masayuki Nii on 2013/06/30.
//  Copyright (c) 2013年 msyk.net. All rights reserved.
//

#import "CipherTestTests.h"
#import "Cipher.h"

@implementation CipherTestTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testCryptData
{
    Cipher *c = [[Cipher alloc]init];
    
    NSString *message = @"short message, long message. ";
    NSData *originalData = [message dataUsingEncoding: NSUTF8StringEncoding];
    NSData *cryptData, *roundTripped;
    BOOL result;
    result = [c encryptData: originalData To: &cryptData];
    STAssertTrue( result, @"should succeed to encrypt.");
    
    STAssertFalse( [cryptData isEqualToData: originalData], @"Encrypt data should be different.");
    
    result = [c decryptData: cryptData To: &roundTripped];
    STAssertTrue( result, @"should succeed to decrypt.");
    
    NSString *roundedString = [[NSString alloc]initWithData: roundTripped encoding: NSUTF8StringEncoding];
    STAssertTrue( [roundedString isEqualToString: message], @"Encrypt and Decrypt should return the same data.");
    
    NSLog( @"\n%@\n%@\n%@", originalData, cryptData, roundTripped);
    
}
/*
- (void)testTransform
{
    Cipher *c = [[Cipher alloc]init];
    
    NSString *message = @"0123456789abcdef";
    NSData *originalData = [message dataUsingEncoding: NSUTF8StringEncoding];
    NSData *cryptData, *roundTripped;
    BOOL result;
    result = [c encryptTransformData: originalData To: &cryptData];
    STAssertTrue( result, @"should succeed to encrypt.");
    
    STAssertFalse( [cryptData isEqualToData: originalData], @"Encrypt data should be different.");
    
    result = [c decryptData: cryptData To: &roundTripped];
    STAssertTrue( result, @"should succeed to decrypt.");
    
    NSString *roundedString = [[NSString alloc]initWithData: roundTripped encoding: NSUTF8StringEncoding];
    STAssertTrue( [roundedString isEqualToString: message], @"Encrypt and Decrypt should return the same data.");
    
    NSLog( @"\n%@\n%@\n%@", originalData, cryptData, roundTripped);
    
}
*/
@end
