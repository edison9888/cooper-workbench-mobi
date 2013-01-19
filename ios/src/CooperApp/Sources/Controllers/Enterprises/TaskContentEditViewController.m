//
//  TaskContentEditViewController.m
//  CooperApp
//
//  Created by sunleepy on 13-1-5.
//  Copyright (c) 2013年 codesharp. All rights reserved.
//

#import "TaskContentEditViewController.h"

@implementation TaskContentEditViewController

@synthesize currentTaskId;
@synthesize taskDetailDict;
@synthesize delegate;

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
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick:)];
    [self.view addGestureRecognizer:recognizer];
    [recognizer release];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detailcreate_bg.png"]];
    
    enterpriseService = [[EnterpriseService alloc] init];
    
    textTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    textTitleLabel.backgroundColor = [UIColor clearColor];
    textTitleLabel.textAlignment = UITextAlignmentCenter;
    textTitleLabel.textColor = APP_TITLECOLOR;
    textTitleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    self.navigationItem.titleView = textTitleLabel;
    textTitleLabel.text = @"编辑";
    
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
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 55, 44)];
    UIView *splitView = [[UIView alloc] initWithFrame:CGRectMake(0, 9, 1, 26)];
    splitView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"split.png"]];
    [rightView addSubview:splitView];
    UIButton *saveTaskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveTaskBtn setTitleColor:APP_TITLECOLOR forState:UIControlStateNormal];
    saveTaskBtn.frame = CGRectMake(6, 8, 54, 30);
    [saveTaskBtn addTarget:self action:@selector(editContent:) forControlEvents:UIControlEventTouchUpInside];
    saveTaskBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    [saveTaskBtn setTitle:@"确认" forState:UIControlStateNormal];
    [rightView addSubview:saveTaskBtn];
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    [saveButtonItem release];
    [splitView release];
    [rightView release];
    
    UILabel *subjectTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width - 20, 16)];
    subjectTitleLabel.font = [UIFont boldSystemFontOfSize:16];
    subjectTitleLabel.backgroundColor = [UIColor clearColor];
    subjectTitleLabel.textColor = [UIColor colorWithRed:160.0/255 green:153.0/255 blue:147.0/255 alpha:1];
    subjectTitleLabel.text = @"任务描述";
    [self.view addSubview:subjectTitleLabel];
    [subjectTitleLabel release];
    
    UIView *subjectInfoView = [[UIView alloc] initWithFrame:CGRectMake(10, 36, self.view.bounds.size.width - 20, 106)];
    subjectInfoView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detailcreate_panel.png"]];
    [self.view addSubview:subjectInfoView];
    
    subjectTextView = [[GCPlaceholderTextView alloc] init];
    subjectTextView.frame = CGRectMake(0, 0, self.view.bounds.size.width - 19, 105);
    subjectTextView.font = [UIFont systemFontOfSize:16.0f];
    subjectTextView.placeholder = @"写点什么";
    subjectTextView.delegate = self;
    subjectTextView.backgroundColor = [UIColor clearColor];
    subjectTextView.textColor = [UIColor colorWithRed:93.0/255 green:81.0/255 blue:73.0/255 alpha:1];
    subjectTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    subjectTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [subjectInfoView addSubview:subjectTextView];
    
    UILabel *bodyTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, self.view.bounds.size.width - 20, 16)];
    bodyTitleLabel.font = [UIFont boldSystemFontOfSize:16];
    bodyTitleLabel.backgroundColor = [UIColor clearColor];
    bodyTitleLabel.textColor = [UIColor colorWithRed:160.0/255 green:153.0/255 blue:147.0/255 alpha:1];
    bodyTitleLabel.text = @"补充信息";
    [self.view addSubview:bodyTitleLabel];
    [bodyTitleLabel release];
    
    UIView *bodyInfoView = [[UIView alloc] initWithFrame:CGRectMake(10, 176, self.view.bounds.size.width - 20, 106)];
    bodyInfoView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detailcreate_panel.png"]];
    [self.view addSubview:bodyInfoView];
    
    bodyTextView = [[GCPlaceholderTextView alloc] init];
    bodyTextView.frame = CGRectMake(0, 0, self.view.bounds.size.width - 19, 105);
    bodyTextView.font = [UIFont systemFontOfSize:16.0f];
    bodyTextView.placeholder = @"写点什么";
    bodyTextView.delegate = self;
    bodyTextView.backgroundColor = [UIColor clearColor];
    bodyTextView.textColor = [UIColor colorWithRed:93.0/255 green:81.0/255 blue:73.0/255 alpha:1];
    bodyTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    bodyTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [bodyInfoView addSubview:bodyTextView];
    
    if(taskDetailDict != nil) {
        subjectTextView.text = [taskDetailDict objectForKey:@"subject"];
    }
    
    [subjectTextView becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc
{
    [enterpriseService release];
    [subjectTextView release];
    [bodyTextView release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - TextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"@"]) {
        [self performSelector:@selector(searchUser:) withObject:nil afterDelay:0.5];
    }
    return YES;
}

#pragma mark - ASIHTTPRequest

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"【请求任务响应数据】%@\n【返回状态码】%d", request.responseString, request.responseStatusCode);
    
    NSDictionary *userInfo = request.userInfo;
    NSString *requestType = [userInfo objectForKey:REQUEST_TYPE];
    
    if([requestType isEqualToString:@"UpdateTask"]) {
        if(request.responseStatusCode == 200) {
            [Tools  close:self.HUD];
            
            [delegate setSubject:subjectTextView.text];
            
            [self goBack:nil];
        }
        else
        {
            [Tools failed:self.HUD];
        }
    }
}

#pragma mark - 私有方法

- (void)goBack:(id)sender
{
    [Tools layerTransition:self.navigationController.view from:@"left"];
    //[self.navigationController popToViewController:prevViewController animated:YES];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)editContent:(id)sender
{
    NSString *subject = subjectTextView.text;
    NSString *body = bodyTextView.text;
    if([subject isEqualToString:@""]) {
        [Tools alert:@"请填写任务描述"];
        return;
    }
    [taskDetailDict setObject:subject forKey:@"subject"];
    [taskDetailDict setObject:body forKey:@"body"];
    
    NSString *dueTime = [taskDetailDict objectForKey:@"dueTime"];
    NSString *assigneeWorkId = [taskDetailDict objectForKey:@"assigneeWorkId"];
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
    
    [subjectTextView resignFirstResponder];
}

- (void)searchUser:(id)sender
{
    SearchUserViewController *searchUserController = [[[SearchUserViewController alloc] init] autorelease];
    searchUserController.delegate = self;
    searchUserController.type = 2;
    [Tools layerTransition:self.navigationController.view from:@"right"];
    [self.navigationController pushViewController:searchUserController animated:NO];
}

- (void)modifyAssignee:(NSMutableDictionary*)assignee
{
    
}
- (void)modifyRelated:(NSMutableDictionary*)related
{
    
}
- (void)writeName:(NSString*)displayname
{
    NSArray *array = [displayname componentsSeparatedByString: @"-"];
    NSString *name;
    if(array.count == 0) {
        name = displayname;
    }
    else {
        name = [array objectAtIndex: 0];
    }
    
    NSString *subject = subjectTextView.text;
    subjectTextView.text = [NSString stringWithFormat:@"%@%@", subject, name];
}

- (void)viewClick:(id)sender
{
    NSLog(@"viewClick");
    [subjectTextView resignFirstResponder];
    [bodyTextView resignFirstResponder];
}

@end
