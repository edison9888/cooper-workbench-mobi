//
//  TaskCommentCreateViewController.m
//  CooperApp
//
//  Created by sunleepy on 13-1-5.
//  Copyright (c) 2013年 codesharp. All rights reserved.
//

#import "TaskCommentCreateViewController.h"

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
    [backBtn setFrame:CGRectMake(14, 16, 15, 10)];
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
    saveTaskBtn.frame = CGRectMake(1, 6, 54, 30);
    [saveTaskBtn addTarget:self action:@selector(addComment:) forControlEvents:UIControlEventTouchUpInside];
    saveTaskBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [saveTaskBtn setTitle:@"确认" forState:UIControlStateNormal];
    [rightView addSubview:saveTaskBtn];
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    [saveButtonItem release];
    [splitView release];
    [rightView release];
    
    UIView *detailInfoView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 106)];
    detailInfoView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detailcreate_panel.png"]];
    [self.view addSubview:detailInfoView];
    
    commentTextView = [[GCPlaceholderTextView alloc] init];
    commentTextView.frame = CGRectMake(10, 10, 279, 85);
    commentTextView.font = [UIFont systemFontOfSize:16.0f];
    commentTextView.placeholder = @"写点什么";
    commentTextView.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1];
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

#pragma mark - ASIHTTPRequest

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"【请求任务响应数据】%@\n【返回状态码】%d", request.responseString, request.responseStatusCode);
    
    NSDictionary *userInfo = request.userInfo;
    NSString *requestType = [userInfo objectForKey:REQUEST_TYPE];
    
    if([requestType isEqualToString:@"CreateCommentFeedback"]) {
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
    //[self.navigationController popToViewController:prevViewController animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addComment:(id)sender
{
    NSString *comment = commentTextView.text;
    if([comment isEqualToString:@""]) {
        [Tools alert:@"请填写评论内容"];
        return;
    }
    
    NSString *commentId = nil;
    if(type == 0) {
        commentId = [taskDetailDict objectForKey:@"weiboId"];
    }
    else {
        commentId = [commentDict objectForKey:@"commentId"];
    }
    NSString *taskId = [taskDetailDict objectForKey:@"taskId"];
    NSString *workId = [[Constant instance] workId];
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    [self.HUD show:YES];
    self.HUD.labelText = @"正在提交";
    NSMutableDictionary *context = [NSMutableDictionary dictionary];
    [context setObject:@"CreateCommentFeedback" forKey:REQUEST_TYPE];
    [enterpriseService createCommentFeedback:commentId
                                      taskId:taskId
                                      workId:workId
                                 description:comment
                                     context:context
                                    delegate:self];
    
    [commentTextView resignFirstResponder];
}

@end
