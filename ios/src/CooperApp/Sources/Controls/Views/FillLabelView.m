//
//  FillLabelView.m
//  Sample
//
//  Created by sunleepy on 12-10-19.
//  Copyright (c) 2012年 sunleepy. All rights reserved.
//

#import "FillLabelView.h"
#import "FillLabel.h"

@implementation FillLabelView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}

- (void)bindTags:(NSMutableArray*)tags
{
    [self bindTags:tags backgroundColor:nil textColor:nil font:nil radius:0];
}

- (void)bindTags:(NSMutableArray*)tags
 backgroundColor:(UIColor*)backgroundColor
       textColor:(UIColor*)textColor
            font:(UIFont*)font
          radius:(CGFloat)radius
{
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }

    CGFloat frameWidth = self.frame.size.width;
    
    CGFloat tagsTotalWidth = 0.0f;
    CGFloat tagsTotalHeight = 0.0f;
    
    CGFloat tagHeight = 0.0f;
    for (NSString *tag in tags)
    {
        FillLabel *fillLabel = [[FillLabel alloc] initWithFrame:CGRectMake(tagsTotalWidth, tagsTotalHeight, 0, 0)];
        if(backgroundColor != nil) {
            fillLabel.backgroundColor = backgroundColor;
        }
        if(textColor != nil) {
            fillLabel.textColor = textColor;
        }
        if(font != nil) {
            fillLabel.font = font;
        }
        if(radius != 0) {
            fillLabel.radius = radius;
        }
        fillLabel.text = tag;
        //fillLabel.frame = CGRectMake(0, 0, fillLabel.frame.size.width + 42, 0);
        CGFloat labelWidth = fillLabel.frame.size.width + 20;
        CGFloat labelHeight = fillLabel.frame.size.height + 10;
//        tagsTotalWidth += labelWidth + 2;
        tagHeight = labelHeight;
        
        if(tagsTotalWidth >= frameWidth)
        {
            tagsTotalHeight += labelHeight + 6;
            tagsTotalWidth = 0.0f;
            fillLabel.frame = CGRectMake(tagsTotalWidth, tagsTotalHeight, labelWidth, labelHeight);
            tagsTotalWidth += labelWidth + 6;
        }
        else
        {
            fillLabel.frame = CGRectMake(tagsTotalWidth, tagsTotalHeight, labelWidth, labelHeight);
        }
        tagsTotalWidth += labelWidth + 6;
        
        [self addSubview:fillLabel];
        [fillLabel release];
    }
    tagsTotalHeight += tagHeight;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, tagsTotalHeight);
}

@end
