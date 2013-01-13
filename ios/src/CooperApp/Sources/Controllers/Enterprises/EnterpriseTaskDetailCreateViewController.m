//
//  EnterpriseTaskDetailCreateViewController.m
//  CooperNative
//
//  Created by sunleepy on 12-12-16.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "EnterpriseTaskDetailCreateViewController.h"

@implementation EnterpriseTaskDetailCreateViewController

//@synthesize dueDateLabel;
//@synthesize priorityButton;
//@synthesize statusButton;
//@synthesize subjectTextField;
//@synthesize bodyTextView;
//@synthesize bodyScrollView;
//@synthesize bodyCell;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
//    viewCenter = self.view.center;
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:UIKeyboardWillShowNotification
//                                                  object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:UIKeyboardWillHideNotification
//                                                  object:nil];
}

- (void)dealloc
{
//    [enterpriseService release];
//    [taskDetailDict release];
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

- (void)initContentView
{
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick:)];
    [self.view addGestureRecognizer:recognizer];
    [recognizer release];

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
    [saveTaskBtn addTarget:self action:@selector(newTask:) forControlEvents:UIControlEventTouchUpInside];
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

    if(createType == 0) {
        subjectTextView = [[GCPlaceholderTextView alloc] init];
        subjectTextView.frame = CGRectMake(10, 10, 279, 85);
        subjectTextView.font = [UIFont systemFontOfSize:16.0f];
        subjectTextView.placeholder = @"写点什么";
        subjectTextView.delegate = self;
        subjectTextView.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1];
        subjectTextView.textColor = [UIColor colorWithRed:93.0/255 green:81.0/255 blue:73.0/255 alpha:1];
        subjectTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        subjectTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [detailInfoView addSubview:subjectTextView];

        [subjectTextView becomeFirstResponder];
    }
    else if(createType == 1) {
        NSString *attachmentId = [taskDetailDict objectForKey:@"attachmentId"];
        if(attachmentId != nil) {
            UIButton *attachmentBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 85, 85)];
            [attachmentBtn setBackgroundImage:[UIImage imageNamed:@"detailcreate_audioflag.png"] forState:UIControlStateNormal];
            [attachmentBtn addTarget:self action:@selector(startPhoto:) forControlEvents:UIControlEventTouchUpInside];
            [detailInfoView addSubview:attachmentBtn];

            subjectTextView = [[GCPlaceholderTextView alloc] init];
            subjectTextView.frame = CGRectMake(105, 10, 185, 85);
            subjectTextView.font = [UIFont systemFontOfSize:16.0f];
            subjectTextView.placeholder = @"写点什么";
            subjectTextView.delegate = self;
            subjectTextView.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1];
            subjectTextView.textColor = [UIColor colorWithRed:93.0/255 green:81.0/255 blue:73.0/255 alpha:1];
            subjectTextView.autocorrectionType = UITextAutocorrectionTypeNo;
            subjectTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
            [detailInfoView addSubview:subjectTextView];

            [subjectTextView becomeFirstResponder];
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

            subjectTextView = [[GCPlaceholderTextView alloc] init];
            subjectTextView.frame = CGRectMake(105, 10, 185, 85);
            subjectTextView.font = [UIFont systemFontOfSize:16.0f];
            subjectTextView.placeholder = @"写点什么";
            subjectTextView.delegate = self;
            subjectTextView.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1];
            subjectTextView.textColor = [UIColor colorWithRed:93.0/255 green:81.0/255 blue:73.0/255 alpha:1];
            subjectTextView.autocorrectionType = UITextAutocorrectionTypeNo;
            subjectTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
            [detailInfoView addSubview:subjectTextView];

            [subjectTextView becomeFirstResponder];
        }
    }

    UIView *assigneePanelView = [[UIView alloc] initWithFrame:CGRectMake(10, 126, 300, 70)];

    UILabel *assigneeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
    assigneeTitleLabel.textColor = [UIColor colorWithRed:158.0/255 green:154.0/255 blue:150.0/255 alpha:1];
    assigneeTitleLabel.backgroundColor = [UIColor clearColor];
    assigneeTitleLabel.text = @"任务分配";
    assigneeTitleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    [assigneePanelView addSubview:assigneeTitleLabel];
    
    UIView *assigneeView = [[UIView alloc] initWithFrame:CGRectMake(0, 26, 270, 44)];
    assigneeView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detailcreate_assignee.png"]];
    
    NSMutableArray *assignMembers = [NSMutableArray array];
    [assignMembers addObject:@"萧玄"];
    [assignMembers addObject:@"何望"];
    [assignMembers addObject:@"何望"];
    [assignMembers addObject:@"何望"];
    [assignMembers addObject:@"何望"];
    
//    FillLabelView *fillLabelView = [[FillLabelView alloc] initWithFrame:CGRectMake(10, 7, 232, 0)];
//    //fillLabelView.layer.borderWidth = 1.0f;
//    //fillLabelView.layer.borderColor = [[UIColor blueColor] CGColor];
//    [fillLabelView bindTags:assignMembers backgroundColor:[UIColor colorWithRed:191.0/255 green:182.0/255 blue:175.0/255 alpha:1] textColor:[UIColor colorWithRed:89.0/255 green:80.0/255 blue:73.0/255 alpha:1] font:[UIFont boldSystemFontOfSize:16.0f] radius:14];
//    [assigneeView addSubview:fillLabelView];

    assigneeBtn = [[CustomButton alloc] initWithFrame:CGRectZero color:[UIColor colorWithRed:191.0/255 green:182.0/255 blue:175.0/255 alpha:1]];
    assigneeBtn.userInteractionEnabled = NO;
    assigneeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [assigneeBtn setTitleColor:[UIColor colorWithRed:89.0/255 green:80.0/255 blue:73.0/255 alpha:1] forState:UIControlStateNormal];
//    [assigneeBtn setTitle:@"萧玄" forState:UIControlStateNormal];
//    CGSize size = CGSizeMake([Tools screenMaxWidth], 10000);
//    CGSize labelsize = [assigneeBtn.titleLabel.text sizeWithFont:assigneeBtn.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
//    CGFloat labelsizeHeight = labelsize.height + 10;
//    assigneeBtn.frame = CGRectMake(10, 7, labelsize.width + 40, labelsizeHeight);

    [assigneeView addSubview:assigneeBtn];

    UIView *assigenChooseView = [[[UIView alloc] initWithFrame:CGRectMake(242, 12, 18, 18)] autorelease];
    assigenChooseView.userInteractionEnabled = YES;
    UIButton *assigneeChooseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    assigneeChooseBtn.userInteractionEnabled = NO;
    [assigneeChooseBtn setBackgroundImage:[UIImage imageNamed:@"detailcreate_assigneeAdd.png"] forState:UIControlStateNormal];
    UITapGestureRecognizer *chooseRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseUser:)];
    [assigenChooseView addGestureRecognizer:chooseRecognizer];
    [chooseRecognizer release];

    [assigenChooseView addSubview:assigneeChooseBtn];
    [assigneeView addSubview:assigenChooseView];

    [assigneePanelView addSubview:assigneeView];

    UIView *assigneeMoreView = [[UIView alloc] initWithFrame:CGRectMake(284, 24, 14, 44)];
    assigneeMoreView.userInteractionEnabled = YES;
    UIButton *assigneeMoreBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 21, 14, 3)];
    assigneeMoreBtn.userInteractionEnabled = NO;
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

    UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(10, 206, 300, 154)];
    moreView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detailcreate_duetime.png"]];

    priorityOptionView = [[PriorityOptionView alloc] initWithFrame:CGRectMake(11, 27, 278, 23)];
    [moreView addSubview:priorityOptionView];
    
    UILabel *dueTimeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 105, 120, 24)];
    dueTimeTitleLabel.backgroundColor = [UIColor clearColor];
    dueTimeTitleLabel.textColor = [UIColor colorWithRed:158.0/255 green:154.0/255 blue:150.0/255 alpha:1];
    dueTimeTitleLabel.text = @"期望完成时间";
    [moreView addSubview:dueTimeTitleLabel];

    dueTimeLabel = [[DatePickerLabel alloc] initWithFrame:CGRectMake(200, 105, 120, 24)];
    dueTimeLabel.backgroundColor = [UIColor clearColor];
    dueTimeLabel.textColor = [UIColor colorWithRed:158.0/255 green:154.0/255 blue:150.0/255 alpha:1];
    //dueTimeLabel.text = @"2012-12-21";
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
    subjectTextView.text = [NSString stringWithFormat:@"%@%@", subject, name];
}

- (void)viewClick:(id)sender
{
    NSLog(@"viewClick");
    [subjectTextView resignFirstResponder];
    [dueTimeLabel resignFirstResponder];
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
    NSString *dueTime = dueTimeLabel.text;
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
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        //资源类型为照相机
        picker.sourceType = sourceType;
        [self presentModalViewController:picker animated:YES];
        [picker release];
    }else {
        NSLog(@"该设备无摄像头");
    }
}

- (void)localPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //资源类型为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

#pragma mark - TextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"@"]) {
        [self performSelector:@selector(searchUser:) withObject:nil afterDelay:0.5];
    }
    return YES;
}

#pragma mark - TableView 事件源

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    if(tableView == detailView) return 1;
////    else if(tableView == assigneeView) return 1;
//    return 1;
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if(tableView == detailView) return 1;
////    else if(tableView == assigneeView) return 1;
//    return 1;
//}
////- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
////{
////    return 2.0f;
////}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(tableView == detailView) {
//        if(indexPath.section == 0 && indexPath.row == 0) {
//            return 100.0f;
//        }
//    }
//    return 35.0f;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell;
//    if(tableView == detailView) {
//        if(indexPath.section == 0) {
//            if(indexPath.row == 0) {
//                cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
//                if(!cell) {
//                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InfoCell"] autorelease];
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                }
//                if(createType == 0) {
//                    subjectTextView = [[GCPlaceholderTextView alloc] init];
//                    subjectTextView.placeholder = @"写点什么";
//                    subjectTextView.frame = CGRectMake(10, 10, cell.frame.size.width - 40, 80);
//                    [cell.contentView addSubview:subjectTextView];
//
//                    [subjectTextView becomeFirstResponder];
//                }
//                else if(createType == 1) {
//                    NSString *attachmentId = [taskDetailDict objectForKey:@"attachmentId"];
//                    if(attachmentId != nil) {
//                        NSString *attachmentThumbUrl = [taskDetailDict objectForKey:@"attachmentThumbUrl"];
//                        //cell.textLabel.text = attachmentFileName;
//                        UIImageView *imageView = [[UIImageView alloc] init];
//                        imageView.frame = CGRectMake(10, 10, 80, 80);
//                        imageView.userInteractionEnabled = YES;
//                        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startPhoto:)];
//                        [imageView addGestureRecognizer:recognizer];
//                        [recognizer release];
//                        [imageView setImageWithURL:[NSURL URLWithString:attachmentThumbUrl]];
//                        [cell.contentView addSubview:imageView];
//                        [imageView release];
//
//                        subjectTextView = [[GCPlaceholderTextView alloc] init];
//                        subjectTextView.placeholder = @"补充点什么";
//                        subjectTextView.frame = CGRectMake(95, 10, cell.frame.size.width - 125, 80);
//                        [cell.contentView addSubview:subjectTextView];
//
//                        [subjectTextView becomeFirstResponder];
//                    }
//                }
//                else if(createType == 2) {
//                    NSString *pictureId = [taskDetailDict objectForKey:@"pictureId"];
//                    if(pictureId != nil) {
//                        NSString *pictureThumbUrl = [taskDetailDict objectForKey:@"pictureThumbUrl"];
//                        //cell.textLabel.text = attachmentFileName;
//                        UIImageView *imageView = [[UIImageView alloc] init];
//                        imageView.frame = CGRectMake(10, 10, 80, 80);
//                        imageView.userInteractionEnabled = YES;
//                        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startPhoto:)];
//                        [imageView addGestureRecognizer:recognizer];
//                        [recognizer release];
//                        [imageView setImageWithURL:[NSURL URLWithString:pictureThumbUrl]];
//                        [cell.contentView addSubview:imageView];
//                        [imageView release];
//
//                        subjectTextView = [[GCPlaceholderTextView alloc] init];
//                        subjectTextView.placeholder = @"补充点什么";
//                        subjectTextView.frame = CGRectMake(95, 10, cell.frame.size.width - 125, 80);
//                        [cell.contentView addSubview:subjectTextView];
//
//                        [subjectTextView becomeFirstResponder];
//                    }
//                }
//            }
//        }
//    }
//    return cell;
//}

////填充单元格
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell;
//    
//    if(tableView == detailView)
//    {
//        if(indexPath.section == 0)
//        {
//            if(indexPath.row == 0) {
//                cell = [tableView dequeueReusableCellWithIdentifier:@"AttachmentCell"];
//                if(!cell)
//                {
//                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AttachmentCell"] autorelease];
//                }
//                NSString *attachmentId = [taskDetailDict objectForKey:@"attachmentId"];
//                if(attachmentId != nil) {
//                    NSString *attachmentFileName = [taskDetailDict objectForKey:@"attachmentFileName"];
//                    NSString *attachmentThumbUrl = [taskDetailDict objectForKey:@"attachmentThumbUrl"];
//                    cell.textLabel.text = attachmentFileName;
//                    UIImageView *imageView = [[UIImageView alloc] init];
//                    imageView.frame = CGRectMake(0, 0, 40, 40);
//                    [imageView setImageWithURL:[NSURL URLWithString:attachmentThumbUrl]];
//                    [cell.contentView addSubview:imageView];
//                    
//                    //[cell.imageView setImageWithURL:[NSURL URLWithString:attachmentUrl]];
//                }
//            }
//            else if(indexPath.row == 1)
//            {
//                cell = [tableView dequeueReusableCellWithIdentifier:@"DueDateCell"];
//                if(!cell)
//                {
//                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DueDateCell"] autorelease];
//                    cell.textLabel.text = @"截至日期:";
//                    [cell.textLabel setTextColor:[UIColor grayColor]];
//                    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
//                    
//                    dueDateLabel = [[DateLabel alloc] initWithFrame:CGRectZero];
//                    //                    if(![[task.editable stringValue] isEqualToString:[[NSNumber numberWithInt:0] stringValue]])
//                    //                    {
//                    UITapGestureRecognizer *recog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectDueDate)];
//                    [self.dueDateLabel addGestureRecognizer:recog];
//                    self.dueDateLabel.delegate = self;
//                    [recog release];
//                    dueDateLabel.userInteractionEnabled = YES;
//                    //                    }
//                    //                    else
//                    //                    {
//                    //                        dueDateLabel.userInteractionEnabled = NO;
//                    //                    }
//                    [self.dueDateLabel setTitle:@"请选择    >" forState:UIControlStateNormal];
//                }
//
//                CGSize size = CGSizeMake([Tools screenMaxWidth],10000);
//                CGSize labelsize = [dueDateLabel.titleLabel.text sizeWithFont:dueDateLabel.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
//                [dueDateLabel setFrame:CGRectMake(110, 8, labelsize.width + 40, labelsize.height + 10)];
//                [cell.contentView addSubview:dueDateLabel];
//            }
//            else if(indexPath.row == 2)
//            {
//                cell = [tableView dequeueReusableCellWithIdentifier:@"PriorityCell"];
//                if(!cell)
//                {
//                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PriorityCell"] autorelease];
//                    cell.textLabel.text = @"优先级:";
//                    [cell.textLabel setTextColor:[UIColor grayColor]];[cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
//                    
//                    priorityButton = [[PriorityButton alloc] initWithFrame:CGRectZero];
//                    
//                    //                    if(![[task.editable stringValue] isEqualToString: [[NSNumber numberWithInt:0] stringValue]])
//                    //                    {
//                    UITapGestureRecognizer *recog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPriority)];
//                    [priorityButton addGestureRecognizer:recog];
//                    priorityButton.delegate = self;
//                    [recog release];
//                    priorityButton.userInteractionEnabled = YES;
//                    //                    }
//                    //                    else
//                    //                    {
//                    //                        priorityButton.userInteractionEnabled = NO;
//                    //                    }
//                    
//                    [priorityButton setTitle:[NSString stringWithFormat:@"%@    >",PRIORITY_TITLE_1] forState:UIControlStateNormal];
//                }
//
//                CGSize size = CGSizeMake([Tools screenMaxWidth],10000);
//                CGSize labelsize = [priorityButton.titleLabel.text sizeWithFont:priorityButton.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
//                [priorityButton setFrame:CGRectMake(110, 8, labelsize.width + 40, labelsize.height + 10)];
//                [cell.contentView addSubview:priorityButton];
//            }
//            else if(indexPath.row == 3)
//            {
//                cell = [tableView dequeueReusableCellWithIdentifier:@"AssigneeCell"];
//                if(!cell)
//                {
//                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"AssigneeCell"] autorelease];
//                    cell.textLabel.text = @"当前处理人:";
//                    [cell.textLabel setTextColor:[UIColor grayColor]];[cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
//                    
//                    assigneeView = [[UIView alloc] initWithFrame:CGRectZero];
//                    //                    if(![[task.editable stringValue] isEqualToString:[[NSNumber numberWithInt:0] stringValue]])
//                    //                    {
//                    assigneeView.userInteractionEnabled = YES;
//                    //                    }
//                    //                    else
//                    //                    {
//                    //                        assigneeView.userInteractionEnabled = NO;
//                    //                    }
//                    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAssignee:)];
//                    [assigneeView addGestureRecognizer:recognizer];
//                    [recognizer release];
//                    [cell.contentView addSubview:assigneeView];
//                }
//                
//                NSString *assigneeName = TEST_USERDISPLAYNAME;
//                if(assigneeName != nil && ![assigneeName isEqualToString:@""])
//                {
//                    CustomButton *assigneeBtn = [[CustomButton alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"btn_bg_gray.png"]];
//                    assigneeBtn.userInteractionEnabled = NO;
//                    [assigneeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                    [assigneeBtn setTitle:assigneeName forState:UIControlStateNormal];
//                    CGSize size = CGSizeMake([Tools screenMaxWidth], 10000);
//                    CGSize labelsize = [assigneeBtn.titleLabel.text sizeWithFont:priorityButton.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
//                    CGFloat labelsizeHeight = labelsize.height + 10;
//                    assigneeBtn.frame = CGRectMake(0, 8, labelsize.width + 40, labelsizeHeight);
//                    [assigneeView addSubview:assigneeBtn];
//                    [assigneeBtn release];
//                    
//                    assigneeView.frame = CGRectMake(110, 0, [Tools screenMaxWidth] - 110, labelsizeHeight);
//                    
//                    [cell setFrame:CGRectMake(0, 0, [Tools screenMaxWidth], labelsizeHeight + 15)];
//                }
//
////                if(task != nil)
////                {
////                    currentAssigneeId = task.assigneeId;
////                }
////
////                TeamMember *teamMember = [teamMemberDao getTeamMemberByTeamId:currentTeamId assigneeId:currentAssigneeId];
////                if(teamMember != nil)
////                {
////                    currentAssigneeId = teamMember.id;
////
////                    CustomButton *memberBtn = [[CustomButton alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"btn_bg_gray.png"]];
////                    memberBtn.userInteractionEnabled = NO;
////                    [memberBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
////                    [memberBtn setTitle:teamMember.name forState:UIControlStateNormal];
////                    CGSize size = CGSizeMake([Tools screenMaxWidth],10000);
////                    CGSize labelsize = [memberBtn.titleLabel.text sizeWithFont:priorityButton.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
////                    CGFloat labelsizeHeight = labelsize.height + 10;
////                    memberBtn.frame = CGRectMake(0, 8, labelsize.width + 40, labelsizeHeight);
////                    [assigneeView addSubview:memberBtn];
////                    [memberBtn release];
////
////                    assigneeView.frame = CGRectMake(110, 0, [Tools screenMaxWidth] - 110, labelsizeHeight);
////
////                    [cell setFrame:CGRectMake(0, 0, [Tools screenMaxWidth], labelsizeHeight + 15)];
////                }
////                else
////                {
////                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, 120, 30)];
////                    label.textColor = [UIColor grayColor];
////                    label.text = @"none";
////                    [assigneeView addSubview:label];
////                    [label release];
////
////                    assigneeView.frame = CGRectMake(110, 0, [Tools screenMaxWidth] - 110, 44);
////                }
//            }
//            else if(indexPath.row == 4)
//            {
//                cell = [tableView dequeueReusableCellWithIdentifier:@"SubjectCell"];
//                if(!cell)
//                {
//                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SubjectCell"] autorelease];
//                    cell.textLabel.text = @"标题:";
//                    [cell.textLabel setTextColor:[UIColor grayColor]];[cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
//                    
//                    subjectTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, [Tools screenMaxWidth] - 120, 25)];
//                    subjectTextField.userInteractionEnabled = YES;
//                    [subjectTextField setReturnKeyType:UIReturnKeyDone];
//                    [subjectTextField setTextAlignment:UITextAlignmentLeft];
//                    [subjectTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
//                    [subjectTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
//                    [subjectTextField setPlaceholder:@"标题"];
//                    [subjectTextField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
//                    [cell.contentView addSubview:subjectTextField];
//                }
//                
//            }
//            else if(indexPath.row == 5)
//            {
//                cell = [tableView dequeueReusableCellWithIdentifier:@"BodyCell"];
//                if(!cell)
//                {
//                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"BodyCell"] autorelease];
//                    
//                    bodyTextView = [[BodyTextView alloc] initWithFrame:self.view.frame];
//                    bodyTextView.userInteractionEnabled = YES;
//                    [bodyTextView setAutocapitalizationType:UITextAutocapitalizationTypeNone];
//                    [bodyTextView setAutocorrectionType:UITextAutocorrectionTypeNo];
//                    bodyTextView.returnKeyType = UIReturnKeyDefault;
//                    bodyTextView.keyboardType = UIReturnKeyDone;
//                    bodyTextView.scrollEnabled = YES;
//                    bodyTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//                    bodyTextView.delegate = self;
//                    bodyTextView.bodyDelegate = self;
//                    [bodyTextView setFont:[UIFont systemFontOfSize:16]];
//                    
//                    bodyScrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 240)] autorelease];
//                    [bodyScrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
//                    [bodyScrollView setContentSize:bodyTextView.frame.size];
//                    [bodyScrollView addSubview:bodyTextView];
//                    
//                    [cell addSubview:bodyScrollView];
//                    
//                    bodyCell = cell;
//                }
//                
//                int totalheight = bodyTextView.contentSize.height;
//                [cell setFrame:CGRectMake(0, 0, [Tools screenMaxWidth], totalheight + 200)];
//            }
//        }
//    }
//    
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = (UITableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
//    return cell.frame.size.height;
//}
//
//- (void)tableViewCell:(DateLabel *)label didEndEditingWithDate:(NSDate *)value
//{
//    [self.dueDateLabel setTitle:[NSString stringWithFormat:@"%@    >", [Tools ShortNSDateToNSString:value]] forState:UIControlStateNormal];
//    
//    NSString *dueTime = [value copy];
//    [taskDetailDict setObject:dueTime forKey:@"dueTime"];
//    
//    CGSize size = CGSizeMake(320,10000);
//    CGSize labelsize = [dueDateLabel.titleLabel.text sizeWithFont:dueDateLabel.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
//    [dueDateLabel setFrame:CGRectMake(110, 8, labelsize.width + 40, labelsize.height + 10)];
//    
//    //    [delegate loadTaskData];
//}
//
//- (void)tableViewCell:(PriorityButton *)button didEndEditingWithValue:(NSString *)value
//{
//    [self.priorityButton setTitle:[NSString stringWithFormat:@"%@    >", value] forState:UIControlStateNormal];
//    NSNumber *priority = [self getPriorityKey:value];
//    [taskDetailDict setObject:priority forKey:@"priority"];
//    
//    CGSize size = CGSizeMake(320,10000);
//    CGSize labelsize = [priorityButton.titleLabel.text sizeWithFont:priorityButton.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
//    [priorityButton setFrame:CGRectMake(110, 8, labelsize.width + 40, labelsize.height + 10)];
//}
//
//-(void)textFieldDoneEditing:(id)sender
//{
//    NSString *subject = self.subjectTextField.text;
//    [taskDetailDict setObject:subject forKey:@"subject"];
//
//    [sender resignFirstResponder];
//}
//
//- (void)returnData
//{
//    NSString *body = bodyTextView.text;
//    [taskDetailDict setObject:body forKey:@"body"];
//}
//
//- (void)selectDueDate
//{
//    [self.dueDateLabel becomeFirstResponder];
//}
//
//- (void)selectPriority
//{
//    [self.priorityButton becomeFirstResponder];
//}
//
//- (BOOL)taskIsFinish
//{
//    return [statusButton.titleLabel.text isEqualToString:@"完成    >"];
//}
//
//- (void)switchStatus
//{
//    //    if([[task.editable stringValue] isEqualToString:[[NSNumber numberWithInt:0] stringValue]])
//    //        return;
//    
//    bool isfinish;
//    if([statusButton.titleLabel.text isEqualToString:@"未完成    >"])
//    {
//        [statusButton setTitle:@"完成    >" forState:UIControlStateNormal];
//        [statusButton setBackgroundImage:[UIImage imageNamed:@"btn_bg_green.png"] forState:UIControlStateNormal];
//        [statusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        
//        isfinish = YES;
//        
//    }
//    else
//    {
//        [statusButton setTitle:@"未完成    >" forState:UIControlStateNormal];
//        [statusButton setBackgroundImage:[UIImage imageNamed:@"btn_bg_gray.png"] forState:UIControlStateNormal];
//        [statusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        
//        isfinish = NO;
//    }
//    
//    NSNumber *isCompleted = [NSNumber numberWithInt: isfinish ? 1 : 0];
//    [taskDetailDict setObject:isCompleted forKey:@"isCompleted"];
//    
//    CGSize size = CGSizeMake(320,10000);
//    CGSize labelsize = [statusButton.titleLabel.text sizeWithFont:statusButton.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
//    [statusButton setFrame:CGRectMake(110, 8, labelsize.width + 40, labelsize.height + 10)];
//}
//
//- (void)selectAssignee:(id)sender
//{
//    //    if (teamTaskOptionViewController == nil)
//    //    {
//    //        teamTaskOptionViewController = [[TeamTaskOptionViewController alloc] init];
//    //    }
//    //
//    //    teamTaskOptionViewController.currentTask = task;
//    //    teamTaskOptionViewController.selectMultiple = NO;
//    //    teamTaskOptionViewController.optionType = 1;
//    //    teamTaskOptionViewController.currentTeamId = currentTeamId;
//    //    teamTaskOptionViewController.currentProjectId = currentProjectId;
//    //    teamTaskOptionViewController.currentMemberId = currentMemberId;
//    //    teamTaskOptionViewController.currentTag = currentTag;
//    //    teamTaskOptionViewController.delegate = self;
//    //
//    //    [Tools layerTransition:self.navigationController.view from:@"right"];
//    //    [self.navigationController pushViewController:teamTaskOptionViewController animated:NO];
//}
//
//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    NSLog(@"height:%f",textView.contentSize.height);
//    
//    CGFloat totalheight = bodyTextView.contentSize.height;
//    
//    //    CGPoint center = viewCenter;
//    
//    //    float height = 116.0 + [Tools screenMaxHeight] - 480;
//    //    if(totalheight > height)
//    //    {
//    //        CGFloat line = (totalheight - height) / 50.0;
//    //
//    //
//    //        center.y -= 256 + 50 * line;
//    //        center.y += 120.0f;
//    //        self.view.center = center;
//    //    }
//    //    else {
//    //        center.y -= 256;
//    //        center.y += 120.0f;
//    //        self.view.center = center;
//    //    }
//    
//    //TODO:目前是无效的，后面处理
//    [bodyScrollView setContentSize:bodyTextView.contentSize];
//    
//    CGRect rect = bodyCell.frame;
//    rect.size.height = totalheight;
//    bodyCell.frame = rect;
//    
//    return YES;
//}
//
//- (void)keyboardWillShow:(NSNotification *)aNotification
//{
//	CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    NSTimeInterval animationDuration =
//	[[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    CGPoint center = viewCenter;
//    NSLog(@"key:%f", keyboardRect.size.height);
//    center.y -= keyboardRect.size.height;
//    center.y += 120.0f;
//    self.view.center = center;
//    [UIView setAnimationDuration:animationDuration];
//    [UIView commitAnimations];
//}
//
//- (void)keyboardWillHide:(NSNotification *)aNotification
//{
//    NSTimeInterval animationDuration =
//	[[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    self.view.center = viewCenter;
//    [UIView setAnimationDuration:animationDuration];
//    [UIView commitAnimations];
//}
//- (NSNumber*)getPriorityKey:(NSString*)priorityValue
//{
//    if([priorityValue isEqualToString:PRIORITY_TITLE_1])
//        return [NSNumber numberWithInt:0];
//    else if([priorityValue isEqualToString:PRIORITY_TITLE_2])
//        return [NSNumber numberWithInt:1];
//    else if([priorityValue isEqualToString:PRIORITY_TITLE_3])
//        return [NSNumber numberWithInt:2];
//    return [NSNumber numberWithInt:0];
//}
//- (NSString*)getPriorityValue:(NSString*)priorityKey
//{
//    if([priorityKey isEqualToString:@"0"])
//        return PRIORITY_TITLE_1;
//    else if([priorityKey isEqualToString:@"1"])
//        return PRIORITY_TITLE_2;
//    else if([priorityKey isEqualToString:@"2"])
//        return PRIORITY_TITLE_3;
//    return PRIORITY_TITLE_1;
//}
//
////- (void)modifyAssignee:(NSString*)assignee
////{
////    currentAssigneeId = assignee;
////}
////- (void)modifyProjects:(NSString*)projects
////{
////    currentProjects = projects;
////}
////- (void)modifyTags:(NSString*)tags
////{
////    currentTags = tags;
////}
//
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"【请求任务响应数据】%@\n【返回状态码】%d", request.responseString, request.responseStatusCode);
    
    NSDictionary *userInfo = request.userInfo;
    NSString *requestType = [userInfo objectForKey:REQUEST_TYPE];
    
    if([requestType isEqualToString:@"CreateTaskAttach"])
    {
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
    SearchUserViewController *searchUserController = [[[SearchUserViewController alloc] init] autorelease];
    searchUserController.delegate = self;
    searchUserController.type = 2;
    [Tools layerTransition:self.navigationController.view from:@"right"];
    [self.navigationController pushViewController:searchUserController animated:NO];
}

//#pragma mark - 私有方法
//
//- (void)initContentView
//{
//    self.title = @"任务编辑";
//    
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backBtn setFrame:CGRectMake(5, 5, 25, 25)];
//    [backBtn setBackgroundImage:[UIImage imageNamed:BACK_IMAGE] forState:UIControlStateNormal];
//    [backBtn addTarget: self action: @selector(goBack:) forControlEvents: UIControlEventTouchUpInside];
//    UIBarButtonItem *backButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backBtn] autorelease];
//    self.navigationItem.leftBarButtonItem = backButtonItem;
//    
//    CustomButton *saveTaskBtn = [[[CustomButton alloc] initWithFrame:CGRectMake(5,5,50,30) image:[UIImage imageNamed:@"btn_center.png"]] autorelease];
//    saveTaskBtn.layer.cornerRadius = 6.0f;
//    [saveTaskBtn.layer setMasksToBounds:YES];
//    [saveTaskBtn addTarget:self action:@selector(saveTask:) forControlEvents:UIControlEventTouchUpInside];
//    [saveTaskBtn setTitle:@"确认" forState:UIControlStateNormal];
//    UIBarButtonItem *saveButton = [[[UIBarButtonItem alloc] initWithCustomView:saveTaskBtn] autorelease];
//    self.navigationItem.rightBarButtonItem = saveButton;
//    
//    CGRect tableViewRect = CGRectMake(0, 0, [Tools screenMaxWidth], [Tools screenMaxHeight]);
//    UITableView* tempTableView = [[[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain] autorelease];
//    tempTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [tempTableView setBackgroundColor:[UIColor whiteColor]];
//    
//    //去掉底部空白
//    UIView *footer = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
//    tempTableView.tableFooterView = footer;
//    
//    detailView = tempTableView;
//    
//    [detailView setAllowsSelection:NO];
//    
//    [self.view addSubview: detailView];
//    detailView.delegate = self;
//    detailView.dataSource = self;
//}
//
//- (void)textView:(JSCoreTextView *)textView linkTapped:(AHMarkedHyperlink *)link
//{
//	WebViewController *webViewController = [[[WebViewController alloc] init] autorelease];
//	[webViewController setUrl:[link URL]];
//	BaseNavigationController *navController = [[[BaseNavigationController alloc] initWithRootViewController:webViewController] autorelease];
//	[navController setModalPresentationStyle:UIModalPresentationFullScreen];
//	[navController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
//    
//	[self presentModalViewController:navController animated:YES];
//}
//
//- (void)goBack:(id)sender
//{
//    [self dismissModalViewControllerAnimated:YES];
//}
//
//- (void)saveTask:(id)sender
//{
//    NSString *dueTime = [taskDetailDict objectForKey:@"dueTime"];
//    NSString *assigneeUserId = [taskDetailDict objectForKey:@"assigneeUserId"];
//    NSNumber *priority = [taskDetailDict objectForKey:@"priority"];
//    
//    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:self.HUD];
//    
//    NSMutableDictionary *context = [NSMutableDictionary dictionary];
//    [context setObject:@"CreateTask" forKey:REQUEST_TYPE];
//    
//    [enterpriseService createTask:TEST_USERID
//                          subject:subjectTextField.text
//                             body:bodyTextView.text
//                          dueTime:dueTime
//                   assigneeUserId:assigneeUserId
//                  relatedUserJson:@""
//                         priority:priority
//                          context:context
//                         delegate:self];
//}

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
        self.title = @"图片上传中...";
        NSMutableDictionary *context = [NSMutableDictionary dictionary];
        [context setObject:@"CreateTaskAttach" forKey:REQUEST_TYPE];
        [enterpriseService createTaskAttach:data
                                   fileName:fileName
                                       type:@"picture"
                                    context:context
                                   delegate:self];
    }
    //关闭相册界面
    [picker dismissModalViewControllerAnimated:YES];
}

@end
