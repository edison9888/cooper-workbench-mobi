//
//  LoginViewController.h
//  Cooper
//
//  Created by sunleepy on 12-7-4.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "CooperService/AccountService.h"
#import "LoginViewDelegate.h"
#import "CustomButton.h"
#import "DomainLabel.h"
#import "Base2ViewController.h"
#import "GTMOAuth2Authentication.h"

@interface LoginViewController : Base2ViewController<UITableViewDelegate
,UITableViewDataSource
,LoginViewDelegate
,DomainLabelDelegate
>
{
    //google oauth2 client id and key
    NSString *googleClientId;
    NSString *googleClientSecret;
    
    GTMOAuth2Authentication *mAuth;
    
    AccountService *accountService;

    CGPoint viewCenter;
}

@property(nonatomic,assign) id<LoginViewDelegate> delegate;

@property (retain, nonatomic) UITextField *textUsername;
@property (retain, nonatomic) UITextField *textPassword;
@property (retain, nonatomic) UITableView *loginTableView;
@property (retain, nonatomic) CustomButton *btnLogin;
@property (retain, nonatomic) CustomButton *btnSkip;
@property (retain, nonatomic) CustomButton *btnGoogleLogin;
@property (retain, nonatomic) DomainLabel *domainLabel;

@property (nonatomic, retain) GTMOAuth2Authentication *auth;

@end
