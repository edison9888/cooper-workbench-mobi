//
//  AudioViewController.m
//  CooperNative
//
//  Created by sunleepy on 12-12-24.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "AudioViewController.h"
#import "EnterpriseTaskDetailCreateViewController.h"

#define AUDIO_RATE 44100
#define AUDIO_QUALITY AVAudioQualityMedium

@implementation AudioViewController

@synthesize prevViewController;

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
    
    recording = 0;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"audio_bg.png"]];

    self.navigationController.navigationBarHidden = YES;

    //底部
    UIView *tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 96, self.view.bounds.size.width, 96)];
    tabbarView.backgroundColor = [UIColor colorWithRed:228.0/255 green:227.0/255 blue:227.0/255 alpha:1];
    [self.view addSubview:tabbarView];

    //添加关闭按钮
    UIView *closeView = [[[UIView alloc] initWithFrame:CGRectMake(19, 32, 32, 32)] autorelease];
    closeView.backgroundColor = [UIColor clearColor];
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0, 0, 32, 32);
    [closeButton setBackgroundImage:[UIImage imageNamed:@"audio_close.png"] forState:UIControlStateNormal];
    closeButton.userInteractionEnabled = NO;
    [closeView addSubview:closeButton];
    closeView.userInteractionEnabled = YES;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack:)];
    [closeView addGestureRecognizer:recognizer];
    [recognizer release];
    [tabbarView addSubview:closeView];
    
    //添加录音开始按钮
    UIView *startView = [[[UIView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 75) / 2.0, 10, 75, 75)] autorelease];
    startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startButton.frame = CGRectMake(0, 0, 75, 75);
    [startButton setBackgroundImage:[UIImage imageNamed:@"audio_start.png"] forState:UIControlStateNormal];
    startButton.userInteractionEnabled = NO;
    [startView addSubview:startButton];
    startView.userInteractionEnabled = YES;
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startRecord:)];
    [startView addGestureRecognizer:recognizer];
    [recognizer release];
    [tabbarView addSubview:startView];
    
    //添加提交按钮
    submitView = [[[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 51, 32, 32, 32)] autorelease];
    submitView.backgroundColor = [UIColor clearColor];
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.userInteractionEnabled = NO;
    submitButton.frame = CGRectMake(0, 0, 32, 32);
    [submitButton setBackgroundImage:[UIImage imageNamed:@"audio_submit.png"] forState:UIControlStateNormal];
    [submitView addSubview:submitButton];
    submitView.userInteractionEnabled = YES;
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(submitAudio:)];
    [submitView addGestureRecognizer:recognizer];
    [recognizer release];
    [tabbarView addSubview:submitView];
    submitView.hidden = YES;

    recordingView = [[[UIView alloc] init] autorelease];
    recordingView.frame = CGRectMake(0, 56, self.view.bounds.size.width, 300);
    [self.view addSubview:recordingView];

    durationLabel = [[[UILabel alloc] init] autorelease];
    durationLabel.font = [UIFont boldSystemFontOfSize:90.0f];
    durationLabel.textColor = [UIColor colorWithRed:141.0/255 green:132.0/255 blue:123.0/255 alpha:1];
    durationLabel.text = @"00:00";
    durationLabel.backgroundColor = [UIColor clearColor];
    durationLabel.textAlignment = UITextAlignmentCenter;
    durationLabel.frame = CGRectMake(0, 0, self.view.bounds.size.width, 90);
    [recordingView addSubview:durationLabel];

    startAudioImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"audio_inhuatong.png"]] autorelease];
    startAudioImageView.frame = CGRectMake((self.view.bounds.size.width - 157) / 2.0, 123, 157, 113);
    [recordingView addSubview:startAudioImageView];
//
//    //停止录音后UI
//    playingView = [[[UIView alloc] init] autorelease];
//    playingView.frame = CGRectMake(0, 100, [Tools screenMaxWidth], 300);
//    [self.view addSubview:playingView];
//
//    UIImageView *soundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sound.png"]];
//    soundImageView.frame = CGRectMake(([Tools screenMaxWidth] - 48) / 2.0, 0, 48, 48);
//    [playingView addSubview:soundImageView];
//
//    playProgressView = [[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault] autorelease];
//    playProgressView.frame = CGRectMake(20, 80, [Tools screenMaxWidth] - 40, 20);
//    [playingView addSubview:playProgressView];
//
//    UIImageView *playImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play.png"]];
//    playImageView.frame = CGRectMake(([Tools screenMaxWidth] - 64) / 2.0, 120, 64, 64);
//    [playingView addSubview:playImageView];
//    playImageView.userInteractionEnabled = YES;
//    UITapGestureRecognizer *playRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startPlay:)];
//    [playImageView addGestureRecognizer:playRecognizer];
//    [playRecognizer release];
//
//    playingView.hidden = YES;

    //    fileSizeLabel = [[UILabel alloc] init];
    //    fileSizeLabel.text = @"";
    //    fileSizeLabel.frame = CGRectMake(100, 140, 320, 40);
    //    [self.view addSubview:fileSizeLabel];

    ///////////////////////////////////////////////////////////
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];

    if(session == nil) {
        NSLog(@"Error creating session: %@", [sessionError description]);
    }
    else {
        [session setActive:YES error:nil];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)timerUpdate:(id)sender
{
    int m = recorder.currentTime / 60;
    int s = ((int) recorder.currentTime) % 60;
    //    int ss = (recorder.currentTime - ((int)recorder.currentTime)) * 100;

    durationLabel.text = [NSString stringWithFormat:@"%.2d:%.2d", m, s];
    //    NSInteger fileSize =  [self getFileSize:[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"]];

    //    fileSizeLabel.text = [NSString stringWithFormat:@"%d kb", fileSize/1024];

    //    if (_playing)
    //    {
    //        _progress.progress = _player.currentTime/_player.duration;
    //    }
    //    if (_playingMp3)
    //    {
    //        _mp3Progress.progress = _mp3Player.currentTime/_mp3Player.duration;
    //    }
}
- (void)timerUpdate2:(id)sender
{
//    int m = player.currentTime / 60;
//    int s = ((int) player.currentTime) % 60;
//    int ss = (player.currentTime - ((int)player.currentTime)) * 100;
//
//    durationLabel.text = [NSString stringWithFormat:@"%.2d:%.2d %.2d", m, s, ss];
//    NSInteger fileSize =  [self getFileSize:[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"]];

    //    fileSizeLabel.text = @"play original";

    playProgressView.progress = player.currentTime / player.duration;
}

- (void)timerUpdate3:(id)sender
{
    int m = mp3Player.currentTime / 60;
    int s = ((int) mp3Player.currentTime) % 60;
    int ss = (mp3Player.currentTime - ((int)player.currentTime)) * 100;

    durationLabel.text = [NSString stringWithFormat:@"%.2d:%.2d %.2d", m, s, ss];
//    NSInteger fileSize =  [self getFileSize:[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"]];

    //    fileSizeLabel.text = @"play mp3";
}

- (NSInteger) getFileSize:(NSString*) path
{
    NSFileManager * filemanager = [[[NSFileManager alloc]init] autorelease];
    if([filemanager fileExistsAtPath:path]){
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:path error:nil];
        NSNumber *theFileSize;
        if ( (theFileSize = [attributes objectForKey:NSFileSize]) )
            return  [theFileSize intValue];
        else
            return -1;
    }
    else
    {
        return -1;
    }
}

- (void)startPlay:(id)sender
{
    if (player == nil)
    {
        NSError *playerError;
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recordedFile error:&playerError];
        player.meteringEnabled = YES;
        if (player == nil)
        {
            NSLog(@"ERror creating player: %@", [playerError description]);
        }
        player.delegate = self;
    }
    [player play];

    timer = [NSTimer scheduledTimerWithTimeInterval:.001f
                                             target:self
                                           selector:@selector(timerUpdate2:)
                                           userInfo:nil
                                            repeats:YES];
}

- (void)startRecord:(id)sender
{
    if(recording == 0) {
        ///////////////////////////////////////////////////////////
        NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithFloat: AUDIO_RATE],
                                  AVSampleRateKey,
                                  [NSNumber numberWithInt: kAudioFormatLinearPCM],
                                  AVFormatIDKey,
                                  [NSNumber numberWithInt: 2],
                                  AVNumberOfChannelsKey,
                                  [NSNumber numberWithInt: AUDIO_QUALITY],
                                  AVEncoderAudioQualityKey,
                                  nil];
        
        recordedFile = [[NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"]] retain];
        NSError* error;
        recorder = [[AVAudioRecorder alloc] initWithURL:recordedFile settings:settings error:&error];
        if (error)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:@"your device doesn't support your setting"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            [alert release];
            return;
        }
        [recorder prepareToRecord];
        recorder.meteringEnabled = YES;
        [recorder record];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:.001f
                                                 target:self
                                               selector:@selector(timerUpdate:)
                                               userInfo:nil
                                                repeats:YES];
        
        [startButton setBackgroundImage:[UIImage imageNamed:@"audio_stop.png"] forState:UIControlStateNormal];
        startAudioImageView.image = [UIImage imageNamed:@"audio_huatong.png"];
        submitView.hidden = NO;
        recording = 1;
    }
    else {
        [self stopRecord:nil];
        [startButton setBackgroundImage:[UIImage imageNamed:@"audio_start.png"] forState:UIControlStateNormal];
        startAudioImageView.image = [UIImage imageNamed:@"audio_inhuatong.png"];
        recording = 0;
    }
}

- (void)stopRecord:(id)sender
{
    [timer invalidate];
    timer = nil;

    [recorder stop];
    [recorder release];
    recorder = nil;
}

- (void)submitAudio:(id)sender
{
    if(timer) {
        [self stopRecord:nil];
    }
    
    self.HUD = [Tools process:@"正在处理录音文件" view:self.view];

//    [self performSelectorOnMainThread:@selector(processAudio)
//                           withObject:nil
//                        waitUntilDone:YES];

    NSThread* myThread = [[NSThread alloc] initWithTarget:self
                                                 selector:@selector(processAudio)
                                                   object:nil];
    [myThread start];
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [timer invalidate];
    timer = nil;
}

- (void)goBack:(id)sender
{
    [self stopRecord:nil];
    
    prevViewController.navigationController.navigationBarHidden = NO;
    [Tools layerTransition:self.navigationController.view from:@"left"];
    [self.navigationController popToViewController:prevViewController animated:NO];
    //[self dismissModalViewControllerAnimated:YES];
}

- (void)sendFile:(id)sender
{
    NSLog(@"sendFile");

    ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:@"http://10.232.101.129/sysDownload.do?app=cooper&c=2043c21fc83cf3a20f8054a72d6a357c&f_time=1356405137&key=2233949"]];

    NSString *mp3FileName = @"Mp3File2";
    mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
    NSString *mp3FilePath = [[NSHomeDirectory() stringByAppendingFormat:@"/Documents/"] stringByAppendingPathComponent:mp3FileName];
    request.delegate = self;
    [request setDownloadDestinationPath:mp3FilePath];

    [request startAsynchronous];

    //    if (mp3Player == nil)
    //    {
    //
    //        NSError *playerError;
    //        mp3Player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://10.232.101.129/sysDownload.do?app=cooper&c=2043c21fc83cf3a20f8054a72d6a357c&f_time=1356405137&key=2233949"]
    //                                                            error:&playerError];
    //        mp3Player.meteringEnabled = YES;
    //        if (mp3Player == nil)
    //        {
    //            NSLog(@"ERror creating player: %@", [playerError description]);
    //        }
    //        mp3Player.delegate = self;
    //    }
    //    [mp3Player play];
    //    timer = [NSTimer scheduledTimerWithTimeInterval:.1
    //                                              target:self
    //                                           selector:@selector(timerUpdate3:)
    //                                            userInfo:nil
    //                                             repeats:YES];


    //    NSString *cafFilePath =[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"];
    //
    //    NSString *mp3FileName = @"Mp3File";
    //    mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
    //    NSString *mp3FilePath = [[NSHomeDirectory() stringByAppendingFormat:@"/Documents/"] stringByAppendingPathComponent:mp3FileName];
    //
    //    NSLog(@"mp3FilePath:%@", mp3FilePath);
    //
    //    @try {
    //        int read, write;
    //
    //        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source
    //        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
    //        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output
    //
    //        const int PCM_SIZE = 8192;
    //        const int MP3_SIZE = 8192;
    //        short int pcm_buffer[PCM_SIZE*2];
    //        unsigned char mp3_buffer[MP3_SIZE];
    //
    //        lame_t lame = lame_init();
    //        lame_set_in_samplerate(lame, 44100);
    //        lame_set_VBR(lame, vbr_default);
    //        lame_init_params(lame);
    //
    //        do {
    //            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
    //            if (read == 0)
    //                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
    //            else
    //                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
    //
    //            fwrite(mp3_buffer, write, 1, mp3);
    //
    //        } while (read != 0);
    //
    //        lame_close(lame);
    //        fclose(mp3);
    //        fclose(pcm);
    //    }
    //    @catch (NSException *exception) {
    //        NSLog(@"%@",[exception description]);
    //    }
    //    @finally {
    //        [self performSelectorOnMainThread:@selector(convertMp3Finish)
    //                               withObject:nil
    //                            waitUntilDone:YES];
    //    }
}

- (void)processAudio
{
    NSString *cafFilePath =[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"];

    NSString *mp3FileName = @"mp3File";
    mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
    NSString *mp3FilePath = [[NSHomeDirectory() stringByAppendingFormat:@"/Documents/"] stringByAppendingPathComponent:mp3FileName];

    NSLog(@"mp3FilePath:%@", mp3FilePath);

    @try {
        int read, write;

        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output

        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];

        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 44100);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);

        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);

            fwrite(mp3_buffer, write, 1, mp3);

        } while (read != 0);

        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        [self performSelectorOnMainThread:@selector(convertMp3Finish)
                               withObject:nil
                            waitUntilDone:YES];
    }
}

- (void) convertMp3Finish
{
    NSLog(@"convertMp3Finish");

    self.HUD.labelText = @"上传音频文件中";
    
    NSString *mp3FileName = @"mp3File";
    mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
    NSString *mp3FilePath = [[NSHomeDirectory() stringByAppendingFormat:@"/Documents/"] stringByAppendingPathComponent:mp3FileName];

    NSLog(@"mp3FilePath:%@", mp3FilePath);

    NSData *data = [NSData dataWithContentsOfFile:mp3FilePath];

    EnterpriseService *enterpriseService = [[EnterpriseService alloc] init];

    NSString *fileName = [NSString stringWithFormat:@"%@.%@", [Tools NSDateToNSFileString:[NSDate date]], @"mp3"];

    
    NSMutableDictionary *context = [NSMutableDictionary dictionary];
    [context setObject:@"CreateTaskAttach" forKey:REQUEST_TYPE];
    [enterpriseService createTaskAttach:data
                               fileName:fileName
                                   type:@"attachment"
                                context:context
                               delegate:self];


//    [_alert dismissWithClickedButtonIndex:0 animated:YES];
//
//    _alert = [[UIAlertView alloc] init];
//    [_alert setTitle:@"Finish"];
//    [_alert setMessage:[NSString stringWithFormat:@"Conversion takes %fs", [[NSDate date] timeIntervalSinceDate:_startDate]]];
//    [_startDate release];
//    [_alert addButtonWithTitle:@"OK"];
//    [_alert setCancelButtonIndex: 0];
//    [_alert show];
//    [_alert release];
//
//    _hasMp3File = YES;
//    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
//    NSInteger fileSize =  [self getFileSize:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", @"Mp3File.mp3"]];
//    _mp3FileSize.text = [NSString stringWithFormat:@"%d kb", fileSize/1024];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
//    NSLog(@"requestFinished");
//
//    if (mp3Player == nil)
//    {
//
//        NSString *mp3FileName = @"Mp3File2";
//        mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
//        NSString *mp3FilePath = [[NSHomeDirectory() stringByAppendingFormat:@"/Documents/"] stringByAppendingPathComponent:mp3FileName];
//
//        NSError *playerError;
//        mp3Player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:mp3FilePath]
//                                                           error:&playerError];
//        mp3Player.meteringEnabled = YES;
//        if (mp3Player == nil)
//        {
//            NSLog(@"ERror creating player: %@", [playerError description]);
//        }
//        mp3Player.delegate = self;
//    }
//    [mp3Player play];
//    timer = [NSTimer scheduledTimerWithTimeInterval:.1
//                                             target:self
//                                           selector:@selector(timerUpdate3:)
//                                           userInfo:nil
//                                            repeats:YES]
    
    NSLog(@"【请求任务响应数据】%@\n【返回状态码】%d", request.responseString, request.responseStatusCode);
    
    NSDictionary *userInfo = request.userInfo;
    NSString *requestType = [userInfo objectForKey:REQUEST_TYPE];
    
    if([requestType isEqualToString:@"CreateTaskAttach"])
    {
        if(request.responseStatusCode == 200)
        {
            self.HUD.labelText = @"上传完成";
            [self.HUD hide:YES afterDelay:1];

            NSDictionary *dict = [[request responseString] JSONValue];
            if(dict)
            {
                NSNumber *state = [dict objectForKey:@"state"];

                if(state == [NSNumber numberWithInt:0]) {
                    NSMutableDictionary *data = [dict objectForKey:@"data"];
                    
                    NSString *attachmentId = [data objectForKey:@"attachmentId"];
                    NSString *attachmentFileName = [data objectForKey:@"fileName"];
                    NSString *attachmentUrl = [data objectForKey:@"url"];
                    NSMutableDictionary *taskDetailDict = [NSMutableDictionary dictionary];
                    [taskDetailDict setObject:attachmentId forKey:@"attachmentId"];
                    [taskDetailDict setObject:attachmentFileName forKey:@"attachmentFileName"];
                    [taskDetailDict setObject:attachmentUrl forKey:@"attachmentUrl"];

                    EnterpriseTaskDetailCreateViewController *taskDetailCreateViewController = [[EnterpriseTaskDetailCreateViewController alloc] init];

                    taskDetailCreateViewController.taskDetailDict = taskDetailDict;
                    taskDetailCreateViewController.prevViewController = prevViewController;
                    taskDetailCreateViewController.createType = 1;

                    [Tools layerTransition:self.navigationController.view from:@"right"];
                    [self.navigationController pushViewController:taskDetailCreateViewController animated:NO];

                    [taskDetailCreateViewController release];
                }
            }
        }
        else
        {
            self.HUD.labelText = @"上传失败";
            [self.HUD hide:YES afterDelay:1];
        }
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error=[request error];
    NSLog(@"ASIHttpRequest出错了!%@",error);
}

@end