//
//  AccountViewController.m
//  Cooper
//
//  Created by sunleepy on 12-7-30.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "AccountViewController.h"
#import "AppDelegate.h"
#import "CooperService/TasklistService.h"
#import "CooperService/AccountService.h"
#import "CooperCore/Tasklist.h"
#import "CooperService/TaskService.h"
#import "MainViewController.h"

@implementation AccountViewController

//@synthesize textUsername;
//@synthesize textPassword;
//@synthesize loginTableView;
//@synthesize accountView;
//@synthesize btnLogin;
@synthesize domainLabel;

#pragma mark - 页面相关事件

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {   
    }
    return self;
}

//- (void)loadView
//{
//    NSLog(@"loadView");
//    
//    //当前面板创建
//    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Tools screenMaxWidth], [Tools screenMaxHeight])];
//    contentView.autoresizesSubviews = YES;
//    contentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
//    self.View = contentView;
//    [contentView release];
//    
//    //登录View
//    CGRect rect = self.view.frame;
//    loginTableView = [[UITableView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y + 20, rect.size.width, rect.size.height) style:UITableViewStyleGrouped];
//    loginTableView.autoresizesSubviews = YES;
//    loginTableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
//    loginTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BACKGROUNDIMAGE]];
//    loginTableView.allowsSelection = NO;
//    loginTableView.dataSource = self;
//    loginTableView.delegate = self;
//    [self.view addSubview:loginTableView]; 
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    accountService = [[AccountService alloc] init];

    UILabel *textTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    textTitleLabel.backgroundColor = [UIColor clearColor];
    textTitleLabel.textAlignment = UITextAlignmentCenter;
    textTitleLabel.textColor = APP_TITLECOLOR;
    textTitleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    textTitleLabel.text = @"账号设置";
    self.navigationItem.titleView = textTitleLabel;
    [textTitleLabel release];
    
    taskDao = [[TaskDao alloc] init];
    taskIdxDao = [[TaskIdxDao alloc] init];
    changeLogDao = [[ChangeLogDao alloc] init];
    tasklistDao = [[TasklistDao alloc] init];
    
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
    
    //保存按钮（相当于切换用户）
//    CustomButton *saveTaskBtn = [[[CustomButton alloc] initWithFrame:CGRectMake(5,5,70,30) image:[UIImage imageNamed:@"btn_center.png"]] autorelease];
//    saveTaskBtn.layer.cornerRadius = 6.0f;
//    [saveTaskBtn.layer setMasksToBounds:YES];
//    [saveTaskBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
//    [saveTaskBtn setTitle:@"保存" forState:UIControlStateNormal];
//    UIBarButtonItem *saveButton = [[[UIBarButtonItem alloc] initWithCustomView:saveTaskBtn] autorelease];
//    self.navigationItem.rightBarButtonItem = saveButton;
    
    accountView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Tools screenMaxWidth], 180)];
    accountView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, [Tools screenMaxWidth], 30)];
    accountLabel.backgroundColor = [UIColor clearColor];
    if([[Constant instance] username].length > 0)
    {
        NSString *loginTypeText = @"";
        if([[[Constant instance] loginType] isEqualToString:@"google"])
        {
            loginTypeText = @"Google - ";
        }
        accountLabel.text = [NSString stringWithFormat:@"当前用户: %@%@", loginTypeText, [[Constant instance] username]];
        [accountView addSubview:accountLabel];
        
        CustomButton *logoutBtn = [[CustomButton alloc] initWithFrame:CGRectMake(5, 35, 80, 30) image:[UIImage imageNamed:@"btn_center.png"]];
        logoutBtn.layer.cornerRadius = 6.0f;
        [logoutBtn.layer setMasksToBounds:YES];
        [logoutBtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
        [logoutBtn setTitle:@"注销" forState:UIControlStateNormal];
        
        [accountView addSubview:logoutBtn];
        
        [logoutBtn release];
    }
    else
    {
        accountLabel.text = @"当前用户: 匿名用户";
        [accountView addSubview:accountLabel];
        
        CustomButton *logoutBtn = [[CustomButton alloc] initWithFrame:CGRectMake(5, 35, 80, 30) image:[UIImage imageNamed:@"btn_center.png"]];
        logoutBtn.layer.cornerRadius = 6.0f;
        [logoutBtn.layer setMasksToBounds:YES];
        [logoutBtn addTarget:self action:@selector(skipToLogin:) forControlEvents:UIControlEventTouchUpInside];
        [logoutBtn setTitle:@"返回登录" forState:UIControlStateNormal];
        
        [accountView addSubview:logoutBtn];
        
        [logoutBtn release];
    }
    
    [self.view addSubview:accountView];

    [accountLabel release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc 
{
//#ifdef __ALI_VERSION__
//    [domainLabel release];
//#endif
//    [textUsername release];
//    [textPassword release];
//    [loginTableView release];
//    [btnLogin release];
    [accountService release];
    [accountView release];
    [taskDao release];
    [taskIdxDao release];
    [changeLogDao release];
    [tasklistDao release];
    [super dealloc];
}

#pragma mark - 相关动作事件

- (void)goBack:(id)sender
{
    [Tools layerTransition:self.navigationController.view from:@"left"]; 
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)skipToLogin:(id)sender
{
    [[Constant instance] setLoginType:@""];
    [[Constant instance] setUsername:@""];
    [[Constant instance] setRecentlyIds:nil];
    [[Constant instance] setRecentlyTeamIds:nil];
    
    [Constant saveToCache];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    MainViewController *mainViewController = [[MainViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    
    appDelegate.window.rootViewController = navController;
    
    [mainViewController release];
}

- (void)logout:(id)sender
{
    if([[Constant instance] username].length > 0)
    {
        self.HUD = [Tools process:@"注销中" view:self.view];
        
        NSMutableDictionary *context = [NSMutableDictionary dictionary];
        [context setObject:@"Logout" forKey:REQUEST_TYPE];

        [accountService logout:context delegate:self];
    }
    
//    lock_counter = 0;

//    if([[Constant instance] username].length > 0)
//    {
//        self.HUD.labelText = @"正在注销当前用户";
//
//        NSMutableDictionary *context = [NSMutableDictionary dictionary];
//        [context setObject:@"Logout" forKey:REQUEST_TYPE];
//       
//        [accountService logout:context delegate:self];
//    }
//    else
//    {
//        [self loginServiceAction];
//    }
}

//- (void)syncAllLocalData
//{
////    NSMutableDictionary *context = [NSMutableDictionary dictionary];
////    [context setObject:@"SyncAll" forKey:@"RequestType"];
////    
////    NSMutableArray *tasklists = [tasklistDao getAllTasklistByGuest];
////    
////    lock_counter = tasklists.count;
////    
////    for(Tasklist *tasklist in tasklists)
////    {
////        [TaskService syncTask:tasklist.id context:context delegate:self];
////    }
//    
////    NSMutableDictionary *context = [NSMutableDictionary dictionary];
////    [context setObject:@"SyncTasklists" forKey:REQUEST_TYPE];
////    if(networkQueue)
////    {
////        networkQueue = nil;
////    }
////    networkQueue = [ASINetworkQueue queue];
////    [tasklistService syncTasklists:context queue:networkQueue delegate:self];
//}

//- (void)loginServiceAction
//{
//    NSMutableDictionary *context = [NSMutableDictionary dictionary];
//    [context setObject:@"Login" forKey:REQUEST_TYPE];
//    
////#ifdef __ALI_VERSION__
////    if ([domainLabel.text length] > 0 
////        && [textUsername.text length] > 0
////        && [textPassword.text length] > 0) 
////#else
//        if([textUsername.text length] > 0
//           && [textPassword.text length] > 0)
////#endif
//        {
//            self.HUD.labelText = @"登录中";
//            
////#ifdef __ALI_VERSION__
////            [accountService login:domainLabel.text 
////                         username:textUsername.text 
////                         password:textPassword.text 
////                          context:context
////                         delegate:self];
////#else
//            [accountService login:textUsername.text
//                         password:textPassword.text
//                          context:context
//                         delegate:self];
////#endif
//        }
//        else 
//        {
//            [Tools alert:@"请输入用户名和密码"];
//        }   
//}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"请求响应数据: %@, %d", [request responseString], [request responseStatusCode]);
    
    NSDictionary *userInfo = request.userInfo;
    NSString *requestType = [userInfo objectForKey:REQUEST_TYPE];
    if([requestType isEqualToString:@"Logout"])
    {
        if(request.responseStatusCode == 200)
        {
            [[Constant instance] setLoginType:@""];
            [[Constant instance] setUsername:@""];
            [[Constant instance] setWorkId:@""];
            [[Constant instance] setRecentlyIds:nil];
            [[Constant instance] setRecentlyTeamIds:nil];
            
            [Constant saveToCache];
            
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            MainViewController *mainViewController = [[MainViewController alloc] init];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
            
            appDelegate.window.rootViewController = navController;
            
            [mainViewController release];
        }
        else
        {
            [Tools failed:self.HUD];
        }
    }
    else if([requestType isEqualToString:@"Login"])
    {
        if(request.responseStatusCode == 200)
        {
            [Tools close:self.HUD];
            
//#ifdef __ALI_VERSION__
//            if([[request responseString] rangeOfString: @"window.opener.loginSuccess"].length == 0)
//            { 
////                [Tools alert:@"用户名和密码不正确"];
////                self.HUD.labelText = @"用户名和密码不正确";
//                [Tools msg:@"用户名和密码不正确" HUD:self.HUD];
//                
//                return;
//            }
//#endif
            NSArray* array = [request responseCookies];
            NSLog(@"cookies数组个数: %d",  array.count);
            
            NSDictionary *dict = [NSHTTPCookie requestHeaderFieldsWithCookies:array];
            NSHTTPCookie *cookieA = [NSHTTPCookie cookieWithProperties:dict];
            NSHTTPCookieStorage *sharedHTTPCookie = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            
            //[sharedHTTPCookie setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
            [sharedHTTPCookie setCookie:cookieA];
            
//#ifdef __ALI_VERSION__
//            [[Constant instance] setDomain:domainLabel.text];
//#endif
//            [[Constant instance] setUsername:textUsername.text];
            [[Constant instance] setLoginType:@"normal"];
            
            [Constant saveToCache];
            
            //把当前用户数据先全部同步到服务端
            //[self syncAllLocalData];
            
//            [Tools alert:@"保存成功"];
            [Tools msg:@"保存成功" HUD:self.HUD];
        }
        else if(request.responseStatusCode == 400)
        {
            [Tools close:self.HUD];
            [Tools alert:[request responseString]];
        }
        else
        {
            [Tools close:self.HUD];
            
            [Tools alert:@"用户名和密码不正确"];
        }
    }
    else if([requestType isEqualToString:@"SyncAll"])
    {
        if(request.responseStatusCode == 200)
        {
            lock_counter--;
            if(lock_counter <= 0)
            {
                NSMutableDictionary *context = [NSMutableDictionary dictionary];
                [context setObject:@"GetTasks" forKey:REQUEST_TYPE];
                [TasklistService getTasklists:context delegate:self];
            }
        }
        else
        {
            [Tools failed:self.HUD];
        }
    }
    else if([requestType isEqualToString:@"GetTasks"])
    {
        if(request.responseStatusCode == 200)
        {
            NSMutableDictionary *tasklistsDict = [[request responseString] JSONValue];
            
            [tasklistDao deleteAll];
            
            for(NSString* key in tasklistsDict.allKeys)
            {
                NSString *value = [tasklistsDict objectForKey:key];
                
                [tasklistDao addTasklist:key:value:@"personal"];
            }
            
            [tasklistDao addTasklist:@"0" :@"默认列表" :@"personal"];
            
            [tasklistDao commitData];
        }
        else
        {
            [Tools failed:self.HUD];
        }
    }
}

-(IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

# pragma mark login table view

//获取TableView的分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//获取在制定的分区编号下的纪录数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#ifndef CODESHARP_VERSION
    return 2;
#else
    return 3;
#endif
}
//填充单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    NSString *identifier = @"BaseCell";
    if(indexPath.row == 0)
    {
        //创建域Cell
        identifier = @"DomainCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell)
            cell = [self createDomainCell:identifier];
    }
    else if(indexPath.row == 1)
    {
        //创建用户名Cell
        identifier = @"UsernameCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell)
            cell = [self createUsernameCell:identifier];   
    }
    else if(indexPath.row == 2)
    {
        //创建密码Cell
        identifier = @"PasswordCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell)
            cell = [self createPasswordCell:identifier];  
    }   
    return cell;
}

- (void)tableViewCell:(DomainLabel *)label didEndEditingWithValue:(NSString *)value
{
    label.text = value;
}

- (void)selectDomain
{
    [domainLabel becomeFirstResponder];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 35.0f;
//}

- (UITableViewCell*)createDomainCell:(NSString*)identifier
{
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier] autorelease];
    
    domainLabel = [[DomainLabel alloc] initWithFrame:CGRectMake(0, 0, 210, 30)];
    domainLabel.text = DEFAULT_DOMAIN;
    [domainLabel setBackgroundColor:[UIColor clearColor]];
    domainLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *recoginzer = [[UITapGestureRecognizer alloc] 
                                          initWithTarget:self 
                                          action:@selector(selectDomain)];
    [domainLabel addGestureRecognizer:recoginzer];
    domainLabel.delegate = self;
    [recoginzer release];
    
    cell.textLabel.text = @"域名";
    cell.accessoryView = domainLabel;
 
    return cell;
}

- (UITableViewCell*)createUsernameCell:(NSString*)identifier
{
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UsernameCell"] autorelease];
    
//    CGFloat width = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 660 : 285;
//    self.textUsername = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, width, 20)];  
//    
//    [self.textUsername setPlaceholder:@"用户名"]; 
//    [self.textUsername setAutocapitalizationType:UITextAutocapitalizationTypeNone];
//    [self.textUsername setAutocorrectionType:UITextAutocorrectionTypeNo];
//    [self.textUsername setReturnKeyType:UIReturnKeyDone];
//    [self.textUsername addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
//    cell.accessoryView = self.textUsername;
//    
//    if([[Constant instance] username].length > 0)
//    {
//        self.textUsername.text = [[Constant instance] username];
//    }
    
    return cell;
}

- (UITableViewCell*)createPasswordCell:(NSString*)identifier
{
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PasswordCell"] autorelease];
    
//    CGFloat width = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 660 : 285;
//    self.textPassword = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, width, 20)]; 
//    [self.textPassword setSecureTextEntry:YES];
//    [self.textPassword setPlaceholder:@"密码"];
//    [self.textPassword setAutocapitalizationType:UITextAutocapitalizationTypeNone];
//    [self.textPassword setAutocorrectionType:UITextAutocorrectionTypeNo];
//    [self.textPassword setReturnKeyType:UIReturnKeyDone];
//    [self.textPassword addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
//    
//    cell.accessoryView = self.textPassword;
//    
//    if([[Constant instance] username].length > 0)
//    {
//        self.textPassword.text = @"***********";
//    }
    
    return cell;
}

@end
