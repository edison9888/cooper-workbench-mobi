//
//  TaskCommentCreateViewController.m
//  CooperApp
//
//  Created by sunleepy on 13-1-5.
//  Copyright (c) 2013年 codesharp. All rights reserved.
//

#import "TaskCommentCreateViewController.h"
#import "AppDelegate.h"

@implementation TaskCommentCreateViewController

@synthesize type;
@synthesize commentDict;
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

    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(appDelegate.isJASideClicked == NO && MODEL_VERSION >= 6.0) {
        CGRect frame = self.view.bounds;
        frame.origin.y -= 19.9f;
        self.view.bounds = frame;
    }
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detailcreate_bg.png"]];
	
    enterpriseService = [[EnterpriseService alloc] init];
    
    textTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
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
    [saveTaskBtn addTarget:self action:@selector(addComment:) forControlEvents:UIControlEventTouchUpInside];
    saveTaskBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    [saveTaskBtn setTitle:@"确认" forState:UIControlStateNormal];
    [rightView addSubview:saveTaskBtn];
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    [saveButtonItem release];
    [splitView release];
    [rightView release];
    
    UIView *detailInfoView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width - 20, 106)];
    detailInfoView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detailcreate_panel.png"]];
    [self.view addSubview:detailInfoView];
    
    commentTextView = [[GCPlaceholderTextView alloc] init];
    commentTextView.frame = CGRectMake(0, 0, self.view.bounds.size.width - 19, 105);
    commentTextView.font = [UIFont systemFontOfSize:16.0f];
    commentTextView.placeholder = @"写点什么";
    commentTextView.delegate = self;
    commentTextView.backgroundColor = [UIColor clearColor];
    commentTextView.textColor = [UIColor colorWithRed:93.0/255 green:81.0/255 blue:73.0/255 alpha:1];
    commentTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    commentTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [detailInfoView addSubview:commentTextView];
    
    if(type == 1) {
        NSString *creatorName = [commentDict objectForKey:@"creatorName"];
        commentTextView.text = [NSString stringWithFormat:@"回复@%@ ", creatorName];
    }
    
    [commentTextView becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc
{
    [enterpriseService release];
    [commentTextView release];
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
    
    if([requestType isEqualToString:@"CreateTaskComment"]) {
        if(request.responseStatusCode == 200) {
            [Tools  close:self.HUD];
            
            [delegate reloadView];
//            [delegate setSubject:subjectTextView.text];
            
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

- (void)addComment:(id)sender
{
    NSString *comment = commentTextView.text;
    if([comment isEqualToString:@""]) {
        [Tools alert:@"请填写评论内容"];
        return;
    }
    
    NSString *weiboId = nil;
    weiboId = [taskDetailDict objectForKey:@"weiboId"];
    NSString *taskId = [taskDetailDict objectForKey:@"taskId"];
    NSString *workId = [[Constant instance] workId];
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    [self.HUD show:YES];
    self.HUD.labelText = @"正在提交";
    NSMutableDictionary *context = [NSMutableDictionary dictionary];
    [context setObject:@"CreateTaskComment" forKey:REQUEST_TYPE];
    [enterpriseService createTaskComment:weiboId
                                      taskId:taskId
                                      workId:workId
                                    content:comment
                                     context:context
                                    delegate:self];
    
    [commentTextView resignFirstResponder];
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
    
    NSString *comment = commentTextView.text;
    commentTextView.text = [NSString stringWithFormat:@"%@%@ ", comment, name];
}

@end
