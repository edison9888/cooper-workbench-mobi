//
//  Tools.h
//  Cooper
//
//  Created by sunleepy on 12-7-8.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "MBProgressHUD.h"

@interface Tools : NSObject

+ (NSString*) NSNumberToString:(NSNumber*)input;

+ (NSNumber*) BOOLToNSNumber:(BOOL)input;

+ (NSString*) NSDateToNSString:(NSDate*)input;

+ (NSString*) ShortNSDateToNSString:(NSDate*)input;

+ (NSDate*) NSStringToNSDate:(NSString*)input;

+ (NSString*) NSDateToNSFileString:(NSDate*)input;

+ (NSDate*) NSStringToShortNSDate:(NSString*)input;

+ (NSString*) BOOLToNSString:(BOOL)value;

+ (void)alert:(NSString *)title;

+ (void)showHUD:(NSString*)title view:(UIView*)view HUD:(MBProgressHUD*)HUD;

+ (MBProgressHUD*)process:(NSString*)title view:(UIView*)view;

+ (void)msg:(NSString*)title HUD:(MBProgressHUD*)HUD;

+ (void)close:(MBProgressHUD*)HUD;

+ (void)failed:(MBProgressHUD*)HUD;

+ (void)failed:(MBProgressHUD*)HUD msg:(NSString*)msg;

+ (NSString*)stringWithUUID;

+ (BOOL)isPad;

+ (void)layerTransition:(UIView*)view from:(NSString*)from;

+ (void)clearFootBlank:(UITableView*)tableView;

+ (float)screenMaxWidth;

+ (float)screenMaxHeight;

@end
