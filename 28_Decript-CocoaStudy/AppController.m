//
//  AppController.m
//  Decript-CocoaStudy
//
//  Created by 新居雅行 on 08/03/28.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"


@implementation AppController

- (void)awakeFromNib
{
	NSString *rPath = [[NSBundle mainBundle] resourcePath];
	NSString *encFile = [rPath stringByAppendingPathComponent:@"data.enc"];
/*
$ openssl bf -P -k apple2
salt=17731E3E93896C77
key=3C27DE1D1DD84C0FA67B6A49E423DF4A
iv =B7FBF5536765B277
*/
	NSData* encData = [NSData dataWithContentsOfFile: encFile];
	NSString* originalString = [[NSString alloc]initWithData: encData encoding: NSASCIIStringEncoding];
	[originalText insertText: originalString];
	
	int plainlen, tmplen;
	unsigned char iv[8] = {0xB7, 0xFB, 0xF5, 0x53, 0x67, 0x65, 0xB2, 0x77};
	unsigned char key[16] = {0x3C, 0x27, 0xDE, 0x1D, 0x1D, 0xD8, 0x4C, 0x0F,
							 0xA6, 0x7B, 0x6A, 0x49, 0xE4, 0x23, 0xDF, 0x4A};
	unsigned char* inData;
	unsigned char* outData;

	inData = (unsigned char*)[encData bytes];
	int inDataLen = [encData length];
	outData = malloc(inDataLen + 8);

	EVP_CIPHER_CTX ctx;
	EVP_CIPHER_CTX_init( &ctx );
	EVP_DecryptInit( &ctx, EVP_bf_cbc(), key ,iv );
	int resultUpdate = EVP_DecryptUpdate( &ctx, outData, &plainlen, inData, inDataLen);
	int resultFinal = EVP_DecryptFinal( &ctx, outData + plainlen, &tmplen);
	EVP_CIPHER_CTX_cleanup(&ctx);
	if ( ( resultFinal != 1 ) || ( resultUpdate != 1 ) )	{
		[decriptedText insertText: @"Decription was not succeed." ];
	} else {
		outData[ plainlen + tmplen ] = 0;
		NSString* decriptedString = [NSString stringWithUTF8String: (char*)outData];
		[decriptedText insertText: decriptedString ];
	}
	free(outData);
}

@end
