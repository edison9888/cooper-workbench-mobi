//
//  TaskCommentCreateViewController.h
//  CooperApp
//
//  Created by sunleepy on 13-1-5.
//  Copyright (c) 2013年 codesharp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base2ViewController.h"
#import "CooperService/EnterpriseService.h"
#import "GCPlaceholderTextView.h"
#import "SearchUserViewController.h"

@protocol TaskCommentCreateDelegate <NSObject>

- (void)reloadView;

@end

@interface TaskCommentCreateViewController : Base2ViewController<UITextViewDelegate, EnterpriseTaskCreateDelegate>
{
    GCPlaceholderTextView *commentTextView;
    
    UILabel *textTitleLabel;
    
    EnterpriseService *enterpriseService;
}

@property (assign, nonatomic) int type;
@property (retain, nonatomic) NSMutableDictionary *commentDict;
@property (retain, nonatomic) NSString *currentTaskId;
@property (retain, nonatomic) NSMutableDictionary *taskDetailDict;
@property (retain, nonatomic) id<TaskCommentCreateDelegate> delegate;
@end
