//
//  FillLabelView.h
//  Sample
//
//  Created by sunleepy on 12-10-19.
//  Copyright (c) 2012年 sunleepy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FillLabelView : UIView

- (void)bindTags:(NSMutableArray*)tags
 backgroundColor:(UIColor*)backgroundColor
       textColor:(UIColor*)textColor
            font:(UIFont*)font
          radius:(CGFloat)radius;
- (void)bindTags:(NSMutableArray*)tags;

@end
