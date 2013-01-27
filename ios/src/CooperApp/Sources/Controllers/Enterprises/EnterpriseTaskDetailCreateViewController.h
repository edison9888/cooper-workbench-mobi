//
//  EnterpriseTaskDetailCreateViewController.h
//  CooperNative
//
//  Created by sunleepy on 12-12-16.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "Base2ViewController.h"
#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "GCPlaceholderTextView.h"
#import "DatePickerLabel.h"
#import "CooperService/EnterpriseService.h"
#import "PriorityOptionView.h"
#import "EnterpriseTaskCreateDelegate.h"
#import "CustomButton.h"
#import "FillLabelView.h"
#import "SearchUserViewController.h"
#import "KOAProgressBar.h"
#import "AudioViewController.h"

@interface EnterpriseTaskDetailCreateViewController : Base2ViewController<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, DatePickerLabelDelegate, EnterpriseTaskCreateDelegate, ASIProgressDelegate, AudioViewDelegate>
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
    
    KOAProgressBar *processBar;
    
    NSThread *processThread;
    
    UIButton *attachmentBtn;
    UIView *attachmentView;
    UILabel *attachmentProcessLabel;
    dispatch_queue_t processAudioQueue;
    ASIHTTPRequest *uploadAudioRequest;
    
    BOOL processing;
}

@property (retain, nonatomic) NSMutableDictionary *taskDetailDict;
@property (retain, nonatomic) UIViewController *prevViewController;
@property (assign, nonatomic) int createType;
@property (retain, nonatomic) UIImage *pictureImage;

@end
