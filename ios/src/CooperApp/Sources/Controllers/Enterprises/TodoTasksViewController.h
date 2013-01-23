//
//  AssigneeTaskViewController.h
//  CooperNative
//
//  Created by sunleepy on 12-12-15.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "Base2ViewController.h"
#import "CooperService/EnterpriseService.h"
#import "EnterpriseTaskTableCell.h"
#import "EnterpriseTaskDetailViewController.h"
#import "EnterpriseTaskDetailCreateViewController.h"
#import "AudioViewController.h"
#import "TabbarLineView.h"
#import "SVPullToRefresh.h"

@interface TodoTasksViewController : Base2ViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, EnterpriseTaskTableCellDelegate, ASIProgressDelegate>
{
    UIView *emptyView;
    UITableView *taskView;
    UIView *tabbarView;
    
    UIActionSheet *photoActionSheet;
    UIActionSheet *audioActionSheet;

    EnterpriseService *enterpriseService;

    UILabel *textTitleLabel;
    
    UIImagePickerController *pickerController;

    ASIHTTPRequest *uploadPicRequest;
    
    BOOL _isLoad;
}

@property (nonatomic, assign) BOOL todayNotice;
@property (nonatomic, retain) NSMutableArray *taskInfos;
@property (nonatomic, retain) EnterpriseTaskDetailViewController *taskDetailViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
             setTitle:(NSString *)title
             setImage:(NSString*)imageName;

@end
