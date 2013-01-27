//
//  CommentInfoView.m
//  CooperApp
//
//  Created by sunleepy on 13-1-5.
//  Copyright (c) 2013年 codesharp. All rights reserved.
//

#import "CommentInfoView.h"

@implementation CommentInfoView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setCommentInfo:(NSMutableDictionary*)commentDict
{
    comment = commentDict;
    
    CGFloat totalHeight = 0;
    
    creatorNameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(6, 10, 150, 13)] autorelease];
    creatorNameLabel.backgroundColor = [UIColor clearColor];
    creatorNameLabel.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    creatorNameLabel.font = [UIFont boldSystemFontOfSize:13];
    creatorNameLabel.text = [commentDict objectForKey:@"creatorName"];
    [self addSubview:creatorNameLabel];
    
    totalHeight += 13 + 6;
    
    createTimeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - 90, 10, 90, 9)] autorelease];
    createTimeLabel.backgroundColor = [UIColor clearColor];
    createTimeLabel.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    createTimeLabel.font = [UIFont systemFontOfSize:9];
    createTimeLabel.text = [commentDict objectForKey:@"createTime"];
    [self addSubview:createTimeLabel];
    
    totalHeight += 9 + 6;
    
    //NSString *replaceStr = @"对任务添加了评论：";
    NSString *content = [commentDict objectForKey:@"content"];
    //content = [content stringByReplacingOccurrencesOfString:replaceStr withString:@""];
    
    contentLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    contentLabel.text = content;
    contentLabel.font = [UIFont systemFontOfSize:13];
    CGSize contentLabelSize = [contentLabel.text sizeWithFont:contentLabel.font
                                            constrainedToSize:CGSizeMake(self.bounds.size.width - 40, 10000)
                                                lineBreakMode:UILineBreakModeWordWrap];
    CGFloat contentLabelHeight = contentLabelSize.height;
    int contentlines = contentLabelHeight / 13;
    contentLabel.numberOfLines = contentlines;
    contentLabel.frame = CGRectMake(6, totalHeight, self.bounds.size.width - 40, contentLabelHeight);
    [self addSubview:contentLabel];

    NSString *type = [commentDict objectForKey:@"type"];
    if([type isEqualToString:@"CommentFeedback"]) {
        UIButton *replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [replyButton setBackgroundImage:[UIImage imageNamed:@"detail_replyComment.png"] forState:UIControlStateNormal];
        replyButton.frame = CGRectMake(self.bounds.size.width - 30, totalHeight, 23, 20);
        [replyButton addTarget:self action:@selector(replyComment:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:replyButton];
    }
    
    totalHeight += contentLabelHeight + 12;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, totalHeight, self.bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_line.png"]];
    [self addSubview:lineView];
    [lineView release];
    totalHeight += 1;
    
    CGRect frame = self.frame;
    frame.size = CGSizeMake(frame.size.width, totalHeight);
    self.frame = frame;
}

- (void)replyComment:(id)sender
{
    [delegate replyComment:comment];
}

@end
