//
//  AudioPreviewViewController.h
//  CooperNative
//
//  Created by sunleepy on 12-12-27.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base2ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#include "lame.h"

@interface AudioPreviewViewController : Base2ViewController<AVAudioPlayerDelegate>
{
    AVAudioPlayer *mp3Player;
}
@property (nonatomic, retain) NSString *url;

@end
