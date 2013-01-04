//
//  SelectedDomainView.m
//  CooperApp
//
//  Created by sunleepy on 13-1-4.
//  Copyright (c) 2013年 codesharp. All rights reserved.
//

#import "SelectedDomainView.h"

@implementation SelectedDomainView

@synthesize selectedIndex;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initContentView];
    }
    return self;
}

- (void)dealloc
{
    [view0 release];
    [view1 release];
    [view2 release];
    [label0 release];
    [label1 release];
    [label2 release];
    [selectedImageView release];
    [super dealloc];
}

- (void)initContentView
{
    selectedIndex = -1;
    
    view0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 176, 36)];
    view0.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_domainTop"]];
    view0.userInteractionEnabled = YES;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selDomain0:)];
    [view0 addGestureRecognizer:recognizer];
    [recognizer release];

    label0 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 146, 36)];
    label0.backgroundColor = [UIColor clearColor];
    label0.textColor = [UIColor colorWithRed:190.0/255 green:182.0/255 blue:175.0/255 alpha:1];
    label0.font = [UIFont systemFontOfSize:15.0f];
    label0.text = @"taobao-hz";
    [view0 addSubview:label0];
    
    [self addSubview:view0];
    
    view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 36, 176, 36)];
    view1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_domainCenter"]];
    view1.userInteractionEnabled = YES;
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selDomain1:)];
    [view1 addGestureRecognizer:recognizer];
    [recognizer release];
    
    label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 146, 36)];
    label1.backgroundColor = [UIColor clearColor];
    label1.textColor = [UIColor colorWithRed:190.0/255 green:182.0/255 blue:175.0/255 alpha:1];
    label1.font = [UIFont systemFontOfSize:15.0f];
    label1.text = @"hz";
    [view1 addSubview:label1];
    
    [self addSubview:view1];
    
    view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 72, 176, 35)];
    view2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_domainButtom"]];
    view2.userInteractionEnabled = YES;
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selDomain2:)];
    [view2 addGestureRecognizer:recognizer];
    [recognizer release];
    
    label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 146, 36)];
    label2.backgroundColor = [UIColor clearColor];
    label2.textColor = [UIColor colorWithRed:190.0/255 green:182.0/255 blue:175.0/255 alpha:1];
    label2.font = [UIFont systemFontOfSize:15.0f];
    label2.text = @"alipay";
    [view2 addSubview:label2];
    
    [self addSubview:view2];
    
    selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_selectedDomain"]];
    selectedImageView.frame = CGRectMake(143, 11, 16, 14);
    
//    [self addSubview:selectedImageView];
}

- (void)selDomain0:(id)sender
{
    [self setSelectedIndex:0];
}
- (void)selDomain1:(id)sender
{
    [self setSelectedIndex:1];
}
- (void)selDomain2:(id)sender
{
    [self setSelectedIndex:2];
}
- (void)setSelectedIndex:(int)index
{
    NSLog(@"select");
    if([self.subviews containsObject:selectedImageView]) {
        [selectedImageView removeFromSuperview];
    }
    
    if(index == 0) {
        [view0 addSubview:selectedImageView];
        [delegate callbackText:label0.text];
    }
    else if(index == 1) {
        [view1 addSubview:selectedImageView];
        [delegate callbackText:label1.text];
    }
    else if(index == 2) {
        [view2 addSubview:selectedImageView];
        [delegate callbackText:label2.text];
    }
    selectedIndex = index;
}

@end
