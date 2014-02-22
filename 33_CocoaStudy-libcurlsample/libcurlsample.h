/*
 *  libcurlsample.h
 *  CocoaStudy-libcurlsample
 *
 *  Created by Masayuki Nii on 09/04/04.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#import <curl/curl.h>
#include <CoreFoundation/CoreFoundation.h>

void simpleHTTP( const char* url, char *receivedStr );
void httpPost( const char* url, const char* postStr, char *receivedStr );
void https( const char* url, char *receivedStr );
void httpAuth( const char* url, const char* username, const char* password, char *receivedStr );

size_t receivedCallback( void *ptr, size_t size, size_t nmemb, void *stream);