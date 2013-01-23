//
//  EnterpriseOptionViewController.m
//  CooperNative
//
//  Created by sunleepy on 12-12-15.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "EnterpriseOptionViewController.h"
#import "TodoTasksViewController.h"
#import "RelatedTaskViewController.h"
#import "SettingViewController.h"
#import "AboutViewController.h"

@implementation EnterpriseOptionViewController

@synthesize optionView;

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
    [self initContentView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

# pragma 私有方法

- (void)initContentView
{
    self.navigationController.navigationBarHidden = YES;
    //任务列表View
    optionView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    optionView.backgroundColor = [UIColor colorWithRed:98.0/255 green:85.0/255 blue:79.0/255 alpha:1];
    optionView.separatorColor = [UIColor colorWithRed:90.0/255 green:77.0/255 blue:69.0/255 alpha:1];
    optionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    optionView.dataSource = self;
    optionView.delegate = self;
    //去掉底部空白
    UIView *footer = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    optionView.tableFooterView = footer;
    [self.view addSubview:optionView];

    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_foot.png"]];
    logoImageView.frame = CGRectMake(121,self.view.bounds.size.height - 10 - 14,77,14);
    [self.view addSubview:logoImageView];
    [logoImageView release];
}

# pragma mark - 任务列表相关委托事件

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if(!cell) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
         //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
         cell.textLabel.textColor = [UIColor colorWithRed:152.0/255 green:145.0/255 blue:137.0/255 alpha:1];
         UIView *selectedView = [[UIView alloc] initWithFrame:cell.frame];
         selectedView.backgroundColor = [UIColor colorWithRed:90.0/255.0f green:77.0/255.0f blue:69.0/255.0f alpha:1.0];
         cell.selectedBackgroundView = selectedView;
         
         UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
         arrowView.frame = CGRectMake(self.view.bounds.size.width - 67, 15, 11, 17);
         [cell.contentView addSubview:arrowView];
         [arrowView release];
         [selectedView release];
     }

    if(indexPath.row == 0) {
        cell.textLabel.text = @"我的任务";
    }
    else if(indexPath.row == 1) {
        cell.textLabel.text = @"相关任务";
    }
    else if(indexPath.row == 2) {
        cell.textLabel.text = @"今日到期";
    }
    else if(indexPath.row == 3) {
        cell.textLabel.text = @"设置";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0) {
        TodoTasksViewController *taskViewController = [[TodoTasksViewController alloc] init];
        Base2NavigationController *taskNavController = [[Base2NavigationController alloc] initWithRootViewController:taskViewController];
        taskViewController.todayNotice = NO;
        self.sidePanelController.centerPanel = taskNavController;
        [taskViewController release];

    }
    else if(indexPath.row == 1) {
        RelatedTaskViewController *taskViewController = [[RelatedTaskViewController alloc] init];
        Base2NavigationController *taskNavController = [[Base2NavigationController alloc] initWithRootViewController:taskViewController];
        self.sidePanelController.centerPanel = taskNavController;
        [taskViewController release];
    }
    else if(indexPath.row == 2) {
        TodoTasksViewController *taskViewController = [[TodoTasksViewController alloc] init];
        Base2NavigationController *taskNavController = [[Base2NavigationController alloc] initWithRootViewController:taskViewController];
        taskViewController.todayNotice = YES;
        self.sidePanelController.centerPanel = taskNavController;
        [taskViewController release];
    }
    else if(indexPath.row == 3) {
//        SettingViewController *settingViewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
//        Base2NavigationController *settingNavController = [[Base2NavigationController alloc] initWithRootViewController:settingViewController];
//        self.sidePanelController.centerPanel = settingNavController;
//        [settingViewController release];

        AboutViewController *aboutViewController = [[AboutViewController alloc] init];
        Base2NavigationController *aboutNavController = [[Base2NavigationController alloc] initWithRootViewController:aboutViewController];
        self.sidePanelController.centerPanel = aboutNavController;
        [aboutViewController release];
    }
    else if(indexPath.row == 3) {
        
    }
}

@end
