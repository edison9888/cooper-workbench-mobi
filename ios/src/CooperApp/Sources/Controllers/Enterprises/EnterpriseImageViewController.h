//
//  EnterpriseImageViewController.h
//  CooperNative
//
//  Created by sunleepy on 12-12-19.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base2ViewController.h"

@interface EnterpriseImageViewController : Base2ViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, retain) UIView *topInfoView;
@property (nonatomic, retain) UIView *buttomInfoView;

@property (nonatomic, retain) UIImageView *previewImageView;

@end
