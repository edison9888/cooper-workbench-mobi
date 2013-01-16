//
//  EditFillLabelView.m
//  CooperApp
//
//  Created by sunleepy on 13-1-13.
//  Copyright (c) 2013年 codesharp. All rights reserved.
//

#import "EditFillLabelView.h"
#import "EditFillLabel.h"

#define LINE_INTERVAL   14

@implementation EditFillLabelView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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
        EditFillLabel *fillLabel = [[EditFillLabel alloc] initWithFrame:CGRectMake(tagsTotalWidth, tagsTotalHeight, 0, 0)];
        fillLabel.userInteractionEnabled = YES;
        fillLabel.font = [UIFont systemFontOfSize:12.0f];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteData:)];
        recognizer.numberOfTapsRequired = 2;
        [fillLabel addGestureRecognizer:recognizer];
        [recognizer release];
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
            tagsTotalHeight += labelHeight + LINE_INTERVAL;
            tagsTotalWidth = 0.0f;
            fillLabel.frame = CGRectMake(tagsTotalWidth, tagsTotalHeight, labelWidth, labelHeight);
            //tagsTotalWidth += labelWidth + LINE_INTERVAL;
        }
        else
        {
            fillLabel.frame = CGRectMake(tagsTotalWidth, tagsTotalHeight, labelWidth, labelHeight);
        }
        tagsTotalWidth += labelWidth + LINE_INTERVAL;
        
        [self addSubview:fillLabel];
        [fillLabel release];
    }
    tagsTotalHeight += tagHeight;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, tagsTotalHeight);
}

-(void)deleteData:(id)sender
{
    NSLog(@"deleteData");
    UITapGestureRecognizer *recognizer = (UITapGestureRecognizer*)sender;
    EditFillLabel *delLabel = (EditFillLabel*)recognizer.view;
    [delegate deleteTag:delLabel.text];
    //[delLabel removeFromSuperview];
}

@end
