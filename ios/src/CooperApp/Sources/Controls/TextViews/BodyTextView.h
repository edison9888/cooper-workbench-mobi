//
//  BodyTextView.h
//  Cooper
//
//  Created by sunleepy on 12-7-31.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BodyTextViewDelegate <NSObject>

- (void)returnData;

@end

@interface BodyTextView : UITextView
{
    UIView *inputAccessoryView;
    
    UITextField *textField;
}

@property (nonatomic, assign) id <BodyTextViewDelegate> bodyDelegate;

//@property (nonatomic, strong) UIPickerView *picker;

@end
