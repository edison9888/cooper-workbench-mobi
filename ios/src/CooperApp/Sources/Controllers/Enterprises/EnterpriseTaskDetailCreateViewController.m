//
//  EnterpriseTaskDetailCreateViewController.m
//  CooperNative
//
//  Created by sunleepy on 12-12-16.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "EnterpriseTaskDetailCreateViewController.h"
#import "AppDelegate.h"

@implementation EnterpriseTaskDetailCreateViewController

@synthesize taskDetailDict;
@synthesize prevViewController;
@synthesize createType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    if(appDelegate.isJASideClicked == NO && MODEL_VERSION >= 6.0) {
//        CGRect frame = self.view.bounds;
//        frame.origin.y -= 19.9f;
//        self.view.bounds = frame;
//    }

    self.navigationController.navigationBarHidden = NO;
    
    if(taskDetailDict == nil) {
        taskDetailDict = [[NSMutableDictionary alloc] init];
    }
    [taskDetailDict setObject:@"" forKey:@"subject"];
    [taskDetailDict setObject:@"" forKey:@"body"];
    [taskDetailDict setObject:@"" forKey:@"dueTime"];
    NSString *workId = [[Constant instance] workId];
    [taskDetailDict setObject:workId forKey:@"creatorWorkId"];
    [taskDetailDict setObject:workId forKey:@"assigneeWorkId"];
    [taskDetailDict setObject:[NSNumber numberWithInt:0] forKey:@"priority"];

    enterpriseService = [[EnterpriseService alloc] init];
    
    
    
    [self initContentView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    viewCenter = self.view.center;
    NSLog("viewCenter: %f, %f",self.view.center.x, self.view.center.y);
    
    [self performSelector:@selector(subjectTextViewClick:) withObject:nil afterDelay:0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)dealloc
{
    [enterpriseService release];
    [taskDetailDict release];
//    [detailView release];
//    [subjectTextView release];
//    [assigneeView release];
//    [priorityControl release];
//    [priorityView release];
//    [dueTimeTextField release];
//    [dueTimeView release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 私有方法

-(void)subjectTextViewClick:(id)sender
{
    [subjectTextView becomeFirstResponder];
}

- (void)initContentView
{
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick:)];
    [self.view addGestureRecognizer:recognizer];
    [recognizer release];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detailcreate_bg.png"]];

    textTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    textTitleLabel.backgroundColor = [UIColor clearColor];
    textTitleLabel.textAlignment = UITextAlignmentCenter;
    textTitleLabel.textColor = APP_TITLECOLOR;
    textTitleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    self.navigationItem.titleView = textTitleLabel;
    textTitleLabel.text = @"创建任务";

    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 38, 45)];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
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
    UIView *splitView = [[UIView alloc] initWithFrame:CGRectMake(5, 9, 1, 26)];
    splitView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"split.png"]];
    [rightView addSubview:splitView];
    UIButton *saveTaskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveTaskBtn setTitleColor:APP_TITLECOLOR forState:UIControlStateNormal];
    saveTaskBtn.frame = CGRectMake(6, 8, 54, 30);
    [saveTaskBtn addTarget:self action:@selector(newTask:) forControlEvents:UIControlEventTouchUpInside];
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

    if(createType == 0) {
        subjectTextView = [[[GCPlaceholderTextView alloc] init] autorelease];
        subjectTextView.frame = CGRectMake(0, 0, self.view.bounds.size.width - 19, 105);
        subjectTextView.font = [UIFont systemFontOfSize:16.0f];
        subjectTextView.placeholder = @"写点什么";
        subjectTextView.delegate = self;
        subjectTextView.backgroundColor = [UIColor clearColor];
        subjectTextView.textColor = [UIColor colorWithRed:93.0/255 green:81.0/255 blue:73.0/255 alpha:1];
        subjectTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        subjectTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [detailInfoView addSubview:subjectTextView];
    }
    else if(createType == 1) {
        NSString *attachmentId = [taskDetailDict objectForKey:@"attachmentId"];
        if(attachmentId != nil) {
            UIButton *attachmentBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 85, 85)];
            [attachmentBtn setBackgroundImage:[UIImage imageNamed:@"detailcreate_audioflag.png"] forState:UIControlStateNormal];
            [attachmentBtn addTarget:self action:@selector(startPhoto:) forControlEvents:UIControlEventTouchUpInside];
            [detailInfoView addSubview:attachmentBtn];

            subjectTextView = [[[GCPlaceholderTextView alloc] init] autorelease];
            subjectTextView.frame = CGRectMake(95, 0, self.view.bounds.size.width - 113, 105);
            subjectTextView.font = [UIFont systemFontOfSize:16.0f];
            subjectTextView.placeholder = @"写点什么";
            subjectTextView.delegate = self;
            subjectTextView.backgroundColor = [UIColor clearColor];
            subjectTextView.textColor = [UIColor colorWithRed:93.0/255 green:81.0/255 blue:73.0/255 alpha:1];
            subjectTextView.autocorrectionType = UITextAutocorrectionTypeNo;
            subjectTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
            [detailInfoView addSubview:subjectTextView];
        }
    }
    else if(createType == 2) {
        NSString *pictureId = [taskDetailDict objectForKey:@"pictureId"];
        if(pictureId != nil) {
            NSString *pictureThumbUrl = [taskDetailDict objectForKey:@"pictureThumbUrl"];
            //cell.textLabel.text = attachmentFileName;
            pictureImageView = [[[UIImageView alloc] init] autorelease];
            pictureImageView.frame = CGRectMake(10, 10, 85, 85);
            pictureImageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startPhoto:)];
            [pictureImageView addGestureRecognizer:recognizer];
            [recognizer release];
            [pictureImageView setImageWithURL:[NSURL URLWithString:pictureThumbUrl]];
            [detailInfoView addSubview:pictureImageView];

            subjectTextView = [[[GCPlaceholderTextView alloc] init] autorelease];
            subjectTextView.frame = CGRectMake(95, 0, self.view.bounds.size.width - 113, 105);
            subjectTextView.font = [UIFont systemFontOfSize:16.0f];
            subjectTextView.placeholder = @"写点什么";
            subjectTextView.delegate = self;
            subjectTextView.backgroundColor = [UIColor clearColor];
            subjectTextView.textColor = [UIColor colorWithRed:93.0/255 green:81.0/255 blue:73.0/255 alpha:1];
            subjectTextView.autocorrectionType = UITextAutocorrectionTypeNo;
            subjectTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
            [detailInfoView addSubview:subjectTextView];
        }
    }

    UIView *assigneePanelView = [[UIView alloc] initWithFrame:CGRectMake(10, 126, self.view.bounds.size.width - 20, 70)];

    UILabel *assigneeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 20, 16)];
    assigneeTitleLabel.textColor = [UIColor colorWithRed:158.0/255 green:154.0/255 blue:150.0/255 alpha:1];
    assigneeTitleLabel.backgroundColor = [UIColor clearColor];
    assigneeTitleLabel.text = @"任务分配";
    assigneeTitleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [assigneePanelView addSubview:assigneeTitleLabel];
    
    UIView *assigneeView = [[UIView alloc] initWithFrame:CGRectMake(0, 21, self.view.bounds.size.width - 50, 44)];
    assigneeView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detailcreate_assignee.png"]];
    
//    FillLabelView *fillLabelView = [[FillLabelView alloc] initWithFrame:CGRectMake(10, 7, 232, 0)];
//    //fillLabelView.layer.borderWidth = 1.0f;
//    //fillLabelView.layer.borderColor = [[UIColor blueColor] CGColor];
//    [fillLabelView bindTags:assignMembers backgroundColor:[UIColor colorWithRed:191.0/255 green:182.0/255 blue:175.0/255 alpha:1] textColor:[UIColor colorWithRed:89.0/255 green:80.0/255 blue:73.0/255 alpha:1] font:[UIFont boldSystemFontOfSize:16.0f] radius:14];
//    [assigneeView addSubview:fillLabelView];

    assigneeBtn = [[CustomButton alloc] initWithFrame:CGRectZero color:[UIColor colorWithRed:191.0/255 green:182.0/255 blue:175.0/255 alpha:1]];
    assigneeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [assigneeBtn setTitleColor:[UIColor colorWithRed:89.0/255 green:80.0/255 blue:73.0/255 alpha:1] forState:UIControlStateNormal];
    
//    [assigneeBtn setTitle:@"萧玄" forState:UIControlStateNormal];
//    CGSize size = CGSizeMake([Tools screenMaxWidth], 10000);
//    CGSize labelsize = [assigneeBtn.titleLabel.text sizeWithFont:assigneeBtn.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
//    CGFloat labelsizeHeight = labelsize.height + 10;
//    assigneeBtn.frame = CGRectMake(10, 7, labelsize.width + 40, labelsizeHeight);

    [assigneeView addSubview:assigneeBtn];

    UIView *assigenChooseView = [[[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 88, 0, 38, 44)] autorelease];
    assigenChooseView.userInteractionEnabled = YES;
    UIButton *assigneeChooseBtn = [[UIButton alloc] initWithFrame:CGRectMake(11, 13, 18, 18)];
    [assigneeChooseBtn addTarget:self action:@selector(chooseUser:) forControlEvents:UIControlEventTouchUpInside];
    [assigneeChooseBtn setBackgroundImage:[UIImage imageNamed:@"detailcreate_assigneeAdd.png"] forState:UIControlStateNormal];
    UITapGestureRecognizer *chooseRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseUser:)];
    [assigenChooseView addGestureRecognizer:chooseRecognizer];
    [chooseRecognizer release];

    [assigenChooseView addSubview:assigneeChooseBtn];
    [assigneeView addSubview:assigenChooseView];

    [assigneePanelView addSubview:assigneeView];

    UIView *assigneeMoreView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 38, 24, 14, 44)];
    assigneeMoreView.userInteractionEnabled = YES;
    UIButton *assigneeMoreBtn = [[UIButton alloc] initWithFrame:CGRectMake(1, 17, 14, 3)];
    [assigneeMoreBtn addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
    [assigneeMoreBtn setBackgroundImage:[UIImage imageNamed:@"detailcreate_more.png"] forState:UIControlStateNormal];
    
    UITapGestureRecognizer *moreRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(more:)];
    [assigneeMoreView addGestureRecognizer:moreRecognizer];
    [moreRecognizer release];
    [assigneeMoreView addSubview:assigneeMoreBtn];
    
    [assigneePanelView addSubview:assigneeMoreView];

    [self.view addSubview:assigneePanelView];

    [assigneeMoreView release];
    [assigneeMoreBtn release];
    [assigneeView release];
    [assigneeTitleLabel release];
    [assigneePanelView release];

    UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(10, 206, self.view.bounds.size.width - 20, 154)];
    moreView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detailcreate_duetime.png"]];

    priorityOptionView = [[PriorityOptionView alloc] initWithFrame:CGRectMake(11, 27, 278, 23)];
    [moreView addSubview:priorityOptionView];
    
    UILabel *dueTimeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 103, 120, 24)];
    dueTimeTitleLabel.backgroundColor = [UIColor clearColor];
    dueTimeTitleLabel.textColor = [UIColor colorWithRed:158.0/255 green:154.0/255 blue:150.0/255 alpha:1];
    dueTimeTitleLabel.text = @"期望完成时间";
    dueTimeTitleLabel.font = [UIFont systemFontOfSize:16];
    dueTimeTitleLabel.userInteractionEnabled = YES;
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectDueTime:)];
    [dueTimeTitleLabel addGestureRecognizer:recognizer];
    dueTimeLabel.delegate = self;
    [recognizer release];
    [moreView addSubview:dueTimeTitleLabel];

    dueTimeLabel = [[DatePickerLabel alloc] initWithFrame:CGRectMake(300-130, 104, 120, 24)];
    dueTimeLabel.backgroundColor = [UIColor clearColor];
    dueTimeLabel.textColor = [UIColor colorWithRed:158.0/255 green:154.0/255 blue:150.0/255 alpha:1];
    dueTimeLabel.font = [UIFont systemFontOfSize:16];
    //dueTimeLabel.text = @"2012-12-21";
    dueTimeLabel.text = @"请选择";
    dueTimeLabel.textAlignment = UITextAlignmentRight;
    dueTimeLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *dueTimeRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectDueTime:)];
    [dueTimeLabel addGestureRecognizer:dueTimeRecognizer];
    dueTimeLabel.delegate = self;
    [dueTimeRecognizer release];
    [moreView addSubview:dueTimeLabel];
    
    [self.view addSubview:moreView];
    [moreView release];
}

- (void)selectDueTime:(id)sender
{
    [dueTimeLabel becomeFirstResponder];
}

- (void)modifyAssignee:(NSMutableDictionary*)assignee
{
    NSString *workId = [assignee objectForKey:@"workId"];
    [taskDetailDict setObject:workId forKey:@"assigneeWorkId"];
    NSString *name = [assignee objectForKey:@"name"];

    [assigneeBtn setTitle:name forState:UIControlStateNormal];
    CGSize size = CGSizeMake([Tools screenMaxWidth], 10000);
    CGSize labelsize = [name sizeWithFont:assigneeBtn.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    CGFloat labelsizeHeight = labelsize.height + 10;
    assigneeBtn.frame = CGRectMake(10, 8, labelsize.width + 40, labelsizeHeight);
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
    subjectTextView.text = [NSString stringWithFormat:@"%@%@ ", subject, name];
}

- (void)viewClick:(id)sender
{
    NSLog(@"viewClick");
    [self performSelector:@selector(subjectTextViewBlur:) withObject:nil afterDelay:0];
   
    [dueTimeLabel resignFirstResponder];
}

- (void)subjectTextViewBlur:(id)sender
{
     [subjectTextView resignFirstResponder];
}

- (void)goBack:(id)sender
{
    [Tools layerTransition:self.navigationController.view from:@"left"];
    [self.navigationController popToViewController:prevViewController animated:NO];
    //[self.navigationController popViewControllerAnimated:YES];
}

- (void)newTask:(id)sender
{
    NSString *creatorWorkId = [taskDetailDict objectForKey:@"creatorWorkId"];
    NSString *subject = subjectTextView.text;
    NSString *dueTime = [dueTimeLabel.text isEqualToString:@"请选择"] ? @"" : dueTimeLabel.text;
    NSString *assigneeWorkId = [taskDetailDict objectForKey:@"assigneeWorkId"];
    NSNumber *priority = [NSNumber numberWithInt: priorityOptionView.selectedIndex];
    NSString *attachmentIds = @"";
    if(createType == 1) {
         attachmentIds = [taskDetailDict objectForKey:@"attachmentId"];
        if (subject == nil || [subject isEqualToString:@""]) {
            subject = [NSString stringWithFormat:@"%@%@", @"语音任务", [Tools ShortNSDateToNSString:[NSDate date]]];
        }
    }
    else if(createType == 2) {
        attachmentIds = [taskDetailDict objectForKey:@"pictureId"];
        if (subject == nil || [subject isEqualToString:@""]) {
            subject = [NSString stringWithFormat:@"%@%@", @"图片任务", [Tools ShortNSDateToNSString:[NSDate date]]];
        }
    }

    self.HUD = [Tools process:@"正在提交" view:self.view];
    NSMutableDictionary *context = [NSMutableDictionary dictionary];
    [context setObject:@"NewTask" forKey:REQUEST_TYPE];
    [enterpriseService newTask:creatorWorkId
                       subject:subject
                       dueTime:dueTime
                assigneeWorkId:assigneeWorkId
                      priority:priority
                 attachmentIds:attachmentIds
                       context:context
                      delegate:self];
}

- (void)chooseUser:(id)sender
{
    NSLog(@"chooseAssigneeUser");
    
    if(self.navigationController.navigationBar.hidden == YES) {
        self.navigationController.navigationBar.hidden = NO;
        self.view.center = viewCenter;
    }
    self.view.center = viewCenter;

    SearchUserViewController *searchUserController = [[[SearchUserViewController alloc] init] autorelease];
    searchUserController.delegate = self;
    searchUserController.type = 0;
    [Tools layerTransition:self.navigationController.view from:@"right"];
    [self.navigationController pushViewController:searchUserController animated:NO];

    //[searchUserController release];
}

- (void)more:(id)sender
{
    [subjectTextView resignFirstResponder];
}

- (void)startPhoto:(id)sender
{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles: @"重新拍照", @"重新从相册选择",nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //拍照
            [self takePhoto];
            
            break;
        case 1:
            //拍照
            [self localPhoto];
            break;
        default:
            break;
    }
}

- (void)takePhoto
{
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        pickerController = [[[UIImagePickerController alloc] init] autorelease];
        pickerController.delegate = self;
        //资源类型为照相机
        pickerController.sourceType = sourceType;
        [self presentModalViewController:pickerController animated:YES];
    }else {
        NSLog(@"该设备无摄像头");
    }
}

- (void)localPhoto
{
    pickerController = [[[UIImagePickerController alloc] init] autorelease];
    //资源类型为图片库
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerController.delegate = self;
    //设置选择后的图片可被编辑
    //picker.allowsEditing = YES;
    [self presentModalViewController:pickerController animated:YES];
}

#pragma mark - TextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"@"]) {
        [self performSelector:@selector(searchUser:) withObject:nil afterDelay:0.5];
    }
    return YES;
}

#pragma mark - ASIHTTPRequestDelgate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"【请求任务响应数据】%@\n【返回状态码】%d", request.responseString, request.responseStatusCode);
    
    NSDictionary *userInfo = request.userInfo;
    NSString *requestType = [userInfo objectForKey:REQUEST_TYPE];
    
    if([requestType isEqualToString:@"CreateTaskAttach"])
    {
        //关闭相册界面
        [pickerController dismissModalViewControllerAnimated:YES];
        
        if(request.responseStatusCode == 200)
        {
            textTitleLabel.text = @"创建任务";
            
            NSDictionary *dict = [[request responseString] JSONValue];
            if(dict)
            {
                NSNumber *state = [dict objectForKey:@"state"];
                
                if(state == [NSNumber numberWithInt:0]) {
                    NSMutableDictionary *data = [dict objectForKey:@"data"];
                    NSString *pictureId = [data objectForKey:@"attachmentId"];
                    NSString *pictureFileName = [data objectForKey:@"fileName"];
                    NSString *pictureUrl = [data objectForKey:@"url"];
                    NSString *pictureThumbUrl = [data objectForKey:@"thumbUrl"];

                    [taskDetailDict setObject:pictureId forKey:@"pictureId"];
                    [taskDetailDict setObject:pictureFileName forKey:@"pictureFileName"];
                    [taskDetailDict setObject:pictureUrl forKey:@"pictureUrl"];
                    [taskDetailDict setObject:pictureThumbUrl forKey:@"pictureThumbUrl"];

                    [pictureImageView setImageWithURL:[NSURL URLWithString:pictureThumbUrl]];
                }
            }
        }
        else
        {
            [Tools failed:self.HUD];
        }
    }
    else if([requestType isEqualToString:@"NewTask"]) {
        [Tools close:self.HUD];
        if(request.responseStatusCode == 200) {
            [self goBack:nil];
        }
        else
        {
            [Tools failed:self.HUD];
        }
    }
    else if([requestType isEqualToString:@"ChangeCompleted"]) {
        if(request.responseStatusCode == 200) {
            //            [detailView reloadData];
        }
        else
        {
            [Tools failed:self.HUD];
        }
    }
    else if([requestType isEqualToString:@"ChangeDueTime"]) {
        if(request.responseStatusCode == 200) {
            //            [detailView reloadData];
        }
        else
        {
            [Tools failed:self.HUD];
        }
    }
    else if([requestType isEqualToString:@"ChangePriority"]) {
        if(request.responseStatusCode == 200) {
            //            [detailView reloadData];
        }
        else
        {
            [Tools failed:self.HUD];
        }
    }
    else if([requestType isEqualToString:@"CreateTask"]) {
        if(request.responseStatusCode == 200) {
            [Tools failed:self.HUD msg:@"创建成功"];
            [self goBack:nil];
        }
        else
        {
            [Tools failed:self.HUD];
        }
    }
}

- (void)searchUser:(id)sender
{
    if(self.navigationController.navigationBar.hidden == YES) {
        self.navigationController.navigationBar.hidden = NO;
        self.view.center = viewCenter;
    }
    self.view.center = viewCenter;
    
    SearchUserViewController *searchUserController = [[[SearchUserViewController alloc] init] autorelease];
    searchUserController.delegate = self;
    searchUserController.type = 2;
    [Tools layerTransition:self.navigationController.view from:@"right"];
    [self.navigationController pushViewController:searchUserController animated:NO];
}

#pragma Delegate method UIImagePickerControllerDelegate

//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    NSLog(@"cancel camara.");
//}

//图像选取器的委托方法，选完图片后回调该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    if (image != nil) {
        
        NSData *data;
        NSString *fileName;
        if (UIImagePNGRepresentation(image)) {
            //返回为png图像
            data = UIImagePNGRepresentation(image);
            fileName = [NSString stringWithFormat:@"%@.%@", [Tools stringWithUUID], @"png"];
        }
        else {
            //返回为JPEG图像
            data = UIImageJPEGRepresentation(image, 1.0);
            fileName = [NSString stringWithFormat:@"%@.%@", [Tools stringWithUUID], @"jpg"];
        }
        //保存到阿里云盘
        self.HUD = [[MBProgressHUD alloc] initWithView:pickerController.view];
        [pickerController.view addSubview:self.HUD];
        [self.HUD show:YES];
        self.HUD.labelText = @"正在上传图片";
        NSMutableDictionary *context = [NSMutableDictionary dictionary];
        [context setObject:@"CreateTaskAttach" forKey:REQUEST_TYPE];
        uploadPicRequest = [enterpriseService createTaskAttach:data
                                   fileName:fileName
                                       type:@"picture"
                                    context:context
                                   delegate:self];
        uploadPicRequest.timeOutSeconds = 10000;
        uploadPicRequest.uploadProgressDelegate = self;
    }
}

- (void)setProgress:(float)newProgress
{
    self.HUD.labelText = [NSString stringWithFormat:@"正在上传图片：%0.f%%", newProgress * 100];
}

#pragma mark - keyboard

- (void)keyboardWillShow:(NSNotification *)aNotification
{
//	CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration =
	[[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    if(self.navigationController.navigationBar.hidden == NO) {
        self.navigationController.navigationBar.hidden = YES;
    }
    CGPoint center = CGPointMake(viewCenter.x, viewCenter.y - 44);
    self.view.center = center;
    [UIView setAnimationDuration:animationDuration];
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    
    NSTimeInterval animationDuration =
	[[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    if(self.navigationController.navigationBar.hidden == YES) {
        self.navigationController.navigationBar.hidden = NO;
    }
    if(viewCenter.y == (([Tools screenMaxHeight] - 20 - 44) / 2 + 22))
    {
        CGPoint center = CGPointMake(viewCenter.x, viewCenter.y + 44);
        viewCenter = center;
    }
    self.view.center = viewCenter;
    [UIView setAnimationDuration:animationDuration];
    [UIView commitAnimations];
    
}

- (void)navigationBarHidden:(id)sender
{
    self.navigationController.navigationBar.hidden = YES;
}

@end
