//
//  EnterpriseTaskDetailViewController.h
//  CooperApp
//
//  Created by sunleepy on 13-1-5.
//  Copyright (c) 2013年 codesharp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base2ViewController.h"
#import "CooperService/EnterpriseService.h"
#import "CommentInfoView.h"
#import "TaskContentEditViewController.h"
#import "TaskCommentCreateViewController.h"
#import "DateButton.h"
#import "PriorityOptionView.h"
#import "ImagePreviewViewController.h"
#import "AudioPreviewViewController.h"
#import "FillLabelView.h"
#import "SearchUserViewController.h"
#import "EnterpriseTaskCreateDelegate.h"

@interface EnterpriseTaskDetailViewController : Base2ViewController<UITableViewDelegate, UITableViewDataSource, TaskContentEditDelegate, TaskCommentCreateDelegate, CommentInfoDelegate, DateButtonDelegate, EnterpriseTaskCreateDelegate>
{
    UILabel *textTitleLabel;
    
    UIView *rightView;
    
    UIView *navPanelView;
    UIImageView *arrowImageView;

    UIView *completeView;
    UIView *completeFlagView;
    UILabel *completeFlagLabel;
    
    UIView *dueTimeFlagView;
    UILabel *dueTimeFlagLabel;
    DateButton *dueTimeView;
    
    UIView *priorityFlagView;
    UILabel *priorityFlagLabel;
    PriorityOptionView *priorityOptionView;
    
    EnterpriseService *enterpriseService;

    UIView *centerPanelView;
    UIView *showPanelView;
    
    UIScrollView *scrollView;
    UIView *contentView;
    UIView *commentTitleView;
    
    UILabel *subjectLabel;
    UILabel *bodyLabel;
    
    UIView *commentView;
    
    NSMutableArray *comments;

    int currentIndex;

    UIView *priorityView0;
    UIView *priorityView1;
    UIView *priorityView2;

    UIImageView *imageView0;
    UIImageView *imageView1;
    UIImageView *imageView2;

    UILabel *label0;
    UILabel *label1;
    UILabel *label2;

    FillLabelView *assgineesView;
}

@property (retain, nonatomic) NSString *currentTaskId;
@property (retain, nonatomic) NSMutableDictionary *taskDetailDict;

@end
