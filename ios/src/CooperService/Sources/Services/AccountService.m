//
//  AccountService.m
//  Cooper
//
//  Created by sunleepy on 12-7-9.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "AccountService.h"

@implementation AccountService

- (void)login:(NSString*)username
     password:(NSString*)password 
      context:(NSMutableDictionary *)context 
     delegate:(id)delegate
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:username forKey:@"userName"];
    [params setObject:password forKey:@"password"];
    
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    [headers setObject:@"xmlhttp" forKey:@"X-Requested-With"];
    
    NSString* url = [[[Constant instance] rootPath] stringByAppendingFormat:LOGIN_URL];
    NSLog(@"【Login登录请求】%@", url);
    
    HttpWebRequest *request = [[HttpWebRequest alloc] init];
    [request postAsync:url params:params headers:headers context:context delegate:delegate];
    [request release];
}

- (void)workbenchLogin:(NSString *)domain
              username:(NSString *)username
              password:(NSString *)password
               context:(NSMutableDictionary*)context
              delegate:(id)delegate
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:domain forKey:@"domain"];
    [params setObject:username forKey:@"userName"];
    [params setObject:password forKey:@"password"];
    
    NSString* url = [[[Constant instance] rootPath] stringByAppendingFormat:WORKBENCHLOGIN_URL];
    NSLog(@"【WorkbenchLogin登录请求】%@", url);
    
    HttpWebRequest *request = [[HttpWebRequest alloc] init];
    [request postAsync:url params:params headers:nil context:context delegate:delegate];
    [request release];
}

- (void) login:(NSString *)domain
      username:(NSString *)username 
      password:(NSString *)password 
       context:(NSMutableDictionary *)context 
      delegate:(id)delegate
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"login" forKey:@"state"];
    [params setObject:domain forKey:@"cbDomain"];
    [params setObject:username forKey:@"tbLoginName"];
    [params setObject:password forKey:@"tbPassword"];
    
    NSString* url = [[[Constant instance] rootPath] stringByAppendingFormat:ARKLOGIN_URL];
    NSLog(@"【ArkLogin登录请求】 %@", url);
    
    HttpWebRequest *request = [[HttpWebRequest alloc] init];
    [request postAsync:url params:params headers:nil context:context delegate:delegate];
    [request release];
}

- (void)googleLogin:(NSString*)refreshToken
            context:(NSMutableDictionary*)context
           delegate:(id)delegate
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:refreshToken forKey:@"refreshToken"];
    
    NSString* url = [[[Constant instance] rootPath] stringByAppendingFormat:@"/Account/GoogleLoginByRefreshToken"];
    NSLog(@"【GoogleLogin登录请求】%@", url);
    
    HttpWebRequest *request = [[HttpWebRequest alloc] init];
    [request postAsync:url params:params headers:nil context:context delegate:delegate];
    [request release];
}

- (void)googleLogin:(NSString *)error
               code:(NSString*)code 
              state:(NSString*)state 
               mobi:(NSString*)mobi 
               joke:(NSString*)joke
            context:(NSMutableDictionary *)context 
           delegate:(id)delegate
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:error forKey:@"error"];
    [params setObject:code forKey:@"code"];
    [params setObject:state forKey:@"state"];
    [params setObject:mobi forKey:@"mobi"];
    [params setObject:joke forKey:@"joke"];
    
    NSString* url = [[[Constant instance] rootPath] stringByAppendingFormat:GOOGLE_LOGIN_URL];
    NSLog(@"【GoogleLogin登录请求】%@", url);
    
    HttpWebRequest *request = [[HttpWebRequest alloc] init];
    [request postAsync:url params:params headers:nil context:context delegate:delegate];
    [request release];
}

- (void)logout:(NSMutableDictionary*)context
      delegate:(id)delegate
{
    NSString* url = [[[Constant instance] rootPath] stringByAppendingFormat:LOGOUT_URL];
    NSLog(@"【注销请求】%@",url);
    
    HttpWebRequest *request = [[HttpWebRequest alloc] init];
    [request postAsync:url params:nil headers:nil context:context delegate:delegate];
    [request release];
}

@end
