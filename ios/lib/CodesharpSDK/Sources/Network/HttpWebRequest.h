//
//  HttpWebRequest.h
//  CodesharpSDK
//
//  Created by sunleepy on 12-9-8.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "Reachability.h"

@protocol HttpWebRequestDelegate <NSObject>

- (void)networkNotReachable;
- (void)requestFinished:(ASIHTTPRequest *)request;
- (void)requestFailed:(ASIHTTPRequest *)request;
- (void)addRequstToPool:(ASIHTTPRequest *)request;
- (void)queueFinished:(ASINetworkQueue *)queue;
- (void)notProcessReturned:(NSMutableDictionary*)context;

@end

@interface HttpWebRequest : NSObject

@property(nonatomic,assign) id<HttpWebRequestDelegate> delegate;

- (id)init;
- (ASIFormDataRequest*)createPostRequest:(NSString*)url
                                 params:(NSMutableDictionary*)params
                                headers:(NSMutableDictionary*)headers
                                context:(NSMutableDictionary*)context;
- (ASIHTTPRequest*)createGetRequest:(NSString*)url
                             params:(NSMutableDictionary*)params
                            headers:(NSMutableDictionary*)headers
                            context:(NSMutableDictionary*)context;
- (void)postAsync:(NSString *)url
           params:(NSMutableDictionary *)params
         fileData:(NSData*)fileData
          fileKey:(NSString*)fileKey
          headers:(NSMutableDictionary *)headers
          context:(NSMutableDictionary *)context
         delegate:(id)myDelegate;
- (void)postAsync:(NSString*)url
           params:(NSMutableDictionary*)params
          headers:(NSMutableDictionary*)headers
          context:(NSMutableDictionary*)context
         delegate:(id)myDelegate;
- (void)getAsync:(NSString*)url
          params:(NSMutableDictionary*)params
         headers:(NSMutableDictionary*)headers
         context:(NSMutableDictionary*)context
        delegate:(id)myDelegate;

@end
