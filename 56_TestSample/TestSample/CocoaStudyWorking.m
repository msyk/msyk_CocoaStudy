//
//  TestClass.m
//  TestSample
//
//  Created by Masayuki Nii on 2012/11/23.
//  Copyright (c) 2012年 net.msyk. All rights reserved.
//

#import "CocoaStudyWorking.h"

@implementation CocoaStudyWorking

@synthesize testProp;
@synthesize roProp;

- (id)init
{
    if (( self = [super init])) {
        [self setTestProp: @""];
//        [self setroProp: @""];
//        self.roProp = @"";
    }
    return self;
}

@end
