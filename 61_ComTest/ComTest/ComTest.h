//
//  ComTest.h
//  ComTest
//
//  Created by Masayuki Nii on 2013/08/31.
//  Copyright (c) 2013年 msyk.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComTest : NSOperation <NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSMutableData *receivedData;
@property (nonatomic) int responseCode;
@property (strong, nonatomic) NSError *communicationError;

-(id) initWithURL: (NSURL *)url
   WithFinishProc: (NSBlockOperation *)finishProc;

@end
