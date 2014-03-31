//
//  BGCommunication.m
//  BackgroundComm
//
//  Created by Masayuki Nii on 2014/03/31.
//  Copyright (c) 2014年 msyk.net. All rights reserved.
//

#import "BGCommunication.h"
#import "AppDelegate.h"

@interface BGCommunication()

@property (nonatomic) BOOL isExecuting;
@property (nonatomic) BOOL isFinished;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) void (^doProgress)(float);
@property (strong, nonatomic) NSBlockOperation *doAfter;
@property (strong, nonatomic) NSString *resultString;
@property (strong, nonatomic) NSError *resultError;
@property (        nonatomic) NSInteger responseCode;

- (void)finishMyOperation;
- (void)backgroundTask;

@end

@implementation BGCommunication

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isExecuting {
    return _isExecuting;
}

- (BOOL)isFinished {
    return _isFinished;
}

- (id) init
{
#ifdef DEBUG
    NSLog( @"%s", __FUNCTION__ );
#endif
    if ( (self = [super init]) )    {
        self.isExecuting = NO;
        self.isFinished = NO;
    }
    return self;
}

- (id) initWithURL: (NSURL *)url
        doProgress: (void (^)(float))progress
           doAfter: (NSBlockOperation *)block
{
    self = [super init];
    if (self)   {
        self.url = url;
        self.doProgress = progress;
        self.doAfter = block;
    }
    return self;
}

- (void)start
{
#ifdef DEBUG
    NSLog( @"%s", __FUNCTION__ );
#endif
    if ([self isCancelled])
    {
        [self willChangeValueForKey:@"isFinished"];
        self.isFinished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    [self willChangeValueForKey:@"isExecuting"];
    self.isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    [self main];
}

- (void)finishMyOperation
{
#ifdef DEBUG
    NSLog( @"%s", __FUNCTION__ );
#endif
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    self.isExecuting = NO;
    self.isFinished = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (void)main {
#ifdef DEBUG
    NSLog( @"%s", __FUNCTION__ );
#endif
    @try {
        self.resultError = nil;
        self.responseCode = -1;
        self.downloadedFile = nil;
        
        NSURLRequest *request = [NSURLRequest requestWithURL: self.url];
        
        NSURLSessionConfiguration *config
        = [NSURLSessionConfiguration backgroundSessionConfiguration: @"mytask"];
        
        self.session = [NSURLSession sessionWithConfiguration: config
                                                              delegate: self
                                                         delegateQueue: nil];
        NSURLSessionDownloadTask *task = [self.session downloadTaskWithRequest: request];
        [task resume];
    }
    @catch(NSException *ex) {
        //例外への対応。例外は再度スルーはしない
    }
}

- (void)backgroundTask
{
    [self finishMyOperation];
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

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
#ifdef DEBUG
    NSLog( @"%s", __FUNCTION__ );
#endif
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.downloadCompletionHandler) {
        void (^completionHandler)() = appDelegate.downloadCompletionHandler;
        appDelegate.downloadCompletionHandler = nil;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            completionHandler();
        }];
    }
    [self backgroundTask];
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
    self.resultError = error;
    [session finishTasksAndInvalidate];
    [[NSOperationQueue mainQueue] addOperation: self.doAfter];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (! appDelegate.downloadCompletionHandler) {
        [self backgroundTask];
    }
}

#pragma mark - NSURLSessionDataDelegate

- (void)   URLSession:(NSURLSession *)session
             dataTask:(NSURLSessionDataTask *)dataTask
didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
#ifdef DEBUG
    NSLog( @"%s", __FUNCTION__ );
#endif
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
#ifdef DEBUG
    NSLog( @"%s", __FUNCTION__ );
#endif
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
#ifdef DEBUG
    NSLog( @"%s", __FUNCTION__ );
    NSLog( @"HTTP Response Code = %ld", (long)httpResponse.statusCode );
#endif
    completionHandler(NSURLSessionResponseAllow);
}

#pragma mark - NSURLSessionDownloadDelegate

- (void)       URLSession:(NSURLSession *)session
             downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
#ifdef DEBUG
    NSLog( @"%s", __FUNCTION__ );
    NSLog( @"%@", location );
#endif
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *URLs = [fileManager URLsForDirectory: NSDocumentDirectory
                                        inDomains: NSUserDomainMask];
    NSString *originalFN = downloadTask.originalRequest.URL.lastPathComponent;
    NSURL *destinationURL = [URLs[0] URLByAppendingPathComponent: originalFN];
    NSError *error;
    [fileManager removeItemAtURL: destinationURL error: NULL];
    if ([fileManager copyItemAtURL: location
                             toURL: destinationURL
                             error: &error]) {
        self.resultError = error;
    }
    self.downloadedFile = destinationURL;
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
    //    NSLog( @"%s %8lld %8lld %8lld", __FUNCTION__, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite );
#endif
    float rate = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;

    NSLog(@"Dowloading %d %%", (int)(rate * 100));
    
    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
        self.doProgress(rate);
    }];
}
@end


