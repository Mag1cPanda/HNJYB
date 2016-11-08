//
//  MoreCarViewController.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/1.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "AccidentHeader.h"
#import "CaseAuditViewController.h"
#import "CollectionFooter.h"
#import "CollectionHeader.h"
#import "DJCameraManager.h"
#import "DJCameraViewController.h"
#import "JCAlertView.h"
#import "MoreCarViewController.h"
#import "RecordHUD.h"
#import "SRAudioRecordController.h"
#import "SRBlockButton.h"
#import "SRVideoPickerController.h"
#import "TakePhotoCell.h"
#import "XZQXViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "lame.h"
#import "GTMBase64.h"

@interface MoreCarViewController () < DJCameraViewControllerDelegate,
                                      UICollectionViewDataSource,
                                      UICollectionViewDelegate,
                                      UICollectionViewDelegateFlowLayout,
                                      UIImagePickerControllerDelegate,
                                      UINavigationControllerDelegate,
                                      AVAudioPlayerDelegate,
                                      UIAlertViewDelegate >
{
    UICollectionView *collection;
    NSMutableDictionary *cellDic;
    AccidentHeader *header;
    NSMutableArray *iconArr;
    NSMutableArray *titleArr;
    NSMutableArray *tipsArr;
    JCAlertView *jcAlert;

    NSMutableDictionary *uploadBean;
    NSMutableDictionary *videoBean;
    NSMutableDictionary *photoDic;
    NSInteger successCount;
    NSString *jfocrname;
    NSString *jfocrcardno;
    NSString *jfocrcarno;
    NSString *jfocrvin;
    NSString *jfocrcartype;

    NSString *yfocrname;
    NSString *yfocrcardno;
    NSString *yfocrcarno;
    NSString *yfocrvin;
    NSString *yfocrcartype;

    MBProgressHUD *hud;

    NSString *jfjszStr;
    NSString *jfxszStr;
    NSString *yfjszStr;
    NSString *yfxszStr;
    NSString *jfcjhStr;
    NSString *yfcjhStr;

    NSData *videoData;

    NSURL *sourceURL;
    NSString *resultPath;
    SRVideoPickerController *vpc;
    UIImage *firstFrame;

    BOOL isSuccess;

    BOOL isUploadedAudio;

    NSString *encodedAudioStr;
    NSTimer *audioTimer;

    NSTimeInterval currentTime;
    UIButton *codeBtn;
    NSTimer *codeTimer;
    NSInteger count;
}
//视频播放器
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
//录音
@property (nonatomic, strong) AVAudioRecorder *recorder;
//播放
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
//录音状态(是否录音)
@property (nonatomic, assign) BOOL isRecoding;
//播放按钮
@property (nonatomic, strong) UIButton *playBtn;
//录音caf文件
@property (nonatomic,strong) NSString *cafFilePath;
//转码后的MP3文件
@property (nonatomic,strong) NSString *mp3FilePath;
//音频文件Data
@property (nonatomic, strong) NSData *voiceData;
@end

//static NSString *cellId = @"TakePhotoCell";
static NSString *const headerId = @"headerId";
static NSString *const footerId = @"footerId";

@implementation MoreCarViewController

#pragma mark - LifeCycle
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_moviePlayer pause];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_moviePlayer play];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"上传事故照片";
    successCount = 0;
    photoDic = [NSMutableDictionary dictionary];
    uploadBean = [NSMutableDictionary dictionary];
    videoBean = [NSMutableDictionary dictionary];
    cellDic = [NSMutableDictionary dictionary];
    [self initUploadBean:uploadBean];
    //    [self getCurrentAreaId];
    [self createUniqueNumber];

    iconArr = @[ @"ctqf",
                 @"IP015",
                 @"IP016",
                 @"IP017",
                 @"jsz",
                 @"IP018",
                 @"jsz",
                 @"IP018",
                 @"IP018",
                 @"IP018",
                 @"ly",
                 @"video",
                 @"add02" ]
                  .mutableCopy;
    titleArr = @[ @"车头前方照片",
                  @"车尾后方照片",
                  @"擦碰点照片",
                  @"事故侧方照片",
                  @"甲方驾驶证照片",
                  @"甲方行驶证照片",
                  @"乙方驾驶证照片",
                  @"乙方行驶证照片",
                  @"甲方车架号照片",
                  @"乙方车架号照片",
                  @"最长可录120S",
                  @"选拍现场视频",
                  @"其他现场照片(选拍)" ]
                   .mutableCopy;
    tipsArr = @[ @"car_double_font",
                 @"car_double_behind",
                 @"car_double_zhuang",
                 @"car_double_other",
                 @"jsznf",
                 @"xsznf",
                 @"jsznf",
                 @"xsznf",
                 @"",
                 @"",
                 @"",
                 @"",
                 @"" ]
                  .mutableCopy;

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 10;
    [layout setHeaderReferenceSize:CGSizeMake(ScreenWidth, 100)];
    [layout setFooterReferenceSize:CGSizeMake(ScreenWidth, 100)];

    collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) collectionViewLayout:layout];
    collection.backgroundColor = [UIColor clearColor];
    collection.delegate = self;
    collection.dataSource = self;
    //    collection.bounces = NO;
    [self.view addSubview:collection];

    //注册Cell Id
    for (NSInteger i = 0; i < 15; i++)
    {
        NSString *cellId = [NSString stringWithFormat:@"TakePhotoCell%zi", i];
        [collection registerNib:[UINib nibWithNibName:@"TakePhotoCell" bundle:nil] forCellWithReuseIdentifier:cellId];
    }

    //注册Header & Footer Id
    [collection registerClass:[CollectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
    [collection registerClass:[CollectionFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];

    _playBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
    UIImage *image1 = [UIImage imageNamed:@"audio001"];
    UIImage *image2 = [UIImage imageNamed:@"audio002"];
    UIImage *image3 = [UIImage imageNamed:@"audio003"];
    [_playBtn setImage:image1 forState:0];
    _playBtn.imageView.animationImages = @[ image1, image2, image3 ];
    _playBtn.imageView.animationDuration = 2;    //设置动画时间
    _playBtn.imageView.animationRepeatCount = 0; //设置动画次数 0 表示无限
    [_playBtn addTarget:self action:@selector(audioPlay) forControlEvents:1 << 6];
    [_playBtn setEnabled:NO];

    //刚打开的时候录音状态为不录音
    self.isRecoding = NO;

    //创建临时文件来存放录音文件
    NSString *urlStr = NSTemporaryDirectory();
    _cafFilePath = [urlStr stringByAppendingPathComponent:@"myRecord.caf"];
    //转化过后的MP3文件位置
    _mp3FilePath = [urlStr  stringByAppendingPathComponent:[NSString stringWithFormat:@"bbb.mp3"]];

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

    //HUD按钮点击事件
    [RecordHUD shareView].stopRecord = ^() {

      currentTime = 0;
      //用户点击按钮  停止录音
      [self stopRecord];

      //上传录音
      [self uploadAudio];

    };
}

#pragma mark - 获取Areaid
- (void)getCurrentAreaId
{
    NSMutableDictionary *bean = [NSMutableDictionary dictionary];

    NSString *maplon = [NSString stringWithFormat:@"%f", GlobleInstance.imagelon];
    NSString *maplat = [NSString stringWithFormat:@"%f", GlobleInstance.imagelat];

    [bean setValue:maplon forKey:@"maplon"];
    [bean setValue:maplat forKey:@"maplat"];

    [LSHttpManager requestUrl:HNServiceURL serviceName:@"jjappgetweather" parameters:bean complete:^(id result, ResultType resultType) {

      if ([result[@"restate"] isEqualToString:@"1"])
      {
          NSLog(@"Areaid -> %@", [Util objectToJson:result]);
          NSString *areaid = result[@"data"];
          GlobleInstance.areaid = areaid;
          [uploadBean setValue:areaid forKey:@"areaid"];
          //获取到areaid之后生成caseno
          [self createUniqueNumber];
      }

    }];
}

#pragma mark - 获取案件编号
- (void)createUniqueNumber
{
    //    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *bean = [NSMutableDictionary dictionary];
    [bean setValue:GlobleInstance.areaid forKey:@"areaid"];
    [bean setValue:GlobleInstance.userflag forKey:@"username"];
    [bean setValue:GlobleInstance.token forKey:@"token"];

    [LSHttpManager requestUrl:HNServiceURL serviceName:@"jjappkckpCreateAppCaseNo" parameters:bean complete:^(id result, ResultType resultType) {

      if ([result[@"restate"] isEqualToString:@"1"])
      {
          NSLog(@"案件编号 -> %@", [Util objectToJson:result]);
          NSString *appcaseno = [NSString stringWithFormat:@"%@", result[@"data"][@"appcaseno"]];
          GlobleInstance.appcaseno = appcaseno;
          [uploadBean setValue:appcaseno forKey:@"appcaseno"];
      }

    }];
}

- (void)initUploadBean:(NSMutableDictionary *)bean
{
    NSString *imagelat = [NSString stringWithFormat:@"%f", GlobleInstance.imagelat];
    NSString *imagelon = [NSString stringWithFormat:@"%f", GlobleInstance.imagelon];
    NSString *imageaddress = [NSString stringWithFormat:@"%@", GlobleInstance.imageaddress];
    NSString *appcaseno = [NSString stringWithFormat:@"%@", GlobleInstance.appcaseno];

    [bean setValue:appcaseno forKey:@"appcaseno"];
    [bean setValue:imagelat forKey:@"imagelat"];
    [bean setValue:imagelon forKey:@"imagelon"];
    [bean setValue:imageaddress forKey:@"imageaddress"];
    [bean setValue:@"1" forKey:@"shoottype"];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    //输出格式为：2010-10-27 10:22:13
    NSLog(@"%@", currentDateStr);

    NSString *username = [NSString stringWithFormat:@"%@", GlobleInstance.userflag];
    NSString *token = [NSString stringWithFormat:@"%@", GlobleInstance.token];
    NSString *areaid = [NSString stringWithFormat:@"%@", GlobleInstance.areaid];

    [bean setValue:currentDateStr forKey:@"imagedate"];
    [bean setValue:username forKey:@"username"];
    [bean setValue:token forKey:@"token"];
    [bean setValue:areaid forKey:@"areaid"];
}

#pragma mark - 拍照
- (void)takePhotoWithIndex:(NSIndexPath *)indexPath
{
    DJCameraViewController *cameraVC = [DJCameraViewController new];
    if (indexPath.item < 10)
    {
        cameraVC.guideImageName = tipsArr[indexPath.item];
    }
    else
    {
        cameraVC.guideImageName = @"car_one_zhuang";
    }
    cameraVC.noticeString = titleArr[indexPath.item];
    cameraVC.isLandscape = YES;
    cameraVC.isShowWarnImage = YES;
    cameraVC.delegate = self;
    cameraVC.index = indexPath.item;
    [self presentViewController:cameraVC animated:YES completion:nil];
}

#pragma mark - 相机代理
- (void)cameraViewController:(DJCameraViewController *)cameraVC ToObtainCameraPhotos:(UIImage *)image
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:cameraVC.index inSection:0];
    TakePhotoCell *cell = (TakePhotoCell *)[collection cellForItemAtIndexPath:indexPath];
    cell.icon.image = image;

    NSString *indexStr = [NSString stringWithFormat:@"%zi", cameraVC.index];
    [photoDic setObject:image forKey:indexStr];

    //增加其他照片
    if (cameraVC.index == 12 || cameraVC.index == 13)
    {
        if (tipsArr.count < 15)
        {
            [tipsArr addObject:@" "];
            [titleArr addObject:@"其他现场照片(选拍)"];
            [iconArr addObject:@"add02"];
        }

        NSLog(@"tipsArr ~ %zi", tipsArr.count);
        NSLog(@"titleArr ~ %zi", titleArr.count);
        NSLog(@"iconArr ~ %zi", iconArr.count);
        [collection reloadData];
    }
}

#pragma mark - 开始录音
- (void)startRecord
{
    //将录音状态变为录音
    self.isRecoding = YES;
    [self.playBtn setEnabled:NO];

    currentTime = 0;
    [RecordHUD show];
    audioTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeAdd) userInfo:nil repeats:YES];

    NSMutableDictionary *recordSetting = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithFloat:8000.0f],AVSampleRateKey,
                                          [NSNumber numberWithInt:2],AVNumberOfChannelsKey,
                                          [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,
                                          [NSNumber numberWithInt:16],AVEncoderBitRateKey,
                                          nil];
    //开始录音,将所获取到得录音存到文件里
    self.recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:_cafFilePath] settings:recordSetting error:nil];

    //准备记录录音
    [_recorder prepareToRecord];

    //启动或者恢复记录的录音文件
    [_recorder record];

    NSTimeInterval recordTime = _recorder.currentTime;
    [RecordHUD setTimeTitle:[NSString stringWithFormat:@"录音: %.0f\"", recordTime]];

    _audioPlayer = nil;
}

#pragma mark - 停止录音
- (void)stopRecord
{
    //录音状态 点击录音按钮 停止录音
    self.isRecoding = NO;
    count = 0;
    self.backBtn.userInteractionEnabled = true;

    //录音停止的时候,播放按钮可以点击
    [self.playBtn setEnabled:YES];

    //停止录音
    [_recorder stop];
    _recorder = nil;
    [RecordHUD dismiss];
    [audioTimer invalidate];

    //MP3格式转换
    [self mp3Transform];
    NSData *audioData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:_mp3FilePath]];

    //GTMBase64转码
    encodedAudioStr = [GTMBase64 stringByEncodingData:audioData];
    
    NSLog(@"_mp3FilePath ~ %@",_mp3FilePath);

    NSError *playError;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:_mp3FilePath] error:&playError];
    //当播放录音为空, 打印错误信息
    if (self.audioPlayer == nil)
    {
        NSLog(@"Error crenting player: %@", [playError description]);
    }
    self.audioPlayer.delegate = self;
}

- (void)mp3Transform
{
    
    @try {
        int read, write;
        FILE *pcm = fopen([_cafFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        //        if(pcm == NULL)
        //        {
        //            NSLog(@"file not found");
        //        }
        
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header,跳过头文件 有的文件录制会有音爆，加上此句话去音爆
        FILE *mp3 = fopen([_mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_num_channels(lame, 2);//设置1为单通道，默认为2双通道
        lame_set_in_samplerate(lame, 8000.0);//11025.0
        //lame_set_VBR(lame, vbr_default);
        lame_set_brate(lame, 16);
        lame_set_mode(lame, 3);
        lame_set_quality(lame, 2);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0) {
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            }else{
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            }
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
        //        return NO;
    }
    @finally {
        
    }
}

//计时器
#pragma mark - 时间自增
- (void)timeAdd
{
    currentTime++;
    [RecordHUD setTimeTitle:[NSString stringWithFormat:@"录音: %.0f\"", currentTime]];

    if (currentTime == 120)
    {
        currentTime = 0;

        //时间达到上限  停止录音
        [self stopRecord];

        //上传录音
        [self uploadAudio];
    }
}

#pragma mark - 上传录音
- (void)uploadAudio
{
    NSMutableDictionary *bean = [NSMutableDictionary dictionary];
    [bean setValue:GlobleInstance.appcaseno forKey:@"appcaseno"];
    [bean setValue:encodedAudioStr forKey:@"voiceurl"];

    NSString *imagelon = [NSString stringWithFormat:@"%f", GlobleInstance.imagelon];
    NSString *imagelat = [NSString stringWithFormat:@"%f", GlobleInstance.imagelat];
    [bean setValue:imagelon forKey:@"imagelon"];
    [bean setValue:imagelat forKey:@"imagelat"];
    [bean setValue:GlobleInstance.imageaddress forKey:@"imageaddress"];
    [bean setValue:GlobleInstance.areaid forKey:@"areaid"];

    MBProgressHUD *voiceHud = [MBProgressHUD showHUDAddedTo:self.view animated:true];

    [LSHttpManager requestUrl:HNServiceURL serviceName:@"jjappkckpsavevoiceinfo" parameters:bean complete:^(id result, ResultType resultType) {

      [voiceHud hide:true];

      if (result)
      {
          NSLog(@"%@", JsonResult);
      }

      TakePhotoCell *cell = (TakePhotoCell *)[collection cellForItemAtIndexPath:[NSIndexPath indexPathForItem:10 inSection:0]];

      if ([result[@"restate"] isEqualToString:@"1"])
      {
          isUploadedAudio = YES;
          cell.titleLab.text = @"录音已上传";
          cell.icon.image = [UIImage imageNamed:@"IP030"];
          cell.icon.contentMode = UIViewContentModeCenter;
      }

      else
      {
          cell.titleLab.text = @"录音上传失败";
          cell.icon.image = [UIImage imageNamed:@"warn"];
          cell.icon.contentMode = UIViewContentModeCenter;
      }

    }];
}

#pragma mark - 播放录音
- (void)audioPlay
{
    //判断是否正在播放,如果正在播放
    if ([self.audioPlayer isPlaying])
    {
        //暂停播放
        [_audioPlayer pause];
        [_playBtn.imageView stopAnimating];
    }
    else
    {
        //开始播放
        [_audioPlayer play];
        [_playBtn.imageView startAnimating];
    }
}

//当播放结束后调用这个方法
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [_playBtn.imageView stopAnimating];
}

#pragma mark - AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self startRecord];
    }
}

#pragma mark - 上传按钮点击事件
- (void)uploadBtnClicked
{
    //再次点击按钮，如果已经上传成功，则直接弹出对话框
    if (isSuccess)
    {
        [self showAlertView];
        return;
    }

    //使用循环查找是否拍摄了所有必拍照片
    for (NSInteger i = 0; i < 10; i++)
    {
        NSString *indexStr = [NSString stringWithFormat:@"%zi", i];

        UIImage *image = photoDic[indexStr];
        if (!image)
        {
            NSString *msg = [NSString stringWithFormat:@"请拍摄%@", titleArr[i]];
            SHOWALERT(msg);
            return; //终止循环
        }
    }

    if (!encodedAudioStr)
    {
        SHOWALERT(@"请录音");
        return;
    }

    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在上传...";

    // 执行任务
    for (int i = 0; i < 10; i++)
    {
        [self uploadImageWith:i];
    }

    //如果有选拍现场照片，则上传照片
    for (NSInteger i = 12; i < 15; i++)
    {
        NSString *indexStr = [NSString stringWithFormat:@"%zi", i];
        UIImage *image = photoDic[indexStr];
        if (image)
        {
            [self uploadImageWith:i];
        }
    }
}

#pragma mark - 上传照片
- (void)uploadImageWith:(NSInteger)index
{
    NSString *indexStr = [NSString stringWithFormat:@"%zi", index];
    UIImage *image = photoDic[indexStr];
    NSString *imageWidth = [NSString stringWithFormat:@"%f", image.size.width];
    NSString *imageHeight = [NSString stringWithFormat:@"%f", image.size.height];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.25);
    NSString *imageBig = [NSString stringWithFormat:@"%zi", imageData.length / 1024];

    NSString *imageStr = [Util imageToString:image];

    NSNumber *type;
    if (index == 0 || index == 1 || index == 2 || index == 3)
    {
        type = [NSNumber numberWithInteger:index];
    }
    else if (index == 4)
    {
        jfjszStr = imageStr;
        type = @6;
    }
    else if (index == 5)
    {
        jfxszStr = imageStr;
        type = @7;
    }
    else if (index == 6)
    {
        yfjszStr = imageStr;
        type = @8;
    }
    else if (index == 7)
    {
        yfxszStr = imageStr;
        type = @9;
    }
    else if (index == 8)
    {
        jfcjhStr = imageStr; //甲方车架号
        type = @14;
    }
    else if (index == 9)
    {
        yfcjhStr = imageStr; //乙方车架号
        type = @15;
    }
    else
    {
        type = @20;
    }

    NSString *token = [NSString stringWithFormat:@"%@", GlobleInstance.token];
    [uploadBean setValue:token forKey:@"token"];
    [uploadBean setValue:imageStr forKey:@"imageurl"];
    [uploadBean setValue:imageBig forKey:@"imagebig"];
    [uploadBean setValue:imageWidth forKey:@"imagewide"];
    [uploadBean setValue:imageHeight forKey:@"imageheigth"];
    [uploadBean setValue:type forKey:@"imagetype"];

    NSLog(@"imagetype -> %@", type);

    [LSHttpManager requestUrl:HNServiceURL serviceName:@"jjzdsubmitcaseimageinfor" parameters:uploadBean complete:^(id result, ResultType resultType) {

      if (result)
      {
          NSLog(@"%zi -> %@", index, [Util objectToJson:result]);
      }

      if ([result[@"restate"] isEqualToString:@"1"])
      {
          successCount++;

          NSDictionary *dataDic = result[@"data"];
          if ([dataDic[@"imagetype"] isEqual:@6])
          {
              jfocrname = dataDic[@"ocrname"];
              jfocrcardno = dataDic[@"ocrcardno"];
          }
          if ([dataDic[@"imagetype"] isEqual:@7])
          {
              jfocrcarno = dataDic[@"ocrcarno"];
              jfocrvin = dataDic[@"ocrvin"];
              jfocrcartype = dataDic[@"ocrcartype"];
          }
          if ([dataDic[@"imagetype"] isEqual:@8])
          {
              yfocrname = dataDic[@"ocrname"];
              yfocrcardno = dataDic[@"ocrcardno"];
          }
          if ([dataDic[@"imagetype"] isEqual:@9])
          {
              yfocrcarno = dataDic[@"ocrcarno"];
              yfocrvin = dataDic[@"ocrvin"];
              yfocrcartype = dataDic[@"ocrcartype"];
          }

          hud.labelText = [NSString stringWithFormat:@"%zi/%zi", successCount, photoDic.allKeys.count];
          if (successCount == photoDic.allKeys.count)
          {
              [hud hide:YES];
              isSuccess = YES;
              [self showAlertView];

              //照片上传完成
              NSMutableDictionary *bean = [NSMutableDictionary dictionary];
              [bean setValue:GlobleInstance.appcaseno forKey:@"appcaseno"];
              [bean setValue:@"data" forKey:@"data"];
              [bean setValue:@"issingle" forKey:@"issingle"];

              [LSHttpManager requestUrl:HNServiceURL serviceName:@"jjappUploadImgIsover" parameters:bean complete:^(id result, ResultType resultType) {

                if ([result[@"restate"] isEqualToString:@"1"])
                {
                    NSLog(@"上传结果 -> %@", [Util objectToJson:result]);
                }

              }];
          }
      }
    }];
}

#pragma mark - 上传视频
- (void)uploadVideo
{
    NSString *imageWidth = [NSString stringWithFormat:@"%f", firstFrame.size.width];
    NSString *imageHeight = [NSString stringWithFormat:@"%f", firstFrame.size.height];
    NSData *imageData = UIImageJPEGRepresentation(firstFrame, 0.25);
    NSString *imageBig = [NSString stringWithFormat:@"%zi", imageData.length / 1024];
    NSString *imageUrl = [Util imageToString:firstFrame];

    //Data转Base64字符串
    NSString *videoStr = [GTMBase64 stringByEncodingData:videoData];

    NSString *imagelat = [NSString stringWithFormat:@"%f", GlobleInstance.imagelat];
    NSString *imagelon = [NSString stringWithFormat:@"%f", GlobleInstance.imagelon];
    NSString *imageaddress = [NSString stringWithFormat:@"%@", GlobleInstance.imageaddress];
    NSString *appcaseno = [NSString stringWithFormat:@"%@", GlobleInstance.appcaseno];
    NSString *areaid = [NSString stringWithFormat:@"%@", GlobleInstance.areaid];

    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];

    [videoBean setValue:appcaseno forKey:@"appcaseno"];
    [videoBean setValue:imagelat forKey:@"imagelat"];
    [videoBean setValue:imagelon forKey:@"imagelon"];
    [videoBean setValue:imageaddress forKey:@"imageaddress"];

    [videoBean setValue:currentDateStr forKey:@"imagedate"];
    [videoBean setValue:areaid forKey:@"areaid"];
    [videoBean setValue:videoStr forKey:@"imageurl"];
    [videoBean setValue:imageBig forKey:@"imagebig"];
    [videoBean setValue:imageWidth forKey:@"imagewide"];
    [videoBean setValue:imageHeight forKey:@"imageheigth"];
    [videoBean setValue:@13 forKey:@"imagetype"];
    [videoBean setValue:imageUrl forKey:@"videopicurl"];
    [videoBean setValue:@"" forKey:@"casetelephoe"];
    [videoBean setValue:@"" forKey:@"shoottype"];

    [LSHttpManager requestUrl:HNServiceURL serviceName:@"kckpsavevideoinfo" parameters:videoBean complete:^(id result, ResultType resultType) {

      if (result)
      {
          NSLog(@"kckpsavevideoinfo-> %@", [Util objectToJson:result]);
      }
      if ([result[@"restate"] isEqualToString:@"1"])
      {
          NSLog(@"上传视频成功");
      }

    }];
}

#pragma mark - 视频拍摄完成
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary< NSString *, id > *)info
{
    sourceURL = [info objectForKey:UIImagePickerControllerMediaURL];
    NSLog(@"%@", [NSString stringWithFormat:@"%f s", [self getVideoLength:sourceURL]]);
    NSLog(@"%@", [NSString stringWithFormat:@"%f kb", [self getFileSize:[[sourceURL absoluteString] substringFromIndex:16]]]);
    [self dismissViewControllerAnimated:YES completion:nil];

    [self convert];

    TakePhotoCell *cell = (TakePhotoCell *)[collection cellForItemAtIndexPath:vpc.indexPath];
    cell.icon.hidden = YES;
    cell.titleLab.hidden = YES;

    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:sourceURL];
    self.moviePlayer.view.frame = cell.contentView.bounds;
    [self.moviePlayer prepareToPlay];

    _moviePlayer.controlStyle = MPMovieControlStyleNone;
    _moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    [cell.contentView addSubview:self.moviePlayer.view];

    _moviePlayer.contentURL = sourceURL;

    videoData = [[NSData alloc] initWithContentsOfURL:sourceURL];

    firstFrame = [_moviePlayer thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];

    NSLog(@"videoData.length %zi", videoData.length);

    [self uploadVideo];
}

- (void)convert
{ //转换时文件不能已存在，否则出错
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:sourceURL options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality])
    {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetLowQuality];
        NSDateFormatter *formater = [[NSDateFormatter alloc] init]; //用时间给文件全名，以免重复，在测试的时候其实可以判断文件是否存在若存在，则删除，重新生成文件即可
        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        resultPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]];
        NSLog(@"%@", resultPath);
        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        exportSession.outputFileType = AVFileTypeMPEG4;
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void) {
          NSLog(@"%zi", exportSession.status);
        }];
    }
}

//此方法可以获取文件的大小，返回的是单位是KB。
- (CGFloat)getFileSize:(NSString *)path
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path])
    {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil]; //获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0 * size / 1024;
    }
    return filesize;
}

//此方法可以获取视频文件的时长。
- (CGFloat)getVideoLength:(NSURL *)URL
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:URL options:opts];
    float second = 0;
    second = urlAsset.duration.value / urlAsset.duration.timescale;
    return second;
}

#pragma mark - 显示上传完成提示框
- (void)showAlertView
{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 60, 200)];
    customView.backgroundColor = [UIColor whiteColor];
    customView.layer.cornerRadius = 5;
    customView.clipsToBounds = YES;

    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(customView.width / 2 - 30, 20, 60, 60)];
    icon.image = [UIImage imageNamed:@"IP030"];
    [customView addSubview:icon];

    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, icon.maxY + 20, customView.width, 20)];
    lab.font = HNFont(14);
    lab.text = @"事故照片上传成功，请进入下一步";
    lab.textColor = [UIColor darkGrayColor];
    lab.textAlignment = NSTextAlignmentCenter;
    [customView addSubview:lab];

    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, lab.maxY + 20, customView.width, 1)];
    horizontalLine.backgroundColor = RGB(235, 235, 235);
    [customView addSubview:horizontalLine];
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(customView.width / 2, lab.maxY + 20, 1, 60)];
    verticalLine.backgroundColor = RGB(235, 235, 235);
    [customView addSubview:verticalLine];

    UIColor *color = [UIColor blackColor];

    SRBlockButton *confirmBtn = [[SRBlockButton alloc] initWithFrame:CGRectMake(0, lab.maxY + 21, customView.width / 2, 60) title:@"确认" titleColor:color handleBlock:^(SRBlockButton *btn) {

      [jcAlert dismissWithCompletion:^{

        //甲方识别结果
        GlobleInstance.jfocrname = jfocrname;
        GlobleInstance.jfocrcardno = jfocrcardno;
        GlobleInstance.jfocrcarno = jfocrcarno;
        GlobleInstance.jfocrvin = jfocrvin;
        GlobleInstance.jfocrcartype = jfocrcartype;

        //乙方识别结果
        GlobleInstance.yfocrname = yfocrname;
        GlobleInstance.yfocrcardno = yfocrcardno;
        GlobleInstance.yfocrcarno = yfocrcarno;
        GlobleInstance.yfocrvin = yfocrvin;
        GlobleInstance.yfocrcartype = yfocrcartype;

        //协警
        if (GlobleInstance.userType == AuxiliaryPolice)
        {
            CaseAuditViewController *vc = [CaseAuditViewController new];
            vc.photoCount = photoDic.allKeys.count;
            [self.navigationController pushViewController:vc animated:YES];
        }
        //交警
        else
        {
            GlobleInstance.jfjszStr = jfjszStr;
            GlobleInstance.jfxszStr = jfxszStr;
            GlobleInstance.yfjszStr = yfjszStr;
            GlobleInstance.yfxszStr = yfxszStr;

            XZQXViewController *vc = [XZQXViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }

      }];

    }];
    [customView addSubview:confirmBtn];

    SRBlockButton *cancelBtn = [[SRBlockButton alloc] initWithFrame:CGRectMake(confirmBtn.maxX + 1, lab.maxY + 21, customView.width / 2, 60) title:@"返回" titleColor:color handleBlock:^(SRBlockButton *btn) {

      [jcAlert dismissWithCompletion:^{

      }];

    }];
    [customView addSubview:cancelBtn];

    jcAlert = [[JCAlertView alloc] initWithCustomView:customView dismissWhenTouchedBackground:YES];
    [jcAlert show];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return iconArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = [NSString stringWithFormat:@"TakePhotoCell%zi", indexPath.item];
    TakePhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    UIImage *image = cell.icon.image;

    if (!image)
    {
        cell.titleLab.text = titleArr[indexPath.row];
        cell.icon.image = [UIImage imageNamed:iconArr[indexPath.row]];
    }

    if (indexPath.item == 10)
    {
        [cell.contentView addSubview:_playBtn];
    }

    return cell;
}

// 和UITableView类似，UICollectionView也可设置段头段尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        CollectionHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];

        return headerView;
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        CollectionFooter *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerId forIndexPath:indexPath];
        [footerView.btn addTarget:self action:@selector(uploadBtnClicked) forControlEvents:1 << 6];
        return footerView;
    }

    return nil;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"item ~ %zi", indexPath.item);

    if (indexPath.item == 11)
    {
        //拍摄视频
        vpc = [[SRVideoPickerController alloc] init];
        vpc.indexPath = indexPath;
        vpc.delegate = self;
        [self presentViewController:vpc animated:YES completion:nil];
    }

    //录音
    else if (indexPath.item == 10)
    {
        TakePhotoCell *cell = (TakePhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];

        if (cell.isRecord)
        {
            UIAlertView *voiceAlert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您已录过音，是否重录？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [voiceAlert show];
        }

        else
        {
            [self startRecord];
            cell.isRecord = true;
        }

        //弹新页面的操作
        //        SRAudioRecordController *vc = [SRAudioRecordController new];
        //        //        __weak typeof(self) weakSelf = self;
        //        vc.audioDidUploaded = ^() {
        //
        //          isUploadedAudio = YES;
        //          cell.titleLab.text = @"录音已上传";
        //          cell.icon.image = [UIImage imageNamed:@"IP030"];
        //          cell.icon.contentMode = UIViewContentModeCenter;
        //
        //        };
        //        [self.navigationController pushViewController:vc animated:YES];
    }

    else
    {
        //拍摄照片
        [self takePhotoWithIndex:indexPath];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (ScreenWidth - 30) / 2;
    return (CGSize){width, width / 1.64 + 20};
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){ScreenWidth, 100};
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return (CGSize){ScreenWidth, 100};
}

@end
