//
//  SettingViewController.h
//  Cooper
//
//  Created by sunleepy on 12-7-12.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "Base2TableViewController.h"

@interface SettingViewController : Base2TableViewController<UITextFieldDelegate>
{
    UILabel *textTitleLabel;
}
- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil 
             setTitle:(NSString *)title 
             setImage:(NSString*)imageName;

@end
