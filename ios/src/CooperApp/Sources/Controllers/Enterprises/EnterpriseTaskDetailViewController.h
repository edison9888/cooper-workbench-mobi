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

@interface EnterpriseTaskDetailViewController : Base2ViewController<UITableViewDelegate, UITableViewDataSource, TaskContentEditDelegate, TaskCommentCreateDelegate, CommentInfoDelegate>
{
    UILabel *textTitleLabel;
    
    UIView *rightView;
    
    UIView *navPanelView;
    UIImageView *arrowImageView;
    
    UIView *completeFlagView;
    UILabel *completeFlagLabel;
    
    UIView *dueTimeFlagView;
    UILabel *dueTimeFlagLabel;
    
    UIView *priorityFlagView;
    UILabel *priorityFlagLabel;
    
    EnterpriseService *enterpriseService;
    
    UIView *showPanelView;
    
    UIScrollView *scrollView;
    UIView *contentView;
    UIView *commentTitleView;
    
    UILabel *subjectLabel;
    UILabel *bodyLabel;
    
    UIView *commentView;
    
    NSMutableArray *comments;
}

@property (retain, nonatomic) NSString *currentTaskId;
@property (retain, nonatomic) NSMutableDictionary *taskDetailDict;

@end
