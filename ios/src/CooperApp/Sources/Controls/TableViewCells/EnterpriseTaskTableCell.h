//
//  EnterpriseTaskTableCell.h
//  CooperNative
//
//  Created by sunleepy on 12-12-16.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CooperService/EnterpriseService.h"

@protocol EnterpriseTaskTableCellDelegate <NSObject>

//- (void) reloadData;

@end

@interface EnterpriseTaskTableCell : UITableViewCell
{
    EnterpriseService *enterpriseService;
}

- (void) setTaskInfo:(NSMutableDictionary*)taskInfo;

@property (nonatomic, retain) NSMutableDictionary* taskInfoDict;

@property (nonatomic, retain) UILabel *subjectLabel;
@property (nonatomic, retain) UILabel *dueTimeLabel;
@property (nonatomic, retain) UILabel *creatorLabel;

@property (nonatomic, retain) UIView *iconsView;

@property (nonatomic, retain) UIView *leftView;

@property (nonatomic, assign) id<EnterpriseTaskTableCellDelegate> delegate;

@end
