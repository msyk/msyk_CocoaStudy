//
//  TestComTest.m
//  TestComTest
//
//  Created by Masayuki Nii on 2013/08/31.
//  Copyright (c) 2013年 msyk.net. All rights reserved.
//

#import "TestComTest.h"
#import "ComTest.h"
#import "ComTestMod.h"

@implementation TestComTest

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

- (void)test1
{
    NSString *urlString = @"http://msyk.net/index.html";
    NSBlockOperation *bo = [NSBlockOperation blockOperationWithBlock: ^(){
        NSLog( @"%s", __FUNCTION__);
        NSLog( @" Thread: %@", [NSThread isMainThread] ? @"Main" : @"Not Main");
        
    }];
    ComTest *ct = [[ComTest alloc] initWithURL: [NSURL URLWithString: urlString]
                                WithFinishProc: bo];
    [ct start];
    
    while (! [ct isFinished] )   {
        [[NSRunLoop currentRunLoop] runUntilDate: [NSDate date]];
    }
    STAssertTrue(ct.receivedData.length > 0, @"should download any data.");
}
/*
- (void)test2
{
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    NSString *urlString = @"http://msyk.net/index.html";
    NSBlockOperation *bo = [NSBlockOperation blockOperationWithBlock: ^(){
        NSLog( @"%s", __FUNCTION__);
        NSLog( @" Thread: %@", [NSThread isMainThread] ? @"Main" : @"Not Main");
        
    }];
    ComTest *ct = [[ComTest alloc] initWithURL: [NSURL URLWithString: urlString]
                                      WithFinishProc: bo];
    [queue addOperation: ct];
    while (! [ct isFinished] )   {
        [[NSRunLoop currentRunLoop] runUntilDate: [NSDate date]];
    }
    NSLog( @"End of the Loop, Thread: %@", [NSThread isMainThread] ? @"Main" : @"Not Main");
    STAssertTrue(ct.receivedData.length > 0, @"should download any data.");
}
*/
/*
- (void)test3
{
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    NSString *urlString = @"http://msyk.net/index.html";
    NSBlockOperation *bo = [NSBlockOperation blockOperationWithBlock: ^(){
        NSLog( @"%s", __FUNCTION__);
        NSLog( @" Thread: %@", [NSThread isMainThread] ? @"Main" : @"Not Main");
        
    }];
    ComTestMod *ct = [[ComTestMod alloc] initWithURL: [NSURL URLWithString: urlString]
                                           withQueue: queue
                                      WithFinishProc: bo];
    [queue addOperation: ct];
    while (! [ct isFinished] )   {
        [[NSRunLoop currentRunLoop] runUntilDate: [NSDate date]];
    }
    NSLog( @"End of the Loop, Thread: %@", [NSThread isMainThread] ? @"Main" : @"Not Main");
    STAssertTrue(ct.receivedData.length > 0, @"should download any data.");
}
*/
@end
