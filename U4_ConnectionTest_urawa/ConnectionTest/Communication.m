//
//  Communication.m
//  ConnectionTest
//
//  Created by Masayuki Nii on 11/06/19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Communication.h"


@implementation Communication

@synthesize receivedData = _receivedData;

- (id)init
{
    if ( (self = [super init]) )  {
        self.receivedData = nil;
    }
    return self;
}

- (void)dealloc
{
    self.receivedData = nil;
    [super dealloc];
}

- (void)downloadData: (NSString *)urlString
{
    NSURL *url = [NSURL URLWithString: urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL: url];
    
    NSLog( @"urlString = %@", urlString );
    self.receivedData = [NSMutableData data];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest: urlRequest 
                                                                  delegate: self];
    if ( connection == nil )    {
        // ERROR
        NSLog( @"ERROR: NSURLConnection is nil" );
    }
}


#pragma -
#pragma NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection 
    didReceiveData:(NSData *)data
{
    NSLog( @"Calling: connection:didReceiveData:" );
    [self.receivedData appendData: data];
}

- (void)connection:(NSURLConnection *)connection 
  didFailWithError:(NSError *)error
{
    NSLog( @"Calling: connection:didFailWithError: %@", error );
    self.receivedData = nil;    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog( @"Calling: connectionDidFinishLoading:" );
    [connection release];
    
    NSLog( @"receivedData = %@", [[[NSString alloc] initWithData: self.receivedData 
                                                        encoding: NSUTF8StringEncoding] autorelease] );
    
    self.receivedData = nil;
}
- (void)    connection:(NSURLConnection *)connection 
    didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpRes = (NSHTTPURLResponse *)response;
    
    NSLog( @"Calling: connection:didReceiveResponse: status code=%d", [httpRes statusCode] );
}


- (BOOL)                       connection:(NSURLConnection *)connection 
    canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    NSString *authMethod = [protectionSpace authenticationMethod];
    NSLog( @"Calling: connection:canAuthenticateAgainstProtectionSpace: "
          " auth method=%@/host=%@", authMethod, [protectionSpace host] );
    
    if ( [authMethod isEqualToString: NSURLAuthenticationMethodServerTrust] )  {
        secTrustRef = [protectionSpace serverTrust];
        if (secTrustRef != NULL)    {
            SecTrustResultType result;
            OSErr er = SecTrustEvaluate( secTrustRef, &result );
            if ( er != noErr)  {
                return NO;
            }
            if ( result == kSecTrustResultRecoverableTrustFailure ) {
                NSLog( @"---SecTrustResultRecoverableTrustFailure" );
            }
            NSLog( @"---Return YES" );
            return YES;
        }
    }
    if ( [authMethod isEqualToString: NSURLAuthenticationMethodDefault] )  {
        NSLog( @"---Return YES" );
        return YES;
    }
    return NO;
}
- (void)                   connection:(NSURLConnection *)connection 
    didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSLog( @"Calling: connection:didReceiveAuthenticationChallenge: %@", challenge );
    
 //   NSURLCredential *credential = [NSURLCredential credentialForTrust: secTrustRef];
 //   [[challenge sender] useCredential: credential forAuthenticationChallenge:challenge];

    if ( [challenge previousFailureCount] == 0 )    {
        NSURLCredential *credential 
            = [NSURLCredential credentialWithUser: @"te"
                                         password: @"te"
                                      persistence: NSURLCredentialPersistenceNone];
        [[challenge sender] useCredential: credential 
               forAuthenticationChallenge:challenge];
    } else if ( [challenge previousFailureCount] == 1 )    {
        NSURLCredential *credential 
            = [NSURLCredential credentialWithUser: @"msyk"
                                         password: @"12345678"
                                      persistence: NSURLCredentialPersistenceNone];
            [[challenge sender] useCredential: credential 
                   forAuthenticationChallenge:challenge];
    } else {
        [[challenge sender] cancelAuthenticationChallenge: challenge];
    }

}
- (void)                  connection:(NSURLConnection *)connection 
    didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSLog( @"Calling: connection:didCancelAuthenticationChallenge: %@", challenge );
    
    
}
- (void)           connection:(NSURLConnection *)connection 
              didSendBodyData:(NSInteger)bytesWritten 
            totalBytesWritten:(NSInteger)totalBytesWritten 
    totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    NSLog( @"Calling: connection:didSendBodyData:totalBytesWritten:totalBytesExpectedToWrite:" );
}
- (NSURLRequest *)connection:(NSURLConnection *)connection 
             willSendRequest:(NSURLRequest *)request 
            redirectResponse:(NSURLResponse *)redirectResponse
{
    NSLog( @"Calling: connection:willSendRequest:redirectResponse: %@", redirectResponse );
    return request;
}
- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection
{
    NSLog( @"Calling: connectionShouldUseCredentialStorage:" );
    return YES;
}

@end
