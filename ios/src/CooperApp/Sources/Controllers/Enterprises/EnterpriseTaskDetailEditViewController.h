//
//  EnterpriseTaskDetailEditViewController.h
//  CooperNative
//
//  Created by sunleepy on 12-12-16.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "WebViewController.h"
#import "Base2NavigationController.h"
#import "Base2ViewController.h"
#import "CommentTextField.h"
#import "PriorityButton.h"
#import "DateLabel.h"
#import "BodyTextView.h"
#import "CooperService/EnterpriseService.h"
#import "CodesharpSDK/JSCoreTextView.h"
#import "ImagePreviewViewController.h"
#import "AudioPreviewViewController.h"

@interface EnterpriseTaskDetailEditViewController : Base2ViewController<UITableViewDelegate, UITableViewDataSource,DateLabelDelegate, PriorityButtonDelegate, UITextViewDelegate, BodyTextViewDelegate>
{
    UITableView *detailView;
    UIView *assigneeView;
    
    CGPoint viewCenter;

    UILabel *textTitleLabel;
    
    EnterpriseService *enterpriseService;
}

@property (retain, nonatomic) NSString *currentTaskId;
@property (retain, nonatomic) NSMutableDictionary *taskDetailDict;

@property (retain, nonatomic) DateLabel *dueDateLabel;
@property (retain, nonatomic) PriorityButton *priorityButton;
@property (retain, nonatomic) CustomButton *statusButton;
@property (retain, nonatomic) UITextField *subjectTextField;
@property (retain, nonatomic) BodyTextView *bodyTextView;
@property (retain, nonatomic) UIScrollView *bodyScrollView;
@property (retain, nonatomic) UITableViewCell *bodyCell;

@end
