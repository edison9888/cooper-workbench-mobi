//
//  AppDelegate.m
//  Cooper
//
//  Created by sunleepy on 12-6-29.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "AppDelegate.h"
#import "CooperRepository/TaskDao.h"
#import "CodesharpSDK/VersionObject.h"
#import "CooperService/VersionService.h"
#import "GTMHTTPFetcher.h"

@implementation AppDelegate

@synthesize window;
@synthesize mainViewController;
@synthesize managedObjectModel;
@synthesize managedObjectContext;
@synthesize persistantStoreCoordiantor;
@synthesize isJASideClicked;
//@synthesize timer;

#pragma mark - 应用程序生命周期

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //从缓存中加载数据
    [Constant loadFromCache];

    NSString *currentRootPath = [[Constant instance] rootPath];
    NSLog(@"【当前版本服务端根路径】%@ 【当前版本】%@"
          , currentRootPath
          , IS_ENTVERSION ? @"企业版" : @"非企业版");
    
    //HACK:为了能够初始化刷新数据库产生的延迟
    [self managedObjectContext];

    if([[Constant instance] rootPath] == nil
       || [[Constant instance] rootPath] == @"")
    {
        NSString* path = [[[SysConfig instance] keyValue] objectForKey: @"env_path"];
        //如果rootPath不存在数据，将从env_path刷一份数据
        [[Constant instance] setRootPath:path];
        //保存路径
        [Constant savePathToCache];
    }

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    if ([[[Constant instance] loginType] isEqualToString:@"anonymous"]
        || [[[Constant instance] loginType] isEqualToString:@"normal"]
        || [[[Constant instance] loginType] isEqualToString:@"google"])
    {
        EnterpriseOptionViewController *optionViewController = [[EnterpriseOptionViewController alloc] init];
        Base2NavigationController *optionNavController = [[Base2NavigationController alloc] initWithRootViewController:optionViewController];
        
        TodoTasksViewController *taskViewController = [[TodoTasksViewController alloc] init];
        Base2NavigationController *taskNavController = [[Base2NavigationController alloc] initWithRootViewController:taskViewController];
        
        JASidePanelController *panelController = [[JASidePanelController alloc] init];
        panelController.shouldDelegateAutorotateToVisiblePanel = NO;
        panelController.leftPanel = optionNavController;
        panelController.centerPanel = taskNavController;
        
        self.window.rootViewController = panelController;
        
        [taskViewController release];
        [optionViewController release];
        [panelController release];
    }
    else
    {
        self.mainViewController = [[MainViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.mainViewController];
        
        self.window.rootViewController = navController;
        
        [navController release];
    }
    
    [self.window makeKeyAndVisible];
    
    
    //[GTMHTTPFetcher setLoggingEnabled:YES];
    
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];  
//    NSString *name = [infoDictionary objectForKey:@"CFBundleDisplayName"];  
//    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];  
//    NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];  
//    NSString *label = [NSString stringWithFormat:@"%@ v%@ (build %@)", name, version, build];
//    
//    NSLog(@"version:%@", label);
    
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
//    [self.timer fire];
    //NSSetUncaughtExceptionHandler(handleRootException);
    
    //[self localPush];
    
    return YES;
}
     
//static void hadnleRootExcetion(NSException *exception)
//{
//    
//}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"【应用程序进入后台运行】");
    
    [Constant saveToCache];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"【应用程序重新从后台载入】");

    isJASideClicked = NO;

    if(![[[Constant instance] rememberVersion] isEqualToString:@"true"]) {
        //检测版本
        [self checkVersionForUpdate];
    }
    
    //应用徽章数字置零
    application.applicationIconBadgeNumber = 0;
    
    //if([[Constant instance] isLocalPush]) {
    [self localPush];
    //}
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"【应用程序即将终止】");
    
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			NSLog(@"【未处理的异常】%@, %@", error, [error userInfo]);
			abort();
        } 
    }
}

//处理提交同步,本地通知等等
//- (void)handleTimer:(NSTimer*)timer
//{
//    [self localPush];
//}

- (void)dealloc
{
    RELEASE(managedObjectModel);
    RELEASE(managedObjectContext);
    RELEASE(persistantStoreCoordiantor);
    RELEASE(mainViewController);
    RELEASE(window);
    [super dealloc];
}

#pragma mark - 相关操作

//检测版本
- (void)checkVersionForUpdate
{
    //获取当前版本 
    VersionObject *versionObject = [VersionObject getVersionObject:[[NSBundle mainBundle] infoDictionary]];
    
    //[AssertHelper isTrue:[versionObject.version isEqualToString:@"0.1"]: @"版本不对"];
    NSString *version = versionObject.version;
    
    //TODO:请求服务端的当前版本比较version
    NSMutableDictionary *context = [NSMutableDictionary dictionary];
    [context setObject:@"GetCurrentAppVersion" forKey:@"key"];
    [context setObject:version forKey:@"localVersion"];
    [VersionService getCurrentAppVersion:context delegate:self];
}

//本地推送通知
- (void)localPush
{
    NSLog(@"【开始执行本地推送通知】");
    
    //TaskDao *taskDao = [[[TaskDao alloc] init] autorelease];
    //NSMutableArray *tasks = [taskDao getTaskByToday];
    
    NSNumber *todoTasksCount = [[Constant instance] todoTasksCount];
    int taskCount = [todoTasksCount intValue];
    
    NSString *todayString = [Tools ShortNSDateToNSString:[NSDate date]];
    NSDate *today = [Tools NSStringToShortNSDate:todayString];
    NSLog(@"【今天日期】%@", [Tools NSDateToNSString:today]);
    NSLog(@"今天有 %d 个未完成的任务", taskCount);
    
    if(taskCount == 0)
        return;
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    int interval = LOCALPUSH_TIME;
    //TODO:设置早上9点钟进行消息提醒
    interval = (23 * 60 * 60 + 49 * 60 + 0);
    
    NSDate *fireDate = [[NSDate alloc] initWithTimeInterval:interval
                                                  sinceDate:today];
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    if(localNotification == nil)
    {
        NSLog(@"localNotification创建为空");
        return;
    }
    localNotification.fireDate = fireDate;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertBody = [NSString stringWithFormat:@"您有 %d 条未完成任务今天过期，请及时处理", taskCount];
    localNotification.alertAction = @"查看详情";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = taskCount;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    [localNotification release];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"收到了本地推送信息");
}

#pragma mark - Core Data 相关

//返回托管对象上下文，如果不存在，将从持久化存储协调器创建它
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}
//返回托管的对象模型，如果模型不存在，将在application bundle找到所有的模型创建它
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}
//返回应用程序的持久化存储协调器，如果不存在，从应用程序的store创建它
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: STORE_DBNAME]];
    NSLog(@"【sqlite数据库存储路径】%@", [storeUrl relativeString]);
    //HACK:可以保持数据库自动兼容
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption,[NSNumber numberWithBool:YES],NSInferMappingModelAutomaticallyOption, nil];
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
		NSLog(@"【sqlite数据库异常解析】%@, %@", error, [error userInfo]);
		abort();
    }    
    
    return persistentStoreCoordinator;
}
//应用程序的Documents目录路径
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];    
}

#pragma mark - 有关事件动作

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"【请求任务响应数据】%@\n【返回状态码】%d", request.responseString, request.responseStatusCode);
    
    NSString *key = [request.userInfo objectForKey:@"key"];
    NSString *localVersion = [request.userInfo objectForKey:@"localVersion"];
    
    if([key isEqualToString:@"GetCurrentAppVersion"])
    {
        if([request responseStatusCode] == 200) 
        {
            NSString *requestString = request.responseString;
            
            NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"<ios_lastversion[^>]*>(.+?)<\\\\/ios_lastversion>" options:NSRegularExpressionCaseInsensitive error:nil];
            NSTextCheckingResult *match = [regex firstMatchInString:requestString
                                              options:0
                                                range:NSMakeRange(0, [requestString length])];


            if(match) {
                NSRange resultRange = [match rangeAtIndex:1];

                //从urlString当中截取数据
                NSString *result = [requestString substringWithRange:resultRange];
                
                if(![localVersion isEqualToString:result])
                {
                    [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"发现新版本 V%@",result]
                                                message:@""  
                                               delegate:self 
                                      cancelButtonTitle:@"稍后再说" 
                                      otherButtonTitles:@"不再提醒",@"马上更新",nil]
                     show];
                }
            }
            else {
                NSLog(@"版本匹配错误，请检查服务中心配置");
            }
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"【错误异常】%@", request.error);
}

- (void)addRequstToPool:(ASIHTTPRequest *)request
{
    NSLog(@"【发送请求URL】%@", request.url);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
            [[Constant instance] setRememberVersion:@"true"];
            [Constant saveToCache];
            break;
        case 2:
            [[Constant instance] setRememberVersion:@""];
            [Constant saveToCache];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_DOWNLOAD_URL]];
            break;

        default:
            break;
    }
}

@end
