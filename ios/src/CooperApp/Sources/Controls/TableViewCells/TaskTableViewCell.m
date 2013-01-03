//
//  TaskTableViewCell.m
//  Cooper
//
//  Created by Ping Li on 12-7-23.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TaskTableViewCell.h"
#import "FillLabelView.h"

#define PADDING         5.0f
#define CONTENT_WIDTH   200.0f
#define MAX_HEIGHT      10000.0f
#define BODY_MAX_LINE   3

@implementation TaskTableViewCell

@synthesize subjectLabel;
@synthesize bodyLabel;
@synthesize dueDateLabel;
@synthesize assigneeNameLabel;
@synthesize tagsLabel;
@synthesize statusButton;
@synthesize arrowButton;
@synthesize leftView;
//@synthesize rightView;
@synthesize task;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initContentView];
        // Initialization code
    }
    return self;
}

- (void)initContentView
{
    subjectLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [subjectLabel setLineBreakMode:UILineBreakModeWordWrap];
    [subjectLabel setFont:[UIFont boldSystemFontOfSize:16]];
    
    bodyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [bodyLabel setLineBreakMode:UILineBreakModeWordWrap];
    [bodyLabel setFont:[UIFont systemFontOfSize:14]];
    [bodyLabel setTextColor:[UIColor lightGrayColor]];
    
    dueDateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [dueDateLabel setLineBreakMode:UILineBreakModeWordWrap];
    [dueDateLabel setFont:[UIFont systemFontOfSize:14]];
    [dueDateLabel setTextColor:APP_BACKGROUNDCOLOR];
    
    assigneeNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [assigneeNameLabel setLineBreakMode:UILineBreakModeWordWrap];
    assigneeNameLabel.font = [UIFont systemFontOfSize:12];
    assigneeNameLabel.textColor = APP_BACKGROUNDCOLOR;
    
    tagsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [tagsLabel setLineBreakMode:UILineBreakModeWordWrap];
    tagsLabel.font = [UIFont systemFontOfSize:12];
    tagsLabel.textColor = [UIColor redColor];
    tagsLabel.textAlignment = UITextAlignmentRight;
    
    [self.contentView addSubview:subjectLabel];
    [self.contentView addSubview:bodyLabel];
    [self.contentView addSubview:dueDateLabel];
    [self.contentView addSubview:assigneeNameLabel];
    [self.contentView addSubview:tagsLabel];
    
    self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    
    statusButton = [[UIButton alloc] initWithFrame:CGRectMake(10, PADDING, 28, 17)];
    UIImage* image = [UIImage imageNamed:@"incomplete-small.png"];
    [statusButton setBackgroundImage:image forState:UIControlStateNormal];
    [self.leftView addSubview:statusButton];
    
    self.leftView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setCompletedAction:)];
    tapped.numberOfTapsRequired = 1;
    [self.leftView addGestureRecognizer:tapped];   
    [tapped release];
    [self.contentView addSubview:self.leftView];
    
//    self.rightView = [[UIView alloc] initWithFrame:CGRectMake(290, 0, 40, 30)];
//    arrowButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 11,14)];
//    UIImage* image2 = [UIImage imageNamed:@"arowright.png"];
//    [arrowButton setBackgroundImage:image2 forState:UIControlStateNormal];
//    self.rightView.userInteractionEnabled = YES;
//
//    [self.rightView addSubview:arrowButton];
//    
//    
//    UITapGestureRecognizer *tapped2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoTaskDetail:)];
//    tapped2.numberOfTapsRequired = 1;
//    [self.rightView addGestureRecognizer:tapped2];   
//    [tapped2 release];
//    [self.contentView addSubview:self.rightView];
}

- (void)gotoTaskDetail:(id)sender
{ 
    [delegate didSelectCell:self.task];
}

- (void)setCompletedAction:(id)sender
{
    if(task.editable == [NSNumber numberWithInt:0])
    {
        return;
    }
    if([[task.status stringValue] isEqualToString:@"1"])
    {
        UIButton *button = statusButton;
        [button setBackgroundImage:[UIImage imageNamed:@"incomplete-small.png"] forState:UIControlStateNormal];
        task.status = [NSNumber numberWithInt:0];
    }
    else {
        UIButton *button = statusButton;
        [button setBackgroundImage:[UIImage imageNamed:@"complete-small.png"] forState:UIControlStateNormal];
        task.status = [NSNumber numberWithInt:1];  
    }
    
    if(self.task.tasklistId != nil)
    {
        [changeLogDao insertChangeLog:[NSNumber numberWithInt:0]
                               dataid:task.id
                                 name:@"iscompleted"
                                value:task.status == [NSNumber numberWithInt:1] ? @"true" : @"false"
                           tasklistId:task.tasklistId];
    }
    else if(self.task.teamId != nil)
    {
        [changeLogDao insertChangeLogByTeam:[NSNumber numberWithInt:0]
                                     dataId:task.id name:@"iscompleted"
                                      value:task.status == [NSNumber numberWithInt:1] ? @"true" : @"false"
                                     teamId:self.task.teamId
                                  projectId:nil
                                   memberId:nil
                                        tag:nil];
    }
        
    [taskDao commitData];
}

- (void)setTaskInfo:(Task *)taskInfo
{
    self.task = taskInfo;
    taskDao = [[TaskDao alloc] init];
    changeLogDao = [[ChangeLogDao alloc] init];
    teamMemberDao = [[TeamMemberDao alloc] init];
    
    if([[task.status stringValue] isEqualToString:@"1"])
    {
        [statusButton setBackgroundImage:[UIImage imageNamed:@"complete-small.png"] forState:UIControlStateNormal];
    }
    else {
        [statusButton setBackgroundImage:[UIImage imageNamed:@"incomplete-small.png"] forState:UIControlStateNormal];
    }
    
    CGFloat totalHeight = 0;
    
    subjectLabel.text = task.subject; 
    CGSize subjectLabelSize = [subjectLabel.text sizeWithFont:subjectLabel.font
                                            constrainedToSize:CGSizeMake(self.bounds.size.width - 50, MAX_HEIGHT)
                                                lineBreakMode:UILineBreakModeWordWrap];
    CGFloat subjectLabelHeight = subjectLabelSize.height;
    int subjectlines = subjectLabelHeight / 16;
    subjectLabel.frame = CGRectMake(50, PADDING, self.bounds.size.width - 50, subjectLabelHeight);
    subjectLabel.numberOfLines = subjectlines; 
    totalHeight += subjectLabelHeight + PADDING;
    
    bodyLabel.text = task.body;  
    CGSize bodyLabelSize = [bodyLabel.text sizeWithFont:bodyLabel.font
                                      constrainedToSize:CGSizeMake(self.bounds.size.width - 50, MAX_HEIGHT)
                                          lineBreakMode:UILineBreakModeWordWrap];
    CGFloat bodyLabelHeight = bodyLabelSize.height;
    if(bodyLabelHeight == 0.0f)
    {
        
    }
    else
    {
        int bodylines = bodyLabelHeight / 14;
        
        if(bodylines > 3)
        {
            bodylines = 3;
        }
        bodyLabel.frame = CGRectMake(50, totalHeight + PADDING, self.bounds.size.width - 50, bodylines * 14);
        bodyLabel.numberOfLines = bodylines;
        
        totalHeight += bodylines * 14 + PADDING;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M-dd"];
    if(task.dueDate != nil)
    {
        dueDateLabel.text = [formatter stringFromDate:task.dueDate];
        [dueDateLabel setFrame:CGRectMake(260  + [Tools screenMaxWidth] - 320, PADDING, 80, 20)];
    }
    
    if(self.task.assigneeId != nil)
    {  
        TeamMember *teamMember = [teamMemberDao getTeamMemberByTeamId:self.task.teamId
                                                           assigneeId:self.task.assigneeId];
        if(teamMember != nil)
        {
            assigneeNameLabel.text = teamMember.name;
            
            CGSize assigneeLabelSize = [assigneeNameLabel.text sizeWithFont:assigneeNameLabel.font
                                                          constrainedToSize:CGSizeMake(self.bounds.size.width - 50, MAX_HEIGHT)
                                                              lineBreakMode:UILineBreakModeWordWrap];
            CGFloat assigneeLabelHeight = assigneeLabelSize.height;
            if(assigneeLabelHeight == 0.0f)
            {
                
            }
            else
            {
                int assigneelines = assigneeLabelHeight / 12;
                
                assigneeNameLabel.frame = CGRectMake(50, totalHeight + PADDING, self.bounds.size.width - 50, assigneeLabelHeight);
                assigneeNameLabel.numberOfLines = assigneelines;
                totalHeight += assigneeLabelHeight + PADDING;
            }
        }
    }
    
    NSMutableArray *tagsArray = nil;
    if(![self.task.tags isEqualToString:@""]) {
        tagsArray = [self.task.tags JSONValue];
    }
    else {
        tagsArray = [NSMutableArray array];
    }
    if(tagsArray.count > 0)
    {
        FillLabelView *fillLabelView = [[FillLabelView alloc] initWithFrame:CGRectMake(150, totalHeight + PADDING, self.bounds.size.width - 150, 0)];
        //fillLabelView.layer.borderWidth = 1.0f;
        //fillLabelView.layer.borderColor = [[UIColor blueColor] CGColor];
        [fillLabelView bindTags:tagsArray];
        [self.contentView addSubview:fillLabelView];
        [fillLabelView release];
        
        totalHeight += fillLabelView.frame.size.height + PADDING;
    }
    
    if(totalHeight < 50)
        totalHeight = 50;
    
    [self setFrame:CGRectMake(0, 0, self.bounds.size.width, totalHeight + PADDING)];
    [leftView setFrame:CGRectMake(0, 0, 40, totalHeight + PADDING)];
}

- (void)dealloc
{
    [super dealloc];
    [subjectLabel release];
    [bodyLabel release];
    [dueDateLabel release];
    [assigneeNameLabel release];
    [tagsLabel release];
    [leftView release];
    //[rightView release];
    [statusButton release];
    [changeLogDao release];
    [taskDao release];
    [teamMemberDao release];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
