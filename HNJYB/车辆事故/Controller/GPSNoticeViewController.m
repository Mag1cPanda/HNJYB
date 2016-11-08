//
//  GPSNoticeViewController.m
//  CZT_HN_Longrise
//
//  Created by OSch on 16/5/21.
//  Copyright © 2016年 OSch. All rights reserved.
//

#import "GPSNoticeViewController.h"
#import "SafetyTipsViewController.h"
#import <CoreLocation/CoreLocation.h>

//定位时间Key
//#define LocationTIMEKEY @"locationTimeKey"

@interface GPSNoticeViewController ()

@end

@implementation GPSNoticeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"温馨提示";
}

#pragma mark - 下一步按钮点击事件
- (IBAction)nextStep:(UIButton *)btn
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
