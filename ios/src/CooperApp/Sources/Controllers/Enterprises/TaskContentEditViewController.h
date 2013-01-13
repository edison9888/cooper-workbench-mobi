//
//  TaskContentEditViewController.h
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

@protocol TaskContentEditDelegate <NSObject>

- (void)setSubject:(NSString*)subject;

@end

@interface TaskContentEditViewController : Base2ViewController<UITextViewDelegate, EnterpriseTaskCreateDelegate>
{
    GCPlaceholderTextView *subjectTextView;
    
    UILabel *textTitleLabel;
    
    EnterpriseService *enterpriseService;
}

@property (retain, nonatomic) NSString *currentTaskId;
@property (retain, nonatomic) NSMutableDictionary *taskDetailDict;
@property (retain, nonatomic) id<TaskContentEditDelegate> delegate;

@end
