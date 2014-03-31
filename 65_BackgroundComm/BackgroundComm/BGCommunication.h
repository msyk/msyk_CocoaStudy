//
//  BGCommunication.h
//  BackgroundComm
//
//  Created by Masayuki Nii on 2014/03/31.
//  Copyright (c) 2014年 msyk.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BGCommunication : NSOperation
<NSURLSessionDelegate, NSURLSessionTaskDelegate,
NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>

@property (strong, nonatomic) NSURL *downloadedFile;

- (id) initWithURL: (NSURL *)url
        doProgress: (void (^)(float))progress
           doAfter: (NSBlockOperation *)block;

@end
