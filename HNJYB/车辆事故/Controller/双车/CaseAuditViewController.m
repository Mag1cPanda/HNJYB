//
//  CaseAuditViewController.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/15.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "CaseAuditViewController.h"
#import "curl.h"
#import "XJTipsViewController.h"
#import "RetakePhotoVC.h"
#define auditMonitorIP @"220.231.252.128:9100"  //监听IP

@interface CaseAuditViewController ()
<UIActionSheetDelegate>
{
    //定时器
    NSTimer *timer;
    NSInteger count;
    UIButton *countBtn;
    CURL *audit_curl;
    
    BOOL isNext;
}
@property (weak, nonatomic) IBOutlet UILabel *tipsLab;

@property (weak, nonatomic) IBOutlet UIButton *waitBtn;

@property (weak, nonatomic) IBOutlet UIButton *policeBtn;

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@end

@implementation CaseAuditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initCurl];
    [self go];
    isNext = YES;
    self.title = @"事故审核";
    self.view.backgroundColor = HNBackColor;
    self.tipsLab.hidden = YES;
    self.waitBtn.hidden = YES;
    self.policeBtn.hidden = YES;
    self.icon.image = [UIImage imageNamed:@"IP024"];
    count = 180;
    
    //开始计时
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
    
    countBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    countBtn.frame = CGRectMake(ScreenWidth/2-60, 300, 120, 120);
    countBtn.layer.cornerRadius = 60;
    countBtn.titleLabel.textColor = [UIColor whiteColor];
    countBtn.titleLabel.font = HNFont(40);
    countBtn.backgroundColor = HNGreen;
    [countBtn setTitle:@"180S" forState:0];
//    [countBtn addTarget:self action:@selector(countDown:) forControlEvents:1<<6];
    [self.view addSubview:countBtn];
}

#pragma mark - 初始化curl及监听事件
-(void)initCurl
{
    curl_global_init(0L);
    audit_curl = curl_easy_init();
    // Some settings I recommend you always set:
    
    //设置http的验证方式  使用‘CURLAUTH_ANY‘将允许libcurl可以选择任何它所支持的验证方式
    
    curl_easy_setopt(audit_curl, CURLOPT_HTTPAUTH, CURLAUTH_ANY);	// support basic, digest, and NTLM authentication
    curl_easy_setopt(audit_curl, CURLOPT_NOSIGNAL, 1L);	// try not to use signals
    curl_easy_setopt(audit_curl, CURLOPT_USERAGENT, curl_version());	// set a default user agent
    // Things specific to this app:
    curl_easy_setopt(audit_curl, CURLOPT_VERBOSE, 1L);	// turn on verbose logging; your app doesn't need to do this except when debugging a connection
    curl_easy_setopt(audit_curl, CURLOPT_DEBUGDATA, self);
    curl_easy_setopt(audit_curl, CURLOPT_WRITEDATA, self);	// prevent libcurl from writing the data to stdout
}

- (void)go
{
    [self performSelectorInBackground:@selector(audit_tartStreaming) withObject:nil];
}

-(void)audit_tartStreaming{
    //  NSString * infoRoadName = @"2015110160003333302656534";
    NSLog(@"开始监听...");
    
    //查询照片审核历史消息
    [self checkHistoryMsg:@"1"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/stream?cname=%@&seq=0&token=null",auditMonitorIP,GlobleInstance.appcaseno]];
    
    curl_easy_setopt(audit_curl, CURLOPT_URL, url.absoluteString.UTF8String);	// little warning: curl_easy_setopt() doesn't retain the memory passed into it, so if the memory used by calling url.absoluteString.UTF8String is freed before curl_easy_perform() is called, then it will crash. IOW, don't drain the autorelease pool before making the call
    
    curl_easy_setopt(audit_curl, CURLOPT_NOSIGNAL, 1L);  // try not to use signals
    curl_easy_setopt(audit_curl, CURLOPT_USERAGENT, curl_version()); // set a default user agent
    curl_easy_setopt(audit_curl, CURLOPT_WRITEFUNCTION, icomet_callback1);
    curl_easy_perform(audit_curl);
    
}

size_t icomet_callback1(char *ptr, size_t size, size_t nmemb, void *userdata)
{
    const size_t sizeInBytes = size*nmemb;
    NSData *data = [[NSData alloc] initWithBytes:ptr length:sizeInBytes];
    
    //利用桥接将非OC对象转换成OC对象
    CaseAuditViewController *audittingVC = (__bridge CaseAuditViewController *)userdata;
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSLog(@"监听dic ============= %@",dic);
    //判断一下type字段，为data时进行处理（为noop时为心跳）。
    if ([dic[@"type"] isEqualToString:@"data"]) {
        NSString *str = [NSString stringWithFormat:@"%@",dic[@"content"]];
        NSData *data1= [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
        [audittingVC  sendResultSucess:dic1];
    }
    else
    {
        NSLog(@"%@",error.description);
    }
    
    return sizeInBytes;
}

#pragma mark - 查询未接收的消息
- (void)checkHistoryMsg:(NSString *)msgtype
{
    NSMutableDictionary *bean = [[NSMutableDictionary alloc] init];
    [bean setValue:[Globle getInstance].appcaseno forKey:@"appcaseno"];
    [bean setValue:msgtype forKey:@"msgtype"];
    [bean setValue:[Globle getInstance].userflag forKey:@"username"];
    [bean setValue:[Globle getInstance].token forKey:@"token"];
    
    [LSHttpManager requestUrl:HNServiceURL serviceName:@"zdsearchunreceivemsg" parameters:bean complete:^(id result, ResultType resultType) {
       
        if (result) {
            if ([result[@"restate"] isEqualToString:@"1"]) {
                NSLog(@"查询成功!");
            }
            else if ([result[@"restate"] isEqualToString:@"-99"])
            {
                NSLog(@"服务器异常!");
            }
            else
            {
                NSLog(@"查询失败!");
            }
        }
        else
        {
            NSLog(@"查询失败，请检查您的网络!!");
        }
        
    }];
    
}

#pragma mark - 接收到消息之后调用
- (void)sendResultSucess:(NSDictionary *)reciveDict
{
    
    NSDictionary *msgdata = reciveDict[@"msgdata"];
    NSDictionary *isqualifylist = msgdata[@"isqualifylist"];
    NSArray *qualifiedArr = isqualifylist[@"key"];
    NSDictionary *unqualifylist = msgdata[@"unqualifylist"];
    NSArray *unQualifiedArr = unqualifylist[@"key"];
    
    NSLog(@"qualifiedArr -> %@",qualifiedArr);
    NSLog(@"unQualifiedArr -> %@",unQualifiedArr);
    
    NSMutableDictionary *bean = [[NSMutableDictionary alloc] init];
    [bean setValue:reciveDict[@"id"] forKey:@"id"];
    [bean setValue:reciveDict[@"msgtype"] forKey:@"msgtype"];
    [bean setValue:GlobleInstance.userflag forKey:@"username"];
    [bean setValue:GlobleInstance.token forKey:@"token"];
    [bean setValue:GlobleInstance.appcaseno forKey:@"appcaseno"];
    
    [LSHttpManager requestUrl:HNServiceURL serviceName:@"zdsearchunreceivemsg" parameters:bean complete:^(id result, ResultType resultType) {
       
        if (result) {
            NSLog(@"zdsearchunreceivemsg -> %@",JsonResult);
        }
        
        if ([result[@"restate"] isEqualToString:@"1"]) {
            if (isNext) {
                isNext = NO;
                //单车
                if (GlobleInstance.isOneCar) {
                    if (qualifiedArr.count == GlobleInstance.photoCount) {
                        XJTipsViewController *vc = [XJTipsViewController new];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    else {
                        RetakePhotoVC *vc = [RetakePhotoVC new];
                        vc.qualifiedArr = qualifiedArr;
                        vc.unQualifiedArr = unQualifiedArr;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }
                //双车
                else {
                    if (qualifiedArr.count == GlobleInstance.photoCount) {
                        XJTipsViewController *vc = [XJTipsViewController new];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    else {
                        RetakePhotoVC *vc = [RetakePhotoVC new];
                        vc.qualifiedArr = qualifiedArr;
                        vc.unQualifiedArr = unQualifiedArr;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }
            }
        }
    }];
}

//页面消失，进入后台不显示该页面，关闭定时器
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    curl_easy_cleanup(audit_curl);
    if(timer)
    {
        //关闭定时器
        [timer setFireDate:[NSDate distantFuture]];
    }
    
}

-(void)countDown:(UIButton *)btn{
    if (count == 1)
    {
        count = 180;
        [timer invalidate];
        self.icon.image = [UIImage imageNamed:@"IP023"];
        countBtn.hidden = YES;
        self.tipsLab.hidden = NO;
        self.waitBtn.hidden = NO;
        self.policeBtn.hidden = NO;
    }
    else
    {
        count--;
        NSString *title = [NSString stringWithFormat:@"%ziS",count];
        [countBtn setTitle:title forState:0];
    }
}

- (IBAction)continueWait:(id)sender {
    //开始计时
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
    countBtn.hidden = NO;
    count = 180;
    self.icon.image = [UIImage imageNamed:@"IP024"];
    self.tipsLab.hidden = YES;
    self.waitBtn.hidden = YES;
    self.policeBtn.hidden = YES;
}

- (IBAction)callPolice:(id)sender {
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"确定拨打电话？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles: nil];
    action.delegate = self;
    [action showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"buttonIndex -> %zi",buttonIndex);
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://122"]]];
    }
    
}

@end
