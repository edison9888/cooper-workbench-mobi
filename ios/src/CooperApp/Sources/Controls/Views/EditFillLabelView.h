//
//  EditFillLabelView.h
//  CooperApp
//
//  Created by sunleepy on 13-1-13.
//  Copyright (c) 2013年 codesharp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditFillLabelViewDelegate <NSObject>

- (void)deleteTag:(NSString*)tag;

@end

@interface EditFillLabelView : UIView

- (void)bindTags:(NSMutableArray*)tags
 backgroundColor:(UIColor*)backgroundColor
       textColor:(UIColor*)textColor
            font:(UIFont*)font
          radius:(CGFloat)radius;

@property (nonatomic, assign) id<EditFillLabelViewDelegate> delegate;

@end
