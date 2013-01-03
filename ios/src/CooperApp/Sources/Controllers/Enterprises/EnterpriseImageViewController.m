//
//  EnterpriseImageViewController.m
//  CooperNative
//
//  Created by sunleepy on 12-12-19.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "EnterpriseImageViewController.h"

@implementation EnterpriseImageViewController

@synthesize topInfoView;
@synthesize buttomInfoView;
@synthesize previewImageView;

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
    label1.text = @"随手派";
    [topInfoView addSubview:label1];
    [label1 release];

    UILabel *label2 = [[UILabel alloc] init];
    label2.textColor = [UIColor whiteColor];
    label2.backgroundColor = [UIColor clearColor];
    label2.textAlignment = UITextAlignmentCenter;
    label2.frame = CGRectMake(0, 40, [Tools screenMaxWidth], 50.0);
    label2.font = [UIFont systemFontOfSize:20.0f];
    label2.text = @"拍个照，把活儿派出去！";
    [topInfoView addSubview:label2];
    [label2 release];

    buttomInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, [Tools screenMaxHeight] - 100, [Tools screenMaxWidth], 100)];
    buttomInfoView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:NAVIGATIONBAR_BG_IMAGE]];
    [self.view addSubview:buttomInfoView];

    UIButton *startPhotoBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    startPhotoBtn.frame = CGRectMake(30, 30, 120, 30);
    [startPhotoBtn setTitle:@"点击拍照" forState:UIControlStateNormal];
    [startPhotoBtn addTarget: self action: @selector(startPhoto:) forControlEvents: UIControlEventTouchUpInside];
    [self.buttomInfoView addSubview:startPhotoBtn];
    
    UIButton *startImageBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    startImageBtn.frame = CGRectMake(170, 30, 120, 30);
    [startImageBtn setTitle:@"从相册选择" forState:UIControlStateNormal];
    [startImageBtn addTarget: self action: @selector(startImage:) forControlEvents: UIControlEventTouchUpInside];
    [self.buttomInfoView addSubview:startImageBtn];
}

- (void)startPhoto:(id)sender
{
    
}

- (void)startImage:(id)sender
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    [self presentModalViewController:imagePickerController animated:YES];

    [imagePickerController release];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"])
    {
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSLog(@"found an image");

        previewImageView = [[UIImageView alloc] initWithImage:image];
        previewImageView.frame = CGRectMake(0, 200, [Tools screenMaxWidth], 100);
        [self.view addSubview:previewImageView];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"close");
}

@end
