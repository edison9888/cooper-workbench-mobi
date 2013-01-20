//
//  Constant.m
//  Cooper
//
//  Created by sunleepy on 12-7-4.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "Constant.h"

@implementation Constant

@synthesize sortHasChanged;
@synthesize domain;
@synthesize username;
@synthesize password;
@synthesize workId;
@synthesize token;
@synthesize loginType;
@synthesize rootPath;
@synthesize recentlyIds;
@synthesize recentlyTeamIds;
@synthesize isLocalPush;
@synthesize tempCreateTasklistId;
@synthesize tempCreateTasklistName;
@synthesize rememberVersion;
@synthesize todoTasksCount;

+ (id)instance {
	static id obj = nil;
	if(nil == obj) {
		obj = [[self alloc] init];
	}
	return obj;	
}

- (id)init {
	if ((self = [super init])) {
        sortHasChanged = @"";
        domain = @"";
        username = @"";
        password = @"";
        workId = @"";
        token = @"";
        loginType = @"";
        isLocalPush = NO;
        rootPath = @"";
        recentlyIds = nil;
        recentlyTeamIds = nil;
        rememberVersion = @"";
        todoTasksCount = [NSNumber numberWithInt:0];
        return self;
	}
	return nil;
}

+ (void)loadFromCache {
    [[Constant instance] setLoginType:[Cache getCacheByKey:@"loginType"]];
    [[Constant instance] setIsLocalPush:[[Cache getCacheByKey:@"isLocalPush"] intValue]];
    [[Constant instance] setSortHasChanged:[Cache getCacheByKey:@"sortHasChanged"]];
    [[Constant instance] setDomain:[Cache getCacheByKey:@"domain"]];
    [[Constant instance] setUsername:[Cache getCacheByKey:@"username"]];
    [[Constant instance] setWorkId:[Cache getCacheByKey:@"workId"]];
    [[Constant instance] setRootPath:[Cache getCacheByKey:@"rootPath"]];
    [[Constant instance] setRememberVersion:[Cache getCacheByKey:@"rememberVersion"]];
    
    id recentlyIds = [Cache getCacheByKey:@"recentlyIds"];
    if([Cache getCacheByKey:@"recentlyIds"] != nil)
    {
        [[Constant instance] setRecentlyIds:recentlyIds];
    }
    id recentlyTeamIds = [Cache getCacheByKey:@"recentlyTeamIds"];
    if([Cache getCacheByKey:@"recentlyTeamIds"] != nil)
    {
        [[Constant instance] setRecentlyTeamIds:recentlyTeamIds];
    }
    
    if([Cache getCacheByKey:@"todoTasksCount"] == nil) {
        [[Constant instance] setTodoTasksCount:[NSNumber numberWithInt:0]];
    }
    else {
        NSNumber *tasksCount = [Cache getCacheByKey:@"todoTasksCount"];
        [[Constant instance] setTodoTasksCount:tasksCount];
    }
}

+ (void)saveToCache {
    [Cache clean];
    [Cache setCacheObject:[[Constant instance] loginType] ForKey:@"loginType"];
    [Cache setCacheObject:[[Constant instance] sortHasChanged] ForKey:@"sortHasChanged"];
    [Cache setCacheObject:[[Constant instance] domain] ForKey:@"domain"];
    [Cache setCacheObject:[[Constant instance] username] ForKey:@"username"];
    [Cache setCacheObject:[[Constant instance] workId] ForKey:@"workId"];
    [Cache setCacheObject:[[Constant instance] rootPath] ForKey:@"rootPath"];
    [Cache setCacheObject:[[Constant instance] rememberVersion] ForKey:@"rememberVersion"];
    [Cache setCacheObject:[[Constant instance] recentlyIds] ForKey:@"recentlyIds"];
    [Cache setCacheObject:[[Constant instance] recentlyTeamIds] ForKey:@"recentlyTeamIds"];
    [Cache setCacheObject:[NSNumber numberWithFloat:[[Constant instance] isLocalPush]] ForKey:@"isLocalPush"];
    
    [Cache saveToDisk];
}

+ (void)savePathToCache
{
    [Cache setCacheObject:[[Constant instance] rootPath] ForKey:@"rootPath"];
    [Cache saveToDisk];
}

+ (void)saveSortHasChangedToCache
{
    [Cache setCacheObject:[NSNumber numberWithFloat:[[Constant instance] isLocalPush]] ForKey:@"sortHasChanged"];
    [Cache saveToDisk];
}

//+ (void)saveRecentlyIdsToCache
//{
//    [Cache setCacheObject:[[Constant instance] recentlyIds] ForKey:@"recentlyIds"];
//    [Cache saveToDisk];
//}
//
+ (void)saveIsLocalPushToCache
{
    [Cache setCacheObject:[NSNumber numberWithFloat:[[Constant instance] isLocalPush]] ForKey:@"isLocalPush"];
    [Cache saveToDisk];
}

+ (void)saveTodoTasksCountToCache
{
    [Cache setCacheObject:[[Constant instance] todoTasksCount] ForKey:@"todoTasksCount"];
    [Cache saveToDisk];
}

@end
