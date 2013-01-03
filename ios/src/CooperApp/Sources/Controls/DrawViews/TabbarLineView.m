//
//  TabbarLineView.m
//  CooperNative
//
//  Created by sunleepy on 12-12-24.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TabbarLineView.h"

@implementation TabbarLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGColorRef color = [UIColor colorWithRed:239.0/255 green:231.0/255 blue:239.0/255 alpha:1].CGColor;
    CGContextSetStrokeColorWithColor(ref, color);
    CGContextBeginPath(ref);
    CGContextMoveToPoint(ref, 0, 0);
    CGContextAddLineToPoint(ref, 320, 0);
//    CGFloat redColor[4]={1.0,0,0,1.0};
//    CGContextSetStrokeColor(ref, redColor);
    CGContextStrokePath(ref);
}

@end
