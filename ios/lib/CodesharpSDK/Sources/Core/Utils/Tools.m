//
//  Tools.m
//  Cooper
//
//  Created by sunleepy on 12-7-8.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "Tools.h"

@implementation Tools

+ (NSString*) NSNumberToString:(NSNumber*)input
{
    return [NSString stringWithFormat:@"%d", [input boolValue]];
}

+ (NSNumber*) BOOLToNSNumber:(BOOL)input
{
    return [NSNumber numberWithInt:input ? 1 : 0];
    //return [NSNumber numberWithBool:input];
}

+ (NSString*) NSDateToNSString:(NSDate*)input
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //dateFormatter.timeStyle = NSDateFormatterNoStyle;
    //dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString* date = [dateFormatter stringFromDate:input];
    
    [dateFormatter release];
    
    return date;
}

+ (NSString*) ShortNSDateToNSString:(NSDate*)input
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *date = [dateFormatter stringFromDate:input];
    
    [dateFormatter release];
    
    return date;
}

+ (NSDate*) NSStringToNSDate:(NSString*)input
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [dateFormatter dateFromString:input];
    
    [dateFormatter release];
    
    return date;
}

+ (NSDate*) NSStringToShortNSDate:(NSString*)input
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [dateFormatter dateFromString:input];
    
    [dateFormatter release];
    
    return date;
}

+ (NSString*) BOOLToNSString:(BOOL)value
{
    return [NSString stringWithFormat:@"%d", value];
}

+ (NSString*) NSDateToNSFileString:(NSDate*)input
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];

    NSString *date = [dateFormatter stringFromDate:input];

    [dateFormatter release];

    return date;
}

+ (void)alert:(NSString *)title 
{
    [[[[UIAlertView alloc] initWithTitle:title
                                message:nil  
                               delegate:nil 
                      cancelButtonTitle:@"确定" 
                      otherButtonTitles:nil] autorelease] show];
}

+ (void)showHUD:(NSString*)title view:(UIView*)view HUD:(MBProgressHUD*)HUD
{
    if(HUD == nil)
        HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    if (title.length > 0) {
        [HUD show:YES];
        HUD.labelText = title;
    }
}

+ (MBProgressHUD*)process:(NSString*)title view:(UIView*)view
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    if (title.length > 0) {
        HUD.labelText = title;
    }
    return HUD;
}

+ (void)msg:(NSString*)title HUD:(MBProgressHUD*)HUD
{
    [HUD show:YES];
    HUD.labelText = title;
    [HUD hide:YES afterDelay:1];
}

+ (void)close:(MBProgressHUD*)HUD
{
    [HUD hide:YES];
}

+ (void)failed:(MBProgressHUD*)HUD
{
    [HUD show:YES];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    HUD.labelText = @"请求失败";
    HUD.mode = MBProgressHUDModeCustomView;
	[HUD hide:YES afterDelay:1];
}
+ (void)failed:(MBProgressHUD*)HUD msg:(NSString*)msg
{
    [HUD show:YES];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    HUD.labelText = msg;
    HUD.mode = MBProgressHUDModeCustomView;
	[HUD hide:YES afterDelay:1];
}

+ (NSString*) stringWithUUID {
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    NSString    *uuidString = (NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return [uuidString autorelease];
}

+ (BOOL)isPad
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

+ (void)layerTransition:(UIView *)view from:(NSString*)from
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionPush;
    transition.subtype = [from isEqualToString:@"left"] ? kCATransitionFromLeft : kCATransitionFromRight;
    [view.layer addAnimation:transition forKey:kCATransition];
}

+ (void)clearFootBlank:(UITableView *)tableView
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.tableFooterView = footer;
    [footer release];
}

+ (float)screenMaxWidth
{
    return [Tools isPad] ? 768 : 320;
}

+ (float)screenMaxHeight
{
    return [Tools isPad] ? 1024 : 480;
}

@end
