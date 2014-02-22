//
//  Communication.m
//  ComTest7
//
//  Created by Masayuki Nii on 2013/09/29.
//  Copyright (c) 2013年 msyk.net. All rights reserved.
//

#import "Communication.h"
#import <Security/Security.h>

@interface Communication()

@property (strong, nonatomic) NSOperationQueue *queue;
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURL *currentURL;
@property (        nonatomic) BOOL isDelegateSelf;
@property (        nonatomic) BOOL isUseQueue;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;

@end

@implementation Communication

- (id)initWithURL: (NSURL *)url
{
    self = [super init];
    if (self)   {
        self.currentURL = url;
        self.queue = [[NSOperationQueue alloc] init];
        self.isDelegateSelf = NO;
        self.isUseQueue = NO;
    }
    return self;
}

- (void)startCommunicationWithURL: (NSURL *)url
{
    self.currentURL = url;
    [self startCommunication];
}

- (void)delegateToSelf
{
    self.isDelegateSelf = YES;
}

- (void)useQueue
{
    self.isUseQueue = YES;
}

- (void)setUserName: (NSString *)username andPasword: (NSString *)password
{
    self.username = username;
    self.password = password;
}

- (void)startCommunication
{
#ifdef DEBUG
    NSLog( @"%s", __FUNCTION__ );
    NSLog( @"Is main thread ? %@", [NSThread isMainThread] ? @"YES" : @"NO");
#endif
    NSURLSessionConfiguration *config
    = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    self.session
    = [NSURLSession sessionWithConfiguration: config
                                    delegate: self.isDelegateSelf ? self : nil
                               delegateQueue: self.isUseQueue ? self.queue : nil];
    NSURLSessionDataTask *task;
    if (self.isDelegateSelf)    {
        task = [self.session dataTaskWithURL: self.currentURL];
    } else {
        task = [self.session dataTaskWithURL:self.currentURL
                           completionHandler:^(NSData *data,
                                               NSURLResponse *response,
                                               NSError *error){
#ifdef DEBUG
                               NSLog(@"%s dataTaskWithURL-completionHandler", __FUNCTION__);
                               NSLog( @"Is main thread ? %@", [NSThread isMainThread] ? @"YES" : @"NO");
                               NSString *dataString = [[NSString alloc]initWithData: data encoding: NSUTF8StringEncoding];
                               NSInteger topLength = data.length > 20 ? 20 :  data.length;
                               NSLog(@"[data] (%d)%@...", data.length, [dataString substringToIndex: topLength]);
                               NSLog(@"[response] %@", response);
                               NSLog(@"[error] %@", error);
#endif
                               [self.session invalidateAndCancel];
                           }];
    }
    [task resume];
#ifdef DEBUG
    NSLog( @"End of %s", __FUNCTION__ );
#endif
}

#pragma mark - NSURLSessionDelegate

- (void)       URLSession:(NSURLSession *)session
didBecomeInvalidWithError:(NSError *)error
{
#ifdef DEBUG
    NSLog( @"%s", __FUNCTION__ );
    NSLog( @"[error] %@", error );
#endif
    
}

- (void) URLSession:(NSURLSession *)session
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
  completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition,
                              NSURLCredential *credential))completionHandler
{
#ifdef DEBUG
    NSLog( @"%s", __FUNCTION__ );
    NSString *authMethod = challenge.protectionSpace.authenticationMethod;
    NSLog( @"[authMethod]%@", authMethod );
#endif
    
    if ( [authMethod isEqualToString: NSURLAuthenticationMethodServerTrust] )  {
        SecTrustRef secTrustRef = challenge.protectionSpace.serverTrust;
        if (secTrustRef != NULL)    {
            SecTrustResultType result;
            OSErr er = SecTrustEvaluate( secTrustRef, &result );
            if ( er != noErr)  {
                completionHandler(NSURLSessionAuthChallengeRejectProtectionSpace, nil);
            }
            if ( result == kSecTrustResultRecoverableTrustFailure ) {
                NSLog( @"---SecTrustResultRecoverableTrustFailure" );
            }
            NSLog( @"---Return YES" );
            NSURLCredential *credential = [NSURLCredential credentialForTrust: secTrustRef];
            //        [[challenge sender] useCredential: credential forAuthenticationChallenge: challenge];
            
            
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        }
    }
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
#ifdef DEBUG
    NSLog( @"%s", __FUNCTION__ );
#endif
    
}

#pragma mark - NSURLSessionTaskDelegate

- (void)  URLSession:(NSURLSession *)session
                task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
#ifdef DEBUG
    NSLog( @"%s", __FUNCTION__ );
    NSLog( @"[error] %@", error );
#endif
    
}
- (void) URLSession:(NSURLSession *)session
               task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
  completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition,
                              NSURLCredential *credential))completionHandler
{
#ifdef DEBUG
    NSLog( @"%s", __FUNCTION__ );
    NSString *authMethod = challenge.protectionSpace.authenticationMethod;
    NSLog( @"[challenge]%@", challenge );
    NSLog( @"[protectionSpace]%@", challenge.protectionSpace );
    NSLog( @"[authMethod]%@", authMethod );
#endif
    
    if ( [authMethod isEqualToString: NSURLAuthenticationMethodDefault] )  {
        NSURLCredential *credential = [NSURLCredential credentialWithUser: self.username
                                                                 password: self.password
                                                              persistence: NSURLCredentialPersistenceNone];
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
    } else {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
}

- (void)      URLSession:(NSURLSession *)session
                    task:(NSURLSessionTask *)task
         didSendBodyData:(int64_t)bytesSent
          totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
#ifdef DEBUG
    NSLog( @"%s", __FUNCTION__ );
#endif
    
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
 needNewBodyStream:(void (^)(NSInputStream *bodyStream))completionHandler
{
#ifdef DEBUG
    NSLog( @"%s", __FUNCTION__ );
#endif
    
}

- (void)        URLSession:(NSURLSession *)session
                      task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
                newRequest:(NSURLRequest *)request
         completionHandler:(void (^)(NSURLRequest *))completionHandler
{
#ifdef DEBUG
    NSLog( @"%s", __FUNCTION__ );
#endif
    completionHandler(request);
}

#pragma mark - NSURLSessionDataDelegate

- (void)   URLSession:(NSURLSession *)session
             dataTask:(NSURLSessionDataTask *)dataTask
didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
    
}
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
#ifdef DEBUG
    NSLog( @"%s", __FUNCTION__ );
    NSLog( @"[data] %@", data );
#endif
    
}
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
#ifdef DEBUG
    NSLog( @"%s", __FUNCTION__ );
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSLog( @"HTTP Response Code = %d", httpResponse.statusCode );
#endif
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler
{
#ifdef DEBUG
    NSLog( @"%s", __FUNCTION__ );
#endif
    completionHandler(nil);
}

#pragma mark - NSURLSessionDownloadDelegate

- (void)       URLSession:(NSURLSession *)session
             downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
#ifdef DEBUG
    NSLog( @"%s", __FUNCTION__ );
#endif
    
}
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
#ifdef DEBUG
    NSLog( @"%s", __FUNCTION__ );
#endif
    
}

- (void)       URLSession:(NSURLSession *)session
             downloadTask:(NSURLSessionDownloadTask *)downloadTask
             didWriteData:(int64_t)bytesWritten
        totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
#ifdef DEBUG
    NSLog( @"%s", __FUNCTION__ );
#endif
    
    
}
@end
