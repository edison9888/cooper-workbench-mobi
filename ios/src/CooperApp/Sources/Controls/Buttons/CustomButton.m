//
//  CustomButton.m
//  Cooper
//
//  Created by Ping Li on 12-7-25.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "CustomButton.h"

@interface CustomButton()

@end

@implementation CustomButton

- (id)initWithFrame:(CGRect)frame image:(UIImage*)image
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 14.0f;
        self.layer.masksToBounds = YES;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self setBackgroundImage:image forState:UIControlStateNormal];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame color:(UIColor*)color
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 14.0f;
        self.layer.masksToBounds = YES;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.backgroundColor = color;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    
    
}

@end
