//
//  HomeViewController.m
//  CZT_HN_Longrise
//
//  Created by OSch on 16/5/12.
//  Copyright © 2016年 OSch. All rights reserved.
//

#import "CaseViewController.h"
#import "GPSNoticeViewController.h"
#import "HomeViewController.h"
#import "InfoViewController.h"
#import "LoginViewController.h"
#import "NavViewController.h"
#import "SafetyTipsViewController.h"
#import "SignViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface HomeViewController () < UIAlertViewDelegate >
{
    NSInteger nextCount;
    NSString *statusCount;
    NSString *localVersion;
    NSString *serverVersion;
    UIAlertView *versionAlertView;
    NSString *downLoad_path;
}
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *bindInfoAry;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation HomeViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"快处快赔";

    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc] init];

    //初始化地理编码类
    _geocodesearch = [[BMKGeoCodeSearch alloc] init];

    //    [self checkBindingInfo];

    //获取用户位置
    [self getPositionInfo];

    [self init_UI];

    [self checkVersion];

    [self loadData];
}

#pragma mark - 退出登录
- (void)backAction
{
    UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:nil message:@"确定退出登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定退出", nil];
    [logoutAlert show];
}

#pragma mark - 初始化UI
- (void)init_UI
{
    self.bindInfoAry = [NSMutableArray array];

    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topClick)];
    [self.userInfoView addGestureRecognizer:singleTap1]; //这个可以加到任何控件上,比如你只想响应WebView，我正好填满整个屏幕
    singleTap1.cancelsTouchesInView = NO;

    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(middleClick)];
    [self.caseDealView addGestureRecognizer:singleTap2]; //这个可以加到任何控件上,比如你只想响应WebView，我正好填满整个屏幕
    singleTap2.cancelsTouchesInView = NO;

    UITapGestureRecognizer *singleTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomClick)];
    [self.myCaseInfoView addGestureRecognizer:singleTap3]; //这个可以加到任何控件上,比如你只想响应WebView，我正好填满整个屏幕
    singleTap3.cancelsTouchesInView = NO;

    //置空单双车的类型 区域id(事故地点每次都要重新识别)
    [Globle getInstance].areaid = @"";
    [Globle getInstance].imageaddress = @"";
}

#pragma mark - 加载数据
- (void)loadData
{
    NSMutableDictionary *bean = [NSMutableDictionary dictionary];

    [bean setValue:GlobleInstance.userid forKey:@"userid"];
    [bean setValue:GlobleInstance.policeno forKey:@"policeno"];
    [bean setValue:GlobleInstance.userflag forKey:@"username"];
    [bean setValue:GlobleInstance.token forKey:@"token"];

    [LSHttpManager
         requestUrl:HNServiceURL
        serviceName:@"kckpjjSearchAllCaseNum"
         parameters:bean
           complete:^(id result, ResultType resultType) {

             if (result)
             {
                 NSLog(@"%@", [Util objectToJson:result]);
                 [_userIcon
                     sd_setImageWithURL:[NSURL URLWithString:GlobleInstance.photo]
                       placeholderImage:[UIImage imageNamed:@"default"]];
                 _contentLab.text = [NSString
                     stringWithFormat:@"您目前已处理完成事故%@起",
                                      result[@"data"]];
                 _userName.text = GlobleInstance.userflag;
             }

           }];
}

#pragma mark - Life Circle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _locService.delegate = self;
    _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _locService.delegate = nil;
    _geocodesearch.delegate = nil; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

#pragma mark 获取位置信息
- (void)getPositionInfo
{
    //判读单例里面是否有定位信息
    if (!GlobleInstance.areaid ||
        !GlobleInstance.imageaddress ||
        !GlobleInstance.imagelat ||
        !GlobleInstance.imagelon)
    {
        //判断是非有定位权限
        if ([CLLocationManager locationServicesEnabled] &&
            ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse))
        {
            //定位功能可用，开始定位
            NSLog(@"开始定位");
            if (_locService != nil)
            {
                locHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                locHud.labelText = @"正在定位";
                [_locService startUserLocationService];
            }
        }
        else
        {
            NSLog(@"定位功能不可用，提示用户");
        }
    }
    else
    {
        //上一次的时间戳
        NSNumber *tempNum;
        float lastTime = 0;
        if (tempNum != nil)
        {
            lastTime = tempNum.floatValue;
        }
        //当前时间戳
        float nowTime = [Util getCurrentTime];
        //判读时间是否超过10分钟
        if (nowTime - lastTime > 10 * 60 * 1000)
        {
            //超过十分钟重写定位
            if (_locService != nil)
            {
                [_locService startUserLocationService];
            }
        }
        else
        {
        }
    }
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //显示经纬度
    NSLog(@"用户位置更新后的经纬度：lat:%f,long:%f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);

    //停止定位
    if (nil != _locService)
    {
        [_locService stopUserLocationService];
    }

    lat = userLocation.location.coordinate.latitude;
    lon = userLocation.location.coordinate.longitude;
    //经纬度写死为河南
    //    lat = 34.7568711;
    //    lon = 113.663221;
    GlobleInstance.imagelat = lat;
    GlobleInstance.imagelon = lon;

    //根据经纬度获取Areaid
    [self getCurrentAreaId];

    //开始检索，将经纬度转化成具体地址
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){lat, lon};

    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if (flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}

#pragma mark 经纬度转化成地址回调接口
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    locHud.mode = MBProgressHUDModeText;

    if (error == BMK_SEARCH_NO_ERROR)
    {
        //        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        //        item.coordinate = result.location;
        //        item.title = result.address;
        locHud.labelText = @"定位成功";
        NSLog(@"反向地理编码地址：%@", result.address);
        imageAddress = result.address;
        [Globle getInstance].imageaddress = result.address;

        //保存当前时间戳
        [UserDefaultsUtil saveNSUserDefaultsForObject:[[NSNumber alloc] initWithFloat:[[NSDate date] timeIntervalSince1970]] forKey:LocationTIMEKEY];
    }
    else
    {
        locHud.labelText = @"定位失败";
        NSLog(@"经纬度转化成地址回调方法中反geo检索发送失败");
    }

    [locHud hide:YES afterDelay:1.0];
}

#pragma mark - 获取Areaid
- (void)getCurrentAreaId
{
    NSMutableDictionary *bean = [NSMutableDictionary dictionary];

    NSString *maplon = [NSString stringWithFormat:@"%f", GlobleInstance.imagelon];
    NSString *maplat = [NSString stringWithFormat:@"%f", GlobleInstance.imagelat];
    NSString *userflag = [NSString stringWithFormat:@"%@", GlobleInstance.userflag];
    NSString *token = [NSString stringWithFormat:@"%@", GlobleInstance.token];

    [bean setValue:maplon forKey:@"maplon"];
    [bean setValue:maplat forKey:@"maplat"];
    [bean setValue:userflag forKey:@"userflag"];
    [bean setValue:token forKey:@"token"];

    [LSHttpManager requestUrl:HNServiceURL serviceName:@"jjappgetweather" parameters:bean complete:^(id result, ResultType resultType) {

      if ([result[@"restate"] isEqualToString:@"1"])
      {
          NSLog(@"Areaid -> %@", [Util objectToJson:result]);

          NSString *areaid = result[@"data"];
          GlobleInstance.areaid = areaid;
      }

      else
      {
          NSLog(@"获取areaid不成功");
      }

    }];
}

#pragma mark - Lazy
- (NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
    }
    return _dataSource;
}

#pragma mark - 车辆事故
- (void)topClick
{
    //判断定位是否开启
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse))
    {
        SafetyTipsViewController *vc = [SafetyTipsViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        GPSNoticeViewController *gpstyVC = [GPSNoticeViewController new];
        [self.navigationController pushViewController:gpstyVC animated:YES];
    }
}

#pragma mark - 历史案件
- (void)middleClick
{
    CaseViewController *vc = [CaseViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 个人信息
- (void)bottomClick
{
    InfoViewController *vc = [InfoViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 绑定信息
- (void)checkBindingInfo
{
    self.bindInfoAry = [NSMutableArray array];

    NSMutableDictionary *bean = [[NSMutableDictionary alloc] init];
    //    [bean setValue:[Globle getInstance].userid forKey:@"userid"];
    //    [bean setValue:[Globle getInstance].userflag forKey:@"username"];
    [bean setValue:[Globle getInstance].token forKey:@"token"];

    [LSHttpManager requestUrl:HNServiceURL serviceName:@"kckpAppBindState" parameters:bean complete:^(id result, ResultType resultType) {

      if (result != nil)
      {
          statusCount = result[@"restate"];

          if ([result[@"restate"] isEqualToString:@"0"])
          {
              _bindInfoAry = [NSMutableArray arrayWithObject:result[@"data"]];
          }

          if ([result[@"restate"] isEqualToString:@"0"])
          {
              for (NSDictionary *dict in _bindInfoAry)
              {
                  if (dict[@"car"] != nil)
                  {
                  }
              }
          }
          else
          {
              SHOWALERT(result[@"redes"]);
          }
      }
      else
      {
          statusCount = @"200";
          [self showAlertView:@"查询绑定信息失败，请检查您的网络!"];
      }

    }];
}

- (void)showAlertView:(NSString *)noticeText
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:noticeText delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark - 检测版本更新
- (void)checkVersion
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    //    [params setValue:@"HNJT_HENAN_IOS" forKey:@"appname"];
    [params setValue:@"HNJT_JJAPP_IOS" forKey:@"arg1"];

    NSString *url = @"http://220.231.252.128/restservices/appgetversion";

    [LSHttpManager requestUrl:url serviceName:@"lbcp_getAppVersion" parameters:params complete:^(id result, ResultType resultType) {

      if (result)
      {
          NSLog(@"Version -> %@", JsonResult);

          localVersion = VersionCode;
          int localVersionNUm = (localVersion == nil ? -1 : [localVersion intValue]);
          downLoad_path = result[@"remarks"];
          //获取服务器版本
          serverVersion = result[@"appversion"];
          int serverVersionNum = (serverVersion == nil ? -1 : [serverVersion intValue]);
          //判断是否升级
          if (localVersionNUm < serverVersionNum)
          {
              versionAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"有新的版本，请及时更新。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", @"取消", nil];
              [versionAlertView show];
          }
      }

    }];
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == versionAlertView)
    {
        if (buttonIndex == 0)
        {
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downLoad_path]];
        }
    }

    else
    {
        if (buttonIndex == 0)
        {
            NSLog(@"取消退出登录");
        }
        else
        {
            [UserDefaultsUtil removeAllUserDefaults]; //删除所有本地用户信息

            NSLog(@"用户确认安全退出，发送退出登录通知");

            NavViewController *nav = [[NavViewController alloc] initWithRootViewController:[LoginViewController new]];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
}

@end
