//
//  CommentTextField.h
//  Cooper
//
//  Created by Ping Li on 12-7-26.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//
#import "CustomButton.h"

@class CommentTextField;

@protocol CommentTextFieldDelegate <UITextFieldDelegate>
@optional
- (void)sendComment:(NSString *)value;
@end

@interface CommentTextField : UITextField
{
    // For iPad
	UIPopoverController *popoverController;
    UIView *inputAccessoryView;
    UITextField *addCommentTextField;
}

@property (nonatomic, assign) id <CommentTextFieldDelegate> delegate;
@end
