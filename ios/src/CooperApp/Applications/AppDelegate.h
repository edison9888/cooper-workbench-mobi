//
//  AppDelegate.h
//  Cooper
//
//  Created by sunleepy on 12-6-29.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "MainViewController.h"
#import "Base2ViewController.h"
#import "Base2NavigationController.h"
#import "TaskOptionViewController.h"
#import "EnterpriseOptionViewController.h"
#import "TodoTasksViewController.h"
#import "JASidePanelController.h"

@interface AppDelegate : NSObject<UIApplicationDelegate, UITabBarControllerDelegate, UIAlertViewDelegate>
{  
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (retain, nonatomic) UIWindow *window;
@property (retain, nonatomic) MainViewController *mainViewController;
@property (retain, nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (retain, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (retain, nonatomic, readonly) NSPersistentStoreCoordinator *persistantStoreCoordiantor;
//@property (retain, nonatomic) NSTimer *timer;
@property (assign, nonatomic) BOOL isJASideClicked;

@end
