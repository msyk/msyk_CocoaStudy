/* AppController */

#import <Cocoa/Cocoa.h>

@interface AppController : NSObject
{
}
- (NSString *)preferedMIMETypeFromFile:(NSString *)targetFile;
- (void)checkEnc:(NSStringEncoding)enc;
@end
