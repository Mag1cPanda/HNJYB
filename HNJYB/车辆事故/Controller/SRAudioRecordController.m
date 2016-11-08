//
//  SRAudioRecordController.m
//  HNJYB
//
//  Created by Mag1cPanda on 2016/11/2.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "RecordHUD.h"
#import "SRAudioRecordController.h"
#import <AVFoundation/AVFoundation.h>

@interface SRAudioRecordController () < AVAudioPlayerDelegate,
                                        UIAlertViewDelegate >
{
    NSString *encodedAudioStr;
    NSTimer *audioTimer;

    NSTimeInterval currentTime;
    UIButton *codeBtn;
    NSTimer *codeTimer;
    NSInteger count;
}
//录音存储路径
@property (nonatomic, strong) NSURL *tmpFile;
//录音
@property (nonatomic, strong) AVAudioRecorder *recorder;
//播放
@property (nonatomic, strong) AVAudioPlayer *player;
//录音状态(是否录音)
@property (nonatomic, assign) BOOL isRecoding;

//录音按钮
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
//播放按钮
@property (weak, nonatomic) IBOutlet UIButton *playButton;

//录音按钮
//@property (strong, nonatomic)  UIButton *recordButton;
//播放按钮
//@property (strong, nonatomic)  UIButton *playButton;
@end

@implementation SRAudioRecordController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"录音";
    self.view.backgroundColor = HNBackColor;

    //    _recordButton= [UIButton buttonWithType:UIButtonTypeCustom];
    //    _recordButton.frame = CGRectMake(10, self.view.height/2-15, self.view.width/2-15, 30);
    //    [_recordButton setTitle:@"录音" forState:0];
    //    [_recordButton setTitleColor:HNGreen forState:0];
    //    _recordButton.titleLabel.font = HNFont(14);
    [_recordButton addTarget:self action:@selector(audioRecord) forControlEvents:1 << 6];
    //    [self.view addSubview:_recordButton];

    //    _playButton= [UIButton buttonWithType:UIButtonTypeCustom];
    //    _playButton.frame = CGRectMake(_recordButton.maxX+10, self.view.height/2-15, self.view.width/2-15, 30);
    //    [_playButton setTitle:@"播放" forState:0];
    //    [_playButton setTitleColor:HNGreen forState:0];
    //    _playButton.titleLabel.font = HNFont(14);
    //播放按钮不能被点击
    [_playButton setEnabled:NO];
    //播放按钮设置成半透明
    //    _playButton.titleLabel.alpha = 0.5;
    [_playButton addTarget:self action:@selector(audioPlay) forControlEvents:1 << 6];
    //    [self.view addSubview:_playButton];

    //刚打开的时候录音状态为不录音
    self.isRecoding = NO;

    //创建临时文件来存放录音文件
    self.tmpFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"JFTmpFile"]];

    //设置后台播放
    AVAudioSession *session = [AVAudioSession sharedInstance];

    NSError *sessionError;

    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];

    //判断后台有没有播放
    if (session == nil)
    {
        NSLog(@"Error creating sessing:%@", [sessionError description]);
    }
    else
    {
        [session setActive:YES error:nil];
    }
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 上传录音
- (IBAction)uploadBtnClicked:(id)sender
{
    [self uploadAudio];
}

-(void)uploadAudio{
    NSMutableDictionary *bean = [NSMutableDictionary dictionary];
    [bean setValue:GlobleInstance.appcaseno forKey:@"appcaseno"];
    [bean setValue:encodedAudioStr forKey:@"voiceurl"];
    
    NSString *imagelon = [NSString stringWithFormat:@"%f", GlobleInstance.imagelon];
    NSString *imagelat = [NSString stringWithFormat:@"%f", GlobleInstance.imagelat];
    [bean setValue:imagelon forKey:@"imagelon"];
    [bean setValue:imagelat forKey:@"imagelat"];
    [bean setValue:GlobleInstance.imageaddress forKey:@"imageaddress"];
    [bean setValue:GlobleInstance.areaid forKey:@"areaid"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    
    [LSHttpManager requestUrl:HNServiceURL serviceName:@"jjappkckpsavevoiceinfo" parameters:bean complete:^(id result, ResultType resultType) {
        
        [hud hide:true];
        
        if (result)
        {
            NSLog(@"%@", JsonResult);
        }
        
        if ([result[@"restate"] isEqualToString:@"1"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"录音上传成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            
            if (_audioDidUploaded)
            {
                _audioDidUploaded();
            }
        }
        
    }];
}

#pragma mark - AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - 录音按钮点击事件
- (void)audioRecord
{
    //判断当录音状态为不录音的时候
    if (!self.isRecoding)
    {
        [self startRecord];
    }
    else
    {
        [self stopRecord];
    }
}

#pragma mark - 开始录音
-(void)startRecord
{
    //将录音状态变为录音
    self.isRecoding = YES;
    self.backBtn.userInteractionEnabled = false;
    
    currentTime = 0;
    [RecordHUD show];
    audioTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeAdd) userInfo:nil repeats:YES];
    
    //将录音按钮变为停止
    [self.recordButton setTitle:@"停止" forState:UIControlStateNormal];
    
    //播放按钮不能被点击
    [self.playButton setEnabled:NO];
    self.playButton.titleLabel.alpha = 0.5;
    
    
    NSMutableDictionary *recordSetting = [NSMutableDictionary dictionary];
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
   
//    NSMutableDictionary *recordSetting = [NSMutableDictionary dictionary];
//    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEGLayer3] forKey:AVFormatIDKey];
//    [recordSetting setValue:[NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
//    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
//    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    
    [recordSetting setValue:[NSNumber numberWithBool:YES] forKey:AVLinearPCMIsBigEndianKey];
    [recordSetting setValue:[NSNumber numberWithBool:YES] forKey:AVLinearPCMIsFloatKey];
    
    //开始录音,将所获取到得录音存到文件里
    self.recorder = [[AVAudioRecorder alloc] initWithURL:_tmpFile settings:recordSetting error:nil];
    
    //准备记录录音
    [_recorder prepareToRecord];
    
    //启动或者恢复记录的录音文件
    [_recorder record];
    
    NSTimeInterval recordTime = _recorder.currentTime;
//    [RecordHUD setTimeTitle:[NSString stringWithFormat:@"录音: %.0f\"", recordTime]];
    
    _player = nil;
}

#pragma mark - 停止录音
-(void)stopRecord
{
    //录音状态 点击录音按钮 停止录音
    self.isRecoding = NO;
    self.backBtn.userInteractionEnabled = true;
    [self.recordButton setTitle:@"录音" forState:UIControlStateNormal];
    
    //录音停止的时候,播放按钮可以点击
    [self.playButton setEnabled:YES];
    [self.playButton.titleLabel setAlpha:1];
    
    //停止录音
    [_recorder stop];
    _recorder = nil;
    [RecordHUD dismiss];
    [audioTimer invalidate];
    
    NSData *audioData = [NSData dataWithContentsOfURL:self.tmpFile];
    
    encodedAudioStr = [audioData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    encodedAudioStr = [encodedAudioStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
    encodedAudioStr = [encodedAudioStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    encodedAudioStr = [encodedAudioStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    encodedAudioStr = [encodedAudioStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    encodedAudioStr = [NSString stringWithFormat:@"\"%@\"", encodedAudioStr];
    
    //        NSLog(@"录音文件 -> %@",encodedAudioStr);
    
    NSError *playError;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:_tmpFile error:&playError];
    //当播放录音为空, 打印错误信息
    if (self.player == nil)
    {
        NSLog(@"Error crenting player: %@", [playError description]);
    }
    self.player.delegate = self;
}

#pragma mark - 时间自增
- (void)timeAdd
{
    currentTime++;
//    [RecordHUD setTimeTitle:[NSString stringWithFormat:@"录音: %.0f\"", currentTime]];

    if (currentTime == 100)
    {
        //时间达到上限  停止录音
        [self stopRecord];
        
        //上传录音
        [self uploadAudio];
    }
}

#pragma mark - 播放
- (void)audioPlay
{
    //判断是否正在播放,如果正在播放
    if ([self.player isPlaying])
    {
        //暂停播放
        [_player pause];
        [self.playButton setTitle:@"播放" forState:UIControlStateNormal];
    }
    else
    {
        //开始播放
        [_player play];
        [self.playButton setTitle:@"暂停" forState:UIControlStateNormal];
    }
}

//当播放结束后调用这个方法
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //按钮标题变为播放
    [self.playButton setTitle:@"播放" forState:UIControlStateNormal];
}

@end
