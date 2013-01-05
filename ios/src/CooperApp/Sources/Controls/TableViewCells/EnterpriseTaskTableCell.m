//
//  EnterpriseTaskTableCell.m
//  CooperNative
//
//  Created by sunleepy on 12-12-16.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "EnterpriseTaskTableCell.h"
#import "FillLabelView.h"

#define PADDING         5.0f
#define CONTENT_WIDTH   200.0f
#define MAX_HEIGHT      10000.0f
#define BODY_MAX_LINE   3

@implementation EnterpriseTaskTableCell

@synthesize taskInfoDict;
@synthesize subjectLabel;
@synthesize dueTimeLabel;
@synthesize creatorLabel;
@synthesize iconsView;

@synthesize leftView;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initContentView];
    }
    return self;
}

- (void)dealloc
{
    [subjectLabel release];
    [dueTimeLabel release];
    [creatorLabel release];
    [iconsView release];
    [leftView release];
    [enterpriseService release];
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setCompletedAction:(id)sender
{
    NSNumber *isExternal = [taskInfoDict objectForKey:@"isExternal"];
    NSNumber *isCompleted = [taskInfoDict objectForKey:@"isCompleted"];
    NSString *taskId = [taskInfoDict objectForKey:@"id"];
    if([isExternal isEqualToNumber: [NSNumber numberWithInt:1]]) {
        return;
    }
    if([isCompleted isEqualToNumber: [NSNumber numberWithInt:1]]) {
        self.imageView.image = [UIImage imageNamed:@"notcompleted.png"];
        isCompleted = [NSNumber numberWithInt:0];
        [taskInfoDict setObject:isCompleted forKey:@"isCompleted"];
    }
    else {
        self.imageView.image = [UIImage imageNamed:@"completed.png"];
        isCompleted = [NSNumber numberWithInt:1];
        [taskInfoDict setObject:isCompleted forKey:@"isCompleted"];
    }
    
    //更新完成状态
    NSMutableDictionary *context = [NSMutableDictionary dictionary];
    [context setObject:@"ChangeTaskCompleted" forKey:REQUEST_TYPE];
    [enterpriseService changeTaskCompleted:taskId isCompleted:isCompleted context:context delegate:delegate];
}

# pragma 私有方法

- (void)initContentView
{
    subjectLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    subjectLabel.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    subjectLabel.backgroundColor = [UIColor clearColor];
    [subjectLabel setFont:[UIFont boldSystemFontOfSize:16]];
    subjectLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
    
    dueTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    dueTimeLabel.textColor = [UIColor colorWithRed:187.0/255 green:187.0/255 blue:187.0/255 alpha:1];
    [dueTimeLabel setLineBreakMode:UILineBreakModeWordWrap];
    [dueTimeLabel setFont:[UIFont systemFontOfSize:11]];
    dueTimeLabel.textColor = [UIColor grayColor];
    dueTimeLabel.backgroundColor = [UIColor clearColor];
    
    creatorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    creatorLabel.textColor = [UIColor colorWithRed:187.0/255 green:187.0/255 blue:187.0/255 alpha:1];
    [creatorLabel setLineBreakMode:UILineBreakModeWordWrap];
    creatorLabel.font = [UIFont systemFontOfSize:11];
    creatorLabel.textColor = [UIColor grayColor];
    creatorLabel.backgroundColor = [UIColor clearColor];

    [self.contentView addSubview:subjectLabel];
    [self.contentView addSubview:dueTimeLabel];
    [self.contentView addSubview:creatorLabel];
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setCompletedAction:)];
    tapped.numberOfTapsRequired = 1;
    [self.imageView addGestureRecognizer:tapped];
}

- (void)layoutSubviews {
    [super layoutSubviews];
  
    CGRect frame = self.imageView.frame;
    self.imageView.frame = CGRectMake(16, frame.origin.y, frame.size.width, frame.size.height);
}

- (void) setTaskInfo:(NSMutableDictionary*)taskInfo
{
    self.taskInfoDict = taskInfo;

    NSString *statusImageStr = @"";
    NSNumber *isExternal = [taskInfoDict objectForKey:@"isExternal"];
    if([isExternal isEqualToNumber:[NSNumber numberWithInt:1]]) {
        statusImageStr = @"external.png";
    }
    else {
        statusImageStr = @"notcompleted.png";
    }
    UIImage* image = [UIImage imageNamed:statusImageStr];

    self.imageView.image = image;
    self.imageView.userInteractionEnabled = YES;
    
    enterpriseService = [[EnterpriseService alloc] init];

    if([isExternal isEqualToNumber:[NSNumber numberWithInt:1]]) {
        self.imageView.image = [UIImage imageNamed:@"external.png"];
    }
    else {
        NSNumber *isCompleted = [taskInfoDict objectForKey:@"isCompleted"];
        
        if([isCompleted isEqualToNumber: [NSNumber numberWithInt:1]])
        {
            self.imageView.image = [UIImage imageNamed:@"completed.png"];
        }
        else {
            self.imageView.image = [UIImage imageNamed:@"notcompleted.png"];
        }
    }
    NSNumber *attachmentCount = [taskInfoDict objectForKey:@"attachmentCount"];
    NSNumber *picCount = [taskInfoDict objectForKey:@"picCount"];
    
    if([attachmentCount intValue] + [picCount intValue] > 0) {
        
        CGFloat iconLeft = [Tools screenMaxWidth] - 8;
        if([attachmentCount intValue] > 0) {
            iconLeft -= 20;
        }
        if([picCount intValue] > 0) {
            iconLeft -= 20;
        }
        
        iconsView = [[UIView alloc] initWithFrame:CGRectMake(iconLeft, PADDING, [Tools screenMaxWidth] - iconLeft, 15)];
        
        CGFloat tempFlagLeft = 0;
        if([attachmentCount intValue] > 0) {
            UIImageView *audioImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"audioflag.png"]];
            audioImageView.frame = CGRectMake(tempFlagLeft, PADDING, 13, 13);
            [iconsView addSubview:audioImageView];
            tempFlagLeft += 20;
        }
        
        if([picCount intValue] > 0) {
            UIImageView *picImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photoflag.png"]];
            picImageView.frame = CGRectMake(tempFlagLeft, PADDING, 12, 12);
            [iconsView addSubview:picImageView];
            tempFlagLeft += 20;
        }
        
        [self.contentView addSubview:iconsView];
    }
    
    CGFloat textWidth = self.bounds.size.width - 120;
    CGFloat textLeft = 60;

    CGFloat totalHeight = 0;
    
    NSString *subject = [taskInfoDict objectForKey:@"subject"];
    subjectLabel.text = subject;
    subjectLabel.frame = CGRectMake(textLeft, 8, textWidth, 16);
    subjectLabel.numberOfLines = 1;
    totalHeight += 16 + 8;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M-dd"];
    NSString* dueTime = [taskInfoDict objectForKey:@"dueTime"];
    
    int lines = 1;
    
    if(![dueTime isEqualToString:@""])
    {
        NSDate *dueDate = [Tools NSStringToShortNSDate:dueTime];
        dueTimeLabel.text = [formatter stringFromDate:dueDate];
        [dueTimeLabel setFrame:CGRectMake(textLeft, totalHeight + PADDING, textWidth, 11)];

        totalHeight += 11 + PADDING;
        
        lines += 1;
    }
    
    CGFloat tagHeight = totalHeight;
    
    NSString *creatorDisplayName = [taskInfoDict objectForKey:@"creatorDisplayName"];
    
    if(![creatorDisplayName isEqualToString:@""]) {

        creatorLabel.text = creatorDisplayName;
        
        if(![creatorDisplayName isEqualToString:@""])
        {
            creatorLabel.frame = CGRectMake(textLeft, totalHeight + PADDING, textWidth, 11);
            tagHeight = totalHeight + PADDING;
            totalHeight += 11 + PADDING;
            
            lines += 1;
        }
    }
    
    if(lines <= 2) {
        totalHeight = 46;
    }
    else {
        totalHeight = 58;
    }

//    if(totalHeight < 46)
//        totalHeight = 46;
//
//    totalHeight += PADDING;
    
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 1)];
    seperatorView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tableview_separator.png"]];
    [self.contentView addSubview:seperatorView];
    [seperatorView release];
    
    totalHeight += 1;
    
    [self setFrame:CGRectMake(0, 0, self.bounds.size.width, totalHeight)];
    [leftView setFrame:CGRectMake(0, 0, 40, totalHeight)];

    
}

@end
