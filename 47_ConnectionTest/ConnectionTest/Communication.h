//
//  Communication.h
//  ConnectionTest
//
//  Created by Masayuki Nii on 11/06/19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Communication : NSObject {
    SecTrustRef secTrustRef;
}

@property (retain, nonatomic) NSMutableData *receivedData;

- (void)downloadData: (NSString *)urlString;

@end
