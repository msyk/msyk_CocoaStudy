//
//  TestClass.h
//  TestSample
//
//  Created by Masayuki Nii on 2012/11/23.
//  Copyright (c) 2012年 net.msyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TestInterface <NSObject>

@property (strong, nonatomic)   NSString *testProp;

@end

@interface CocoaStudyWorking : NSObject <TestInterface>

//@property NSString *newName;
@property NSString *getName;
@property (readonly) NSString *roProp;

@end
