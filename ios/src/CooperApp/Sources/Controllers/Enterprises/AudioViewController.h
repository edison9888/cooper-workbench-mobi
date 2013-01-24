//
//  AudioViewController.h
//  CooperNative
//
//  Created by sunleepy on 12-12-24.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base2ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#include "lame.h"
#import "TabbarLineView.h"
#import "CooperService/EnterpriseService.h"

@interface AudioViewController : Base2ViewController<AVAudioPlayerDelegate, ASIProgressDelegate>
{
    NSURL *recordedFile;
    NSTimer *timer;
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    AVAudioPlayer *mp3Player;

    UIView *recordingView;
    UIView *playingView;

    UILabel *durationLabel;

    UIView *stopView;
    UIView *submitView;
    UIProgressView *playProgressView;

    UIImageView *startAudioImageView;
    
    UIButton *startButton;
    
    int recording;

    ASIHTTPRequest *uploadAudioRequest;
    
    //UILabel *fileSizeLabel;
}

@property (retain, nonatomic) UIViewController *prevViewController;

@end