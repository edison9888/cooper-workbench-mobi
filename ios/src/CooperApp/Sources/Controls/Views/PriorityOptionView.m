//
//  PriorityOptionView.m
//  CooperNative
//
//  Created by sunleepy on 12-12-27.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "PriorityOptionView.h"

#define LABELCOLOR [UIColor colorWithRed:173.0/255 green:165.0/255 blue:165.0/255 alpha:1]
#define LABELCOLOR_SEL [UIColor colorWithRed:90.0/255 green:82.0/255 blue:66.0/255 alpha:1]

@implementation PriorityOptionView

@synthesize selectedIndex;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initContentView];
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

- (void)dealloc
{
    [priorityView0 release];
    [priorityView1 release];
    [priorityView2 release];
    [imageView0 release];
    [imageView1 release];
    [imageView2 release];
    [label0 release];
    [label1 release];
    [label2 release];
    [super dealloc];
}

- (void)initContentView
{
    selectedIndex = -1;
    
    priorityView0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 23)];
    priorityView0.userInteractionEnabled = YES;
    imageView0 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"priority_0.png"]];
    imageView0.frame = CGRectMake(0, 0, 23, 23);
    label0 = [[UILabel alloc] initWithFrame:CGRectMake(30, 7, 80, 12)];
    label0.backgroundColor = [UIColor clearColor];
    label0.textColor = LABELCOLOR;
    label0.text = @"尽快完成";
    label0.font = [UIFont boldSystemFontOfSize:12.0f];
    [priorityView0 addSubview:imageView0];
    [priorityView0 addSubview:label0];
    
    priorityView1 = [[UIView alloc] initWithFrame:CGRectMake(100, 0, 80, 23)];
    priorityView1.userInteractionEnabled = YES;
    imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"priority_1.png"]];
    imageView1.frame = CGRectMake(0, 0, 23, 23);
    label1 = [[UILabel alloc] initWithFrame:CGRectMake(30, 7, 100, 12)];
    label1.backgroundColor = [UIColor clearColor];
    label1.textColor = LABELCOLOR;
    label1.text = @"稍后完成";
    label1.font = [UIFont boldSystemFontOfSize:12.0f];
    [priorityView1 addSubview:imageView1];
    [priorityView1 addSubview:label1];
    
    priorityView2 = [[UIView alloc] initWithFrame:CGRectMake(200, 0, 80, 23)];
    priorityView2.userInteractionEnabled = YES;
    imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"priority_2.png"]];
    imageView2.frame = CGRectMake(0, 0, 23, 23);
    label2 = [[UILabel alloc] initWithFrame:CGRectMake(30, 7, 100, 12)];
    label2.backgroundColor = [UIColor clearColor];
    label2.textColor = LABELCOLOR;
    label2.text = @"迟些再说";
    label2.font = [UIFont boldSystemFontOfSize:12.0f];
    [priorityView2 addSubview:imageView2];
    [priorityView2 addSubview:label2];
    
    [self addSubview:priorityView0];
    [self addSubview:priorityView1];
    [self addSubview:priorityView2];
    
    UITapGestureRecognizer *recognizer0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setPriority0:)];
    [priorityView0 addGestureRecognizer:recognizer0];
    [recognizer0 release];
    
    UITapGestureRecognizer *recognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setPriority1:)];
    [priorityView1 addGestureRecognizer:recognizer1];
    [recognizer1 release];
    
    UITapGestureRecognizer *recognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setPriority2:)];
    [priorityView2 addGestureRecognizer:recognizer2];
    [recognizer2 release];
}

- (void)setPriority0:(id)sender
{
    [self setSelectedIndex:0];
}
- (void)setPriority1:(id)sender
{
    [self setSelectedIndex:1];
}
- (void)setPriority2:(id)sender
{
    [self setSelectedIndex:2];
}

- (void)setSelectedIndex:(int)index
{
    if(index == 0) {
        imageView0.image = [UIImage imageNamed:@"priority_sel_0.png"];
        imageView1.image = [UIImage imageNamed:@"priority_1.png"];
        imageView2.image = [UIImage imageNamed:@"priority_2.png"];
        label0.textColor = LABELCOLOR_SEL;
        label1.textColor = LABELCOLOR;
        label2.textColor = LABELCOLOR;
    }
    else if(index == 1) {
        imageView0.image = [UIImage imageNamed:@"priority_0.png"];
        imageView1.image = [UIImage imageNamed:@"priority_sel_1.png"];
        imageView2.image = [UIImage imageNamed:@"priority_2.png"];
        label0.textColor = LABELCOLOR;
        label1.textColor = LABELCOLOR_SEL;
        label2.textColor = LABELCOLOR;
    }
    else if(index == 2) {
        imageView0.image = [UIImage imageNamed:@"priority_0.png"];
        imageView1.image = [UIImage imageNamed:@"priority_1.png"];
        imageView2.image = [UIImage imageNamed:@"priority_sel_2.png"];
        label0.textColor = LABELCOLOR;
        label1.textColor = LABELCOLOR;
        label2.textColor = LABELCOLOR_SEL;
    }
    selectedIndex = index;
}

@end
