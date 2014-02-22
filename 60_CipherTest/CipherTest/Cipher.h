//
//  Cipher.h
//  CipherTest
//
//  Created by Masayuki Nii on 2013/06/30.
//  Copyright (c) 2013年 msyk.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cipher : NSObject

- (BOOL)encryptFile: (NSString *)fromFile To: (NSString *)toFile;
- (BOOL)decryptFile: (NSString *)fromFile To: (NSString *)toFile;
- (BOOL)encryptData: (NSData *)fromData To: (NSData **)toData;
- (BOOL)decryptData: (NSData *)fromData To: (NSData **)toData;
- (BOOL)encryptTransformData: (NSData *)fromData To: (NSData **)toData;
- (BOOL)decryptTransformData: (NSData *)fromData To: (NSData **)toData;

@end
