//
//  CommentInfoView.h
//  CooperApp
//
//  Created by sunleepy on 13-1-5.
//  Copyright (c) 2013年 codesharp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommentInfoDelegate <NSObject>

- (void)replyComment:(NSMutableDictionary*)comment;

@end

@interface CommentInfoView : UIView
{
    UILabel *creatorNameLabel;
    UILabel *createTimeLabel;
    UILabel *contentLabel;
    
    NSMutableDictionary *comment;
}

- (void)setCommentInfo:(NSMutableDictionary*)commentDict;
@property (retain, nonatomic) id<CommentInfoDelegate> delegate;

@end
