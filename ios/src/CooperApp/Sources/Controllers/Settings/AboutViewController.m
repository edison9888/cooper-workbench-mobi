//
//  AboutViewController.m
//  CooperApp
//
//  Created by sunleepy on 13-1-13.
//  Copyright (c) 2013年 codesharp. All rights reserved.
//

#import "AboutViewController.h"
#import "AppDelegate.h"

@implementation AboutViewController

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
    
    accountService = [[AccountService alloc] init];

    UIView *aboutView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
    aboutView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"about_bg.png"]];
    [self.view addSubview:aboutView];
    UILabel *textTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    textTitleLabel.backgroundColor = [UIColor clearColor];
    textTitleLabel.textAlignment = UITextAlignmentCenter;
    textTitleLabel.textColor = APP_TITLECOLOR;
    textTitleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    textTitleLabel.text = @"关于";
    self.navigationItem.titleView = textTitleLabel;
    [textTitleLabel release];
    
//    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 38, 45)];
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.userInteractionEnabled = NO;
//    [backBtn setFrame:CGRectMake(14, 16, 15, 10)];
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"back2.png"] forState:UIControlStateNormal];
//    [backView addSubview:backBtn];
//    backView.userInteractionEnabled = YES;
//    UITapGestureRecognizer *backRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack:)];
//    [backView addGestureRecognizer:backRecognizer];
//    [backRecognizer release];
//    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
//    self.navigationItem.leftBarButtonItem = backButtonItem;
//    [backButtonItem release];
//    [backView release];

    UITextView *textView1 = [[UITextView alloc] initWithFrame:CGRectMake(0, 146, 320, 85)];
    textView1.userInteractionEnabled = NO;
    textView1.textAlignment = UITextAlignmentCenter;
    textView1.textColor = [UIColor colorWithRed:172.0/255 green:164.0/255 blue:157.0/255 alpha:1];
    textView1.backgroundColor = [UIColor clearColor];
    textView1.font = [UIFont systemFontOfSize:12];
    textView1.text = @"COOPER\r\n取Cooperation，协作、协同之意\r\n也可以理解为Cool Person\r\n--Cool Person use COOPER！";
    [aboutView addSubview:textView1];
    [textView1 release];
    
    UITextView *textView2 = [[UITextView alloc] initWithFrame:CGRectMake(0, 226, 320, 85)];
    textView2.userInteractionEnabled = NO;
    textView2.textAlignment = UITextAlignmentCenter;
    textView2.textColor = [UIColor colorWithRed:172.0/255 green:164.0/255 blue:157.0/255 alpha:1];
    textView2.backgroundColor = [UIColor clearColor];
    textView2.font = [UIFont systemFontOfSize:11];
    textView2.text = @"Powered By Workflow & IT Team\r\nAITA、COOPER Inside\r\nPD：谢逊、舒儿 | UED：铭秋 | 开发：萧玄\r\n其他贡献人员：侯昆、鼎天、无名...";
    [aboutView addSubview:textView2];
    [textView2 release];
    
    UITextView *textView3 = [[UITextView alloc] initWithFrame:CGRectMake(0, 295, 320, 50)];
    textView1.userInteractionEnabled = NO;
    textView3.textAlignment = UITextAlignmentCenter;
    textView3.textColor = [UIColor colorWithRed:172.0/255 green:164.0/255 blue:157.0/255 alpha:1];
    textView3.backgroundColor = [UIColor clearColor];
    textView3.font = [UIFont systemFontOfSize:12];
    textView3.text = @"更多信息请登陆PC版任务中心：";
    [aboutView addSubview:textView3];
    [textView3 release];
    
    UILabel *textView4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 305, 320, 50)];
    textView4.userInteractionEnabled = NO;
    textView4.textAlignment = UITextAlignmentCenter;
    textView4.textColor = [UIColor colorWithRed:59.0/255 green:118.0/255 blue:163.0/255 alpha:1];
    textView4.backgroundColor = [UIColor clearColor];
    textView4.font = [UIFont systemFontOfSize:12];
    textView4.text = @"http://aita.alibaba-inc.com";
    textView4.userInteractionEnabled = YES;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goLinkUrl:)];
    [textView4 addGestureRecognizer:recognizer];
    [recognizer release];
    [aboutView addSubview:textView4];
    [textView4 release];
    
    CustomButton *logoutBtn = [[CustomButton alloc] initWithFrame:CGRectMake(40, 355, 240, 40) color:[UIColor colorWithRed:187.0/255 green:187.0/255 blue:187.0/255 alpha:1]];
    logoutBtn.layer.cornerRadius = 1.0f;
    [logoutBtn.layer setMasksToBounds:YES];
    [logoutBtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [logoutBtn setTitle:@"注销" forState:UIControlStateNormal];
    [aboutView addSubview:logoutBtn];
    [logoutBtn release];

    [aboutView release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc
{
    [accountService release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)goBack:(id)sender
{
    [Tools layerTransition:self.navigationController.view from:@"left"];
    [self.navigationController popViewControllerAnimated:NO];
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
}

- (void)goLinkUrl:(id)sender
{
    UITapGestureRecognizer *recognizer = (UITapGestureRecognizer*)sender;
    UILabel *label = (UILabel*)recognizer.view;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:label.text]];
}

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
}

@end
