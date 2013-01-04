//
//  LoginViewController.m
//  Cooper
//
//  Created by sunleepy on 12-7-4.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "LoginViewController.h"
#import "GTMOAuth2ViewControllerTouch.h"

static NSString *const kKeychainItemName = @"CooperKeychain";

@implementation LoginViewController

@synthesize textUsername;
@synthesize textPassword;
@synthesize loginTableView;
@synthesize delegate;
@synthesize btnLogin;
@synthesize btnGoogleLogin;
@synthesize btnSkip;
@synthesize domainLabel;
@synthesize auth = mAuth;

#pragma mark - UI相关

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    accountService = [[AccountService alloc] init];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick:)];
    [self.view addGestureRecognizer:recognizer];
    [recognizer release];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg.png"]];
    
    //LogoImageView
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 164)];
    UIImage *logoImage = [UIImage imageNamed:@"login_logo.png"];
    logoImageView.image = logoImage;
    [self.view addSubview:logoImageView];
    [logoImageView release];
    
    //域账号View
    UIView *domainView = [[UIView alloc] initWithFrame:CGRectMake((320 - 176) / 2.0, 180, 176, 35)];
    domainView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_input.png"]];
    
    domainTextField = [[UITextField alloc] initWithFrame:CGRectMake(8, 0, 176, 35)];
    domainTextField.userInteractionEnabled = NO;
    domainTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    domainTextField.placeholder = @"域账号";
    domainTextField.textColor = [UIColor colorWithRed:190.0/255 green:182.0/255 blue:175.0/255 alpha:1];
    
    [domainView addSubview:domainTextField];
    
    UIView *selDomainView = [[UIView alloc] initWithFrame:CGRectMake(133, 0, 14, 35)];
    selDomainView.userInteractionEnabled = YES;
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selDomain:)];
    [domainView addGestureRecognizer:recognizer];
    [recognizer release];
    
    selDomainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selDomainButton setFrame:CGRectMake(13, 13, 14, 9)];
    [selDomainButton setBackgroundImage:[UIImage imageNamed:@"login_selDown.png"] forState:UIControlStateNormal];
    [selDomainView addSubview:selDomainButton];
    
    [domainView addSubview:selDomainView];
    
    [selDomainView release];
    
    [self.view addSubview:domainView];
    
    [domainView release];
    
    //域账号选择框
    selectedDomainView = [[SelectedDomainView alloc] initWithFrame:CGRectMake((320 - 176) / 2.0, 230, 176, 107)];
    selectedDomainView.delegate = self;
    
    //用户名TextField
    UIView *userNameView = [[UIView alloc] initWithFrame:CGRectMake((320 - 176) / 2.0, 230, 176, 35)];
    userNameView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_input.png"]];
    
    userNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(8, 0, 176, 35)];
    userNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    userNameTextField.placeholder = @"用户名";
    userNameTextField.textColor = [UIColor colorWithRed:190.0/255 green:182.0/255 blue:175.0/255 alpha:1];
    userNameTextField.keyboardType = UIKeyboardTypeDefault;
    userNameTextField.keyboardAppearance = UIKeyboardAppearanceDefault;
    userNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    userNameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    userNameTextField.returnKeyType = UIReturnKeyNext;
    [userNameTextField addTarget:self action:@selector(textFieldNextEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [userNameView addSubview:userNameTextField];
    
    [self.view addSubview:userNameView];
    
    [userNameView release];
    
    //密码TextField
    UIView *passwordView = [[UIView alloc] initWithFrame:CGRectMake((320 - 176) / 2.0, 280, 176, 35)];
    passwordView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_input.png"]];
    
    passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(8, 0, 176, 35)];
    passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passwordTextField.placeholder = @"密码";
    passwordTextField.textColor = [UIColor colorWithRed:190.0/255 green:182.0/255 blue:175.0/255 alpha:1];
    passwordTextField.keyboardType = UIKeyboardTypeDefault;
    passwordTextField.keyboardAppearance = UIKeyboardAppearanceDefault;
    passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordTextField.returnKeyType = UIReturnKeyJoin;
    passwordTextField.secureTextEntry = YES;
    [passwordTextField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [passwordView addSubview:passwordTextField];
    
    [self.view addSubview:passwordView];
    
    [passwordView release];
    
    
    //[self.view addSubview:selectedDomainView];
    //NSString* login_btn_text = [[[SysConfig instance] keyValue] objectForKey:@"login_btn_text"];
    //NSString* skip_btn_text = [[[SysConfig instance] keyValue] objectForKey:@"skip_btn_text"];
    //NSString* googlelogin_btn_text = [[[SysConfig instance] keyValue] objectForKey:@"googlelogin_btn_text"];
    
//    //登录View
//    float loginIpadHeight = 150;
//    float loginIphoneHeight = 220;
//    //float googleLoginHeight = 0;
//
//    self.loginTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 180, [Tools screenMaxWidth], [Tools isPad] ? loginIpadHeight : loginIphoneHeight) style:UITableViewStyleGrouped];
//    if(!IS_ENTVERSION) {
//        self.loginTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BACKGROUNDIMAGE]];
//    }
//    else {
//        self.loginTableView.backgroundColor = [UIColor clearColor];
//    }
//    self.loginTableView.allowsSelection = NO;
//    self.loginTableView.delegate = self;
//    self.loginTableView.dataSource = self;
//    self.loginTableView.scrollEnabled = NO;
//    self.loginTableView.backgroundView.alpha = 0.0;
//    
//    [self.view addSubview:self.loginTableView];
//
//    //登录按钮
//    self.btnLogin = [[CustomButton alloc] initWithFrame:CGRectMake([Tools screenMaxWidth] - 150 + (IS_ENTVERSION ? 80 : 0) - [Tools screenMaxWidth] / 16.0, 320 + googleLoginHeight, 70, 40)
//                                                  image:[UIImage imageNamed:@"btn_center.png"]];
//    self.btnLogin.layer.cornerRadius = 10.0f;
//    self.btnLogin.layer.masksToBounds = YES;
//    [self.btnLogin addTarget:self 
//                      action:@selector(login:)
//            forControlEvents:UIControlEventTouchUpInside];
//    [self.btnLogin setTitle:login_btn_text 
//                   forState:UIControlStateNormal];
//    self.btnLogin.titleLabel.font = [UIFont boldSystemFontOfSize:20];
//    [self.view addSubview:self.btnLogin];
//        
//    if(!IS_ENTVERSION) {
//        //跳过按钮
//        self.btnSkip = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        self.btnSkip.frame = CGRectMake([Tools screenMaxWidth] - 70 - [Tools screenMaxWidth] / 16.0, 250 + googleLoginHeight, 70, 40);
//        self.btnSkip.layer.cornerRadius = 6.0f;
//        self.btnSkip.layer.masksToBounds = YES;
//        [self.btnSkip addTarget:self 
//                         action:@selector(skip:)
//               forControlEvents:UIControlEventTouchUpInside];
//        [self.btnSkip setTitle:skip_btn_text 
//                      forState:UIControlStateNormal];
//        self.btnSkip.titleLabel.font = [UIFont boldSystemFontOfSize:20];
//        [self.view addSubview:self.btnSkip];
//    }
//    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 164)];
//    UIImage *imgLogo = [UIImage imageNamed:@"login_logo.png"];
//    
//    imageView.image = imgLogo;
//    
//    [self.view addSubview:imageView];
//    
//    [imageView release];
    
//#ifndef __ALI_VERSION__
//    //使用谷歌登录
//    self.btnGoogleLogin = [[CustomButton alloc] initWithFrame:CGRectMake(10 + ([Tools isPad] ? 30 : 0), 100, [Tools screenMaxWidth] - 2 * (10 + ([Tools isPad] ? 30 : 0)), 40) color:[UIColor colorWithRed:91.0/255 green:181.0/255 blue:91.0/255 alpha:1]];
//    self.btnGoogleLogin.layer.cornerRadius = 10.0f;
//    self.btnGoogleLogin.layer.masksToBounds = YES;
//    [self.btnGoogleLogin addTarget:self 
//                            action:@selector(googleLogin:)
//                  forControlEvents:UIControlEventTouchUpInside];
//    [self.btnGoogleLogin setTitle:googlelogin_btn_text 
//                         forState:UIControlStateNormal];
//    self.btnGoogleLogin.titleLabel.font = [UIFont boldSystemFontOfSize:20];
//    [self.view addSubview:self.btnGoogleLogin];
//    
//    //google oauth相关初始化
//    googleClientId = [[[SysConfig instance] keyValue] objectForKey:@"googleClientId"];
//    googleClientSecret = [[[SysConfig instance] keyValue] objectForKey:@"googleClientSecret"];
//#endif
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;

    viewCenter = CGPointMake(self.view.center.x, self.view.center.y + 22.0f);
    
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
    self.navigationController.navigationBar.hidden = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)textFieldNextEditing:(id)sender
{
    if ([userNameTextField isFirstResponder]) {
        [passwordTextField becomeFirstResponder];
    }
}

-(IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
    
    [self login:nil];
}

- (void)dealloc 
{
    [accountService release];
    [domainTextField release];
    [selectedDomainView release];
    [userNameTextField release];
    [passwordTextField release];
    [self.domainLabel release];
    [textUsername release];
    [textPassword release];
    [loginTableView release];
    [btnLogin release];
    [btnGoogleLogin release];
    [self.btnSkip release];
    [mAuth release];
    [super dealloc];
}

#pragma mark - 触发自定义事件

- (void)viewClick:(id)sender
{
    NSLog(@"【viewClick】");
    if([self.view.subviews containsObject:selectedDomainView]) {
        [selectedDomainView removeFromSuperview];
        [selDomainButton setBackgroundImage:[UIImage imageNamed:@"login_selDown.png"] forState:UIControlStateNormal];
    }
    [userNameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
}

- (void)selDomain:(id)sender
{
    if ([self.view.subviews containsObject:selectedDomainView]) {
        [selectedDomainView removeFromSuperview];
        [selDomainButton setBackgroundImage:[UIImage imageNamed:@"login_selDown.png"] forState:UIControlStateNormal];
    }
    else {
//        [selectBtn removeFromSuperview];
//        if ([regionLabel.text isEqualToString:kTAOBAO_HZ]) {
//            selectBtn.frame = btn1.frame;
//        }
//        else if ([regionLabel.text isEqualToString:kHZ]) {
//            selectBtn.frame = btn2.frame;
//        }
//        else if ([regionLabel.text isEqualToString:kALIPAY]) {
//            selectBtn.frame = btn3.frame;
//        }
//        [regionView insertSubview:selectBtn atIndex:2];
        [self.view addSubview:selectedDomainView];
        [selDomainButton setBackgroundImage:[UIImage imageNamed:@"login_selUp.png"] forState:UIControlStateNormal];
    }
}

- (void)googleLogin:(id)sender
{
    NSLog(@"进入google oauth登录页面");
    
    [self signOut:nil];
    
    NSString *scope = [[[SysConfig instance] keyValue] objectForKey:@"googleScope"];
    
    NSString *keychainItemName  = kKeychainItemName;
    
    SEL finishedSel = @selector(viewController:finishedWithAuth:error:);
    
    GTMOAuth2ViewControllerTouch *viewController;
    viewController = [GTMOAuth2ViewControllerTouch controllerWithScope:scope
                                                              clientID:googleClientId
                                                          clientSecret:googleClientSecret
                                                      keychainItemName:keychainItemName
                                                              delegate:self
                                                      finishedSelector:finishedSel];
    viewController.loginDelegate = self;
    
    NSString *html = @"<html><body bgcolor=white><div align=center>正在进入google登录页面...</div></body></html>";
    viewController.initialHTMLString = html;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)signOut:(id)sender
{
    if ([self.auth.serviceProvider isEqual:kGTMOAuth2ServiceProviderGoogle]) {
        [GTMOAuth2ViewControllerTouch revokeTokenForGoogleAuthentication:self.auth];
    }
    
    [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:kKeychainItemName];
    
    self.auth = nil;
}

- (void)login:(id)sender
{
    NSLog("【开始登录】");
    
    if (domainTextField.text.length > 0
        && userNameTextField.text.length > 0
        && passwordTextField.text.length > 0)
        {
            self.HUD = [Tools process:@"登录中" view:self.view];

            NSMutableDictionary *context = [NSMutableDictionary dictionary];
            if(IS_ENTVERSION) {
                [context setObject:@"WORKBENCHLOGIN" forKey:REQUEST_TYPE];
                
            }
            else {
                [context setObject:@"LOGIN" forKey:REQUEST_TYPE];
            }
            
            if(IS_ENTVERSION) {
                [accountService workbenchLogin:domainTextField.text
                                      username:userNameTextField.text
                                      password:passwordTextField.text
                                       context:context
                                      delegate:self];
            }
            else {
                [accountService login:domainTextField.text
                             username:userNameTextField.text
                             password:passwordTextField.text
                              context:context
                             delegate:self];
            }
        }
        else 
        {
            [Tools alert:@"请输入用户名和密码"];
        }
}

- (void)skip:(id)sender
{
    //自动保存用户登录
    [[Constant instance] setLoginType:@"anonymous"];
    [Constant saveToCache];
    
    [self dismissModalViewControllerAnimated:NO];
    
    [delegate loginFinish];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [Tools close:self.HUD];
    NSLog(@"请求响应数据: %@, %d"
          , [request responseString]
          , [request responseStatusCode]);
    
    NSDictionary *userInfo = [request userInfo];
    NSString * requestType = [userInfo objectForKey:REQUEST_TYPE];
    
    if([requestType isEqualToString:@"LOGIN"])
    {
        if(request.responseStatusCode == 200 && [request.responseString rangeOfString: @"window.opener.loginSuccess"].length > 0)
        {
            NSArray* array = request.responseCookies;
            NSLog(@"Cookies的数组个数: %d",  array.count);
            
            NSDictionary *dict = [NSHTTPCookie requestHeaderFieldsWithCookies:array];
            NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:dict];
            NSHTTPCookieStorage *sharedHTTPCookie = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            
            [sharedHTTPCookie setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
            [sharedHTTPCookie setCookie:cookie];
            
            [[Constant instance] setDomain:self.domainLabel.text];
            [[Constant instance] setUsername:self.textUsername.text];
            [[Constant instance] setLoginType:@"normal"];
            if(IS_ENTVERSION) {
                NSString* workId = request.responseString;
                workId = [workId stringByReplacingOccurrencesOfString:@"\""
                                                     withString:@""];
                [[Constant instance] setWorkId:workId];
            }
            [Constant saveToCache];
            
            [self dismissModalViewControllerAnimated:NO];
            
            [delegate loginFinish];
        }
        else if(request.responseStatusCode == 400)
        {
            [Tools alert:[request responseString]];
        }
        else
        {
            [Tools alert:@"用户名和密码不正确"];
        }
    }
    else if([requestType isEqualToString:@"WORKBENCHLOGIN"]) {
        if(request.responseStatusCode == 200) {
            NSArray* array = request.responseCookies;
            NSLog(@"【Cookies的数组个数】%d",  array.count);
            
            NSDictionary *dict = [NSHTTPCookie requestHeaderFieldsWithCookies:array];
            NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:dict];
            NSHTTPCookieStorage *sharedHTTPCookie = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            
            [sharedHTTPCookie setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
            [sharedHTTPCookie setCookie:cookie];
            
            [[Constant instance] setDomain:self.domainLabel.text];
            [[Constant instance] setUsername:self.textUsername.text];
            [[Constant instance] setLoginType:@"normal"];

            NSMutableDictionary *result = [request.responseString JSONValue];
            NSMutableDictionary *data = [result objectForKey:@"data"];
            NSString *workId = [data objectForKey:@"workId"];
                [[Constant instance] setWorkId:workId];

            [Constant saveToCache];
            
            [self dismissModalViewControllerAnimated:NO];
            
            [delegate loginFinish];
        }
        else {
            [Tools alert:[NSString stringWithFormat:@"返回验证码错误:%d,返回错误信息:%@"
                          , request.responseStatusCode
                          , request.responseString]];
        }
    }
    else if([requestType isEqualToString:@"GOOGLELOGIN"]) {
        if(request.responseStatusCode == 200)
        {
            NSArray* array = request.responseCookies;
            NSLog(@"Cookies的数组个数: %d",  array.count);
            
            NSDictionary *dict = [NSHTTPCookie requestHeaderFieldsWithCookies:array];
            NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:dict];
            NSHTTPCookieStorage *sharedHTTPCookie = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            
            [sharedHTTPCookie setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
            [sharedHTTPCookie setCookie:cookie];
            NSString *username = [request.responseString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            [[Constant instance] setUsername:username];
            [[Constant instance] setLoginType:@"google"];
            [Constant saveToCache];
            
            [self dismissModalViewControllerAnimated:NO];
            [delegate loginFinish];
        }
        else
        {
            [Tools failed:self.HUD];
        }
    }
}

- (void)loginFinish
{
    
}

- (void)googleLoginFinish:(NSArray*)array
{
    NSString *codeQuery = [array objectAtIndex:1];
    NSArray *patams = [codeQuery componentsSeparatedByString:@"="];
    NSString *code = [patams objectAtIndex:0];
    if([code isEqualToString:@"code"])
    {
        self.HUD = [Tools process:@"登录中" view:self.view];
        NSMutableDictionary *context = [NSMutableDictionary dictionary];
        [context setObject:@"GOOGLELOGIN" forKey:REQUEST_TYPE];
        
        NSString *anthCode = [patams objectAtIndex:1];
        [accountService googleLogin:@"" code:anthCode state:@"login" mobi:@"true" joke:@"false" context:context delegate:self];
    }
}
# pragma mark - 域账号相关事件

- (void)tableViewCell:(DomainLabel *)label didEndEditingWithValue:(NSString *)value
{
    label.text = value;
}

- (void)selectDomain
{
    [domainLabel becomeFirstResponder];
}

# pragma mark - 登录TableView相关的委托事件

//获取TableView的分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//获取在制定的分区编号下的纪录数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35.0f;
}

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
    
    CGFloat width = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 660 : 285;
    self.textUsername = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, width, 20)];  
    
    [self.textUsername setPlaceholder:@"用户名"]; 
    [self.textUsername setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    self.textUsername.keyboardType = UIKeyboardTypeDefault;
    self.textUsername.keyboardAppearance = UIKeyboardAppearanceDefault;
    [self.textUsername setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.textUsername setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.textUsername setReturnKeyType:UIReturnKeyDone];
    [self.textUsername addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    cell.accessoryView = self.textUsername;
    
    return cell;
}

- (UITableViewCell*)createPasswordCell:(NSString*)identifier
{
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PasswordCell"] autorelease];
    
    CGFloat width = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 660 : 285;
    self.textPassword = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, width, 20)]; 
    [self.textPassword setSecureTextEntry:YES];
    [self.textPassword setPlaceholder:@"密码"];
    [self.textPassword setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    self.textPassword.keyboardType = UIKeyboardTypeDefault;
    self.textPassword.keyboardAppearance = UIKeyboardAppearanceDefault;
    [self.textPassword setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.textPassword setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.textPassword setReturnKeyType:UIReturnKeyDone];
    [self.textPassword addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    cell.accessoryView = self.textPassword;
    return cell;
}

#pragma mark keyboard

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    [selectedDomainView removeFromSuperview];
	CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration =
	[[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    CGPoint center = viewCenter;
    center.y -= keyboardRect.size.height;
    center.y += 120.0f;
    self.view.center = center;
    [UIView setAnimationDuration:animationDuration];
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [selectedDomainView removeFromSuperview];
    NSTimeInterval animationDuration =
	[[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    self.view.center = viewCenter;
    [UIView setAnimationDuration:animationDuration];
    [UIView commitAnimations];
}

#pragma mark - SelectedDomainViewDelegate接口

- (void)callbackText:(NSString *)text
{
    domainTextField.text = text;
    [selectedDomainView removeFromSuperview];
    [selDomainButton setBackgroundImage:[UIImage imageNamed:@"login_selDown.png"] forState:UIControlStateNormal];
}

#pragma mark - google oauth相关

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)authInfo
                 error:(NSError *)error 
{
    NSLog(@"finish!");
    if (error != nil) 
    {
        NSLog(@"应用程序异常: %@", error);
        NSData *responseData = [[error userInfo] objectForKey:@"data"];
        if ([responseData length] > 0) 
        {
            NSString *str = [[[NSString alloc] initWithData:responseData
                                                   encoding:NSUTF8StringEncoding] autorelease];
            NSLog(@"%@", str);
        }
        
        [Tools msg:@"登录失败！请重新尝试！" HUD:self.HUD];
    }
    else 
    {
        if(authInfo)
        {
            NSLog(@"persistenceResponseString:%@ \r\n serviceProvider:%@ \r\n userEmail:%@ \r\n accessToken:%@ \r\n expirationDate:%@ \r\n refreshToken:%@ \r\n code:%@ \r\n            tokenTYpe:%@ \r\n error:%@"
                  , authInfo.persistenceResponseString
                  , authInfo.serviceProvider
                  , authInfo.userEmail
                  , authInfo.accessToken
                  , [authInfo.expirationDate description]
                  , authInfo.refreshToken
                  , authInfo.code
                  , authInfo.tokenType
                  , authInfo.errorString);
            
            self.auth = authInfo;
            [Tools showHUD:@"登录中" view:self.view HUD:self.HUD];
            //requestType = GoogleLoginValue;
            NSMutableDictionary *context = [NSMutableDictionary dictionary];
            [context setObject:@"GOOGLELOGIN" forKey:REQUEST_TYPE];
            [accountService googleLogin:authInfo.refreshToken context:context delegate:self];
        }
    }
}

@end
