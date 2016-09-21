//
//  JFCreateProtocolVC.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/2.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "JFCreateProtocolVC.h"
#import "ZRRDView.h"
#import "SRBlockButton.h"
#import "YFCreateProtocolVC.h"
#import "SignViewController.h"
#import "QRadioButton.h"
#import <AVFoundation/AVFoundation.h>
#import "OwnerModel.h"
#import "RecordHUD.h"
#import "JCAlertView.h"

@interface JFCreateProtocolVC ()
<SignViewControllerDelegate,
AVAudioPlayerDelegate>
{
    UIScrollView *scroll;
    UIImageView *signView;
    
    ZRRDView *zrrd;
    ZRRDView *jsrxm;
    ZRRDView *cphm;
    ZRRDView *lxdh;
    ZRRDView *sjyzm;
    ZRRDView *jsrqm;
    ZRRDView *jsyly;
    
    NSArray *casecarlist;
    
    UITextField *codeField;
    
    QRadioButton *_radio1;
    QRadioButton *_radio2;
    
    NSString *jfJuQian;
    NSString * encodedAudioStr;
    NSTimer *audioTimer;
    
    NSTimeInterval currentTime;
    UIButton *codeBtn;
    NSTimer *codeTimer;
    NSInteger count;
    
    JCAlertView *endAlert;
}
//录音存储路径
@property (nonatomic, strong)NSURL *tmpFile;
//录音
@property (nonatomic, strong)AVAudioRecorder *recorder;
//播放
@property (nonatomic, strong)AVAudioPlayer *player;
//录音状态(是否录音)
@property (nonatomic, assign) BOOL isRecoding;
//录音按钮
@property (strong, nonatomic)  UIButton *recordButton;
//播放按钮
@property (strong, nonatomic)  UIButton *playButton;
@end

@implementation JFCreateProtocolVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"生成协议书";
    count = 60;
    
    [self initScroll];
    
    if (_isHistoryPush) {
        [self loadHistoryData];
    }
    
    //刚打开的时候录音状态为不录音
    self.isRecoding = NO;
    
    //创建临时文件来存放录音文件
    self.tmpFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"JFTmpFile"]];
    
    //设置后台播放
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSError *sessionError;
    
    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    
    //判断后台有没有播放
    if (session == nil) {
        
        NSLog(@"Error creating sessing:%@", [sessionError description]);
        
    } else {
        
        [session setActive:YES error:nil];
        
    }
    
}

#pragma mark - 责任类型文字转换为代码
-(void)setDutyTypeWithCode:(NSString *)code{
    if ([code isEqualToString:@"0"]) {
        zrrd.contentLab.text = @"全责";
    }
    if ([code isEqualToString:@"1"]) {
        zrrd.contentLab.text = @"无责";
    }
    if ([code isEqualToString:@"2"]) {
        zrrd.contentLab.text = @"同责";
    }
    if ([code isEqualToString:@"3"]) {
        zrrd.contentLab.text = @"主责";
    }
    if ([code isEqualToString:@"4"]) {
        zrrd.contentLab.text = @"次责";
    }
}

#pragma mark - ScrollView初始化
-(void)initScroll{
    
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    [self.view addSubview:scroll];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    header.backgroundColor = HNBlue;
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, header.height-20, header.height-20)];
    icon.image = [UIImage imageNamed:@"IP013"];
    [header addSubview:icon];
    
    UILabel *headerLab = [[UILabel alloc] initWithFrame:CGRectMake(icon.maxX+10, header.height/2-20, ScreenWidth-icon.maxX-20, 40)];
    headerLab.textColor = [UIColor whiteColor];
    headerLab.numberOfLines = 0;
    headerLab.textAlignment = NSTextAlignmentCenter;
    headerLab.text = @"系统将以短信方式向双方手机发送验证码，如长时间未收到请点击重发验证码";
    headerLab.font = [UIFont systemFontOfSize:15];
    [header addSubview:headerLab];

    [scroll addSubview:header];
    
    /*---------------------------*/
    
    CGFloat viewWidth = ScreenWidth-20;
    CGFloat viewHeight = 50;
    
    ZRRDView *titleView = [[ZRRDView alloc] initWithFrame:CGRectMake(10, header.maxY+20, viewWidth, viewHeight)];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 50)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = @"甲方信息";
    [titleView addSubview:titleLab];
    [scroll addSubview:titleView];
    
    /*---------------------------*/
    
    zrrd = [[ZRRDView alloc] initWithFrame:CGRectMake(10, titleView.maxY+10, viewWidth, viewHeight)];
    zrrd.titleLab.text = @"责任认定:";
    zrrd.contentLab.textColor = HNGreen;
    [scroll addSubview:zrrd];
    
    [self setDutyTypeWithCode:_jfDutyType];
    
    /*---------------------------*/
    
    jsrxm = [[ZRRDView alloc] initWithFrame:CGRectMake(10, zrrd.maxY+10, viewWidth, viewHeight)];
    jsrxm.titleLab.text = @"驾驶人姓名:";
    jsrxm.contentLab.text = _jfModel.name;
    [scroll addSubview:jsrxm];
    
    /*---------------------------*/
    
    cphm = [[ZRRDView alloc] initWithFrame:CGRectMake(10, jsrxm.maxY+10, viewWidth, viewHeight)];
    cphm.titleLab.text = @"车牌号码:";
    cphm.contentLab.text = _jfModel.carNum;
    [scroll addSubview:cphm];
    
    /*---------------------------*/
    
    lxdh = [[ZRRDView alloc] initWithFrame:CGRectMake(10, cphm.maxY+10, viewWidth, viewHeight)];
    lxdh.titleLab.text = @"联系人电话:";
    lxdh.contentLab.text = _jfModel.phoneNum;
    [scroll addSubview:lxdh];
    
    /*---------------------------*/
    
    ZRRDView *jq = [[ZRRDView alloc] initWithFrame:CGRectMake(10, lxdh.maxY+10, viewWidth, viewHeight)];
    jq.titleLab.text = @"拒签:";
    [scroll addSubview:jq];
    
    CGFloat btnWidth = 20;
    CGFloat btnHeight = 20;
    CGFloat btnY = 20;
    
    _radio1 = [[QRadioButton alloc] initWithDelegate:self groupId:@"jq"];
    _radio1.frame = CGRectMake(125, btnY, btnWidth, btnHeight);
    _radio1.checked = NO;
    [jq addSubview:_radio1];
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(_radio1.maxX, btnY, 80, btnHeight)];
    lab1.text = @"是";
    lab1.font = HNFont(15);
    [jq addSubview:lab1];
    
    _radio2 = [[QRadioButton alloc] initWithDelegate:self groupId:@"jq"];
    _radio2.frame = CGRectMake(lab1.maxX, btnY, btnWidth, btnHeight);
    _radio2.checked = YES;
    [jq addSubview:_radio2];
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(_radio2.maxX, btnY, 80, btnHeight)];
    lab2.text = @"否";
    lab2.font = HNFont(15);
    [jq addSubview:lab2];
    
    /*---------------------------*/
    
    sjyzm = [[ZRRDView alloc] initWithFrame:CGRectMake(10, jq.maxY+10, viewWidth, viewHeight)];
    sjyzm.titleLab.text = @"手机验证码:";
    [scroll addSubview:sjyzm];
    
    codeField = [[UITextField alloc] initWithFrame:CGRectMake(125, 10, 120, 30)];
    codeField.placeholder = @"在此填写验证码";
    codeField.font = HNFont(14);
    [sjyzm addSubview:codeField];
    
    codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    codeBtn.frame = CGRectMake(245, 10, 80, 30);
    [codeBtn addTarget:self action:@selector(getVerifyCode) forControlEvents:1<<6];
    codeBtn.titleLabel.font = HNFont(13);
    [codeBtn setTitle:@"获取验证码" forState:0];
    [codeBtn setTitleColor:HNGreen forState:0];
    [sjyzm addSubview:codeBtn];
    
    /*---------------------------*/
    
    jsrqm = [[ZRRDView alloc] initWithFrame:CGRectMake(10, sjyzm.maxY+10, viewWidth, viewHeight)];
    jsrqm.titleLab.text = @"驾驶人签名:";
    [scroll addSubview:jsrqm];
    
    signView = [[UIImageView alloc] initWithFrame:CGRectMake(125, 0, jsrqm.height*ScreenHeight/ScreenWidth, jsrqm.height)];
    [jsrqm addSubview:signView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signature)];
    [jsrqm addGestureRecognizer:tap];
    
    /*---------------------------*/
    
    jsyly = [[ZRRDView alloc] initWithFrame:CGRectMake(10, jsrqm.maxY+10, viewWidth, viewHeight)];
    jsyly.titleLab.text = @"驾驶人录音:";
    [scroll addSubview:jsyly];
    
    _recordButton= [UIButton buttonWithType:UIButtonTypeCustom];
    _recordButton.frame = CGRectMake(110, 0, 60, viewHeight);
    [_recordButton setTitle:@"录音" forState:0];
    [_recordButton setTitleColor:HNGreen forState:0];
    _recordButton.titleLabel.font = HNFont(14);
    [_recordButton addTarget:self action:@selector(audioRecord) forControlEvents:1<<6];
    [jsyly addSubview:_recordButton];
    
    
    _playButton= [UIButton buttonWithType:UIButtonTypeCustom];
    _playButton.frame = CGRectMake(180, 0, 60, viewHeight);
    [_playButton setTitle:@"播放" forState:0];
    [_playButton setTitleColor:HNGreen forState:0];
    _playButton.titleLabel.font = HNFont(14);
    //播放按钮不能被点击
    [_playButton setEnabled:NO];
    //播放按钮设置成半透明
    _playButton.titleLabel.alpha = 0.5;
    [_playButton addTarget:self action:@selector(audioPlay) forControlEvents:1<<6];
    [jsyly addSubview:_playButton];
    
    
    /*---------------------------*/
    
    UILabel *tipsLab = [[UILabel alloc] initWithFrame:CGRectMake(10, jsyly.maxY+20, viewWidth, 40)];
    tipsLab.textColor = [UIColor redColor];
    tipsLab.font = HNFont(14);
    tipsLab.textAlignment = 0;
    tipsLab.text = @"验证码输入后，将视为您已经确认事故相关信息无误并认可事故责任";
    tipsLab.numberOfLines = 0;
    [scroll addSubview:tipsLab];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(10, tipsLab.maxY+20, viewWidth, 50);
    [nextBtn setTitle:@"进入下页" forState:0];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:0];
    nextBtn.backgroundColor = HNBlue;
    nextBtn.titleLabel.font = HNFont(16);
    [nextBtn addTarget:self action:@selector(toNextPage) forControlEvents:1<<6];
    nextBtn.layer.cornerRadius = 5;
    [scroll addSubview:nextBtn];
    
    scroll.contentSize = CGSizeMake(ScreenWidth, nextBtn.maxY+20);

}


#pragma mark - 录音
-(void)audioRecord{
    
    //判断当录音状态为不录音的时候
    if (!self.isRecoding) {
        //将录音状态变为录音
        self.isRecoding = YES;
        
        currentTime = 0;
        [RecordHUD show];
        audioTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeAdd) userInfo:nil repeats:YES];
        
        //将录音按钮变为停止
        [self.recordButton setTitle:@"停止" forState:UIControlStateNormal];
        
        //播放按钮不能被点击
        [self.playButton setEnabled:NO];
        self.playButton.titleLabel.alpha = 0.5;
        
        //开始录音,将所获取到得录音存到文件里
        self.recorder = [[AVAudioRecorder alloc] initWithURL:_tmpFile settings:@{} error:nil];
        
        //准备记录录音
        [_recorder prepareToRecord];
        
        //启动或者恢复记录的录音文件
        [_recorder record];
        
        _player = nil;
        
        
    } else {
        
        //录音状态 点击录音按钮 停止录音
        self.isRecoding = NO;
        
        [self.recordButton setTitle:@"录音" forState:UIControlStateNormal];
        
        //录音停止的时候,播放按钮可以点击
        [self.playButton setEnabled:YES];
        [self.playButton.titleLabel setAlpha:1];
        
        //停止录音
        [_recorder stop];
        [RecordHUD dismiss];
        [audioTimer invalidate];
        
        _recorder = nil;
        
        NSData *data = [NSData dataWithContentsOfURL:self.tmpFile];
        
        encodedAudioStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        encodedAudioStr = [encodedAudioStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
        encodedAudioStr = [encodedAudioStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        encodedAudioStr = [encodedAudioStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        encodedAudioStr = [encodedAudioStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        encodedAudioStr = [NSString stringWithFormat:@"\"%@\"",encodedAudioStr];
        
//        NSLog(@"录音文件 -> %@",encodedAudioStr);
        
        NSError *playError;
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:_tmpFile error:&playError];
        //当播放录音为空, 打印错误信息
        if (self.player == nil) {
            NSLog(@"Error crenting player: %@", [playError description]);
        }
        self.player.delegate = self;
    }
}

-(void)timeAdd{
    currentTime ++;
    [RecordHUD setTimeTitle:[NSString stringWithFormat:@"录音: %.0f\"",currentTime]];
}

#pragma mark - 播放
-(void)audioPlay{
    //判断是否正在播放,如果正在播放
    if ([self.player isPlaying]) {
        //暂停播放
        [_player pause];
        
        //按钮显示为播放
        [self.playButton setTitle:@"播放" forState:UIControlStateNormal];
        
    } else {
        
        //开始播放
        [_player play];
        
        //
        [self.playButton setTitle:@"暂停" forState:UIControlStateNormal];
        
    }
}

//当播放结束后调用这个方法
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //按钮标题变为播放
    [self.playButton setTitle:@"播放" forState:UIControlStateNormal];
}

#pragma mark - 加载数据(继续处理)
-(void)loadHistoryData{
    NSMutableDictionary *bean = [NSMutableDictionary dictionary];
    [bean setValue:GlobleInstance.token forKey:@"token"];
    [bean setValue:GlobleInstance.userflag forKey:@"username"];
    [bean setValue:GlobleInstance.appcaseno forKey:@"casenumber"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [LSHttpManager requestUrl:HNServiceURL serviceName:@"kckpjjAccidentDetails" parameters:bean complete:^(id result, ResultType resultType) {
       
        [hud hide:YES];
        if ([result[@"restate"] isEqualToString:@"1"]) {
            NSLog(@"History -> %@",JsonResult);
            NSDictionary *data = result[@"data"];
            GlobleInstance.casehaptime = data[@"casehaptime"];
            casecarlist = data[@"casecarlist"];
            NSDictionary *jfDic = casecarlist[0];
            NSDictionary *yfDic = casecarlist[1];
            OwnerModel *jfModel = [[OwnerModel alloc] initWithDict:jfDic];
            
            self.jfModel = [[InfoModel alloc] init];
            self.jfModel.name = jfDic[@"carownname"];
            self.jfModel.phoneNum = jfDic[@"carownphone"];
            self.jfModel.carNum = jfDic[@"casecarno"];
            self.jfDutyType = jfDic[@"dutytype"];
            
            self.yfModel = [[InfoModel alloc] init];
            self.yfModel.name = yfDic[@"carownname"];
            self.yfModel.phoneNum = yfDic[@"carownphone"];
            self.yfModel.carNum = yfDic[@"casecarno"];
            self.yfDutyType = yfDic[@"dutytype"];
            
            [self setDutyTypeWithCode:jfModel.dutytype];
            jsrxm.contentLab.text = jfModel.carownname;
            cphm.contentLab.text = jfModel.casecarno;
            lxdh.contentLab.text = jfModel.carownphone;
        }
        
    }];
}

#pragma mark - 获取验证码
-(void)getVerifyCode{
    NSMutableDictionary *bean = [NSMutableDictionary dictionary];
    [bean setValue:@"11" forKey:@"contenttype"];
    [bean setValue:lxdh.contentLab.text forKey:@"mobilephone"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [LSHttpManager requestUrl:HNServiceURL serviceName:@"jjappreceivedatafsdx" parameters:bean complete:^(id result, ResultType resultType) {
        
        hud.mode = MBProgressHUDModeText;
        if ([result[@"restate"] isEqualToString:@"1"]) {
            NSLog(@"%@",JsonResult);
//            NSString *msg = result[@"data"];
//            codeField.text = msg;
            hud.labelText = @"获取成功";
            codeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
        }
        
        else {
            hud.labelText = result[@"redes"];
        }
        [hud hide:YES afterDelay:1.0];
    }];
}

-(void)countDown:(UIButton *)btn{
    if (count == 1)
    {
        codeBtn.userInteractionEnabled = YES;
        [codeBtn setTitle:@"获取验证码" forState:0];
        count = 60;
        [codeTimer invalidate];
    }
    else
    {
        codeBtn.userInteractionEnabled = NO;
        count--;
        NSString *title = [NSString stringWithFormat:@"%ziS",count];
        [codeBtn setTitle:title forState:0];
    }
}

#pragma mark - QRadioButtonDelegate
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
    
    if (radio == _radio1) {
        jfJuQian = @"0";
        sjyzm.titleLab.enabled = NO;
        codeField.enabled = NO;
        codeBtn.enabled = NO;
        jsrqm.titleLab.enabled = NO;
        jsrqm.userInteractionEnabled = NO;
    }
    else {
        jfJuQian = @"1";
        sjyzm.titleLab.enabled = YES;
        codeField.enabled = YES;
        codeBtn.enabled = YES;
        jsrqm.titleLab.enabled = YES;
        jsrqm.userInteractionEnabled = YES;
    }
    
}

#pragma mark - 签名
-(void)signature{
    SignViewController *signVC = [SignViewController new];
    signVC.delegate = self;
    [self presentViewController:signVC animated:YES completion:nil];
}

#pragma mark - 进入下页
-(void)toNextPage
{
    //无论是否拒签都要录音
    if (!encodedAudioStr) {
        SHOWALERT(@"请录音");
        return;
    }
    //拒签情形(拒签无需验证码和签名)
    if ([jfJuQian isEqualToString:@"0"]) {
        
        YFCreateProtocolVC *vc = [YFCreateProtocolVC new];
        vc.jfModel = _jfModel;
        vc.yfModel = _yfModel;
        vc.jfJuqian = jfJuQian;
        vc.jfDutyType = _jfDutyType;
        vc.yfDutyType = _yfDutyType;
        vc.jfCode = @"";
        vc.jfAudioStr = encodedAudioStr;
        
        if (_isHistoryPush) {
            NSDictionary *yfDic = casecarlist[1];
            vc.partyBModel = [[OwnerModel alloc] initWithDict:yfDic];
        }
        
        vc.jfImgStr = @"";
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    //没有拒签的情形
    else {
        
        if (codeField.text.length < 1) {
            SHOWALERT(@"请输入验证码");
            return;
        }
        
        if (!signView.image) {
            SHOWALERT(@"请甲方驾驶人签名");
            return;
        }
        
        NSMutableDictionary *bean = [NSMutableDictionary dictionary];
        [bean setValue:lxdh.contentLab.text forKey:@"mobilephone"];
        [bean setValue:codeField.text forKey:@"code"];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [LSHttpManager requestUrl:HNServiceURL serviceName:@"jjappkckpValCode" parameters:bean complete:^(id result, ResultType resultType) {
            
            [hud hide:YES];
            
            if (result) {
                NSLog(@"YZM -> %@",JsonResult);
            }
            
            if ([result[@"restate"] isEqualToString:@"1"]) {
                YFCreateProtocolVC *vc = [YFCreateProtocolVC new];
                vc.jfModel = _jfModel;
                vc.yfModel = _yfModel;
                vc.jfJuqian = jfJuQian;
                vc.jfDutyType = _jfDutyType;
                vc.yfDutyType = _yfDutyType;
                vc.jfCode = codeField.text;
                vc.jfAudioStr = encodedAudioStr;
                
                if (_isHistoryPush) {
                    NSDictionary *yfDic = casecarlist[1];
                    vc.partyBModel = [[OwnerModel alloc] initWithDict:yfDic];
                }
                
                UIImage *image = signView.image;
                NSString *imgStr = [Util imageToString:image];
                vc.jfImgStr = imgStr;
                
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            else {
                SHOWALERT(@"验证码不正确");
            }
        }];
    }
}

#pragma mark 签名信息
-(void)passSignImage:(UIImage *)signImage
{
    signView.image = signImage;
}


#pragma mark - 返回按钮点击事件（返回首页）
-(void)backAction{
    [self showEndThisCaseAlert];
}

-(void)showEndThisCaseAlert{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-60, 200)];
    customView.backgroundColor = [UIColor whiteColor];
    customView.layer.cornerRadius = 5;
    customView.clipsToBounds = YES;
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(customView.width/2-30, 20, 60, 60)];
    icon.image = [UIImage imageNamed:@"warn"];
    [customView addSubview:icon];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, icon.maxY+20, customView.width, 20)];
    lab.font = HNFont(14);
    lab.text = @"是否结束本次快处";
    lab.textColor = [UIColor darkGrayColor];
    lab.textAlignment = NSTextAlignmentCenter;
    [customView addSubview:lab];
    
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, lab.maxY+20, customView.width, 1)];
    horizontalLine.backgroundColor = RGB(235, 235, 235);
    [customView addSubview:horizontalLine];
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(customView.width/2, lab.maxY+20, 1, 60)];
    verticalLine.backgroundColor = RGB(235, 235, 235);
    [customView addSubview:verticalLine];
    
    UIColor *color = [UIColor blackColor];
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(0, lab.maxY+21, customView.width/2, 60);
    [confirmBtn setTitle:@"确认" forState:0];
    [confirmBtn setTitleColor:color forState:0];
    [confirmBtn addTarget:self action:@selector(jumpToHome) forControlEvents:1<<6];
    [customView addSubview:confirmBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(confirmBtn.maxX+1, lab.maxY+21, customView.width/2, 60);
    [cancelBtn setTitle:@"暂不" forState:0];
    [cancelBtn setTitleColor:color forState:0];
    [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:1<<6];
    [customView addSubview:cancelBtn];
    
    endAlert = [[JCAlertView alloc] initWithCustomView:customView dismissWhenTouchedBackground:YES];
    [endAlert show];
}

-(void)jumpToHome{
    [endAlert dismissWithCompletion:^{
        NSArray *arr = self.navigationController.viewControllers;
        [self.navigationController popToViewController:arr[1] animated:YES];
    }];
}

-(void)dismiss{
    [endAlert dismissWithCompletion:nil];
}

@end
