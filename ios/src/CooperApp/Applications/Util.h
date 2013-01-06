//
//  Util.h
//  Cooper-ali
//
//  Created by sunleepy on 12-8-1.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#ifndef Cooper_Util_h
#define Cooper_Util_h

#import <Availability.h>

#ifndef __IPHONE_4_0
#warning "This project uses features only available in iOS SDK 4.0 and later."
#endif

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#endif

#import "NSObject+SBJSON.h"
#import "NSString+SBJSON.h"

#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"

#import "UIImageView+WebCache.h"

#ifdef DEBUG
#   define NSLog(fmt, ...) NSLog((@"\n%s [Line %d] " fmt @"\n------------------------------------------"), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define NSLog(...)
#endif

#import "CodesharpSDK/Tools.h"
#import "CodesharpSDK/MBProgressHUD.h"
#import "CodesharpSDK/NetworkManager.h"
#import "CodesharpSDK/HttpWebRequest.h"
#import "CodesharpSDK/AssertHelper.h"
#import "CooperCore/SysConfig.h"
#import "CodesharpSDK/ASIHTTPRequest.h"

#define RELEASE(_ptr_) if((_ptr_) != nil) {[_ptr_ release]; _ptr_ = nil;}  

//模拟器/设备名称
#define MODEL_NAME                      [[UIDevice currentDevice] model]
#define MODEL_VERSION                   [[[UIDevice currentDevice] systemVersion] floatValue]

//app下载地址
#define APP_DOWNLOAD_URL                @"http://xyj.im"

//获取任务列表路径
#define GETTASKLISTS_URL                @"/Personal/GetTaskFolders"
//同步任务列表路径
#define CREATETASKLIST_URL              @"/Personal/CreateTaskFolder"
//优先级获取路径
#define TASK_GETBYPRIORITY_URL          @"/Personal/GetByPriority"
//同步路径
#define TASK_SYNC_URL                   @"/Personal/Sync"
//注销路径
#define LOGOUT_URL                      @"/Account/Logout"

//标题栏
#define APP_TITLE                       @"cooper:task"
//背景图片（条纹）
#define APP_BACKGROUNDIMAGE             @"bg-line.png"
//背景主色调
#define APP_BACKGROUNDCOLOR             [UIColor colorWithRed:47.0/255 green:157.0/255 blue:216.0/255 alpha:1]
//背景主色调2
#define APP_BACKGROUNDCOLOR_2           [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1]
//标题文字色调
#define APP_TITLECOLOR                  [UIColor colorWithRed:47.0/255 green:157.0/255 blue:216.0/255 alpha:1]
//导航背景图片
#define NAVIGATIONBAR_BG_IMAGE          @"navigationbar_bg.png"
//底部栏背景图片
#define TABBAR_BG_IMAGE                 @"tabbar_bg.png"
//编辑按钮图片
#define EDIT_IMAGE                      @"edit.png"
//同步按钮图片
#define REFRESH_IMAGE                   @"refresh.png"
//设置按钮图片
#define SETTING_IMAGE                   @"setting.png"
//后退按钮图片
#define BACK_IMAGE                      @"back.png"
//列表图片
#define LIST_IMAGE                      @"list.png"

#define PRIORITY_TITLE_1                @"尽快完成"
#define PRIORITY_TITLE_2                @"稍后完成"
#define PRIORITY_TITLE_3                @"迟些再说"
//加载文本
#define LOADING_TITLE                   @"加载中"

//TODO:半个小时定时器更新一次
#define TIMER_INTERVAL                  0.5 * 60 * 60
//TODO:默认每天早上8点钟推送通知
#define LOCALPUSH_TIME                  8 * 60 * 60

//本地数据库名称
#define STORE_DBNAME                    @"TaskModel.sqlite"

//当前网络提示
#define NOT_NETWORK_MESSAGE             @"当前网络不可用"

#define REQUEST_TYPE                    @"RequestType"


#define MAXLENGTH                       8
//#define AES_KEY                         @""

#define IS_ENTVERSION                   [[[[SysConfig instance] keyValue] objectForKey:@"isENTVersion"] isEqualToString:@"1"]

#endif
