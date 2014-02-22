//
//  Cipher.m
//  CipherTest
//
//  Created by Masayuki Nii on 2013/06/30.
//  Copyright (c) 2013年 msyk.net. All rights reserved.
//

#import "Cipher.h"
#include <CommonCrypto/CommonCryptor.h>

/*
 $ openssl aes-128-cbc -P -k password
 salt=12E2732481B1D9B0
 key=C23E7FD73828C7682476C7D837799CA7
 iv =97E9F88299535383F72BA825DA0712A3
 */

unsigned char iv[16]
= {0x97, 0xE9, 0xF8, 0x82, 0x99, 0x53, 0x53, 0x83, 0xF7, 0x2B, 0xA8, 0x25, 0xDA, 0x07, 0x12, 0xA3};
unsigned char key[16]
= {0xC2, 0x3E, 0x7F, 0xD7, 0x38, 0x28, 0xC7, 0x68, 0x24, 0x76, 0xC7, 0xD8, 0x37, 0x79, 0x9C, 0xA7};

#define BLOCK_SIZE 16

@interface Cipher()
- (BOOL)processingCipher: (BOOL)isEncrypt From: (NSData *)fromData To: (NSData **)toData;
@end

@implementation Cipher

- (BOOL)encryptFile: (NSString *)fromFile To: (NSString *)toFile
{
    return NO;
}
- (BOOL)decryptFile: (NSString *)fromFile To: (NSString *)toFile
{
    return NO;
}
- (BOOL)encryptData: (NSData *)fromData To: (NSData **)toData
{
    return [self processingCipher: YES From: fromData To: toData];
}

- (BOOL)decryptData: (NSData *)fromData To: (NSData **)toData
{
    return [self processingCipher: NO From: fromData To: toData];
}

- (BOOL)processingCipher: (BOOL)isEncrypt From: (NSData *)fromData To: (NSData **)toData
{
    
    unsigned char inbuf[BLOCK_SIZE];
    unsigned char outbuf[BLOCK_SIZE];
    NSMutableData *outputData = [NSMutableData data];
    unsigned long inputLength, outlen, total = 0;
    CCCryptorRef cryptorRef;
    CCCryptorStatus status; //kCCSuccess
    status = CCCryptorCreate(isEncrypt ? kCCEncrypt : kCCDecrypt,
                             kCCAlgorithmAES128,
                             kCCOptionPKCS7Padding,
                             key, 16, iv, &cryptorRef);
    while( fromData.length > total ) {
        inputLength = fromData.length - total;
        if ( inputLength > BLOCK_SIZE ) {
            inputLength = BLOCK_SIZE;
        }
        [fromData getBytes: inbuf range: NSMakeRange(total, inputLength)];
        total += inputLength;
        if(CCCryptorUpdate(cryptorRef, inbuf, inputLength, outbuf, BLOCK_SIZE, &outlen) != kCCSuccess) {
            status = CCCryptorRelease(cryptorRef);
            return NO;
        }
        [outputData appendBytes: outbuf length: outlen];
    }
    if((status = CCCryptorFinal(cryptorRef, outbuf, BLOCK_SIZE, &outlen)) != kCCSuccess) {
        status = CCCryptorRelease(cryptorRef);
        return NO;
    }
    [outputData appendBytes: outbuf length: outlen];
    status = CCCryptorRelease(cryptorRef);
    *toData = [NSData dataWithData: outputData];
     
    return YES;
}

- (BOOL)encryptTransformData: (NSData *)fromData To: (NSData **)toData
{
    CFErrorRef error = NULL;
    NSData *keyData = [NSData dataWithBytes: key length: 16];
    NSData *ivData = [NSData dataWithBytes: iv length: 16];
    NSDictionary *keyParams = @{CFBridgingRelease(kSecAttrKeyType): CFBridgingRelease(kSecAttrKeyTypeAES)};
    SecKeyRef secKey = SecKeyCreateFromData ((__bridge CFDictionaryRef)(keyParams),
                                             (__bridge CFDataRef)(keyData),
                                             &error);
    SecTransformRef encrypt = NULL;
    encrypt = SecEncryptTransformCreate(secKey, &error);
    SecTransformSetAttribute(encrypt, kSecPaddingKey, kSecPaddingPKCS7Key, &error);
    SecTransformSetAttribute(encrypt, kSecIVKey, (__bridge CFTypeRef)(ivData), &error);
    SecTransformSetAttribute(encrypt, kSecTransformInputAttributeName, (__bridge CFTypeRef)(fromData), &error);
    *toData = CFBridgingRelease(SecTransformExecute(encrypt, &error));
    return YES;
}
- (BOOL)decryptTransformData: (NSData *)fromData To: (NSData **)toData
{
    CFErrorRef error = NULL;
    NSData *keyData = [NSData dataWithBytes: key length: 16];
    NSData *ivData = [NSData dataWithBytes: iv length: 16];
    NSDictionary *keyParams = @{CFBridgingRelease(kSecAttrKeyType): CFBridgingRelease(kSecAttrKeyTypeAES)};
    SecKeyRef secKey = SecKeyCreateFromData ((__bridge CFDictionaryRef)(keyParams),
                                             (__bridge CFDataRef)(keyData),
                                             &error);
    SecTransformRef encrypt = NULL;
    encrypt = SecDecryptTransformCreate(secKey, &error);
    SecTransformSetAttribute(encrypt, kSecPaddingKey, kSecPaddingPKCS7Key, &error);
    SecTransformSetAttribute(encrypt, kSecIVKey, (__bridge CFTypeRef)(ivData), &error);
    SecTransformSetAttribute(encrypt, kSecTransformInputAttributeName, (__bridge CFTypeRef)(fromData), &error);
    *toData = CFBridgingRelease(SecTransformExecute(encrypt, &error));
    return YES;
}

@end
