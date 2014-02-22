#import "AppController.h"

@interface NSString ( CocoaStudy23 )
-(id) initWithData:(NSData *)data IANACharSetName:(NSString *)charSetName;
@end

@implementation NSString ( CocoaStudy23 )
-(id) initWithData:(NSData *)data IANACharSetName:(NSString *)charSetName
{
	CFStringEncoding cfCharset = CFStringConvertIANACharSetNameToEncoding((CFStringRef)charSetName);
	NSStringEncoding nsCharset = CFStringConvertEncodingToNSStringEncoding(cfCharset);
	return [self initWithData:data encoding:nsCharset];
}
@end

@implementation AppController

-(void) awakeFromNib
{
	UInt8 cString[] = { 0x82, 0xA9, 0x82, 0xC8, 0x8A, 0xBF, 0x95, 0x5C, 0 };

	NSData *streamedString = [NSData dataWithBytes:(void *)&cString length:sizeof cString];
	NSString *testString = [[NSString alloc]initWithData:streamedString IANACharSetName:@"Shift-JIS"];
	NSLog( testString );
	
	NSString *targetFile = @"/Users/msyk/Documents/apple-reg.pdf";
	NSString *prefMIMEType = [self preferedMIMETypeFromFile:targetFile];
	NSLog( prefMIMEType );
	
	targetFile = @"/Users/msyk/Desktop/upload-3.wmail";
	prefMIMEType = [self preferedMIMETypeFromFile:targetFile];
	NSLog( prefMIMEType );
/*	
   [self checkEnc:NSASCIIStringEncoding];
   [self checkEnc:NSNEXTSTEPStringEncoding];
   [self checkEnc:NSJapaneseEUCStringEncoding];
   [self checkEnc:NSUTF8StringEncoding];
   [self checkEnc:NSISOLatin1StringEncoding];
   [self checkEnc:NSSymbolStringEncoding];
   [self checkEnc:NSNonLossyASCIIStringEncoding];
   [self checkEnc:NSShiftJISStringEncoding];
   [self checkEnc:NSISOLatin2StringEncoding];
   [self checkEnc:NSUnicodeStringEncoding];
   [self checkEnc:NSWindowsCP1251StringEncoding];
   [self checkEnc:NSWindowsCP1252StringEncoding];
   [self checkEnc:NSWindowsCP1253StringEncoding];
   [self checkEnc:NSWindowsCP1254StringEncoding];
   [self checkEnc:NSWindowsCP1250StringEncoding];
   [self checkEnc:NSISO2022JPStringEncoding];
   [self checkEnc:NSMacOSRomanStringEncoding];
   [self checkEnc:NSProprietaryStringEncoding];	
*/
}

/*
- (NSString *)preferedMIMETypeFromFile:(NSString *)targetFile
{
	NSString *currentFileExtension = [targetFile pathExtension];
	CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(
		kUTTagClassFilenameExtension, (CFStringRef)currentFileExtension, NULL);
	CFStringRef prefferdMIMEType = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType);
	return (NSString *)prefferdMIMEType;
}
*/
- (NSString *)preferedMIMETypeFromFile:(NSString *)targetFile
{
	FSRef ref;
	FSPathMakeRef ((unsigned char*)[targetFile fileSystemRepresentation], &ref, NULL);
	
	CFDictionaryRef values = NULL;
	CFStringRef attrs[] = { kLSItemContentType, kLSItemExtension, kLSItemRoleHandlerDisplayName };
	CFStringRef prefferdMIMEType = NULL;
	CFArrayRef attrNames = CFArrayCreate(NULL, (const void **)attrs, 3 , NULL);
	if ( LSCopyItemAttributes(&ref, kLSRolesAll, attrNames, &values) == noErr )	{
		CFTypeRef uti = CFDictionaryGetValue(values, kLSItemContentType);
		CFStringRef extInfo = CFDictionaryGetValue(values, kLSItemExtension);
		CFStringRef appInfo = CFDictionaryGetValue(values, kLSItemRoleHandlerDisplayName);
		NSLog ( @"%@ -> %@ -> %@", uti, extInfo, appInfo );
		prefferdMIMEType = UTTypeCopyPreferredTagWithClass( uti, kUTTagClassMIMEType );
	}
	if ( prefferdMIMEType == nil )	{
		/* Your Own Codes */
	}
	return (NSString *)prefferdMIMEType;
}

- (void)checkEnc:(NSStringEncoding)enc
{
	CFStringEncoding cfEnc = CFStringConvertNSStringEncodingToEncoding(enc);
	CFStringRef cSet = CFStringConvertEncodingToIANACharSetName(cfEnc);
	UInt32 codePage = CFStringConvertEncodingToWindowsCodepage(cfEnc);
	NSLog ( @"<tr><td>%d</td><td>%d</td><td>%@</td><td>%d</td></tr>", enc, cfEnc, cSet, codePage);
}
@end
