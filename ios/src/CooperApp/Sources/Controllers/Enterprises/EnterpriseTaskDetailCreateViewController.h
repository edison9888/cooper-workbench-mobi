//
//  EnterpriseTaskDetailCreateViewController.h
//  CooperNative
//
//  Created by sunleepy on 12-12-16.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

//#import "WebViewController.h"
//#import "BaseNavigationController.h"
#import "Base2ViewController.h"
#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "GCPlaceholderTextView.h"
//#import "CommentTextField.h"
//#import "PriorityButton.h"
//#import "DateLabel.h"
#import "DatePickerLabel.h"
//#import "BodyTextView.h"
#import "CooperService/EnterpriseService.h"
//#import "SEFilterControl.h"
#import "PriorityOptionView.h"
#import "EnterpriseTaskCreateDelegate.h"
#import "CustomButton.h"
#import "FillLabelView.h"
#import "SearchUserViewController.h"
//#import "CodesharpSDK/JSCoreTextView.h"

@interface EnterpriseTaskDetailCreateViewController : Base2ViewController<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, DatePickerLabelDelegate, EnterpriseTaskCreateDelegate, ASIProgressDelegate>
{
    GCPlaceholderTextView *subjectTextView;
    PriorityOptionView *priorityOptionView;
    DatePickerLabel *dueTimeLabel;
    CustomButton *assigneeBtn;
    UIImageView *pictureImageView;

    UILabel *textTitleLabel;
    
    EnterpriseService *enterpriseService;
    
    CGPoint viewCenter;
    CGPoint viewCenter2;

    UIImagePickerController *pickerController;

    ASIHTTPRequest *uploadPicRequest;
}

@property (retain, nonatomic) NSMutableDictionary *taskDetailDict;
@property (retain, nonatomic) UIViewController *prevViewController;
@property (assign, nonatomic) int createType;

@end
