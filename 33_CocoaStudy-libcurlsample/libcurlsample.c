/*
 *  libcurlsample.c
 *  CocoaStudy-libcurlsample
 *
 *  Created by Masayuki Nii on 09/04/04.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "libcurlsample.h"

char *buffer;

size_t receivedCallback( void *ptr, size_t size, size_t nmemb, void *stream)	{
	int endPoint = strlen( buffer );
	memcpy( buffer + endPoint, ptr, size * nmemb );
	buffer[endPoint + size * nmemb + 1]=0;
	return size * nmemb;
}

void simpleHTTP( const char* url, char *receivedStr )	{
	buffer = receivedStr;
	buffer[0] = 0;
	CURLcode cc = curl_global_init( CURL_GLOBAL_ALL );
	if ( cc == 0 )	{
		CURL *curlHandle = curl_easy_init();
		curl_easy_setopt( curlHandle, CURLOPT_URL, url );
		curl_easy_setopt( curlHandle, CURLOPT_WRITEFUNCTION, receivedCallback );
		
		curl_easy_setopt( curlHandle, CURLOPT_VERBOSE, 1 );
		CURLcode success = curl_easy_perform( curlHandle );
		if ( success != 0 )	{
			 sprintf( receivedStr, "libcurl error: %d", success );
		}
		curl_easy_cleanup( curlHandle );
	}
//	printf( "libcurl version: %s\n", curl_version() );
}

void httpPost( const char* url, const char* postStr, char *receivedStr )	{
	buffer = receivedStr;
	buffer[0] = 0;
	CURLcode cc = curl_global_init( CURL_GLOBAL_ALL );
	if ( cc == 0 )	{
		CURL *curlHandle = curl_easy_init();
		curl_easy_setopt( curlHandle, CURLOPT_URL, url );
		curl_easy_setopt( curlHandle, CURLOPT_WRITEFUNCTION, receivedCallback );
		char *urlEncoded = curl_easy_escape( curlHandle , postStr , 0 );
		char *param = "postdata";
		char *postData = malloc( strlen( urlEncoded ) + strlen( param ) + 2 );
		strcpy( postData, param );
		strcat( postData, "=" );
		strcat( postData, urlEncoded );
		curl_easy_setopt(curlHandle, CURLOPT_POSTFIELDS, postData);
		
		curl_easy_setopt( curlHandle, CURLOPT_VERBOSE, 1 );
		CURLcode success = curl_easy_perform( curlHandle );
		if ( success != 0 )	{
			 sprintf( receivedStr, "libcurl error: %d", success );
		}
		free( postData );
		curl_free( urlEncoded );
		curl_easy_cleanup( curlHandle );
	}
}

void https( const char* url, char *receivedStr )	{
	buffer = receivedStr;
	buffer[0] = 0;
	CURLcode cc = curl_global_init( CURL_GLOBAL_ALL );
	if ( cc == 0 )	{
		CURL *curlHandle = curl_easy_init();
		curl_easy_setopt( curlHandle, CURLOPT_URL, url );
		curl_easy_setopt( curlHandle, CURLOPT_WRITEFUNCTION, receivedCallback );
//		curl_easy_setopt(curlHandle, CURLOPT_SSL_VERIFYPEER, 0L);
//		curl_easy_setopt(curlHandle, CURLOPT_SSL_VERIFYHOST, 0L);
		curl_easy_setopt( curlHandle, CURLOPT_VERBOSE, 1 );
		CURLcode success = curl_easy_perform( curlHandle );
		if ( success != 0 )	{
			 sprintf( receivedStr, "libcurl error: %d", success );
		}
		curl_easy_cleanup( curlHandle );
	}
}

void httpAuth( const char* url, const char* username, const char* password, char *receivedStr )	{
	buffer = receivedStr;
	buffer[0] = 0;
	CURLcode cc = curl_global_init( CURL_GLOBAL_ALL );
	if ( cc == 0 )	{
		CURL *curlHandle = curl_easy_init();
		curl_easy_setopt( curlHandle, CURLOPT_URL, url );
		curl_easy_setopt( curlHandle, CURLOPT_WRITEFUNCTION, receivedCallback );
		char *authInfo = malloc( strlen( username ) + strlen( password ) + 2 );
		strcpy( authInfo, username );
		strcat( authInfo, ":" );
		strcat( authInfo, password );
		curl_easy_setopt( curlHandle, CURLOPT_USERPWD, authInfo );
		curl_easy_setopt( curlHandle, CURLOPT_HTTPAUTH,  CURLAUTH_DIGEST|CURLAUTH_BASIC);
		
		curl_easy_setopt( curlHandle, CURLOPT_VERBOSE, 1 );
		CURLcode success = curl_easy_perform( curlHandle );
		if ( success != 0 )	{
			 sprintf( receivedStr, "libcurl error: %d", success );
		}
		curl_easy_cleanup( curlHandle );
		free( authInfo );
	}
}
