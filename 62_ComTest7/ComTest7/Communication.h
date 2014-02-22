//
//  Communication.h
//  ComTest7
//
//  Created by Masayuki Nii on 2013/09/29.
//  Copyright (c) 2013年 msyk.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Communication : NSObject
    <NSURLSessionDelegate, NSURLSessionTaskDelegate,
        NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>

- (id)initWithURL: (NSURL *)url;
- (void)delegateToSelf;
- (void)useQueue;
- (void)setUserName: (NSString *)username andPasword: (NSString *)password;
- (void)startCommunication;
- (void)startCommunicationWithURL: (NSURL *)url;

@end
