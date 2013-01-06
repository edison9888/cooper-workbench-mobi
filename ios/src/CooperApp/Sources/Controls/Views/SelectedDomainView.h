//
//  SelectedDomainView.h
//  CooperApp
//
//  Created by sunleepy on 13-1-4.
//  Copyright (c) 2013年 codesharp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectedDomainViewDelegate <NSObject>

- (void) callbackText:(NSString*)text;

@end

@interface SelectedDomainView : UIView
{
    UIButton *view0;
    UIButton *view1;
    UIButton *view2;
    
    UILabel *label0;
    UILabel *label1;
    UILabel *label2;
    
    UIImageView *selectedImageView;
}

@property (assign, nonatomic) int selectedIndex;
@property (assign, nonatomic) id<SelectedDomainViewDelegate> delegate;

-(void) setSelectedIndex:(int)index;

@end
