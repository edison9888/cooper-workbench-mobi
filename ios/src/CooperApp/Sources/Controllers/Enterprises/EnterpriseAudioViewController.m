//
//  EnterpriseAudioViewController.m
//  CooperNative
//
//  Created by sunleepy on 12-12-19.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "EnterpriseAudioViewController.h"

@implementation EnterpriseAudioViewController

@synthesize topInfoView;
@synthesize buttomInfoView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initContentView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc
{
    [topInfoView release];
    [buttomInfoView release];

    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

# pragma 似有方法

- (void)initContentView
{
    //TODO:导航下拉动画效果制作
    //TODO:封装UILabel效果
    topInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Tools screenMaxWidth], 100)];
    topInfoView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:NAVIGATIONBAR_BG_IMAGE]];
    [self.view addSubview:topInfoView];

    UILabel *label1 = [[UILabel alloc] init];
    label1.textColor = [UIColor whiteColor];
    label1.backgroundColor = [UIColor clearColor];
    label1.textAlignment = UITextAlignmentCenter;
    label1.frame = CGRectMake(0, 10, [Tools screenMaxWidth], 50.0);
    label1.font = [UIFont boldSystemFontOfSize:20.0f];
    label1.text = @"随口记";
    [topInfoView addSubview:label1];
    [label1 release];

    UILabel *label2 = [[UILabel alloc] init];
    label2.textColor = [UIColor whiteColor];
    label2.backgroundColor = [UIColor clearColor];
    label2.textAlignment = UITextAlignmentCenter;
    label2.frame = CGRectMake(0, 40, [Tools screenMaxWidth], 50.0);
    label2.font = [UIFont systemFontOfSize:20.0f];
    label2.text = @"说句话，把活儿记下来！";
    [topInfoView addSubview:label2];
    [label2 release];

    buttomInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, [Tools screenMaxHeight] - 100, [Tools screenMaxWidth], 100)];
    buttomInfoView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:NAVIGATIONBAR_BG_IMAGE]];
    [self.view addSubview:buttomInfoView];

    UIButton *startAudioBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    startAudioBtn.frame = CGRectMake(110, 30, 120, 30);
    [startAudioBtn setTitle:@"点击开始录音" forState:UIControlStateNormal];
    [startAudioBtn addTarget: self action: @selector(startAudio:) forControlEvents: UIControlEventTouchUpInside];

    [self.buttomInfoView addSubview:startAudioBtn];
}

- (void)startAudio:(id)sender
{
    
}

@end
