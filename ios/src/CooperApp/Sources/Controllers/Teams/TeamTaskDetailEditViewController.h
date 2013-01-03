//
//  TeamTaskDetailEditViewController.h
//  CooperNative
//
//  Created by sunleepy on 12-9-21.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "WebViewController.h"
#import "BaseNavigationController.h"
#import "TeamTaskOptionViewController.h"
#import "TeamTaskDetailEditViewController.h"
#import "TeamTaskViewDelegate.h"
#import "TeamTaskDetailEditViewDelegate.h"
#import "CommentTextField.h"
#import "PriorityButton.h"
#import "DateLabel.h"
#import "BodyTextView.h"
#import "CodesharpSDK/JSCoreTextView.h"
#import "CooperRepository/TaskDao.h"
#import "CooperRepository/TaskIdxDao.h"
#import "CooperRepository/ChangeLogDao.h"
#import "CooperRepository/TeamMemberDao.h"
#import "CooperRepository/ProjectDao.h"
#import "CooperRepository/TagDao.h"
#import "CooperRepository/CommentDao.h"

@interface TeamTaskDetailEditViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, CommentTextFieldDelegate, TeamTaskViewDelegate, DateLabelDelegate, PriorityButtonDelegate, TeamTaskDetailEditViewDelegate>
{
    UITableView *detailView;
    UIView *assigneeView;
    UIView *projectView;
    UIView *tagView;
    
    NSString *oldPriority;
    NSString *currentPriority;
    NSNumber *currentStatus;
    NSDate *currentDueDate;
    NSString *currentAssigneeId;
    NSString *currentProjects;
    NSString *currentTags;
    
    TaskDao *taskDao;
    TaskIdxDao *taskIdxDao;
    ChangeLogDao *changeLogDao;
    TeamMemberDao *teamMemberDao;
    ProjectDao *projectDao;
    TagDao *tagDao;
    CommentDao *commentDao;
    
    CGPoint viewCenter;
}

@property(nonatomic,assign) id<TeamTaskViewDelegate> delegate;
@property (retain, nonatomic) Task *task;
@property (retain, nonatomic) NSMutableArray *taskCommentArray;
@property (retain, nonatomic) DateLabel *dueDateLabel;
@property (retain, nonatomic) PriorityButton *priorityButton;
@property (retain, nonatomic) CustomButton *statusButton;
@property (retain, nonatomic) NSString *currentTeamId;
@property (retain, nonatomic) NSString *currentProjectId;
@property (retain, nonatomic) NSString *currentMemberId;
@property (retain, nonatomic) NSString *currentTag;
@property (retain, nonatomic) UITextField *subjectTextField;
@property (retain, nonatomic) BodyTextView *bodyTextView;
@property (retain, nonatomic) UIScrollView *bodyScrollView;
@property (retain, nonatomic) UITableViewCell *bodyCell;

@property (retain, nonatomic) TeamTaskOptionViewController *teamTaskOptionViewController;

@end
