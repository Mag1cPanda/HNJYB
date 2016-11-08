//
//  NavViewController.m
//  CZT_IOS_Longrise
//
//  Created by 程三 on 15/11/27.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "NavViewController.h"

@interface NavViewController ()

@end

@implementation NavViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImage *img = [UIImage imageNamed:@"blue"];
    // 指定为拉伸模式，伸缩后重新赋值
    img = [img resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    self.navigationBar.backgroundColor = [UIColor whiteColor];
    [self.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];

    //去除导航栏底部黑线
    [self.navigationBar setShadowImage:[UIImage new]];

    //导航栏文字颜色变为白色
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

    //去掉系统自带返回按钮的文字，只保留箭头
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];

    //改变返回按钮的颜色
    [self.navigationBar setTintColor:[UIColor whiteColor]];

    //设置原点坐标从标题栏下面开始
    self.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
