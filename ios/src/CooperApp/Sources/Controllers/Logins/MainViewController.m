//
//  MainViewController.m
//  Cooper
//
//  Created by sunleepy on 12-7-4.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "MainViewController.h"
#import "TasklistViewController.h"
#import "TodoTasksViewController.h"

@implementation MainViewController

@synthesize loginViewNavController;
@synthesize tasklistNavController;
@synthesize taskOptionNavController;
@synthesize panelController;

# pragma mark - UI相关

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[[Constant instance] loginType] isEqualToString:@"anonymous"]
        || [[[Constant instance] loginType] isEqualToString:@"normal"]
        || [[[Constant instance] loginType] isEqualToString:@"google"])
    {
        //跳过登录
        [self loginFinish];
    }
    else 
    {
        if(loginViewNavController == nil)
        {
            //登录
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            loginViewController.delegate = self;
            loginViewNavController = [[BaseNavigationController alloc] initWithRootViewController:loginViewController];
            [loginViewController release];
        }
        [self.navigationController presentModalViewController:loginViewNavController animated:NO];
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    for (UIView *view in tabBarController.tabBar.subviews)
    {      
        if ([NSStringFromClass([view class]) isEqualToString:@"UITabBarButton"])
        {
            for (UIView *subview in view.subviews)
            {                                    
                if ([subview isKindOfClass:[UILabel class]])
                {
                    UILabel *label = (UILabel *)subview;
                    label.textColor = [UIColor whiteColor];
                }
            }
        }
    } 
}

//- (void)viewDidUnload
//{
//    loginViewNavController = nil;
//    tasklistNavController = nil;
//    [super viewDidUnload];
//}

- (void)dealloc
{
    RELEASE(loginViewNavController);
    RELEASE(tasklistNavController);
    RELEASE(panelController);
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

# pragma mark - 相关动作事件

- (void)loginFinish
{
    NSLog(@"【登录成功】");
 
    if([[[Constant instance] loginType] isEqualToString:@"anonymous"])
    {
        //打开任务列表
        if(tasklistNavController == nil)
        {
            TasklistViewController *tasklistViewController = [[TasklistViewController alloc] init];
            tasklistNavController = [[BaseNavigationController alloc] initWithRootViewController:tasklistViewController];
            [tasklistViewController release];
        }
        [self.navigationController presentModalViewController:tasklistNavController animated:NO];
    }
    else
    {
        if (IS_ENTVERSION) {
            Base2NavigationController *taskNavController = nil;
            TodoTasksViewController *taskViewController = nil;
            if(panelController == nil) {

                EnterpriseOptionViewController *optionViewController = [[EnterpriseOptionViewController alloc] init];
                Base2NavigationController *optionNavController = [[Base2NavigationController alloc] initWithRootViewController:optionViewController];
                taskViewController = [[TodoTasksViewController alloc] init];
                taskNavController = [[Base2NavigationController alloc] initWithRootViewController:taskViewController];
                panelController = [[JASidePanelController alloc] init];
                panelController.leftPanel = optionNavController;
                panelController.centerPanel = taskNavController;

                [panelController toggleLeftPanel:nil];

                [taskViewController release];
                [optionViewController release];
            }

            [self.navigationController presentModalViewController:panelController animated:NO];
        }
        else {
            if(taskOptionNavController == nil)
            {
                TaskOptionViewController *taskOptionViewController = [[TaskOptionViewController alloc] init];
                taskOptionNavController = [[BaseNavigationController alloc] initWithRootViewController: taskOptionViewController];
                [taskOptionViewController release];
            }
            [self.navigationController presentModalViewController:taskOptionNavController animated:NO];
        }
    }
}

- (void)googleLoginFinish:(NSArray*)array
{
    
}

@end
