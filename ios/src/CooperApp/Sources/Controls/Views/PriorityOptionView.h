//
//  PriorityOptionView.h
//  CooperNative
//
//  Created by sunleepy on 12-12-27.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PriorityOptionView : UIView
{
    UIView *priorityView0;
    UIView *priorityView1;
    UIView *priorityView2;
    
    UIImageView *imageView0;
    UIImageView *imageView1;
    UIImageView *imageView2;
    
    UILabel *label0;
    UILabel *label1;
    UILabel *label2;
}

@property (assign, nonatomic) int selectedIndex;

-(void) setSelectedIndex:(int)index;

@end
