//
//  RemoteDutyViewController.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/31.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "RemoteDutyViewController.h"
#import "curl.h"
#import "JFCreateProtocolVC.h"
#define auditMonitorIP @"220.231.252.128:9100"  //监听IP

@interface RemoteDutyViewController ()<UIActionSheetDelegate>
{
    CURL *audit_curl;
    BOOL isNext;
}
@end

@implementation RemoteDutyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"远程定责";
    [self initCurl];
    [self go];
    isNext = YES;
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
    
    //查询历史消息
    [self checkHistoryMsg:@"2"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/stream?cname=%@&seq=0&token=null",auditMonitorIP,GlobleInstance.appcaseno]];
    
    curl_easy_setopt(audit_curl, CURLOPT_URL, url.absoluteString.UTF8String);	// little warning: curl_easy_setopt() doesn't retain the memory passed into it, so if the memory used by calling url.absoluteString.UTF8String is freed before curl_easy_perform() is called, then it will crash. IOW, don't drain the autorelease pool before making the call
    
    curl_easy_setopt(audit_curl, CURLOPT_NOSIGNAL, 1L);  // try not to use signals
    curl_easy_setopt(audit_curl, CURLOPT_USERAGENT, curl_version()); // set a default user agent
    curl_easy_setopt(audit_curl, CURLOPT_WRITEFUNCTION, icomet_callback2);
    curl_easy_perform(audit_curl);
    
}

size_t icomet_callback2(char *ptr, size_t size, size_t nmemb, void *userdata)
{
    const size_t sizeInBytes = size*nmemb;
    NSData *data = [[NSData alloc] initWithBytes:ptr length:sizeInBytes];
    
    //利用桥接将非OC对象转换成OC对象
    RemoteDutyViewController *vc = (__bridge RemoteDutyViewController *)userdata;
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSLog(@"RemoteDic -> %@",dic);
    //判断一下type字段，为data时进行处理（为noop时为心跳）。
    if ([dic[@"type"] isEqualToString:@"data"]) {
        NSString *str = [NSString stringWithFormat:@"%@",dic[@"content"]];
        NSData *data1= [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
        [vc  sendResultSucess:dic1];
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
    NSArray *dutylist = msgdata[@"dutylist"];
    
    NSMutableDictionary *bean = [[NSMutableDictionary alloc] init];
    [bean setValue:reciveDict[@"id"] forKey:@"id"];
    [bean setValue:reciveDict[@"msgtype"] forKey:@"msgtype"];
    [bean setValue:GlobleInstance.userflag forKey:@"username"];
    [bean setValue:GlobleInstance.token forKey:@"token"];
    [bean setValue:GlobleInstance.appcaseno forKey:@"appcaseno"];
    
    [LSHttpManager requestUrl:HNServiceURL serviceName:@"zdsearchunreceivemsg" parameters:bean complete:^(id result, ResultType resultType) {
        
        if (result) {
            NSLog(@"认定责任类型 -> %@",JsonResult);
        }
        
        if ([result[@"restate"] isEqualToString:@"1"]) {
            if (isNext) {
                isNext = NO;
                JFCreateProtocolVC *vc = [JFCreateProtocolVC new];
                vc.jfModel = GlobleInstance.jfModel;
                vc.yfModel = GlobleInstance.yfModel;
                
                for (NSDictionary *item in dutylist) {
                    if ([item[@"ownother"] isEqualToString:@"1"]) {
                        vc.jfDutyType = item[@"dutytype"];
                    }
                    if ([item[@"ownother"] isEqualToString:@"0"]) {
                        vc.yfDutyType = item[@"dutytype"];
                    }
                }
                
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }];
}

//页面消失，销毁curl
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    curl_easy_cleanup(audit_curl);
}

@end
