//
//  AccountViewController.h
//  Cooper
//
//  Created by sunleepy on 12-7-30.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomButton.h"
#import "DomainLabel.h"
#import "CooperService/AccountService.h"
#import "CooperRepository/TaskDao.h"
#import "CooperRepository/TaskIdxDao.h"
#import "CooperRepository/ChangeLogDao.h"
#import "CooperRepository/TasklistDao.h"

@interface AccountViewController : BaseViewController<UITableViewDelegate
    , UITableViewDataSource
    , DomainLabelDelegate
>
{
    //TODO:需要完善
    int lock_counter;
    
    TaskDao *taskDao;
    TaskIdxDao *taskIdxDao;
    ChangeLogDao *changeLogDao;
    TasklistDao *tasklistDao;
    
    UIView *accountView;
    UIButton *btnBack;
    
    AccountService *accountService;
}

//@property (retain, nonatomic) UITextField *textUsername;
//@property (retain, nonatomic) UITextField *textPassword;
//@property (retain, nonatomic) UITableView *loginTableView;
//@property (retain, nonatomic) UIView *accountView;
//@property (retain, nonatomic) CustomButton *btnLogin;
@property (retain, nonatomic) DomainLabel *domainLabel;

@end
