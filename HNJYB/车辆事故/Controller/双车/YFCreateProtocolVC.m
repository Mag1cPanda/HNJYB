//
//  YFCreateProtocolVC.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/2.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "JCAlertView.h"
#import "MoreTipsViewController.h"
#import "QRadioButton.h"
#import "RecordHUD.h"
#import "SRBlockButton.h"
#import "SignViewController.h"
#import "YFCreateProtocolVC.h"
#import "ZRRDView.h"
#import <AVFoundation/AVFoundation.h>

@interface YFCreateProtocolVC () < SignViewControllerDelegate,
                                   UIActionSheetDelegate,
                                   AVAudioPlayerDelegate >
{
    UIScrollView *scroll;
    UIImageView *signView;
    JCAlertView *jcAlert;
    JCAlertView *endAlert;
    NSMutableDictionary *bean;

    ZRRDView *zrrd;
    ZRRDView *jsrxm;
    ZRRDView *cphm;
    ZRRDView *lxdh;
    ZRRDView *sjyzm;
    ZRRDView *jsrqm;
    ZRRDView *jsyly;

    UITextField *codeField;

    NSString *yfJuqian;

    QRadioButton *_radio1;
    QRadioButton *_radio2;

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
@property (strong, nonatomic) UIButton *recordButton;
//播放按钮
@property (strong, nonatomic) UIButton *playButton;
@end

@implementation YFCreateProtocolVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    if (_titleStr) {
    //        self.title = _titleStr;
    //    }
    //    else{
    //        self.title = @"生成认定书";
    //    }

    self.title = @"生成认定书";

    count = 60;

    bean = [NSMutableDictionary dictionary];
    NSString *appcaseno = GlobleInstance.appcaseno;
    [bean setValue:appcaseno forKey:@"appcaseno"];
    [bean setValue:GlobleInstance.userflag forKey:@"username"];
    [bean setValue:GlobleInstance.token forKey:@"token"];

    [self initScroll];

    if (_partyBModel)
    {
        [self setDutyTypeWithCode:_partyBModel.dutytype];
        jsrxm.contentLab.text = _partyBModel.carownname;
        cphm.contentLab.text = _partyBModel.casecarno;
        lxdh.contentLab.text = _partyBModel.carownphone;
    }

    //刚打开的时候录音状态为不录音
    self.isRecoding = NO;

    //创建临时文件来存放录音文件
    self.tmpFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"YFTmpFile"]];

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

#pragma mark - 责任类型文字转换为代码
- (void)setDutyTypeWithCode:(NSString *)code
{
    if ([code isEqualToString:@"0"])
    {
        zrrd.contentLab.text = @"全责";
    }
    if ([code isEqualToString:@"1"])
    {
        zrrd.contentLab.text = @"无责";
    }
    if ([code isEqualToString:@"2"])
    {
        zrrd.contentLab.text = @"同责";
    }
    if ([code isEqualToString:@"3"])
    {
        zrrd.contentLab.text = @"主责";
    }
    if ([code isEqualToString:@"4"])
    {
        zrrd.contentLab.text = @"次责";
    }
}

#pragma mark - ScrollView初始化
- (void)initScroll
{
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    [self.view addSubview:scroll];

    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    header.backgroundColor = HNBlue;

    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, header.height - 20, header.height - 20)];
    icon.image = [UIImage imageNamed:@"IP013"];
    [header addSubview:icon];

    UILabel *headerLab = [[UILabel alloc] initWithFrame:CGRectMake(icon.maxX + 10, header.height / 2 - 20, ScreenWidth - icon.maxX - 20, 40)];
    if (ScreenWidth == 320) {
        headerLab.height = 60;
    }
    headerLab.textColor = [UIColor whiteColor];
    headerLab.numberOfLines = 0;
    headerLab.textAlignment = NSTextAlignmentCenter;
    headerLab.text = @"系统将以短信方式向双方手机发送验证码，如长时间未收到请点击重发验证码";
    headerLab.font = [UIFont systemFontOfSize:15];
    [header addSubview:headerLab];

    [scroll addSubview:header];

    /*---------------------------*/

    CGFloat viewWidth = ScreenWidth - 20;
    CGFloat viewHeight = 50;

    ZRRDView *titleView = [[ZRRDView alloc] initWithFrame:CGRectMake(10, header.maxY + 20, viewWidth, viewHeight)];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 50)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = @"乙方信息";
    [titleView addSubview:titleLab];
    [scroll addSubview:titleView];

    /*---------------------------*/

    zrrd = [[ZRRDView alloc] initWithFrame:CGRectMake(10, titleView.maxY + 10, viewWidth, viewHeight)];
    zrrd.titleLab.text = @"责任认定:";
    zrrd.contentLab.textColor = HNGreen;
    [scroll addSubview:zrrd];

    [self setDutyTypeWithCode:_yfDutyType];

    /*---------------------------*/

    jsrxm = [[ZRRDView alloc] initWithFrame:CGRectMake(10, zrrd.maxY + 10, viewWidth, viewHeight)];
    jsrxm.titleLab.text = @"驾驶人姓名:";
    jsrxm.contentLab.text = _yfModel.name;
    [scroll addSubview:jsrxm];

    cphm = [[ZRRDView alloc] initWithFrame:CGRectMake(10, jsrxm.maxY + 10, viewWidth, viewHeight)];
    cphm.titleLab.text = @"车牌号码:";
    cphm.contentLab.text = _yfModel.carNum;
    [scroll addSubview:cphm];

    /*---------------------------*/

    lxdh = [[ZRRDView alloc] initWithFrame:CGRectMake(10, cphm.maxY + 10, viewWidth, viewHeight)];
    lxdh.titleLab.text = @"联系人电话:";
    lxdh.contentLab.text = _yfModel.phoneNum;
    [scroll addSubview:lxdh];

    /*---------------------------*/

    ZRRDView *jq = [[ZRRDView alloc] initWithFrame:CGRectMake(10, lxdh.maxY + 10, viewWidth, viewHeight)];
    jq.titleLab.text = @"拒签:";
    [scroll addSubview:jq];

    CGFloat btnWidth = 20;
    CGFloat btnHeight = 20;
    CGFloat btnY = jq.height/2-10;

    _radio1 = [[QRadioButton alloc] initWithDelegate:self groupId:@"jq"];
    _radio1.frame = CGRectMake(110, btnY, btnWidth, btnHeight);
    _radio1.checked = NO;
    [jq addSubview:_radio1];
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(_radio1.maxX, btnY, 40, btnHeight)];
    lab1.text = @"是";
    lab1.font = HNFont(15);
    [jq addSubview:lab1];

    _radio2 = [[QRadioButton alloc] initWithDelegate:self groupId:@"jq"];
    _radio2.frame = CGRectMake(lab1.maxX, btnY, btnWidth, btnHeight);
    _radio2.checked = YES;
    [jq addSubview:_radio2];
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(_radio2.maxX, btnY, 40, btnHeight)];
    lab2.text = @"否";
    lab2.font = HNFont(15);
    [jq addSubview:lab2];

    /*---------------------------*/

    sjyzm = [[ZRRDView alloc] initWithFrame:CGRectMake(10, jq.maxY + 10, viewWidth, viewHeight)];
    sjyzm.titleLab.text = @"手机验证码:";
    [scroll addSubview:sjyzm];

    codeField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, sjyzm.width-195, 30)];
    codeField.placeholder = @"在此填写验证码";
    codeField.font = HNFont(14);
    [sjyzm addSubview:codeField];

    codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    codeBtn.frame = CGRectMake(sjyzm.width-85, 10, 80, 30);
    [codeBtn addTarget:self action:@selector(getVerifyCode) forControlEvents:1 << 6];
    codeBtn.titleLabel.font = HNFont(13);
    [codeBtn setTitle:@"获取验证码" forState:0];
    [codeBtn setTitleColor:HNGreen forState:0];
    [sjyzm addSubview:codeBtn];

    /*---------------------------*/

    jsrqm = [[ZRRDView alloc] initWithFrame:CGRectMake(10, sjyzm.maxY + 10, viewWidth, viewHeight)];
    jsrqm.titleLab.text = @"驾驶人签名:";
    [scroll addSubview:jsrqm];

    signView = [[UIImageView alloc] initWithFrame:CGRectMake(110, 0, jsrqm.height * ScreenHeight / ScreenWidth, jsrqm.height)];
    [jsrqm addSubview:signView];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signature)];
    [jsrqm addGestureRecognizer:tap];

    /*---------------------------*/

    //    jsyly = [[ZRRDView alloc] initWithFrame:CGRectMake(10, jsrqm.maxY+10, viewWidth, viewHeight)];
    //    jsyly.titleLab.text = @"驾驶人录音:";
    //    [scroll addSubview:jsyly];
    //
    //    _recordButton= [UIButton buttonWithType:UIButtonTypeCustom];
    //    _recordButton.frame = CGRectMake(110, 0, 60, viewHeight);
    //    [_recordButton setTitle:@"录音" forState:0];
    //    [_recordButton setTitleColor:HNGreen forState:0];
    //    _recordButton.titleLabel.font = HNFont(14);
    //    [_recordButton addTarget:self action:@selector(audioRecord) forControlEvents:1<<6];
    ////    [jsyly addSubview:_recordButton];
    //
    //
    //    _playButton= [UIButton buttonWithType:UIButtonTypeCustom];
    //    _playButton.frame = CGRectMake(180, 0, 60, viewHeight);
    //    [_playButton setTitle:@"播放" forState:0];
    //    [_playButton setTitleColor:HNGreen forState:0];
    //    _playButton.titleLabel.font = HNFont(14);
    //    //播放按钮不能被点击
    //    [_playButton setEnabled:NO];
    //    //播放按钮设置成半透明
    //    _playButton.titleLabel.alpha = 0.5;
    //    [_playButton addTarget:self action:@selector(audioPlay) forControlEvents:1<<6];
    //    [jsyly addSubview:_playButton];

    /*---------------------------*/

    UILabel *tipsLab = [[UILabel alloc] initWithFrame:CGRectMake(10, jsrqm.maxY + 20, viewWidth, 40)];
    tipsLab.textColor = [UIColor redColor];
    tipsLab.font = HNFont(14);
    tipsLab.textAlignment = 0;
    tipsLab.text = @"验证码输入后，将视为您已经确认事故相关信息无误并认可事故责任";
    tipsLab.numberOfLines = 0;
    [scroll addSubview:tipsLab];

    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(10, tipsLab.maxY + 20, viewWidth, 50);

    //    if (_titleStr) {
    //       [nextBtn setTitle:_titleStr forState:0];
    //    }
    //    else{
    //       [nextBtn setTitle:@"认可并提交生成事故责任协议书" forState:0];
    //    }

    [nextBtn setTitle:@"认可并提交生成事故认定书" forState:0];

    [nextBtn setTitleColor:[UIColor whiteColor] forState:0];
    nextBtn.backgroundColor = HNBlue;
    nextBtn.titleLabel.font = HNFont(16);
    [nextBtn addTarget:self action:@selector(toNextPage) forControlEvents:1 << 6];
    nextBtn.layer.cornerRadius = 5;
    [scroll addSubview:nextBtn];

    //交警账号
    if (UserType == TrafficPolice)
    {
        scroll.contentSize = CGSizeMake(ScreenWidth, nextBtn.maxY + 20);
    }

    //协警账号
    else
    {
        UIButton *reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        reportBtn.frame = CGRectMake(10, nextBtn.maxY + 10, viewWidth, 50);
        [reportBtn setTitle:@"不认可" forState:0];
        [reportBtn setTitleColor:[UIColor whiteColor] forState:0];
        reportBtn.backgroundColor = HNBlue;
        reportBtn.titleLabel.font = HNFont(16);
        [reportBtn addTarget:self action:@selector(callPolice) forControlEvents:1 << 6];
        [scroll addSubview:reportBtn];

        scroll.contentSize = CGSizeMake(ScreenWidth, reportBtn.maxY + 20);
    }
}

//#pragma mark - 录音
//- (void)audioRecord
//{
//    //判断当录音状态为不录音的时候
//    if (!self.isRecoding)
//    {
//        //将录音状态变为录音
//        self.isRecoding = YES;
//
//        currentTime = 0;
//        [RecordHUD show];
//        audioTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeAdd) userInfo:nil repeats:YES];
//
//        //将录音按钮变为停止
//        [self.recordButton setTitle:@"停止" forState:UIControlStateNormal];
//
//        //播放按钮不能被点击
//        [self.playButton setEnabled:NO];
//        self.playButton.titleLabel.alpha = 0.5;
//
//        //开始录音,将所获取到得录音存到文件里
//        self.recorder = [[AVAudioRecorder alloc] initWithURL:_tmpFile settings:@{} error:nil];
//
//        //准备记录录音
//        [_recorder prepareToRecord];
//
//        //启动或者恢复记录的录音文件
//        [_recorder record];
//
//        NSTimeInterval recordTime = _recorder.currentTime;
//        [RecordHUD setTimeTitle:[NSString stringWithFormat:@"录音: %.0f\"", recordTime]];
//
//        _player = nil;
//    }
//    else
//    {
//        //录音状态 点击录音按钮 停止录音
//        self.isRecoding = NO;
//        [self.recordButton setTitle:@"录音" forState:UIControlStateNormal];
//
//        //录音停止的时候,播放按钮可以点击
//        [self.playButton setEnabled:YES];
//        [self.playButton.titleLabel setAlpha:1];
//
//        //停止录音
//        [_recorder stop];
//        _recorder = nil;
//        [RecordHUD dismiss];
//        [audioTimer invalidate];
//
//        NSData *data = [NSData dataWithContentsOfURL:self.tmpFile];
//
//        encodedAudioStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//        encodedAudioStr = [encodedAudioStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
//        encodedAudioStr = [encodedAudioStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//        encodedAudioStr = [encodedAudioStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//        encodedAudioStr = [encodedAudioStr stringByReplacingOccurrencesOfString:@" " withString:@""];
//        encodedAudioStr = [NSString stringWithFormat:@"\"%@\"", encodedAudioStr];
//
//        //        NSLog(@"录音文件 -> %@",encodedAudioStr);
//
//        NSError *playError;
//        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:_tmpFile error:&playError];
//        //当播放录音为空, 打印错误信息
//        if (self.player == nil)
//        {
//            NSLog(@"Error crenting player: %@", [playError description]);
//        }
//        self.player.delegate = self;
//    }
//}

//- (void)timeAdd
//{
//    currentTime++;
//    [RecordHUD setTimeTitle:[NSString stringWithFormat:@"录音: %.0f\"", currentTime]];
//}

//#pragma mark - 播放
//- (void)audioPlay
//{
//    //判断是否正在播放,如果正在播放
//    if ([self.player isPlaying])
//    {
//        //暂停播放
//        [_player pause];
//        [self.playButton setTitle:@"播放" forState:UIControlStateNormal];
//    }
//    else
//    {
//        //开始播放
//        [_player play];
//        [self.playButton setTitle:@"暂停" forState:UIControlStateNormal];
//    }
//}
//
////当播放结束后调用这个方法
//- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
//{
//    //按钮标题变为播放
//    [self.playButton setTitle:@"播放" forState:UIControlStateNormal];
//}

#pragma mark - 获取验证码
- (void)getVerifyCode
{
    NSMutableDictionary *codeBean = [NSMutableDictionary dictionary];
    [codeBean setValue:@"11" forKey:@"contenttype"];
    [codeBean setValue:lxdh.contentLab.text forKey:@"mobilephone"];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [LSHttpManager requestUrl:HNServiceURL serviceName:@"jjappreceivedatafsdx" parameters:codeBean complete:^(id result, ResultType resultType) {

      hud.mode = MBProgressHUDModeText;

      if ([result[@"restate"] isEqualToString:@"1"])
      {
          NSLog(@"%@", JsonResult);
          //            NSString *msg = result[@"data"];
          //            codeField.text = msg;
          hud.labelText = @"获取成功";
          codeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
      }

      else
      {
          hud.labelText = result[@"redes"];
      }
      [hud hide:YES afterDelay:1.0];
    }];
}

- (void)countDown:(UIButton *)btn
{
    if (count == 1)
    {
        codeBtn.userInteractionEnabled = YES;
        [codeBtn setTitle:@"重发验证码" forState:0];
        count = 60;
        [codeTimer invalidate];
    }
    else
    {
        codeBtn.userInteractionEnabled = NO;
        count--;
        NSString *title = [NSString stringWithFormat:@"%ziS", count];
        [codeBtn setTitle:title forState:0];
    }
}

#pragma mark - 签名
- (void)signature
{
    SignViewController *signVC = [SignViewController new];
    signVC.delegate = self;
    [self presentViewController:signVC animated:YES completion:nil];
}

#pragma mark - QRadioButtonDelegate
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId
{
    if (radio == _radio1)
    {
        yfJuqian = @"0";
        sjyzm.titleLab.enabled = NO;
        codeField.text = @"";
        codeField.enabled = NO;
        codeBtn.enabled = NO;
        jsrqm.titleLab.enabled = NO;
        jsrqm.userInteractionEnabled = NO;
    }
    else
    {
        yfJuqian = @"1";
        sjyzm.titleLab.enabled = YES;
        codeField.enabled = YES;
        codeBtn.enabled = YES;
        jsrqm.titleLab.enabled = YES;
        jsrqm.userInteractionEnabled = YES;
    }
}

#pragma mark - 提交按钮点击事件
- (void)toNextPage
{
    //无论是否拒签都要录音
    //    if (!encodedAudioStr) {
    //        SHOWALERT(@"请录音");
    //        return;
    //    }

    UIImage *image = signView.image;
    NSString *yfImgStr = [Util imageToString:image];

    //拒签情形
    if ([_jfJuqian isEqualToString:@"0"])
    {
        [bean setValue:@"" forKey:@"othersig"];
        [bean setValue:yfImgStr forKey:@"ownsig"];
    }

    else if ([yfJuqian isEqualToString:@"0"])
    {
        [bean setValue:@"" forKey:@"ownsig"];
        [bean setValue:_jfImgStr forKey:@"othersig"];
    }

    else if ([_jfJuqian isEqualToString:@"0"] && [yfJuqian isEqualToString:@"0"])
    {
        [bean setValue:@"" forKey:@"ownsig"];
        [bean setValue:@"" forKey:@"othersig"];
    }

    else
    {
        if (codeField.text.length < 1)
        {
            SHOWALERT(@"请输入验证码");
            return;
        }

        if (!signView.image)
        {
            SHOWALERT(@"请乙方驾驶人签名");
            return;
        }

        [bean setValue:_jfImgStr forKey:@"othersig"];
        [bean setValue:yfImgStr forKey:@"ownsig"];
    }

    [self createAgreement];
}

- (void)createAgreement
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    //输出格式为：2010-10-27 10:22:13
    NSLog(@"%@", currentDateStr);
    [bean setValue:currentDateStr forKey:@"alarmtime"];

    NSString *appphone = [NSString stringWithFormat:@"%@", _jfModel.phoneNum];
    NSString *appcaseno = [NSString stringWithFormat:@"%@", GlobleInstance.appcaseno];
    NSString *casehaptime = [NSString stringWithFormat:@"%@", GlobleInstance.casehaptime];
    NSString *accidentplace = [NSString stringWithFormat:@"%@", GlobleInstance.imageaddress];
    NSDictionary *kcBean = @{ @"appcaseno" : appcaseno,
                              @"appphone" : appphone,
                              @"casehaptime" : casehaptime,
                              @"accidentplace" : accidentplace };
    [bean setValue:kcBean forKey:@"kcbean"];
    NSLog(@"kcBean -> %@", kcBean);

    NSString *zero = [NSString stringWithFormat:@"%@", @"0"];
    NSString *one = [NSString stringWithFormat:@"%@", @"1"];

    if (!_jfAudioStr)
    {
        _jfAudioStr = @"";
    }

    if (!encodedAudioStr)
    {
        encodedAudioStr = @"";
    }

    NSArray *carbeans = @[ @{ @"carownname" : _yfModel.name,
                              @"carownphone" : _yfModel.phoneNum,
                              @"casecarno" : _yfModel.carNum,
                              @"dutytype" : _yfDutyType, //
                              @"isrefused" : yfJuqian,
                              @"code" : codeField.text,
                              @"party" : zero,
                              //                            @"voice":encodedAudioStr
                          },
                           @{ @"carownname" : _jfModel.name,
                              @"carownphone" : _jfModel.phoneNum,
                              @"casecarno" : _jfModel.carNum,
                              @"dutytype" : _jfDutyType, //
                              @"isrefused" : _jfJuqian,
                              @"code" : _jfCode,
                              @"party" : one,
                              //                            @"voice":_jfAudioStr
                           } ];

    [bean setValue:carbeans forKey:@"carbeans"];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [LSHttpManager requestUrl:HNServiceURL serviceName:@"kckpjjCreateResponImg" parameters:bean complete:^(id result, ResultType resultType) {

      [hud hide:YES];

      if (result)
      {
          NSLog(@"%@", JsonResult);
      }

      if ([result[@"restate"] isEqualToString:@"1"])
      {
          //            [self showAlertView];
          MoreTipsViewController *vc = [MoreTipsViewController new];
          [self.navigationController pushViewController:vc animated:YES];
      }

      else
      {
          SHOWALERT(result[@"redes"]);
      }

    }];
}

#pragma mark 签名信息
- (void)passSignImage:(UIImage *)signImage
{
    signView.image = signImage;
}

#pragma mark - 拨打电话
- (void)callPolice
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"确定拨打电话？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
    action.delegate = self;
    [action showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex -> %zi", buttonIndex);
    if (buttonIndex == 0)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://122"]]];
    }
}

#pragma mark - 显示自定义AlertView
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
    lab.text = @"事故上传成功，是否立即返回首页";
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
        NSArray *arr = self.navigationController.viewControllers;
        [self.navigationController popToViewController:arr[1] animated:YES];
      }];

    }];
    [customView addSubview:confirmBtn];

    SRBlockButton *cancelBtn = [[SRBlockButton alloc] initWithFrame:CGRectMake(confirmBtn.maxX + 1, lab.maxY + 21, customView.width / 2, 60) title:@"暂不" titleColor:color handleBlock:^(SRBlockButton *btn) {

      [jcAlert dismissWithCompletion:^{

      }];

    }];
    [customView addSubview:cancelBtn];

    jcAlert = [[JCAlertView alloc] initWithCustomView:customView dismissWhenTouchedBackground:NO];
    [jcAlert show];
}

@end
