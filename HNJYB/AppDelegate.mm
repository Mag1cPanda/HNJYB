//
//  AppDelegate.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/7/28.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "NavViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h> //引入base相关所有的头文件
//#import <Bugly/Bugly.h>
#import "BaiduMobStat.h"
#import "DESCript.h"

@interface AppDelegate ()
@property (nonatomic, strong) UIAlertView *alert;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.

    //    [Bugly startWithAppId:@"900049918"];

    [self registerBaiduStatistiCal];

    // 要使用百度地图，请先启动BaiduMapManager
    BMKMapManager *_mapManager = [[BMKMapManager alloc] init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"g4sxtWpGAWz6hPkoNtFnYVGEhoZKEFCu" generalDelegate:nil];
    if (!ret)
    {
        NSLog(@"manager 启动失败");
    }

    //给账户在其他地方登陆的通知添加观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AccountLoginInOtherPlace:) name:@"LoginOutNotifaction" object:nil];

    NavViewController *nav = [[NavViewController alloc] init];
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [nav pushViewController:loginVC animated:YES];
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    return YES;
}

#pragma mark - 百度统计注册
- (void)registerBaiduStatistiCal
{
    /*若应用是基于iOS 9系统开发，需要在程序的info.plist文件中添加一项参数配置，确保日志正常发送，配置如下：
     NSAppTransportSecurity(NSDictionary):
     NSAllowsArbitraryLoads(Boolen):YES
     */
    BaiduMobStat *statTracker = [BaiduMobStat defaultStat];
    // 此处(startWithAppId之前)可以设置初始化的可选参数，具体有哪些参数，可详见BaiduMobStat.h文件，例如：
    statTracker.shortAppVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    statTracker.enableDebugOn = NO;

    [statTracker startWithAppId:@"c2353b2f23"]; // 设置您在mtj网站上添加的app的appkey,此处AppId即为应用的appKey
}

- (void)AccountLoginInOtherPlace:(NSNotification *)notification
{
    NSLog(@"AccountLoginInOtherPlace");
    NSLog(@"账户被挤掉%@", notification.object);
    NSDictionary *dic = notification.object;
    if ([dic[@"restate"] isEqualToString:@"-4"])
    {
    }

    if (!_alert)
    {
        _alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的账号已在其他设备登录，如非本人操作，请及时更改密码！" delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"重新登录", nil];
        [_alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //退出
        NavViewController *nav = [[NavViewController alloc] init];
        [nav pushViewController:[[LoginViewController alloc] init] animated:YES];
        self.window.rootViewController = nav;
    }
    else
    {
        //确定
        NSMutableDictionary *bean = [NSMutableDictionary dictionary];

        NSString *userflag = GlobleInstance.userflag;
        NSString *password = [UserDefaultsUtil getDataForKey:@"password"];
        NSString *encryptPwd = [DESCript encrypt:password encryptOrDecrypt:kCCEncrypt key:[Util getKey]];
        NSLog(@"重新登录密码：%@", password);
        [bean setValue:userflag forKey:@"userflag"];
        [bean setValue:encryptPwd forKey:@"password"];

        [LSHttpManager requestUrl:HNServiceURL serviceName:@"jjapplogin" parameters:bean complete:^(id result, ResultType resultType) {

          if (result)
          {
              NSLog(@"重新登录 -> %@", [Util objectToJson:result]);
              if ([result[@"restate"] isEqualToString:@"1"])
              {
                  GlobleInstance.loginData   = result[@"data"];
                  GlobleInstance.token       = result[@"data"][@"token"];
                  GlobleInstance.userflag    = result[@"data"][@"userinfo"][@"userflag"];
                  GlobleInstance.userid      = result[@"data"][@"userinfo"][@"id"];
                  GlobleInstance.cardno      = result[@"data"][@"userinfo"][@"cardno"];
                  GlobleInstance.armyname    = result[@"data"][@"userinfo"][@"name"];
                  GlobleInstance.policeno    = result[@"data"][@"userinfo"][@"usercode"];
                  GlobleInstance.showname    = result[@"data"][@"userinfo"][@"showname"];
                  GlobleInstance.photo       = result[@"data"][@"userinfo"][@"photo"];
                  GlobleInstance.mobilephone = result[@"data"][@"userinfo"][@"mobilephone"];
              }
              else
              {
                  SHOWALERT(result[@"redes"]);
              }
          }

        }];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 后台下载
//-(void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler{
//
//    self.backgroundSessionCompletionHandler = completionHandler;
//
//}

@end
