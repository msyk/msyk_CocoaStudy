//
//  ComTest.m
//  ComTest
//
//  Created by Masayuki Nii on 2013/08/31.
//  Copyright (c) 2013年 msyk.net. All rights reserved.
//

#import "ComTest.h"

@interface ComTest()

@property (nonatomic) BOOL isExecuting;
@property (nonatomic) BOOL isFinished;

@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSBlockOperation *onFinishProc;
@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableURLRequest *request;
@property (nonatomic,strong) NSOperationQueue *queue;

@end

@implementation ComTest

- (BOOL)isConcurrent
{
    return YES;
}

- (id) init
{
    if ( (self = [super init]) )    {
        self.queue = nil;
    }
    return self;
}

-(id) initWithURL: (NSURL *)url
   WithFinishProc: (NSBlockOperation *)finishProc
{
#ifdef DEBUG
    NSLog( @"[Main=%@]%s", [NSThread isMainThread] ? @"YES" : @"NO ", __FUNCTION__ );
#endif
    
    if (( self = [self init] ))    {
        self.url = url;
        
#ifdef DEBUG
        NSLog( @"URL=%@", self.url);
#endif
        
        self.onFinishProc = finishProc;
        self.communicationError = nil;
    }
    return self;
}

- (void)start
{
#ifdef DEBUG
    NSLog( @"[Main=%@]%s", [NSThread isMainThread] ? @"YES" : @"NO ", __FUNCTION__ );
#endif
    
    self.receivedData = [NSMutableData data];
    self.responseCode = 0;
    self.communicationError = nil;
    
    
#ifdef DEBUG
    NSLog( @"Connect to: %@", self.url );
#endif
    self.request = [NSMutableURLRequest requestWithURL: self.url];
    self.connection = [[NSURLConnection alloc] initWithRequest: self.request
                                                      delegate: self];
    if (self.connection == nil) {
        [self finish];
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    self.isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];

#ifdef DEBUG
    NSLog( @"Finish: %s", __FUNCTION__ );
#endif
}

- (void)finish
{
#ifdef DEBUG
    NSLog( @"[Main=%@]%s", [NSThread isMainThread] ? @"YES" : @"NO ", __FUNCTION__ );
#endif
    
    self.connection = nil;
    
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    self.isExecuting = NO;
    self.isFinished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
#ifdef DEBUG
    NSLog( @"[Main=%@]%s", [NSThread isMainThread] ? @"YES" : @"NO ", __FUNCTION__ );
#endif
    
    self.responseCode = ((NSHTTPURLResponse *)response).statusCode;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
#ifdef DEBUG
    NSLog( @"[Main=%@]%s", [NSThread isMainThread] ? @"YES" : @"NO ", __FUNCTION__ );
#endif
    
    [self.receivedData appendData: data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
#ifdef DEBUG
    NSLog( @"[Main=%@]%s", [NSThread isMainThread] ? @"YES" : @"NO ", __FUNCTION__ );
#endif
    
    [self.onFinishProc main];
    [self finish];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
#ifdef DEBUG
    NSLog( @"[Main=%@]%s", [NSThread isMainThread] ? @"YES" : @"NO ", __FUNCTION__ );
#endif
    
    self.communicationError = error;
    [self.onFinishProc main];
    [self finish];
}

@end
