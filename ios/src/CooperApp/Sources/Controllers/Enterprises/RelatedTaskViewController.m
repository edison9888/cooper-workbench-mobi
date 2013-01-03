//
//  RelatedTaskViewController.m
//  CooperNative
//
//  Created by sunleepy on 12-12-15.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "RelatedTaskViewController.h"
#import "CustomTabBarItem.h"
#import "CustomToolbar.h"

@implementation RelatedTaskViewController

@synthesize taskInfos;
@synthesize taskDetailEditViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
             setTitle:(NSString *)title
             setImage:(NSString*)imageName
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.title = title;
        //底部条
        CustomTabBarItem *tabBarItem = [[CustomTabBarItem alloc] init];
        [tabBarItem setTitle:title];
        [tabBarItem setCustomImage:[UIImage imageNamed:imageName]];
        self.tabBarItem = tabBarItem;
        [tabBarItem release];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    taskInfos = [[NSMutableArray alloc] init];
    
    enterpriseService = [[EnterpriseService alloc] init];
    
    [self initContentView];

    //TODO:兼容iOS4无法触发问题
    [self loadTaskData];
    [self getRelatedTasks];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadTaskData];
    [self getRelatedTasks];
}

- (void)getRelatedTasks
{
    //    self.HUD = [Tools process:LOADING_TITLE view:self.view];
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];

    textTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    textTitleLabel.backgroundColor = [UIColor clearColor];
    textTitleLabel.textAlignment = UITextAlignmentCenter;
    textTitleLabel.textColor = APP_TITLECOLOR;
    textTitleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    self.navigationItem.titleView = textTitleLabel;
    textTitleLabel.text = @"Loading...";
    
    NSString *workId = [[Constant instance] workId];
    NSMutableDictionary *context = [NSMutableDictionary dictionary];
    [context setObject:@"GetRelevantTasks" forKey:REQUEST_TYPE];
    
    [enterpriseService getRelevantTasks:workId
                                context:context
                               delegate:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [emptyView release];
    [taskView release];
    [tabbarView release];
    [enterpriseService release];
    [taskInfos release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view 数据源

//获取TableView的分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//获取在制定的分区编号下的纪录数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [taskInfos count];
}
//填充单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"EnterpriseTaskTableCell";
    EnterpriseTaskTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
	{
        cell = [[EnterpriseTaskTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
	}
    NSMutableDictionary *taskInfoDict = [taskInfos objectAtIndex:indexPath.row];
    [cell setTaskInfo:taskInfoDict];
    cell.delegate = self;
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //cell.showsReorderControl = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    UIView *selectedView = [[UIView alloc] initWithFrame:cell.frame];
    selectedView.backgroundColor = [UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1.0];
    cell.backgroundColor = [UIColor whiteColor];
    
    //设置选中后cell的背景颜色
    cell.selectedBackgroundView = selectedView;
    
    return cell;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:YES animated:YES];
    
    return indexPath;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 28;
//}

- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = (UITableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
	return cell.frame.size.height;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//点击单元格事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    taskDetailEditViewController = [[EnterpriseTaskDetailEditViewController alloc] init];
    
    NSMutableDictionary *taskInfoDict = [self.taskInfos objectAtIndex:indexPath.row];
    NSString *taskId = [taskInfoDict objectForKey:@"id"];
    taskDetailEditViewController.currentTaskId = taskId;
    
    taskDetailEditViewController.hidesBottomBarWhenPushed = YES;
    
    [Tools layerTransition:self.navigationController.view from:@"right"];
    [self.navigationController pushViewController:taskDetailEditViewController animated:NO];
    
    [taskDetailEditViewController release];
}

# pragma 似有方法

- (void)initContentView
{
    NSLog(@"【初始化待办任务列表】");
    
    //任务列表
    taskView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [Tools screenMaxWidth], [Tools screenMaxHeight] - 49 - 64) style:UITableViewStylePlain];
    taskView.separatorStyle = UITableViewCellSeparatorStyleNone;
    taskView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tableview_background.png"]];
    //去掉底部空白
    UIView *footer = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    taskView.tableFooterView = footer;
    taskView.delegate = self;
    taskView.dataSource = self;
    [self.view addSubview: taskView];
    
    //    //底部分割线
    //    TabbarLineView *tabbarLineView = [[TabbarLineView alloc] init];
    //    tabbarLineView.frame = CGRectMake(0, [Tools screenMaxHeight] - 49 - 64, self.view.bounds.size.width, 1);
    //    [self.view addSubview:tabbarLineView];
    //    [tabbarLineView release];
    
    //底部
    tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, [Tools screenMaxHeight] - 49 - 63, [Tools screenMaxWidth], 49)];
    tabbarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background.png"]];
    [self.view addSubview:tabbarView];
    //底部添加音频按钮
    UIView *audioView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 38, 45)];
    
    UIImageView *audioImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 12, 19)];
    UIImage *audioImage = [UIImage imageNamed:@"audio.png"];
    audioImageView.image = audioImage;
    [audioView addSubview:audioImageView];
    audioView.userInteractionEnabled = YES;
    UITapGestureRecognizer *audioRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startAudio:)];
    [audioView addGestureRecognizer:audioRecognizer];
    [audioRecognizer release];
    [tabbarView addSubview:audioView];
    [audioImageView release];
    [audioView release];
    //底部添加文本按钮
    UIView *addView = [[UIView alloc] initWithFrame:CGRectMake([Tools screenMaxWidth] / 2.0 - 23, 0, 38, 45)];
    UIImageView *addImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 19, 19)];
    UIImage *addImage = [UIImage imageNamed:@"text.png"];
    addImageView.image = addImage;
    [addView addSubview:addImageView];
    addView.userInteractionEnabled = YES;
    UITapGestureRecognizer *addRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startAdd:)];
    [addView addGestureRecognizer:addRecognizer];
    [addRecognizer release];
    [tabbarView addSubview:addView];
    [addImageView release];
    [addView release];
    //添加拍照按钮
    UIView *photoView = [[UIView alloc] initWithFrame:CGRectMake([Tools screenMaxWidth] - 10 - 42, 0, 38, 45)];
    UIImageView *photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 19, 17)];
    UIImage *photoImage = [UIImage imageNamed:@"photo.png"];
    photoImageView.image = photoImage;
    [photoView addSubview:photoImageView];
    photoView.userInteractionEnabled = YES;
    UITapGestureRecognizer *photoRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startPhoto:)];
    [photoView addGestureRecognizer:photoRecognizer];
    [photoRecognizer release];
    [tabbarView addSubview:photoView];
    [photoImageView release];
    [photoView release];
}

- (void)loadTaskData
{
    NSLog(@"【开始初始化任务数据】");
    
    [taskView reloadData];
    
    if(taskInfos.count == 0)
    {
        taskView.hidden = YES;
        
        if (!emptyView)
        {
//            UIView *tempemptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, [Tools screenMaxWidth], 100)];
//            tempemptyView.backgroundColor = [UIColor whiteColor];
//            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80 + (([Tools screenMaxWidth] - 320) / 2.0), 0, 200, 30)];
//            label.text = @"点击这里指派一个新任务";
//            label.font = [UIFont boldSystemFontOfSize:16];
//            [tempemptyView addSubview:label];
//            
//            CustomButton *addFirstBtn = [[[CustomButton alloc] initWithFrame:CGRectMake(110 + (([Tools screenMaxWidth] - 320) / 2.0), 50,100,30) image:[UIImage imageNamed:@"btn_center.png"]] autorelease];
//            addFirstBtn.layer.cornerRadius = 6.0f;
//            [addFirstBtn.layer setMasksToBounds:YES];
//            [addFirstBtn addTarget:self action:@selector(addTask:) forControlEvents:UIControlEventTouchUpInside];
//            [addFirstBtn setTitle:@"开始添加" forState:UIControlStateNormal];
//            [tempemptyView addSubview:addFirstBtn];
//            emptyView = tempemptyView;
//            [self.view addSubview:emptyView];
//            
//            [tempemptyView release];
        }
        else
        {
            emptyView.hidden = NO;
        }
    }
    else {
        taskView.hidden = NO;
        emptyView.hidden = YES;
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    textTitleLabel.text = @"相关任务(内测)";
    
    NSLog(@"【请求任务响应数据】%@\n【返回状态码】%d", request.responseString, request.responseStatusCode);
    
    NSDictionary *userInfo = request.userInfo;
    NSString *requestType = [userInfo objectForKey:REQUEST_TYPE];
    
    if([requestType isEqualToString:@"GetRelevantTasks"])
    {
        if(request.responseStatusCode == 200)
        {
            NSDictionary *dict = [[request responseString] JSONValue];
            if(dict)
            {
                NSNumber *state = [dict objectForKey:@"state"];
                
                if(state == [NSNumber numberWithInt:0]) {
                    
                    taskInfos = [[NSMutableArray alloc] init];
                    
                    NSMutableArray *tasks = [dict objectForKey:@"data"];
                    
                    for(NSMutableDictionary *taskDict in tasks)
                    {
                        NSNumber *taskId = [taskDict objectForKey:@"id"];
                        NSString* subject = [taskDict objectForKey:@"subject"] == [NSNull null] ? @"" : [taskDict objectForKey:@"subject"];
                        NSString *body = [taskDict objectForKey:@"body"] == [NSNull null] ? @"" : [taskDict objectForKey:@"body"];
                        NSMutableDictionary *creatorDict = [taskDict objectForKey:@"creator"];
                        NSString *creatorDisplayName = [creatorDict objectForKey:@"displayName"];
                        
                        NSString *source = [taskDict objectForKey:@"source"];
                        NSNumber *isExternal = [taskDict objectForKey:@"isExternal"];
                        NSString *createTime = [taskDict objectForKey:@"createTime"];
                        NSString *dueTime = [taskDict objectForKey:@"dueTime"] == [NSNull null] ? @"" : [taskDict objectForKey:@"dueTime"];
                        NSNumber *priority = [taskDict objectForKey:@"priority"] == [NSNull null] ? [NSNumber numberWithInt:-1] : [taskDict objectForKey:@"priority"];
                        NSNumber *isCompleted = [taskDict objectForKey:@"isCompleted"];
                        NSString *relatedUrl = [taskDict objectForKey:@"relatedUrl"];
                        
                        NSNumber *attachmentCount = [taskDict objectForKey:@"attachmentCount"];
                        NSNumber *picCount = [taskDict objectForKey:@"picCount"];
                        
                        NSMutableDictionary *taskInfoDict = [NSMutableDictionary dictionary];
                        [taskInfoDict setObject:taskId forKey:@"id"];
                        [taskInfoDict setObject:subject forKey:@"subject"];
                        [taskInfoDict setObject:body forKey:@"body"];
                        [taskInfoDict setObject:creatorDisplayName forKey:@"creatorDisplayName"];
                        [taskInfoDict setObject:source forKey:@"source"];
                        [taskInfoDict setObject:isExternal forKey:@"isExternal"];
                        [taskInfoDict setObject:createTime forKey:@"createTime"];
                        [taskInfoDict setObject:dueTime forKey:@"dueTime"];
                        [taskInfoDict setObject:priority forKey:@"priority"];
                        [taskInfoDict setObject:isCompleted forKey:@"isCompleted"];
                        [taskInfoDict setObject:relatedUrl forKey:@"relateUrl"];
                        [taskInfoDict setObject:attachmentCount forKey:@"attachmentCount"];
                        [taskInfoDict setObject:picCount forKey:@"picCount"];
                        
                        [taskInfos addObject:taskInfoDict];
                    }
                    
                    [self loadTaskData];
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
    else if([requestType isEqualToString:@"ChangeCompleted"]) {
        if(request.responseStatusCode == 200) {
            //TODO:正常ok
        }
        else {
            [Tools failed:self.HUD];
        }
    }
}

- (void)goBack:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)startAudio:(id)sender
{
    audioActionSheet = [[UIActionSheet alloc]
                        initWithTitle:nil
                        delegate:self
                        cancelButtonTitle:@"取消"
                        destructiveButtonTitle:nil
                        otherButtonTitles: @"开始录音",nil];
    [audioActionSheet showInView:self.view];
}

- (void)startAdd:(id)sender
{
    EnterpriseTaskDetailCreateViewController *taskDetailCreateViewController = [[EnterpriseTaskDetailCreateViewController alloc] init];

    taskDetailCreateViewController.prevViewController = self;
    taskDetailCreateViewController.createType = 0;

    [Tools layerTransition:self.navigationController.view from:@"right"];
    [self.navigationController pushViewController:taskDetailCreateViewController animated:NO];

    [taskDetailCreateViewController release];
}

- (void)startPhoto:(id)sender
{
    photoActionSheet = [[UIActionSheet alloc]
                        initWithTitle:nil
                        delegate:self
                        cancelButtonTitle:@"取消"
                        destructiveButtonTitle:nil
                        otherButtonTitles: @"开始拍照", @"从相册选择",nil];
    [photoActionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet == photoActionSheet) {
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
    else if(actionSheet == audioActionSheet) {
        switch (buttonIndex) {
            case 0:
                //录音
                [self takeAudio];
                break;
            default:
                break;
        }
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

- (void)takeAudio
{
    AudioViewController *audioViewController = [[AudioViewController alloc] init];
    audioViewController.prevViewController = self;
    [Tools layerTransition:self.navigationController.view from:@"right"];
    [self.navigationController pushViewController:audioViewController animated:NO];

    [audioViewController release];
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
            fileName = [NSString stringWithFormat:@"%@.%@", [Tools NSDateToNSFileString:[NSDate date]], @"png"];
        }
        else {
            //返回为JPEG图像
            data = UIImageJPEGRepresentation(image, 1.0);
            fileName = [NSString stringWithFormat:@"%@.%@", [Tools NSDateToNSFileString:[NSDate date]], @"jpg"];
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
