//
//  EnterpriseTaskDetailViewController.m
//  CooperApp
//
//  Created by sunleepy on 13-1-5.
//  Copyright (c) 2013年 codesharp. All rights reserved.
//

#import "EnterpriseTaskDetailViewController.h"
#import "AppDelegate.h"

@implementation EnterpriseTaskDetailViewController

@synthesize currentTaskId;
@synthesize taskDetailDict;
@synthesize editable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(appDelegate.isJASideClicked == NO && MODEL_VERSION >= 6.0) {
        CGRect frame = self.view.bounds;
        frame.origin.y -= 19.9f;
        self.view.bounds = frame;
    }
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detailcreate_bg.png"]];

    currentIndex = -1;
    
    UITapGestureRecognizer *recognizer = nil;
    
    enterpriseService = [[EnterpriseService alloc] init];
	
    textTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    textTitleLabel.backgroundColor = [UIColor clearColor];
    textTitleLabel.textAlignment = UITextAlignmentCenter;
    textTitleLabel.textColor = APP_TITLECOLOR;
    textTitleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    self.navigationItem.titleView = textTitleLabel;
    textTitleLabel.text = @"任务详情";
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 38, 45)];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.userInteractionEnabled = NO;
    [backBtn setFrame:CGRectMake(9, 17, 15, 10)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back2.png"] forState:UIControlStateNormal];
    [backView addSubview:backBtn];
    backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *backRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack:)];
    [backView addGestureRecognizer:backRecognizer];
    [backRecognizer release];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    [backButtonItem release];
    [backView release];
    
    rightView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 55, 44)] autorelease];
    UIView *splitView = [[UIView alloc] initWithFrame:CGRectMake(5, 9, 1, 26)];
    splitView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"split.png"]];
    [rightView addSubview:splitView];
    UIButton *saveTaskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveTaskBtn setTitleColor:APP_TITLECOLOR forState:UIControlStateNormal];
    saveTaskBtn.frame = CGRectMake(6, 8, 54, 30);
    [saveTaskBtn addTarget:self action:@selector(addComment:) forControlEvents:UIControlEventTouchUpInside];
    saveTaskBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    [saveTaskBtn setTitle:@"评论" forState:UIControlStateNormal];
    [rightView addSubview:saveTaskBtn];
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    [saveButtonItem release];
    [splitView release];
    
    //选择属性面板
    navPanelView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 59)] autorelease];
    navPanelView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_navPanel.png"]];
    
    //完成面板
    completeView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width / 4, 39)] autorelease];
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCompletePanel:)];
    [completeView addGestureRecognizer:recognizer];
    [recognizer release];
    
    completeFlagView = [[[UIView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width / 4 - 22) / 2, 8, 22, 22)] autorelease];
    completeFlagView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_notsetcomplete.png"]];
    
    [completeView addSubview:completeFlagView];
    
    completeFlagLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 36, self.view.bounds.size.width / 4, 12)] autorelease];
    completeFlagLabel.text = @"完成状态";
    completeFlagLabel.backgroundColor = [UIColor clearColor];
    completeFlagLabel.textColor = [UIColor colorWithRed:98.0/255 green:85.0/255 blue:79.0/255 alpha:1];
    completeFlagLabel.font = [UIFont systemFontOfSize:12.0f];
    completeFlagLabel.textAlignment = UITextAlignmentCenter;
    
    [completeView addSubview:completeFlagLabel];
    
    [navPanelView addSubview:completeView];

//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.3];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//
//    [UIView commitAnimations];

    //完成时间面板
    dueTimeView = [[DateButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 4 , 0, self.view.bounds.size.width / 4, 39)];
    dueTimeView.delegate = self;
    if(editable == NO) {
        dueTimeView.userInteractionEnabled = NO;
    }
    else {
        dueTimeView.userInteractionEnabled = YES;
    }
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDueTimePanel:)];
    [dueTimeView addGestureRecognizer:recognizer];
    [recognizer release];

    dueTimeFlagView = [[[UIView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width / 4 - 23) / 2, 8, 23, 23)] autorelease];
    dueTimeFlagView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_dueTime.png"]];
    
    [dueTimeView addSubview:dueTimeFlagView];
    
    dueTimeFlagLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 36, self.view.bounds.size.width / 4, 12)] autorelease];
    dueTimeFlagLabel.text = @"完成日期";
    dueTimeFlagLabel.backgroundColor = [UIColor clearColor];
    dueTimeFlagLabel.textColor = [UIColor colorWithRed:98.0/255 green:85.0/255 blue:79.0/255 alpha:1];
    dueTimeFlagLabel.font = [UIFont systemFontOfSize:12.0f];
    dueTimeFlagLabel.textAlignment = UITextAlignmentCenter;
    
    [dueTimeView addSubview:dueTimeFlagLabel];
    
    [navPanelView addSubview:dueTimeView];
    
    //优先级面板
    UIView *priorityView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 2, 0, self.view.bounds.size.width / 4, 39)];
    if(editable == NO) {
        priorityView.userInteractionEnabled = NO;
    }
    else {
        priorityView.userInteractionEnabled = YES;
    }
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPriorityPanel:)];
    [priorityView addGestureRecognizer:recognizer];
    [recognizer release];
    
    priorityFlagView = [[[UIView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width / 4 - 23) / 2, 8, 23, 23)] autorelease];
    priorityFlagView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_priority0Flag2.png"]];
    
    [priorityView addSubview:priorityFlagView];
    
    priorityFlagLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 36, self.view.bounds.size.width / 4, 12)] autorelease];
    priorityFlagLabel.text = @"优先级";
    priorityFlagLabel.backgroundColor = [UIColor clearColor];
    priorityFlagLabel.textColor = [UIColor colorWithRed:98.0/255 green:85.0/255 blue:79.0/255 alpha:1];
    priorityFlagLabel.font = [UIFont systemFontOfSize:12.0f];
    priorityFlagLabel.textAlignment = UITextAlignmentCenter;
    
    [priorityView addSubview:priorityFlagLabel];
    
    [navPanelView addSubview:priorityView];
    [priorityView release];
    
    //人员面板
    UIView *userView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 4 * 3, 0, self.view.bounds.size.width / 4, 39)];
    userView.userInteractionEnabled = YES;
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserPanel:)];
    [userView addGestureRecognizer:recognizer];
    [recognizer release];
    
    UIView *userFlagView = [[[UIView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width / 4 - 26) / 2, 8, 26, 23)] autorelease];
    userFlagView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_userFlag.png"]];
    
    [userView addSubview:userFlagView];
    
    UILabel *userFlagLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 36, self.view.bounds.size.width / 4, 12)] autorelease];
    userFlagLabel.text = @"相关人员";
    userFlagLabel.backgroundColor = [UIColor clearColor];
    userFlagLabel.textColor = [UIColor colorWithRed:98.0/255 green:85.0/255 blue:79.0/255 alpha:1];
    userFlagLabel.font = [UIFont systemFontOfSize:12.0f];
    userFlagLabel.textAlignment = UITextAlignmentCenter;
    
    [userView addSubview:userFlagLabel];
    
    [navPanelView addSubview:userView];
    [userView release];
    
    [self.view addSubview:navPanelView];
    
    //添加滚动
    scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 58, self.view.bounds.size.width, self.view.bounds.size.height - 58)] autorelease];
    //scrollView.backgroundColor = [UIColor redColor];
    //scrollView.contentSize = CGSizeMake(320, 50);
    [self.view addSubview:scrollView];
    
    taskDetailDict = [[NSMutableDictionary alloc] init];
    
    [self getTaskDetail];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.currentRequest clearDelegatesAndCancel];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.currentRequest clearDelegatesAndCancel];
}

- (void)dealloc
{
    [comments release];
    [showPanelView release];
    [centerPanelView release];
    [arrowImageView release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - TaskContentEditDelegate接口

- (void)setSubject:(NSString *)subject
{
    [taskDetailDict setObject:subject forKey:@"subject"];
    
    [self bindData];
}

#pragma mark - TaskCommentCreateDelegate接口
- (void)reloadView
{
    [self getTaskDetail];
}

#pragma mark - CommentInfoDelegate接口
- (void)replyComment:(NSMutableDictionary *)comment
{
    TaskCommentCreateViewController *viewController = [[[TaskCommentCreateViewController alloc] init] autorelease];
    viewController.type = 1;
    viewController.commentDict = comment;
    viewController.currentTaskId = currentTaskId;
    viewController.taskDetailDict = taskDetailDict;
    viewController.delegate = self;
    [Tools layerTransition:self.navigationController.view from:@"right"];
    [self.navigationController pushViewController:viewController animated:NO];
}

#pragma mark - DateButtonDelegate接口
- (void)returnValue:(NSDate *)value
{
    NSString *dueTime = [Tools ShortNSDateToNSString:value];

    currentIndex = -1;
    self.HUD = [Tools process:@"正在提交" view:self.view];

    NSMutableDictionary *context = [NSMutableDictionary dictionary];
    [context setObject:dueTime forKey:@"dueTime"];
    [context setObject:@"ChangeTaskDueTime" forKey:REQUEST_TYPE];
    [enterpriseService changeTaskDueTime:currentTaskId
                                 dueTime:dueTime
                                 context:context
                                delegate:self];
}

#pragma mark - EditFillLabelViewDelegate接口
- (void)deleteTag:(NSString *)tag
{
    NSLog(@"deleteTag");
    
    NSMutableArray *relatedUserArray = [taskDetailDict objectForKey:@"relatedUserArray"];
    NSInteger index = 0;
    for (NSMutableDictionary *dict in relatedUserArray) {
        NSString *displayTag = [NSString stringWithFormat:@"%@  ×", [dict objectForKey:@"displayName"]];
        if ([tag isEqualToString:displayTag]) {
            [relatedUserArray removeObjectAtIndex:index];
            break;
        }
        index++;
    }
    
    [taskDetailDict setObject:relatedUserArray forKey:@"relatedUserArray"];
    
    NSString *subject = [taskDetailDict objectForKey:@"subject"];
    NSString *body = [taskDetailDict objectForKey:@"body"];
    NSString *dueTime = [taskDetailDict objectForKey:@"dueTime"];
    NSNumber *priority = [taskDetailDict objectForKey:@"priority"];
    NSNumber *isCompleted = [taskDetailDict objectForKey:@"isCompleted"];
    NSString *assigneeWorkId = [taskDetailDict objectForKey:@"assigneeWorkId"];
    
    NSString *attachmentsStr = @"";
    NSMutableArray *attachments = [taskDetailDict objectForKey:@"attachments"];
    NSMutableArray *pictures = [taskDetailDict objectForKey:@"pictures"];
    NSMutableArray *attachmentIds = [NSMutableArray array];
    for (NSMutableDictionary *dict in attachments) {
        [attachmentIds addObject:[dict objectForKey:@"attachmentId"]];
    }
    for (NSMutableDictionary *dict in pictures) {
        [attachmentIds addObject:[dict objectForKey:@"attachmentId"]];
    }
    attachmentsStr = [attachmentIds componentsJoinedByString:@"||"];
    
    NSMutableArray *workIdsArray = [NSMutableArray array];
    for (NSMutableDictionary *userDict in relatedUserArray) {
        [workIdsArray addObject:[userDict objectForKey:@"workId"]];
    }
    NSString *relatedUserWorkIds = [workIdsArray componentsJoinedByString:@"||"];
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    [self.HUD show:YES];
    self.HUD.labelText = @"正在提交";
    NSMutableDictionary *context = [NSMutableDictionary dictionary];
    [context setObject:@"UpdateTaskRelated" forKey:REQUEST_TYPE];
    //[context setObject:assigneeWorkId forKey:@"assigneeWorkId"];
    //[context setObject:name forKey:@"assigneeName"];
    [enterpriseService updateTask:currentTaskId
                          subject:subject
                             body:body
                          dueTime:dueTime
                   assigneeWorkId:assigneeWorkId
               relatedUserWorkIds:relatedUserWorkIds
                         priority:priority
                      isCompleted:isCompleted
                    attachmentIds:attachmentsStr
                          context:context
                         delegate:self];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return photos.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < photos.count)
        return [photos objectAtIndex:index];
    return nil;
}

#pragma mark - ASIHTTPRequest

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"【请求任务响应数据】%@\n【返回状态码】%d", request.responseString, request.responseStatusCode);
    
    NSDictionary *userInfo = request.userInfo;
    NSString *requestType = [userInfo objectForKey:REQUEST_TYPE];
    
    if([requestType isEqualToString:@"TaskDetail"])
    {
        if(request.responseStatusCode == 200)
        {
            [Tools close:self.HUD];
            
            NSDictionary *dict = [[request responseString] JSONValue];
            if(dict)
            {
                NSNumber *state = [dict objectForKey:@"state"];
                
                if(state == [NSNumber numberWithInt:0]) {
                    
                    NSMutableDictionary *data = [dict objectForKey:@"data"];
                    
                    NSString *taskId = [data objectForKey:@"id"];
                    NSString *subject = [data objectForKey:@"subject"];
                    NSString *body = [data objectForKey:@"body"];
                    //                    NSMutableDictionary *creatorDict = [data objectForKey:@"creator"];
                    NSMutableDictionary *assigneeDict = [data objectForKey:@"assignee"];
                    NSString *assigneeName = [assigneeDict objectForKey:@"displayName"];
                    NSString *assigneeWorkId = [assigneeDict objectForKey:@"workId"];
                    
                    NSMutableArray *related = [data objectForKey:@"related"];
                    NSMutableArray *relatedUserArray = [NSMutableArray array];
                    for (NSMutableDictionary *relatedDict in related) {
                        NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
                        [userDict setObject:[relatedDict objectForKey:@"workId"] forKey:@"workId"];
                        [userDict setObject:[relatedDict objectForKey:@"displayName"] forKey:@"displayName"];
                        [relatedUserArray addObject:userDict];
                    }
                    
                    NSString *dueTime = [data objectForKey:@"dueTime"] == [NSNull null] ? @"" : [data objectForKey:@"dueTime"];
                    NSNumber *priority = [data objectForKey:@"priority"] == [NSNull null] ? [NSNumber numberWithInt:99] : [data objectForKey:@"priority"];
                    NSNumber *isCompleted = [data objectForKey:@"isCompleted"];
                    NSNumber *isExternal = [data objectForKey:@"isExternal"];
                    NSString *weiboId = [data objectForKey:@"weiboId"];
                    
                    NSNumber *attachmentCount = [data objectForKey:@"attachmentCount"];
                    NSNumber *picCount = [data objectForKey:@"picCount"];
                    
                    NSMutableArray *attachments = [[data objectForKey:@"attachments"] copy];
                    NSMutableArray *pictures = [[data objectForKey:@"pictures"] copy];
                    
                    NSMutableArray *feedbacks = [[data objectForKey:@"feedbacks"] copy];
                    for (NSMutableDictionary *feedbackDict in feedbacks) {
                        //NSString *type = [feedbackDict objectForKey:@"type"];
                        //if([type isEqualToString:@"CommentFeedback"]) {
                            [comments addObject:feedbackDict];
                        //}
                    }
                    
                    [taskDetailDict setObject:taskId forKey:@"taskId"];
                    [taskDetailDict setObject:subject forKey:@"subject"];
                    [taskDetailDict setObject:body forKey:@"body"];
                    [taskDetailDict setObject:dueTime forKey:@"dueTime"];
                    [taskDetailDict setObject:priority forKey:@"priority"];
                    [taskDetailDict setObject:isCompleted forKey:@"isCompleted"];
                    [taskDetailDict setObject:assigneeName forKey:@"assigneeName"];
                    [taskDetailDict setObject:assigneeWorkId forKey:@"assigneeWorkId"];
                    [taskDetailDict setObject:relatedUserArray forKey:@"relatedUserArray"];
                    [taskDetailDict setObject:attachments forKey:@"attachments"];
                    [taskDetailDict setObject:pictures forKey:@"pictures"];
                    [taskDetailDict setObject:comments forKey:@"comments"];
                    [taskDetailDict setObject:isExternal forKey:@"isExternal"];
                    [taskDetailDict setObject:attachmentCount forKey:@"attachmentCount"];
                    [taskDetailDict setObject:picCount forKey:@"picCount"];
                    [taskDetailDict setObject:weiboId forKey:@"weiboId"];
                    
                    [self bindData];
                }
                else {
                    NSString *errorMsg = [dict objectForKey:@"errorMsg"];
                    [Tools failed:self.HUD msg:errorMsg];
                }
            }
        }
        else
        {
            [Tools failed:self.HUD];
        }
    }
    else if([requestType isEqualToString:@"ChangeTaskCompleted"]) {
        NSNumber *isCompleted = [userInfo objectForKey:@"isCompleted"];
        if(request.responseStatusCode == 200) {
            [Tools close:self.HUD];

            [taskDetailDict setObject:isCompleted forKey:@"isCompleted"];
            
            if([isCompleted isEqualToNumber:[NSNumber numberWithInt:0]]) {
                completeFlagView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_incomplete_sel.png"]];
                completeFlagLabel.text = @"未完成";
                [incompleteButton setBackgroundImage:[UIImage imageNamed:@"detail_incomplete.png"] forState:UIControlStateNormal];
                [completeButton setBackgroundImage:[UIImage imageNamed:@"detail_notsetcomplete.png"] forState:UIControlStateNormal];
            }
            else {
                completeFlagView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_complete_sel.png"]];
                completeFlagLabel.text = @"已完成";
                [incompleteButton setBackgroundImage:[UIImage imageNamed:@"detail_notsetcomplete.png"] forState:UIControlStateNormal];
                [completeButton setBackgroundImage:[UIImage imageNamed:@"detail_complete.png"] forState:UIControlStateNormal];
            }

            if([self.view.subviews containsObject:showPanelView]) {
                [centerPanelView removeFromSuperview];
                [showPanelView removeFromSuperview];
                [arrowImageView removeFromSuperview];
                navPanelView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_navPanel.png"]];
                [self adjuctScrollView:-adjuctScrollHeight];
            }
        }
        else
        {
            [Tools failed:self.HUD];
        }
    }
    else if([requestType isEqualToString:@"ChangeTaskDueTime"]) {
        NSString *dueTime = [userInfo objectForKey:@"dueTime"];
        if(request.responseStatusCode == 200) {
            [Tools close:self.HUD];
            
            [taskDetailDict setObject:dueTime forKey:@"dueTime"];
            dueTimeFlagLabel.text = dueTime;
        }
        else
        {
            [Tools failed:self.HUD];
        }
    }
    else if([requestType isEqualToString:@"ChangeTaskPriority"]) {
        NSNumber *priority = [userInfo objectForKey:@"priority"];
        if(request.responseStatusCode == 200) {
            [Tools close:self.HUD];

            [taskDetailDict setObject:priority forKey:@"priority"];
            
            //绑定优先级
            priorityFlagLabel.text = [self getPriorityValue:priority];
            if([priority isEqualToNumber:[NSNumber numberWithInt:99]]) {
                priorityFlagView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_priority0Flag2.png"]];
            }
            else {
                priorityFlagView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"detail_priority%@Flag2.png", [priority stringValue]]]];
            }

            if([self.view.subviews containsObject:showPanelView]) {
                [centerPanelView removeFromSuperview];
                [showPanelView removeFromSuperview];
                [arrowImageView removeFromSuperview];
                navPanelView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_navPanel.png"]];
                [self adjuctScrollView:-adjuctScrollHeight];
            }
        }
        else
        {
            [Tools failed:self.HUD];
        }
    }
    else if([requestType isEqualToString:@"UpdateTask"]) {
        NSString *assigneeWorkId = [userInfo objectForKey:@"assigneeWorkId"];
        NSString *assigneeName = [userInfo objectForKey:@"assigneeName"];
        if(request.responseStatusCode == 200) {
            [Tools close:self.HUD];

            [taskDetailDict setObject:assigneeWorkId forKey:@"assigneeWorkId"];
            [taskDetailDict setObject:assigneeName forKey:@"assigneeName"];
        }
        else
        {
            [Tools failed:self.HUD];
        }
    }
    else if([requestType isEqualToString:@"UpdateTaskRelated"]) {
        if(request.responseStatusCode == 200) {
            [Tools close:self.HUD];
            currentIndex = -1;;
            [self showUserPanel:nil];
            //[self bindData];
        }
        else
        {
            [Tools failed:self.HUD];
        }
    }
    else if([requestType isEqualToString:@"DownloadAudio"]) {
        if (mp3Player == nil)
        {
            NSString *mp3FileName = @"Mp3File_temp";
            mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
            NSString *mp3FilePath = [[NSHomeDirectory() stringByAppendingFormat:@"/Documents/"] stringByAppendingPathComponent:mp3FileName];

            NSError *playerError;
            mp3Player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:mp3FilePath]
                                                               error:&playerError];
            mp3Player.meteringEnabled = YES;
            if (mp3Player == nil)
            {
                NSLog(@"Error creating player: %@", [playerError description]);
            }
            mp3Player.delegate = self;
        }
        [mp3Player play];
    }
}

#pragma mark - 私有方法

- (void)bindData
{
    NSNumber *attachmentCount = [taskDetailDict objectForKey:@"attachmentCount"];
    NSNumber *picCount = [taskDetailDict objectForKey:@"picCount"];
    NSString *subject = [taskDetailDict objectForKey:@"subject"];
    NSString *body = [taskDetailDict objectForKey:@"body"];
    NSMutableArray *attachments = [taskDetailDict objectForKey:@"attachments"];
    NSMutableArray *pictures = [taskDetailDict objectForKey:@"pictures"];
    NSNumber *isExternal = [taskDetailDict objectForKey:@"isExternal"];
    NSNumber *priority = [taskDetailDict objectForKey:@"priority"];
    NSNumber *isCompleted = [taskDetailDict objectForKey:@"isCompleted"];
    NSString *dueTime = [taskDetailDict objectForKey:@"dueTime"];
    
    //TODO:去除scrollView下所有View
    for (UIView *subView in scrollView.subviews) {
        [subView removeFromSuperview];
    }
    
    //添加内容
    contentView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0)] autorelease];
    contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_contentBg.png"]];
    
    subjectLabel = [[[UILabel alloc] init] autorelease];
    subjectLabel.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    subjectLabel.backgroundColor = [UIColor clearColor];
    subjectLabel.font = [UIFont boldSystemFontOfSize:17];
    subjectLabel.lineBreakMode = UILineBreakModeWordWrap;
    
    [contentView addSubview:subjectLabel];
    
    bodyLabel = [[[UILabel alloc] init] autorelease];
    bodyLabel.textColor = [UIColor colorWithRed:187.0/255 green:187.0/255 blue:187.0/255 alpha:1];
    bodyLabel.backgroundColor = [UIColor clearColor];
    bodyLabel.font = [UIFont boldSystemFontOfSize:14];
    bodyLabel.lineBreakMode = UILineBreakModeWordWrap;
    
    [contentView addSubview:bodyLabel];
    
    [scrollView addSubview:contentView];
    
    //添加进展信息
    commentTitleView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 28)] autorelease];
    
    UILabel *commentTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 6, self.view.bounds.size.width, 16)];
    commentTitleLabel.font = [UIFont boldSystemFontOfSize:16];
    commentTitleLabel.backgroundColor = [UIColor clearColor];
    commentTitleLabel.textColor = [UIColor colorWithRed:160.0/255 green:153.0/255 blue:147.0/255 alpha:1];
    commentTitleLabel.text = @"进展信息";
    
    [commentTitleView addSubview:commentTitleLabel];
    [commentTitleLabel release];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 27, self.view.bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_line.png"]];
    [commentTitleView addSubview:lineView];
    [lineView release];
    
    [scrollView addSubview:commentTitleView];
    
    //添加评论列表
    commentView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    commentView.backgroundColor = [UIColor clearColor];
    
    [scrollView addSubview:commentView];
    
    if([attachmentCount intValue] + [picCount intValue] > 0) {
        
        CGFloat iconLeft = [Tools screenMaxWidth] - 8;
        if([attachmentCount intValue] > 0) {
            iconLeft -= 20;
        }
        if([picCount intValue] > 0) {
            iconLeft -= 20;
        }
        
        UIView *iconsView = [[UIView alloc] initWithFrame:CGRectMake(iconLeft, 5, self.view.bounds.size.width - iconLeft, 15)];
        
        CGFloat tempFlagLeft = 5;
        if([attachmentCount intValue] > 0) {
            UIImageView *audioImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"audioflag.png"]];
            audioImageView.frame = CGRectMake(tempFlagLeft, 5, 13, 13);
            [iconsView addSubview:audioImageView];
            [audioImageView release];
            tempFlagLeft += 20;
        }
        
        if([picCount intValue] > 0) {
            UIImageView *picImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photoflag.png"]];
            picImageView.frame = CGRectMake(tempFlagLeft, 5, 12, 12);
            [iconsView addSubview:picImageView];
            [picImageView release];
            tempFlagLeft += 20;
        }
        
        [contentView addSubview:iconsView];
        [iconsView release];
    }
    
    //绑定content
    CGFloat totalHeight = 0;
    //绑定标题
    subjectLabel.text = subject;
    CGSize subjectLabelSize = [subjectLabel.text sizeWithFont:subjectLabel.font constrainedToSize:CGSizeMake(self.view.bounds.size.width - 50, 10000) lineBreakMode:UILineBreakModeWordWrap];
    CGFloat subjectLabelHeight = subjectLabelSize.height;
    int subjectlines = subjectLabelHeight / 17;
    subjectLabel.frame = CGRectMake(6, 8, self.view.bounds.size.width - 50, subjectLabelHeight);
    subjectLabel.numberOfLines = subjectlines;
    totalHeight += subjectLabelHeight;
    
    //绑定备注
    bodyLabel.text = body;
    if(![bodyLabel.text isEqualToString:@""]) {
        CGSize bodyLabelSize = [subjectLabel.text sizeWithFont:bodyLabel.font constrainedToSize:CGSizeMake(self.view.bounds.size.width - 12, 10000) lineBreakMode:UILineBreakModeWordWrap];
        CGFloat bodyLabelHeight = bodyLabelSize.height;
        int bodylines = bodyLabelHeight / 14;
        bodyLabel.frame = CGRectMake(6, totalHeight + 8, self.view.bounds.size.width - 12, bodyLabelHeight);
        bodyLabel.numberOfLines = bodylines;
        totalHeight += bodyLabelHeight;
    }
    
    //绑定图片和附件
    if([attachmentCount intValue] + [picCount intValue] > 0) {
        
        CGFloat tempLeft = 6;
        
        if([picCount intValue] > 0) {
            NSMutableDictionary *pictureDict = [pictures objectAtIndex:0];
            
            NSString *thumbUrl = [pictureDict objectForKey:@"thumbUrl"];
            NSString *url = [pictureDict objectForKey:@"url"];

            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:url]];
            photos = [[NSMutableArray alloc] init];
            [photos addObject:photo];
                              
            
            UIImageView *imageView = [[[UIImageView alloc] init] autorelease];
            //imageView.tag = [dict objectForKey:@"url"];
            [imageView setImageWithURL:[NSURL URLWithString:thumbUrl]];
            imageView.frame = CGRectMake(tempLeft, totalHeight + 16, 80, 50);
            //                            imageView.tag = count;
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *recognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getPicUrl:)] autorelease];
            [imageView addGestureRecognizer:recognizer];
            [contentView addSubview:imageView];
            tempLeft += 86;
        }
        if([attachmentCount intValue] > 0) {
            for (NSMutableDictionary *dict in attachments) {
                NSString *fileName = [dict objectForKey:@"fileName"];
                
                NSString *url = [dict objectForKey:@"url"];
                NSLog("url:%@", url);
                
                if([fileName.pathExtension isEqualToString:@"mp3"]) {
                    
                    audio_ImageView = [[[UIImageView alloc] init] autorelease];
                    //imageView.tag = [dict objectForKey:@"url"];
                    audio_ImageView.image = [UIImage imageNamed:@"detail_audio.png"];
                    audio_ImageView.frame = CGRectMake(tempLeft, totalHeight + 16, 50, 50);
                    //                            imageView.tag = count;
                    audio_ImageView.userInteractionEnabled = YES;
                    UITapGestureRecognizer *recognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getAudioUrl:)] autorelease];
                    [audio_ImageView addGestureRecognizer:recognizer];
                    [contentView addSubview:audio_ImageView];
                    tempLeft += 56;
                    
                    break;
                }
            }
        }
        
        totalHeight += 62;
    }
    
    if([isExternal isEqualToNumber:[NSNumber numberWithInt:0]] && editable == YES) {
        
        //rightView.hidden = NO;
        
        UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [editButton setBackgroundImage:[UIImage imageNamed:@"detail_editContent.png"] forState:UIControlStateNormal];
        [editButton addTarget:self action:@selector(editContent:) forControlEvents:UIControlEventTouchUpInside];
        editButton.frame = CGRectMake(self.view.bounds.size.width - 24, totalHeight + 8, 16, 16);
        
        [contentView addSubview:editButton];
        
        totalHeight += 16;
    }
    
    contentView.frame = CGRectMake(0, 0, self.view.bounds.size.width, totalHeight + 16);
    
    commentTitleView.frame = CGRectMake(0, totalHeight + 16, self.view.bounds.size.width, 28);
    
    totalHeight += 28;
    
    CGFloat tempCommentHeight = 0.0f;
    for (NSMutableDictionary *commentDict in comments) {
        CommentInfoView *commentInfoView = [[CommentInfoView alloc] initWithFrame:CGRectMake(0, tempCommentHeight, self.view.bounds.size.width, 0)];
        commentInfoView.delegate = self;
        //commentInfoView.backgroundColor = [UIColor redColor];
        [commentInfoView setCommentInfo:commentDict];
        [commentView addSubview:commentInfoView];
        tempCommentHeight += commentInfoView.frame.size.height;
        [commentInfoView release];
    }
    commentView.frame = CGRectMake(0, totalHeight + 16, self.view.bounds.size.width, tempCommentHeight);
    totalHeight += tempCommentHeight;
    
    totalHeight += 16;
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, totalHeight + 44);

    if([isExternal isEqualToNumber:[NSNumber numberWithInt:1]] || editable == NO) {
        completeView.userInteractionEnabled = NO;
    }
    else {
        completeView.userInteractionEnabled = YES;
    }
    
    //绑定完成状态
    if([isCompleted isEqualToNumber:[NSNumber numberWithInt:0]]) {
        completeFlagView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_incomplete_sel.png"]];
        completeFlagLabel.text = @"未完成";
    }
    else {
        completeFlagView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_complete_sel.png"]];
        completeFlagLabel.text = @"已完成";
    }
    //绑定期待完成时间
    if(![dueTime isEqualToString:@""]) {
        dueTimeFlagLabel.text = dueTime;
    }
    //绑定优先级
    priorityFlagLabel.text = [self getPriorityValue:priority];
    if([priority isEqualToNumber:[NSNumber numberWithInt:99]]) {
        priorityFlagView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_priority0Flag2.png"]];
    }
    else {
        priorityFlagView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"detail_priority%@Flag2.png", [priority stringValue]]]];
    }
}

- (void)goBack:(id)sender
{
    if (mp3Player != nil)
    {
        [mp3Player stop];
        mp3Player = nil;
    }
    [Tools layerTransition:self.navigationController.view from:@"left"];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)getPicUrl:(id)sender
{
    NSLog("getPicUrl");
    //UITapGestureRecognizer *imageView = (UITapGestureRecognizer*)sender;
//    NSMutableArray *pictures = [taskDetailDict objectForKey:@"pictures"];
//    NSMutableDictionary *dict = [pictures objectAtIndex:0];
//    NSString *url = [dict objectForKey:@"url"];

//    ImagePreviewViewController *controller = [[[ImagePreviewViewController alloc] init] autorelease];
//    controller.url = url;
//    [Tools layerTransition:self.navigationController.view from:@"right"];
//    [self.navigationController pushViewController:controller animated:NO];

//    KTPhotoScrollViewController *controller = [[KTPhotoScrollViewController alloc] initWithDataSource:self andStartWithPhotoAtIndex:0];
//    //controller.url = url;
//    [Tools layerTransition:self.navigationController.view from:@"right"];
//    [self.navigationController pushViewController:controller animated:NO];

    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;

    UINavigationController *nc = [[[UINavigationController alloc] initWithRootViewController:browser] autorelease];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:nc animated:YES];
}

- (void)getAudioUrl:(id)sender
{
    if (mp3Player != nil)
    {
        [mp3Player stop];
        mp3Player = nil;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(change1:) object:nil];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(change2:) object:nil];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(change3:) object:nil];
        return;
    }
    [self performSelector:@selector(change1:) withObject:nil afterDelay:0.5];

    NSLog("getAudioUrl");
    //UITapGestureRecognizer *recognizer = (UITapGestureRecognizer*)sender;
    //UIImageView *imageView = (UIImageView*)recognizer.view;
    //imageView.image = [UIImage imageNamed:@"detail_audio_sel.png"];
    NSMutableArray *attachments = [taskDetailDict objectForKey:@"attachments"];
    for (NSMutableDictionary *dict in attachments) {
        NSString *fileName = [dict objectForKey:@"fileName"];
        //if([label.text isEqualToString:fileName]) {
            NSString *url = [dict objectForKey:@"url"];
            NSLog("url:%@", url);
            
            if([fileName.pathExtension isEqualToString:@"mp3"]) {
//                AudioPreviewViewController *controller = [[[AudioPreviewViewController alloc] init] autorelease];
//                controller.url = url;
//                [Tools layerTransition:self.navigationController.view from:@"right"];
//                [self.navigationController pushViewController:controller animated:NO];

                ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];

                NSString *mp3FileName = @"Mp3File_temp";
                mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
                NSString *mp3FilePath = [[NSHomeDirectory() stringByAppendingFormat:@"/Documents/"] stringByAppendingPathComponent:mp3FileName];
                request.delegate = self;
                NSMutableDictionary *context = [NSMutableDictionary dictionary];
                [context setObject:@"DownloadAudio" forKey:REQUEST_TYPE];
                [request setUserInfo:[NSDictionary dictionaryWithDictionary:context]];
                [request setDownloadDestinationPath:mp3FilePath];
                
                [request startAsynchronous];
                
                break;
            }
            
          //  break;
        //}
    }
}

- (void)change1:(id)sender
{
    audio_ImageView.image = [UIImage imageNamed:@"detail_audio1.png"];
    [self performSelector:@selector(change2:) withObject:nil afterDelay:0.5];
}
- (void)change2:(id)sender
{
    audio_ImageView.image = [UIImage imageNamed:@"detail_audio2.png"];
    [self performSelector:@selector(change3:) withObject:nil afterDelay:0.5];
}
- (void)change3:(id)sender
{
    audio_ImageView.image = [UIImage imageNamed:@"detail_audio3.png"];
    [self performSelector:@selector(change1:) withObject:nil afterDelay:0.5];
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [mp3Player stop];
    mp3Player = nil;

    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(change1:) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(change2:) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(change3:) object:nil];
}

- (void)editContent:(id)sender
{
    TaskContentEditViewController *viewController = [[[TaskContentEditViewController alloc] init] autorelease];
    viewController.currentTaskId = currentTaskId;
    viewController.taskDetailDict = taskDetailDict;
    viewController.delegate = self;
    [Tools layerTransition:self.navigationController.view from:@"right"];
    [self.navigationController pushViewController:viewController animated:NO];
}

- (void)addComment:(id)sender
{
    TaskCommentCreateViewController *viewController = [[[TaskCommentCreateViewController alloc] init] autorelease];
    viewController.type = 0;
    viewController.currentTaskId = currentTaskId;
    viewController.taskDetailDict = taskDetailDict;
    viewController.delegate = self;
    [Tools layerTransition:self.navigationController.view from:@"right"];
    [self.navigationController pushViewController:viewController animated:NO];
}

- (void)getTaskDetail
{
    comments = [[NSMutableArray alloc] init];
    
    self.HUD = [Tools process:LOADING_TITLE view:self.view];
    
    NSMutableDictionary *context = [NSMutableDictionary dictionary];
    [context setObject:@"TaskDetail" forKey:REQUEST_TYPE];
    self.currentRequest = [enterpriseService getTaskDetail:currentTaskId context:context delegate:self];
}

- (void)showCompletePanel:(id)sender
{
    NSLog(@"showCompletePanel");

    [dueTimeView resignFirstResponder];
    
    if([self.view.subviews containsObject:showPanelView]) {
        [centerPanelView removeFromSuperview];
        [showPanelView removeFromSuperview];
        [arrowImageView removeFromSuperview];
        navPanelView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_navPanel.png"]];
        [self adjuctScrollView:-adjuctScrollHeight];
    }
    
    if(currentIndex == 0) {
        currentIndex = -1;
        return;
    }
    else {
        currentIndex = 0;
    }
    
    showPanelView = [[UIView alloc] init];
    showPanelView.frame = CGRectMake(0, 56, self.view.bounds.size.width, 46);
    showPanelView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_showUpPanel.png"]];

    UILabel *iscompleteTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(6, 14, 100, 17)] autorelease];
    iscompleteTitleLabel.text = @"任务状态：";
    iscompleteTitleLabel.font = [UIFont systemFontOfSize:17];
    iscompleteTitleLabel.backgroundColor = [UIColor clearColor];
    iscompleteTitleLabel.textColor = [UIColor whiteColor];
    [showPanelView addSubview:iscompleteTitleLabel];
    
    NSNumber *isCompeleted = [taskDetailDict objectForKey:@"isCompleted"];

    UIView *incompleteSelView = [[[UIView alloc] initWithFrame:CGRectMake(105, 0, 80, 46)] autorelease];
    incompleteSelView.userInteractionEnabled = YES;
    incompleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    incompleteButton.userInteractionEnabled = NO;
    incompleteButton.frame = CGRectMake(0, 12, 22, 22);
    if([isCompeleted isEqualToNumber:[NSNumber numberWithInt:0]]) {
        [incompleteButton setBackgroundImage:[UIImage imageNamed:@"detail_incomplete.png"] forState:UIControlStateNormal];
    }
    else {
       [incompleteButton setBackgroundImage:[UIImage imageNamed:@"detail_notsetcomplete.png"] forState:UIControlStateNormal];
    }
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeFalseIsCompleted:)];
    [incompleteSelView addGestureRecognizer:recognizer];
    [recognizer release];
    [incompleteSelView addSubview:incompleteButton];
    UILabel *incompleteTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(28, 17, 60, 12)] autorelease];
    incompleteTitleLabel.text = @"未完成";
    incompleteTitleLabel.font = [UIFont systemFontOfSize:12];
    incompleteTitleLabel.backgroundColor = [UIColor clearColor];
    incompleteTitleLabel.textColor = [UIColor whiteColor];
    [incompleteSelView addSubview:incompleteTitleLabel];

    [showPanelView addSubview:incompleteSelView];

    UIView *completeSelView = [[[UIView alloc] initWithFrame:CGRectMake(180, 0, 80, 46)] autorelease];
    completeSelView.userInteractionEnabled = YES;
    completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    completeButton.userInteractionEnabled = NO;
    completeButton.frame = CGRectMake(0, 12, 22, 22);
    if([isCompeleted isEqualToNumber:[NSNumber numberWithInt:1]]) {
        [completeButton setBackgroundImage:[UIImage imageNamed:@"detail_complete.png"] forState:UIControlStateNormal];
    }
    else {
      [completeButton setBackgroundImage:[UIImage imageNamed:@"detail_notsetcomplete.png"] forState:UIControlStateNormal];
    }

    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeTrueIsCompleted:)];
    [completeSelView addGestureRecognizer:recognizer];
    [recognizer release];
    [completeSelView addSubview:completeButton];
    UILabel *completeTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(28, 17, 60, 12)] autorelease];
    completeTitleLabel.text = @"已完成";
    completeTitleLabel.font = [UIFont systemFontOfSize:12];
    completeTitleLabel.backgroundColor = [UIColor clearColor];
    completeTitleLabel.textColor = [UIColor whiteColor];
    [completeSelView addSubview:completeTitleLabel];
    
    [showPanelView addSubview:completeSelView];
    
    adjuctScrollHeight = 44;
    [self adjuctScrollView:adjuctScrollHeight];
    
    navPanelView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_navPanelWithShow.png"]];
    arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_navArrow.png"]];
    [navPanelView addSubview:arrowImageView];
    arrowImageView.frame = CGRectMake((self.view.bounds.size.width / 4 - 12) / 2, 50, 12, 6);
    [self.view addSubview:showPanelView];
    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.5];
//    CGRect frame = showPanelView.frame;
//    frame.size.height = 46;
//    showPanelView.frame = frame;
//    [UIView commitAnimations];
    
//    CGRect frame = scrollView.frame;
//    CGFloat frameY = frame.origin.y + 46;
//    scrollView.frame = CGRectMake(frame.origin.x, frameY, frame.size.width, frame.size.height);
}

- (void)showDueTimePanel:(id)sender
{
    NSLog(@"showDueTimePanel");

    if([self.view.subviews containsObject:showPanelView]) {
        [centerPanelView removeFromSuperview];
        [showPanelView removeFromSuperview];
        [arrowImageView removeFromSuperview];
        navPanelView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_navPanel.png"]];
        [self adjuctScrollView:-adjuctScrollHeight];
    }

//    UIDatePicker *datePicker = [[[UIDatePicker alloc] init] autorelease];
//    datePicker.datePickerMode=UIDatePickerModeDate;
//    [UIView beginAnimations:@"fa;" context:nil];
//    datePicker.frame = CGRectMake(0, 480,320 , 300);
//    datePicker.tag = 201;
//
//    [self.view addSubview:datePicker];
//    datePicker.frame = CGRectMake(0, 240, 320, 220);
//    [datePicker addTarget:self action:@selector(changedDate:) forControlEvents:      UIControlEventValueChanged];
//    [UIView setAnimationDuration:5.0];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView commitAnimations];

    if(currentIndex == 1) {
        currentIndex = -1;
        [dueTimeView resignFirstResponder];
        return;
    }
    else {
        [dueTimeView becomeFirstResponder];
        currentIndex = 1;
    }
}

- (void)showPriorityPanel:(id)sender
{
    NSLog(@"showPriorityPanel");

    [dueTimeView resignFirstResponder];
    
    if([self.view.subviews containsObject:showPanelView]) {
        [centerPanelView removeFromSuperview];
        [showPanelView removeFromSuperview];
        [arrowImageView removeFromSuperview];
        navPanelView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_navPanel.png"]];
        [self adjuctScrollView:-adjuctScrollHeight];
    }

    if(currentIndex == 2) {
        currentIndex = -1;
        return;
    }
    else {
        currentIndex = 2;
    }
    
    showPanelView = [[UIView alloc] init];
    showPanelView.frame = CGRectMake(0, 56, self.view.bounds.size.width, 46);
    showPanelView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_showUpPanel.png"]];
    
    navPanelView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_navPanelWithShow.png"]];
    
    arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_navArrow.png"]];
    [navPanelView addSubview:arrowImageView];
    arrowImageView.frame = CGRectMake(self.view.bounds.size.width * 0.5 + (self.view.bounds.size.width / 4 - 12) / 2, 50, 12, 6);

    priorityView0 = [[UIView alloc] initWithFrame:CGRectMake(20, 11, 80, 23)];
    priorityView0.userInteractionEnabled = YES;
    imageView0 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_priority0Flag.png"]];
    imageView0.frame = CGRectMake(0, 0, 23, 23);
    label0 = [[UILabel alloc] initWithFrame:CGRectMake(30, 7, 80, 12)];
    label0.backgroundColor = [UIColor clearColor];
    label0.textColor = [UIColor colorWithRed:98.0/255 green:85.0/255 blue:79.0/255 alpha:1];
    //label0.textColor = LABELCOLOR;
    label0.text = @"尽快完成";
    label0.font = [UIFont systemFontOfSize:12.0f];
    [priorityView0 addSubview:imageView0];
    [priorityView0 addSubview:label0];

    priorityView1 = [[UIView alloc] initWithFrame:CGRectMake(120, 11, 80, 23)];
    priorityView1.userInteractionEnabled = YES;
    imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_priority1Flag.png"]];
    imageView1.frame = CGRectMake(0, 0, 23, 23);
    label1 = [[UILabel alloc] initWithFrame:CGRectMake(30, 7, 100, 12)];
    label1.backgroundColor = [UIColor clearColor];
    //label1.textColor = LABELCOLOR;
    label1.textColor = [UIColor colorWithRed:98.0/255 green:85.0/255 blue:79.0/255 alpha:1];
    label1.text = @"稍后完成";
    label1.font = [UIFont systemFontOfSize:12.0f];
    [priorityView1 addSubview:imageView1];
    [priorityView1 addSubview:label1];

    priorityView2 = [[UIView alloc] initWithFrame:CGRectMake(220, 11, 80, 23)];
    priorityView2.userInteractionEnabled = YES;
    imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_priority2Flag.png"]];
    imageView2.frame = CGRectMake(0, 0, 23, 23);
    label2 = [[UILabel alloc] initWithFrame:CGRectMake(30, 7, 100, 12)];
    label2.backgroundColor = [UIColor clearColor];
    //label2.textColor = LABELCOLOR;
    label2.textColor = [UIColor colorWithRed:98.0/255 green:85.0/255 blue:79.0/255 alpha:1];
    label2.text = @"迟些再说";
    label2.font = [UIFont systemFontOfSize:12.0f];
    [priorityView2 addSubview:imageView2];
    [priorityView2 addSubview:label2];

    [showPanelView addSubview:priorityView0];
    [showPanelView addSubview:priorityView1];
    [showPanelView addSubview:priorityView2];

    if([label0.text isEqualToString:priorityFlagLabel.text]) {
        imageView0.image = [UIImage imageNamed:@"detail_priority0Flag_sel.png"];
        label0.textColor = [UIColor whiteColor];
    }
    else if([label1.text isEqualToString:priorityFlagLabel.text]) {
        imageView1.image = [UIImage imageNamed:@"detail_priority1Flag_sel.png"];
        label1.textColor = [UIColor whiteColor];
    }
    else if([label2.text isEqualToString:priorityFlagLabel.text]) {
        imageView2.image = [UIImage imageNamed:@"detail_priority2Flag_sel.png"];
        label2.textColor = [UIColor whiteColor];
    }

    UITapGestureRecognizer *recognizer0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setPriority0:)];
    [priorityView0 addGestureRecognizer:recognizer0];
    [recognizer0 release];

    UITapGestureRecognizer *recognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setPriority1:)];
    [priorityView1 addGestureRecognizer:recognizer1];
    [recognizer1 release];

    UITapGestureRecognizer *recognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setPriority2:)];
    [priorityView2 addGestureRecognizer:recognizer2];
    [recognizer2 release];
    
    [self.view addSubview:showPanelView];
    
    adjuctScrollHeight = 44;
    [self adjuctScrollView:adjuctScrollHeight];
    
//    CGRect frame = scrollView.frame;
//    CGFloat frameY = frame.origin.y + 46;
//    scrollView.frame = CGRectMake(frame.origin.x, frameY, frame.size.width, frame.size.height);
}

- (void)showUserPanel:(id)sender
{
    NSLog(@"showUserPanel");

    [dueTimeView resignFirstResponder];
    
    if([self.view.subviews containsObject:showPanelView]) {
        [showPanelView removeFromSuperview];
        [centerPanelView removeFromSuperview];
        [arrowImageView removeFromSuperview];
        navPanelView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_navPanel.png"]];
        [self adjuctScrollView:-adjuctScrollHeight];
    }

    if(currentIndex == 3) {
        currentIndex = -1;
        return;
    }
    else {
        currentIndex = 3;
    }

    centerPanelView = [[UIView alloc] init];
    //centerPanelView.userInteractionEnabled = NO;
    centerPanelView.frame = CGRectMake(0, 56, self.view.bounds.size.width, 44);
    centerPanelView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_centerPanel.png"]];

    UILabel *assigneeTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(6, 12, 90, 17)] autorelease];
    assigneeTitleLabel.text = @"转交他人：";
    assigneeTitleLabel.font = [UIFont systemFontOfSize:16];
    assigneeTitleLabel.backgroundColor = [UIColor clearColor];
    assigneeTitleLabel.textColor = [UIColor whiteColor];
    [centerPanelView addSubview:assigneeTitleLabel];

    NSString *assigneeName = [taskDetailDict objectForKey:@"assigneeName"];
    NSMutableArray *assignMembers = [NSMutableArray array];
    [assignMembers addObject:assigneeName];

    assgineesView = [[FillLabelView alloc] initWithFrame:CGRectMake(92, 9, 188, 0)];
    [assgineesView bindTags:assignMembers backgroundColor:[UIColor colorWithRed:191.0/255 green:182.0/255 blue:175.0/255 alpha:1] textColor:[UIColor colorWithRed:89.0/255 green:80.0/255 blue:73.0/255 alpha:1] font:[UIFont boldSystemFontOfSize:16.0f] radius:14];
    [centerPanelView addSubview:assgineesView];

    NSNumber *isExternal = [taskDetailDict objectForKey:@"isExternal"];
    if([isExternal isEqualToNumber:[NSNumber numberWithInt:0]] && editable == YES) {
        UIView *assigenChooseView = [[[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 26, 12, 18, 18)] autorelease];
        UIButton *assigneeChooseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
        assigneeChooseBtn.userInteractionEnabled = NO;
        [assigneeChooseBtn setBackgroundImage:[UIImage imageNamed:@"detailcreate_assigneeAdd.png"] forState:UIControlStateNormal];
        UITapGestureRecognizer *chooseRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseUser:)];
        [assigenChooseView addGestureRecognizer:chooseRecognizer];
        [chooseRecognizer release];

        [assigenChooseView addSubview:assigneeChooseBtn];

        [centerPanelView addSubview:assigenChooseView];
    }

    [self.view addSubview:centerPanelView];

//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 90, 320, 1)];
//    lineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_shiline.png"]];
//    [self.view addSubview:lineView];
//    [lineView release];

    showPanelView = [[UIView alloc] init];
//    showPanelView.frame = CGRectMake(0, 100, 320, 46);
    
    navPanelView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_navPanelWithShow.png"]];
    arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_navArrow.png"]];
    [navPanelView addSubview:arrowImageView];
    arrowImageView.frame = CGRectMake(self.view.bounds.size.width * 0.75 + (self.view.bounds.size.width / 4 - 12) / 2, 50, 12, 6);

    NSMutableArray *relatedUserArray = [taskDetailDict objectForKey:@"relatedUserArray"];
    NSMutableArray *relevantMembers = [NSMutableArray array];
    for (NSMutableDictionary *relevantDict in relatedUserArray) {
        [relevantMembers addObject:[relevantDict objectForKey:@"displayName"]];
    }
    
    EditFillLabelView *relevantLabelView = [[EditFillLabelView alloc] initWithFrame:CGRectMake(92, 9, 140, 0)];
    if(relevantMembers.count > 0) {
        [relevantLabelView bindTags:relevantMembers backgroundColor:[UIColor colorWithRed:191.0/255 green:182.0/255 blue:175.0/255 alpha:1] textColor:[UIColor colorWithRed:89.0/255 green:80.0/255 blue:73.0/255 alpha:1] font:[UIFont boldSystemFontOfSize:16.0f] radius:14];
    }
    if(editable == YES) {
        relevantLabelView.delegate = self;
    }
    [showPanelView addSubview:relevantLabelView];
    
    int lines = relevantMembers.count == 0 ? 1 : ((relevantMembers.count - 1) / 2 + 1);
    
    int tempHeight = 0;
    for (int index = 0; index < lines - 1; index++) {
        UIView *bgView = [[[UIView alloc] initWithFrame:CGRectMake(0, tempHeight, self.view.bounds.size.width, 44)] autorelease];
        bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_centerPanel.png"]];
        [showPanelView insertSubview:bgView atIndex:0];
        tempHeight += 44;
    }
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, tempHeight, self.view.bounds.size.width, 46)];
    footView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_showUpPanel.png"]];
    [showPanelView insertSubview:footView atIndex:0];
    
    showPanelView.frame = CGRectMake(0, 100, self.view.bounds.size.width, tempHeight + 46);
    
    UILabel *relevantTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(6, 12, 90, 17)] autorelease];
    relevantTitleLabel.text = @"相关人员：";
    relevantTitleLabel.font = [UIFont systemFontOfSize:16];
    relevantTitleLabel.backgroundColor = [UIColor clearColor];
    relevantTitleLabel.textColor = [UIColor whiteColor];
    [showPanelView addSubview:relevantTitleLabel];

//    NSString *assigneeName = [taskDetailDict objectForKey:@"assigneeName"];
//    NSMutableArray *assignMembers = [NSMutableArray array];
//    [assignMembers addObject:assigneeName];
//
//    assgineesView = [[FillLabelView alloc] initWithFrame:CGRectMake(102, 8, 188, 0)];
//    [assgineesView bindTags:assignMembers backgroundColor:[UIColor colorWithRed:191.0/255 green:182.0/255 blue:175.0/255 alpha:1] textColor:[UIColor colorWithRed:89.0/255 green:80.0/255 blue:73.0/255 alpha:1] font:[UIFont boldSystemFontOfSize:16.0f] radius:14];
//    [showPanelView addSubview:assgineesView];
//
//    NSNumber *isExternal = [taskDetailDict objectForKey:@"isExternal"];
    if([isExternal isEqualToNumber:[NSNumber numberWithInt:0]] && editable == YES) {
        UIView *relevantChooseView = [[[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 26, 13, 18, 18)] autorelease];
        relevantChooseView.userInteractionEnabled = YES;
        UIButton *relevantChooseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
        relevantChooseBtn.userInteractionEnabled = NO;
        [relevantChooseBtn setBackgroundImage:[UIImage imageNamed:@"detailcreate_assigneeAdd.png"] forState:UIControlStateNormal];
        UITapGestureRecognizer *relevantRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseRelevantUser:)];
        [relevantChooseView addGestureRecognizer:relevantRecognizer];
        [relevantRecognizer release];

        [relevantChooseView addSubview:relevantChooseBtn];

        [showPanelView addSubview:relevantChooseView];
    }
    
    [self.view addSubview:showPanelView];
    
    adjuctScrollHeight = tempHeight + 44 + 44;
    [self adjuctScrollView:adjuctScrollHeight];
}

- (void)adjuctScrollView:(CGFloat)top
{
    CGRect scrollFrame = scrollView.frame;
    scrollFrame.origin.y += top;
    scrollView.frame = scrollFrame;
    
    CGSize scrollContentSize = scrollView.contentSize;
    scrollContentSize.height += top;
    scrollView.contentSize = scrollContentSize;
}

- (void)changeTrueIsCompleted:(id)sender
{
    [self changeIsCompleted:[NSNumber numberWithInt:1]];
}

- (void)changeFalseIsCompleted:(id)sender
{
    [self changeIsCompleted:[NSNumber numberWithInt:0]];
}

- (void)changeIsCompleted:(NSNumber*)isCompleted
{
    currentIndex = -1;
    
    self.HUD = [Tools process:@"正在提交" view:self.view];
    NSMutableDictionary *context = [NSMutableDictionary dictionary];
    [context setObject:@"ChangeTaskCompleted" forKey:REQUEST_TYPE];
    [context setObject:isCompleted forKey:@"isCompleted"];
    [enterpriseService changeTaskCompleted:currentTaskId
                               isCompleted:isCompleted
                                   context:context
                                  delegate:self];
}

- (void)chooseUser:(id)sender
{
    NSLog(@"chooseAssigneeUser");

    SearchUserViewController *searchUserController = [[[SearchUserViewController alloc] init] autorelease];
    searchUserController.delegate = self;
    searchUserController.type = 0;
    [Tools layerTransition:self.navigationController.view from:@"right"];
    [self.navigationController pushViewController:searchUserController animated:NO];

    //[searchUserController release];
}

- (void)chooseRelevantUser:(id)sender
{
    SearchUserViewController *searchUserController = [[[SearchUserViewController alloc] init] autorelease];
    searchUserController.delegate = self;
    searchUserController.type = 1;
    [Tools layerTransition:self.navigationController.view from:@"right"];
    [self.navigationController pushViewController:searchUserController animated:NO];
}

- (void)modifyAssignee:(NSMutableDictionary*)assignee
{
    NSString *workId = [assignee objectForKey:@"workId"];
    [taskDetailDict setObject:workId forKey:@"assigneeWorkId"];
    NSString *name = [assignee objectForKey:@"name"];
    NSArray *array = [name componentsSeparatedByString: @"-"];
    NSString *displayName;
    if(array.count == 0) {
        displayName = name;
    }
    else {
        displayName = [array objectAtIndex: 0];
    }
    NSString *assigneeWorkId = [assignee objectForKey:@"workId"];

    NSMutableArray *assignMembers = [NSMutableArray array];
    [assignMembers addObject:displayName];

    [assgineesView bindTags:assignMembers backgroundColor:[UIColor colorWithRed:191.0/255 green:182.0/255 blue:175.0/255 alpha:1] textColor:[UIColor colorWithRed:89.0/255 green:80.0/255 blue:73.0/255 alpha:1] font:[UIFont boldSystemFontOfSize:16.0f] radius:14];

    NSString *subject = [taskDetailDict objectForKey:@"subject"];
    NSString *body = [taskDetailDict objectForKey:@"body"];
    NSString *dueTime = [taskDetailDict objectForKey:@"dueTime"];
    NSNumber *priority = [taskDetailDict objectForKey:@"priority"];
    NSNumber *isCompleted = [taskDetailDict objectForKey:@"isCompleted"];

    NSString *attachmentsStr = @"";
    NSMutableArray *attachments = [taskDetailDict objectForKey:@"attachments"];
    NSMutableArray *pictures = [taskDetailDict objectForKey:@"pictures"];
    NSMutableArray *attachmentIds = [NSMutableArray array];
    for (NSMutableDictionary *dict in attachments) {
        [attachmentIds addObject:[dict objectForKey:@"attachmentId"]];
    }
    for (NSMutableDictionary *dict in pictures) {
        [attachmentIds addObject:[dict objectForKey:@"attachmentId"]];
    }
    attachmentsStr = [attachmentIds componentsJoinedByString:@"||"];
    
    NSMutableArray *relatedUserArray = [taskDetailDict objectForKey:@"relatedUserArray"];
    NSMutableArray *workIdsArray = [NSMutableArray array];
    for (NSMutableDictionary *userDict in relatedUserArray) {
        [workIdsArray addObject:[userDict objectForKey:@"workId"]];
    }
    NSString *relatedUserWorkIds = [workIdsArray componentsJoinedByString:@"||"];
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    [self.HUD show:YES];
    self.HUD.labelText = @"正在提交";
    NSMutableDictionary *context = [NSMutableDictionary dictionary];
    [context setObject:@"UpdateTask" forKey:REQUEST_TYPE];
    [context setObject:assigneeWorkId forKey:@"assigneeWorkId"];
    [context setObject:name forKey:@"assigneeName"];
    [enterpriseService updateTask:currentTaskId
                          subject:subject
                             body:body
                          dueTime:dueTime
                   assigneeWorkId:assigneeWorkId
               relatedUserWorkIds:relatedUserWorkIds
                         priority:priority
                      isCompleted:isCompleted
                    attachmentIds:attachmentsStr
                          context:context
                         delegate:self];
}
- (void)modifyRelated:(NSMutableDictionary*)related
{
    NSString *workId = [related objectForKey:@"workId"];
    NSString *name = [related objectForKey:@"name"];
    NSArray *array = [name componentsSeparatedByString: @"-"];
    NSString *displayName;
    if(array.count == 0) {
        displayName = name;
    }
    else {
        displayName = [array objectAtIndex: 0];
    }
    
    NSMutableArray *relatedUserArray = [taskDetailDict objectForKey:@"relatedUserArray"];
    for (NSMutableDictionary *dict in relatedUserArray) {
        if([workId isEqualToString:[dict objectForKey:@"workId"]]) {
            return;
        }
    }
    
    NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
    [userDict setObject:workId forKey:@"workId"];
    [userDict setObject:displayName forKey:@"displayName"];
    [relatedUserArray addObject:userDict];
    [taskDetailDict setObject:relatedUserArray forKey:@"relatedUserArray"];
    
//    NSMutableArray *assignMembers = [NSMutableArray array];
//    [assignMembers addObject:displayName];
//    
//    [assgineesView bindTags:assignMembers backgroundColor:[UIColor colorWithRed:191.0/255 green:182.0/255 blue:175.0/255 alpha:1] textColor:[UIColor colorWithRed:89.0/255 green:80.0/255 blue:73.0/255 alpha:1] font:[UIFont boldSystemFontOfSize:16.0f] radius:14];
    
    NSString *subject = [taskDetailDict objectForKey:@"subject"];
    NSString *body = [taskDetailDict objectForKey:@"body"];
    NSString *dueTime = [taskDetailDict objectForKey:@"dueTime"];
    NSNumber *priority = [taskDetailDict objectForKey:@"priority"];
    NSNumber *isCompleted = [taskDetailDict objectForKey:@"isCompleted"];
    NSString *assigneeWorkId = [taskDetailDict objectForKey:@"assigneeWorkId"];
    
    NSString *attachmentsStr = @"";
    NSMutableArray *attachments = [taskDetailDict objectForKey:@"attachments"];
    NSMutableArray *pictures = [taskDetailDict objectForKey:@"pictures"];
    NSMutableArray *attachmentIds = [NSMutableArray array];
    for (NSMutableDictionary *dict in attachments) {
        [attachmentIds addObject:[dict objectForKey:@"attachmentId"]];
    }
    for (NSMutableDictionary *dict in pictures) {
        [attachmentIds addObject:[dict objectForKey:@"attachmentId"]];
    }
    attachmentsStr = [attachmentIds componentsJoinedByString:@"||"];
    
    NSMutableArray *workIdsArray = [NSMutableArray array];
    for (NSMutableDictionary *userDict in relatedUserArray) {
        [workIdsArray addObject:[userDict objectForKey:@"workId"]];
    }
    NSString *relatedUserWorkIds = [workIdsArray componentsJoinedByString:@"||"];
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    [self.HUD show:YES];
    self.HUD.labelText = @"正在提交";
    NSMutableDictionary *context = [NSMutableDictionary dictionary];
    [context setObject:@"UpdateTaskRelated" forKey:REQUEST_TYPE];
    //[context setObject:assigneeWorkId forKey:@"assigneeWorkId"];
    //[context setObject:name forKey:@"assigneeName"];
    [enterpriseService updateTask:currentTaskId
                          subject:subject
                             body:body
                          dueTime:dueTime
                   assigneeWorkId:assigneeWorkId
                  relatedUserWorkIds:relatedUserWorkIds
                         priority:priority
                      isCompleted:isCompleted
                    attachmentIds:attachmentsStr
                          context:context
                         delegate:self];
}
- (void)writeName:(NSString*)displayname
{
    
}

- (void)setPriority0:(id)sender
{
    [self setSelectedIndex:0];
}
- (void)setPriority1:(id)sender
{
    [self setSelectedIndex:1];
}
- (void)setPriority2:(id)sender
{
    [self setSelectedIndex:2];
}

- (void)setSelectedIndex:(int)index
{
    if(index == 0) {
        imageView0.image = [UIImage imageNamed:@"detail_priority0Flag_sel.png"];
        imageView1.image = [UIImage imageNamed:@"detail_priority1Flag.png"];
        imageView2.image = [UIImage imageNamed:@"detail_priority2Flag.png"];
        label0.textColor = [UIColor whiteColor];
        label1.textColor = [UIColor colorWithRed:98.0/255 green:85.0/255 blue:79.0/255 alpha:1];
        label2.textColor = [UIColor colorWithRed:98.0/255 green:85.0/255 blue:79.0/255 alpha:1];
    }
    else if(index == 1) {
        imageView0.image = [UIImage imageNamed:@"detail_priority0Flag.png"];
        imageView1.image = [UIImage imageNamed:@"detail_priority1Flag_sel.png"];
        imageView2.image = [UIImage imageNamed:@"detail_priority2Flag.png"];
        label0.textColor = [UIColor colorWithRed:98.0/255 green:85.0/255 blue:79.0/255 alpha:1];
        label1.textColor = [UIColor whiteColor];
        label2.textColor = [UIColor colorWithRed:98.0/255 green:85.0/255 blue:79.0/255 alpha:1];
    }
    else if(index == 2) {
        imageView0.image = [UIImage imageNamed:@"detail_priority0Flag.png"];
        imageView1.image = [UIImage imageNamed:@"detail_priority1Flag.png"];
        imageView2.image = [UIImage imageNamed:@"detail_priority2Flag_sel.png"];
        label0.textColor = [UIColor colorWithRed:98.0/255 green:85.0/255 blue:79.0/255 alpha:1];
        label1.textColor = [UIColor colorWithRed:98.0/255 green:85.0/255 blue:79.0/255 alpha:1];
        label2.textColor = [UIColor whiteColor];
    }

    currentIndex = -1;
    self.HUD = [Tools process:@"正在提交" view:self.view];
    NSNumber *priority = [NSNumber numberWithInt:index];
    NSMutableDictionary *context = [NSMutableDictionary dictionary];
    [context setObject:priority forKey:@"priority"];
    [context setObject:@"ChangeTaskPriority" forKey:REQUEST_TYPE];
    [enterpriseService changeTaskPriority:currentTaskId
                                 priority:priority
                                  context:context
                                 delegate:self];
}

- (NSNumber*)getPriorityKey:(NSString*)priorityValue
{
    if([priorityValue isEqualToString:PRIORITY_TITLE_1])
        return [NSNumber numberWithInt:0];
    else if([priorityValue isEqualToString:PRIORITY_TITLE_2])
        return [NSNumber numberWithInt:1];
    else if([priorityValue isEqualToString:PRIORITY_TITLE_3])
        return [NSNumber numberWithInt:2];
    return [NSNumber numberWithInt:99];
}

- (NSString*)getPriorityValue:(NSNumber*)priorityKey
{
    if([priorityKey isEqualToNumber:[NSNumber numberWithInt:0]])
        return PRIORITY_TITLE_1;
    else if([priorityKey isEqualToNumber:[NSNumber numberWithInt:1]])
        return PRIORITY_TITLE_2;
    else if([priorityKey isEqualToNumber:[NSNumber numberWithInt:2]])
        return PRIORITY_TITLE_3;
    return @"优先级";
}

@end
