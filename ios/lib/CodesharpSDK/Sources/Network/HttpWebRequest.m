//
//  HttpWebRequest.m
//  CodesharpSDK
//
//  Created by sunleepy on 12-9-8.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "HttpWebRequest.h"

@implementation HttpWebRequest

@synthesize delegate;

- (id)init
{
    self = [super init];
    if(self) {
        
    }
    return self;
}

- (ASIFormDataRequest*)createPostRequest:(NSString*)url
                                 params:(NSMutableDictionary*)params
                                headers:(NSMutableDictionary*)headers
                                context:(NSMutableDictionary*)context
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
	[reachability startNotifier];
	if (reachability.currentReachabilityStatus == NotReachable) {
        return nil;
	}
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    if (context)
    {
		[request setUserInfo:[NSDictionary dictionaryWithDictionary:context]];
	}
    if (headers)
    {
        for (NSString *key in headers.allKeys)
        {
            [request addRequestHeader:key value:[headers objectForKey:key]];
        }
    }
    if(params)
    {
        for(NSString *key in params.allKeys)
        {
            [request setPostValue:[params objectForKey:key] forKey:key];
        }
    }
    
    //cookies设置
    NSHTTPCookieStorage *sharedHTTPCookie = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //[request setUseCookiePersistence:YES];
    [request setRequestCookies: [NSMutableArray arrayWithArray:sharedHTTPCookie.cookies]];
    
    [request setTimeOutSeconds:SYSTEM_REQUEST_TIMEOUT];
	[request setCachePolicy:ASIAskServerIfModifiedCachePolicy];
    
    [request setValidatesSecureCertificate:NO];
    return request;
}

- (ASIHTTPRequest*)createGetRequest:(NSString*)url
                                  params:(NSMutableDictionary*)params
                                 headers:(NSMutableDictionary*)headers
                                 context:(NSMutableDictionary*)context
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
	[reachability startNotifier];
	if (reachability.currentReachabilityStatus == NotReachable) {
        return nil;
	}
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    if (context)
    {
		[request setUserInfo:[NSDictionary dictionaryWithDictionary:context]];
	}
    if (headers)
    {
        for (NSString *key in headers.allKeys)
        {
            [request addRequestHeader:key value:[headers objectForKey:key]];
        }
    }
//    if(params)
//    {
//        for(NSString *key in params.allKeys)
//        {
//            [request setPostValue:[params objectForKey:key] forKey:key];
//        }
//    }
    
    //cookies设置
    NSHTTPCookieStorage *sharedHTTPCookie = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //[request setUseCookiePersistence:YES];
    [request setRequestCookies: [NSMutableArray arrayWithArray:sharedHTTPCookie.cookies]];
    
    [request setTimeOutSeconds:SYSTEM_REQUEST_TIMEOUT];
	[request setCachePolicy:ASIAskServerIfModifiedCachePolicy];
    
    [request setValidatesSecureCertificate:NO];
    return request;
}
- (ASIHTTPRequest*)postAsync:(NSString *)url
           params:(NSMutableDictionary *)params
         fileData:(NSData*)fileData
          fileKey:(NSString*)fileKey
          headers:(NSMutableDictionary *)headers
          context:(NSMutableDictionary *)context
         delegate:(id)myDelegate
{
    self.delegate = myDelegate;
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
	[reachability startNotifier];
	if (reachability.currentReachabilityStatus == NotReachable) {
		[self.delegate networkNotReachable];
        return nil;
	}
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    if (context)
    {
		[request setUserInfo:[NSDictionary dictionaryWithDictionary:context]];
	}
    if (headers)
    {
        for (NSString *key in headers.allKeys)
        {
            [request addRequestHeader:key value:[headers objectForKey:key]];
        }
    }
    if(params)
    {
        for(NSString *key in params.allKeys)
        {
            [request setPostValue:[params objectForKey:key] forKey:key];
        }
    }
    if(fileData) {
        [request setData:fileData forKey:fileKey];
    }
    
    //cookies设置
    NSHTTPCookieStorage *sharedHTTPCookie = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //[request setUseCookiePersistence:YES];
    [request setRequestCookies: [NSMutableArray arrayWithArray:sharedHTTPCookie.cookies]];
    
    [request setTimeOutSeconds:SYSTEM_REQUEST_TIMEOUT];
	[request setCachePolicy:ASIAskServerIfModifiedCachePolicy];
    
    [request setValidatesSecureCertificate:NO];
    [request setDelegate:self.delegate];
	[request startAsynchronous];
    
    [self.delegate addRequstToPool:request];
    return request;
}
- (ASIHTTPRequest*)postAsync:(NSString *)url
           params:(NSMutableDictionary *)params
          headers:(NSMutableDictionary *)headers
          context:(NSMutableDictionary *)context
         delegate:(id)myDelegate
{
    return [self postAsync:url params:params fileData:nil fileKey:nil headers:headers context:context delegate:myDelegate];
}

- (ASIHTTPRequest*)getAsync:(NSString *)url
           params:(NSMutableDictionary *)params
          headers:(NSMutableDictionary *)headers
          context:(NSMutableDictionary *)context
         delegate:(id)myDelegate
{
    self.delegate = myDelegate;
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
	[reachability startNotifier];
	if (reachability.currentReachabilityStatus == NotReachable) {
		[self.delegate networkNotReachable];
        return nil;
	}
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    if (context)
    {
		[request setUserInfo:[NSDictionary dictionaryWithDictionary:context]];
	}
    if (headers)
    {
        for (NSString *key in headers.allKeys)
        {
            [request addRequestHeader:key value:[headers objectForKey:key]];
        }
    }
    if(params)
    {
        for(NSString *key in params.allKeys)
        {
            //[request setPostValue:[params objectForKey:key] forKey:key];
        }
    }
    
    //cookies设置
    NSHTTPCookieStorage *sharedHTTPCookie = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //[request setUseCookiePersistence:YES];
    [request setRequestCookies: [NSMutableArray arrayWithArray:sharedHTTPCookie.cookies]];
    
    [request setTimeOutSeconds:SYSTEM_REQUEST_TIMEOUT];
	[request setCachePolicy:ASIAskServerIfModifiedCachePolicy];
    
    [request setValidatesSecureCertificate:NO];
    [request setDelegate:self.delegate];
	[request startAsynchronous];
    
    [self.delegate addRequstToPool:request];
    return request;
}

@end
