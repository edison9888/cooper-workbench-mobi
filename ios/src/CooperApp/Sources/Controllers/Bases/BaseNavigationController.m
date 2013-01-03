//
//  BaseNavigationController.m
//  Cooper
//
//  Created by sunleepy on 12-7-27.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "BaseNavigationController.h"

@implementation BaseNavigationController

- (void)loadView
{
    [super loadView];
//    self.navigationBar.tintColor = APP_BACKGROUNDCOLOR_2;

//    self.navigationBar.backgroundColor = [UIColor clearColor];
    if(MODEL_VERSION >= 5.0)
    {
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background.png"] forBarMetrics:UIBarMetricsDefault];
    }
    else {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_background.png"]];
        [imageView setFrame:CGRectMake(0, 0, [Tools screenMaxWidth], 44)];
        [self.navigationBar addSubview:imageView];
        [imageView release];
    }
}

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
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
