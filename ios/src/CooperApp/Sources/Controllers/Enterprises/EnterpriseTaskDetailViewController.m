//
//  EnterpriseTaskDetailViewController.m
//  CooperApp
//
//  Created by sunleepy on 13-1-5.
//  Copyright (c) 2013年 codesharp. All rights reserved.
//

#import "EnterpriseTaskDetailViewController.h"

@implementation EnterpriseTaskDetailViewController

@synthesize currentTaskId;
@synthesize taskDetailDict;

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
    
    UITapGestureRecognizer *recognizer = nil;
    
    enterpriseService = [[EnterpriseService alloc] init];
	
    textTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    textTitleLabel.backgroundColor = [UIColor clearColor];
    textTitleLabel.textAlignment = UITextAlignmentCenter;
    textTitleLabel.textColor = APP_TITLECOLOR;
    textTitleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    self.navigationItem.titleView = textTitleLabel;
    textTitleLabel.text = @"详情";
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 38, 45)];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(14, 16, 15, 10)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back2.png"] forState:UIControlStateNormal];
    [backView addSubview:backBtn];
    backView.userInteractionEnabled = YES;
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack:)];
    [backView addGestureRecognizer:recognizer];
    [recognizer release];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    [backButtonItem release];
    [backView release];
    
    rightView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 55, 44)] autorelease];
    rightView.hidden = YES;
    UIView *splitView = [[UIView alloc] initWithFrame:CGRectMake(0, 9, 1, 26)];
    splitView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"split.png"]];
    [rightView addSubview:splitView];
    UIButton *saveTaskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveTaskBtn setTitleColor:APP_TITLECOLOR forState:UIControlStateNormal];
    saveTaskBtn.frame = CGRectMake(1, 6, 54, 30);
    [saveTaskBtn addTarget:self action:@selector(addComment:) forControlEvents:UIControlEventTouchUpInside];
    saveTaskBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [saveTaskBtn setTitle:@"评论" forState:UIControlStateNormal];
    [rightView addSubview:saveTaskBtn];
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    [saveButtonItem release];
    [splitView release];
    
    //选择属性面板
    navPanelView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 59)] autorelease];
    navPanelView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_navPanel.png"]];
    
    //完成面板
    UIView *completeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 39)];
    completeView.userInteractionEnabled = YES;
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCompletePanel:)];
    [completeView addGestureRecognizer:recognizer];
    [recognizer release];
    
    completeFlagView = [[[UIView alloc] initWithFrame:CGRectMake(28, 8, 22, 22)] autorelease];
    completeFlagView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_notsetcomplete.png"]];
    
    [completeView addSubview:completeFlagView];
    
    completeFlagLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 36, 80, 12)] autorelease];
    completeFlagLabel.text = @"未设置";
    completeFlagLabel.backgroundColor = [UIColor clearColor];
    completeFlagLabel.textColor = [UIColor colorWithRed:98.0/255 green:85.0/255 blue:79.0/255 alpha:1];
    completeFlagLabel.font = [UIFont systemFontOfSize:12.0f];
    completeFlagLabel.textAlignment = UITextAlignmentCenter;
    
    [completeView addSubview:completeFlagLabel];
    
    [navPanelView addSubview:completeView];
    [completeView release];
    
    //完成时间面板
    UIView *dueTimeView = [[UIView alloc] initWithFrame:CGRectMake(80, 0, 80, 39)];
    dueTimeView.userInteractionEnabled = YES;
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDueTimePanel:)];
    [dueTimeView addGestureRecognizer:recognizer];
    [recognizer release];
    
    dueTimeFlagView = [[[UIView alloc] initWithFrame:CGRectMake(28, 8, 23, 23)] autorelease];
    dueTimeFlagView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_dueTimeFlag.png"]];
    
    [dueTimeView addSubview:dueTimeFlagView];
    
    dueTimeFlagLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 36, 80, 12)] autorelease];
    dueTimeFlagLabel.text = @"未设置";
    dueTimeFlagLabel.backgroundColor = [UIColor clearColor];
    dueTimeFlagLabel.textColor = [UIColor colorWithRed:98.0/255 green:85.0/255 blue:79.0/255 alpha:1];
    dueTimeFlagLabel.font = [UIFont systemFontOfSize:12.0f];
    dueTimeFlagLabel.textAlignment = UITextAlignmentCenter;
    
    [dueTimeView addSubview:dueTimeFlagLabel];
    
    [navPanelView addSubview:dueTimeView];
    [dueTimeView release];
    
    //优先级面板
    UIView *priorityView = [[UIView alloc] initWithFrame:CGRectMake(160, 0, 80, 39)];
    priorityView.userInteractionEnabled = YES;
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPriorityPanel:)];
    [priorityView addGestureRecognizer:recognizer];
    [recognizer release];
    
    priorityFlagView = [[[UIView alloc] initWithFrame:CGRectMake(28, 8, 23, 23)] autorelease];
    priorityFlagView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_priority0Flag.png"]];
    
    [priorityView addSubview:priorityFlagView];
    
    priorityFlagLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 36, 80, 12)] autorelease];
    priorityFlagLabel.text = @"未设置";
    priorityFlagLabel.backgroundColor = [UIColor clearColor];
    priorityFlagLabel.textColor = [UIColor colorWithRed:98.0/255 green:85.0/255 blue:79.0/255 alpha:1];
    priorityFlagLabel.font = [UIFont systemFontOfSize:12.0f];
    priorityFlagLabel.textAlignment = UITextAlignmentCenter;
    
    [priorityView addSubview:priorityFlagLabel];
    
    [navPanelView addSubview:priorityView];
    [priorityView release];
    
    //人员面板
    UIView *userView = [[UIView alloc] initWithFrame:CGRectMake(240, 0, 80, 39)];
    userView.userInteractionEnabled = YES;
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserPanel:)];
    [userView addGestureRecognizer:recognizer];
    [recognizer release];
    
    UIView *userFlagView = [[[UIView alloc] initWithFrame:CGRectMake(28, 8, 23, 23)] autorelease];
    userFlagView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_userFlag.png"]];
    
    [userView addSubview:userFlagView];
    
    UILabel *userFlagLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 36, 80, 12)] autorelease];
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
    scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 56, 320, self.view.bounds.size.height - 56)] autorelease];
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

- (void)dealloc
{
    [comments release];
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
                    //                    NSMutableDictionary *related = [data objectForKey:@"related"];
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
                        NSString *type = [feedbackDict objectForKey:@"type"];
                        if([type isEqualToString:@"CommentFeedback"]) {
                            [comments addObject:feedbackDict];
                        }
                    }
                    
                    [taskDetailDict setObject:taskId forKey:@"taskId"];
                    [taskDetailDict setObject:subject forKey:@"subject"];
                    [taskDetailDict setObject:body forKey:@"body"];
                    [taskDetailDict setObject:dueTime forKey:@"dueTime"];
                    [taskDetailDict setObject:priority forKey:@"priority"];
                    [taskDetailDict setObject:isCompleted forKey:@"isCompleted"];
                    [taskDetailDict setObject:assigneeName forKey:@"assigneeName"];
                    [taskDetailDict setObject:assigneeWorkId forKey:@"assigneeWorkId"];
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
        if(request.responseStatusCode == 200) {
            //            [detailView reloadData];
        }
        else
        {
            [Tools failed:self.HUD];
        }
    }
    else if([requestType isEqualToString:@"ChangeTaskDueTime"]) {
        if(request.responseStatusCode == 200) {
            //            [detailView reloadData];
        }
        else
        {
            [Tools failed:self.HUD];
        }
    }
    else if([requestType isEqualToString:@"ChangeTaskPriority"]) {
        if(request.responseStatusCode == 200) {
            //            [detailView reloadData];
        }
        else
        {
            [Tools failed:self.HUD];
        }
    }
    else if([requestType isEqualToString:@"UpdateTask"]) {
        if(request.responseStatusCode == 200) {
            //            [detailView reloadData];
        }
        else
        {
            [Tools failed:self.HUD];
        }
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
    contentView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)] autorelease];
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
    commentTitleView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 28)] autorelease];
    
    UILabel *commentTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 6, 320, 16)];
    commentTitleLabel.font = [UIFont boldSystemFontOfSize:16];
    commentTitleLabel.backgroundColor = [UIColor clearColor];
    commentTitleLabel.textColor = [UIColor colorWithRed:160.0/255 green:153.0/255 blue:147.0/255 alpha:1];
    commentTitleLabel.text = @"进展信息";
    
    [commentTitleView addSubview:commentTitleLabel];
    [commentTitleLabel release];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 27, 320, 1)];
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
        
        UIView *iconsView = [[UIView alloc] initWithFrame:CGRectMake(iconLeft, 5, [Tools screenMaxWidth] - iconLeft, 15)];
        
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
    CGSize subjectLabelSize = [subjectLabel.text sizeWithFont:subjectLabel.font constrainedToSize:CGSizeMake(270, 10000) lineBreakMode:UILineBreakModeWordWrap];
    CGFloat subjectLabelHeight = subjectLabelSize.height;
    int subjectlines = subjectLabelHeight / 17;
    subjectLabel.frame = CGRectMake(6, 8, 270, subjectLabelHeight);
    subjectLabel.numberOfLines = subjectlines;
    totalHeight += subjectLabelHeight;
    
    //绑定备注
    bodyLabel.text = body;
    if(![bodyLabel.text isEqualToString:@""]) {
        CGSize bodyLabelSize = [subjectLabel.text sizeWithFont:bodyLabel.font constrainedToSize:CGSizeMake(308, 10000) lineBreakMode:UILineBreakModeWordWrap];
        CGFloat bodyLabelHeight = bodyLabelSize.height;
        int bodylines = bodyLabelHeight / 14;
        bodyLabel.frame = CGRectMake(6, totalHeight + 8, 308, bodyLabelHeight);
        bodyLabel.numberOfLines = bodylines;
        totalHeight += bodyLabelHeight;
    }
    
    //绑定图片和附件
    if([attachmentCount intValue] + [picCount intValue] > 0) {
        
        CGFloat tempLeft = 6;
        
        if([picCount intValue] > 0) {
            NSMutableDictionary *pictureDict = [pictures objectAtIndex:0];
            
            NSString *thumbUrl = [pictureDict objectForKey:@"thumbUrl"];
            
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
                    
                    UIImageView *imageView = [[[UIImageView alloc] init] autorelease];
                    //imageView.tag = [dict objectForKey:@"url"];
                    imageView.image = [UIImage imageNamed:@"detail_audio.png"];
                    imageView.frame = CGRectMake(tempLeft, totalHeight + 16, 50, 50);
                    //                            imageView.tag = count;
                    imageView.userInteractionEnabled = YES;
                    UITapGestureRecognizer *recognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getPicUrl:)] autorelease];
                    [imageView addGestureRecognizer:recognizer];
                    [contentView addSubview:imageView];
                    tempLeft += 56;
                    
                    break;
                }
            }
        }
        
        totalHeight += 62;
    }
    
    if([isExternal isEqualToNumber:[NSNumber numberWithInt:0]]) {
        
        rightView.hidden = NO;
        
        UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [editButton setBackgroundImage:[UIImage imageNamed:@"detail_editContent.png"] forState:UIControlStateNormal];
        [editButton addTarget:self action:@selector(editContent:) forControlEvents:UIControlEventTouchUpInside];
        editButton.frame = CGRectMake(296, totalHeight + 8, 16, 16);
        
        [contentView addSubview:editButton];
        
        totalHeight += 16;
    }
    
    contentView.frame = CGRectMake(0, 0, 320, totalHeight + 16);
    
    commentTitleView.frame = CGRectMake(0, totalHeight + 16, 320, 28);
    
    totalHeight += 28;
    
    CGFloat tempCommentHeight = 0.0f;
    for (NSMutableDictionary *commentDict in comments) {
        CommentInfoView *commentInfoView = [[CommentInfoView alloc] initWithFrame:CGRectMake(0, tempCommentHeight, 320, 0)];
        commentInfoView.delegate = self;
        //commentInfoView.backgroundColor = [UIColor redColor];
        [commentInfoView setCommentInfo:commentDict];
        [commentView addSubview:commentInfoView];
        tempCommentHeight += commentInfoView.frame.size.height;
        [commentInfoView release];
    }
    commentView.frame = CGRectMake(0, totalHeight + 16, 320, tempCommentHeight);
    totalHeight += tempCommentHeight;
    
    totalHeight += 16;
    scrollView.contentSize = CGSizeMake(320, totalHeight + 44);
    
    //绑定完成状态
    if([isCompleted isEqualToNumber:[NSNumber numberWithInt:0]]) {
        completeFlagView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_incomplete.png"]];
        completeFlagLabel.text = @"未完成";
    }
    else {
        completeFlagView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_complete.png"]];
        completeFlagLabel.text = @"已完成";
    }
    //绑定期待完成时间
    if(![dueTime isEqualToString:@""]) {
        dueTimeFlagLabel.text = dueTime;
    }
    //绑定优先级
    priorityFlagLabel.text = [self getPriorityValue:priority];
    if([priority isEqualToNumber:[NSNumber numberWithInt:99]]) {
        priorityFlagView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_priority0Flag.png"]];
    }
    else {
        priorityFlagView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"detail_priority%@Flag.png", [priority stringValue]]]];
    }
}

- (void)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    [enterpriseService getTaskDetail:currentTaskId context:context delegate:self];
}

- (void)showCompletePanel:(id)sender
{
    NSLog(@"showCompletePanel");
    
    if([self.view.subviews containsObject:showPanelView]) {
        [showPanelView removeFromSuperview];
    }
    
    showPanelView = [[[UIView alloc] init] autorelease];
    showPanelView.frame = CGRectMake(0, 56, 320, 46);
    showPanelView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_showUpPanel.png"]];
    
    navPanelView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_navPanelWithShow.png"]];
    if(arrowImageView == nil) {
        arrowImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_navArrow.png"]] autorelease];
        [navPanelView addSubview:arrowImageView];
    }
    arrowImageView.frame = CGRectMake(34, 50, 12, 6);
    [self.view addSubview:showPanelView];
    
    CGRect frame = scrollView.frame;
    CGFloat frameY = frame.origin.y + 46;
    scrollView.frame = CGRectMake(frame.origin.x, frameY, frame.size.width, frame.size.height);
}

- (void)showDueTimePanel:(id)sender
{
    NSLog(@"showDueTimePanel");
    
    if([self.view.subviews containsObject:showPanelView]) {
        [showPanelView removeFromSuperview];
    }
    
    showPanelView = [[[UIView alloc] init] autorelease];
    showPanelView.frame = CGRectMake(0, 56, 320, 46);
    showPanelView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_showUpPanel.png"]];
    
    navPanelView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_navPanelWithShow.png"]];
    if(arrowImageView == nil) {
        arrowImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_navArrow.png"]] autorelease];
        [navPanelView addSubview:arrowImageView];
    }
    arrowImageView.frame = CGRectMake(114, 50, 12, 6);
    [self.view addSubview:showPanelView];
}

- (void)showPriorityPanel:(id)sender
{
    NSLog(@"showPriorityPanel");
    
    if([self.view.subviews containsObject:showPanelView]) {
        [showPanelView removeFromSuperview];
    }
    
    showPanelView = [[[UIView alloc] init] autorelease];
    showPanelView.frame = CGRectMake(0, 56, 320, 46);
    showPanelView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_showUpPanel.png"]];
    
    navPanelView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_navPanelWithShow.png"]];
    
    if(arrowImageView == nil) {
        arrowImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_navArrow.png"]] autorelease];
        [navPanelView addSubview:arrowImageView];
    }
    arrowImageView.frame = CGRectMake(194, 50, 12, 6);
    
    [self.view addSubview:showPanelView];
    
    CGRect frame = scrollView.frame;
    CGFloat frameY = frame.origin.y + 46;
    scrollView.frame = CGRectMake(frame.origin.x, frameY, frame.size.width, frame.size.height);
}

- (void)showUserPanel:(id)sender
{
    NSLog(@"showUserPanel");
    
    if([self.view.subviews containsObject:showPanelView]) {
        [showPanelView removeFromSuperview];
    }
    
    showPanelView = [[[UIView alloc] init] autorelease];
    showPanelView.frame = CGRectMake(0, 56, 320, 46);
    showPanelView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_showUpPanel.png"]];
    
    navPanelView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_navPanelWithShow.png"]];
    if(arrowImageView == nil) {
        arrowImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_navArrow.png"]] autorelease];
        [navPanelView addSubview:arrowImageView];
    }
    arrowImageView.frame = CGRectMake(274, 50, 12, 6);
    [self.view addSubview:showPanelView];
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
    else if([priorityKey isEqualToNumber:[NSNumber numberWithInt:0]])
        return PRIORITY_TITLE_3;
    return @"未设置";
}

@end
