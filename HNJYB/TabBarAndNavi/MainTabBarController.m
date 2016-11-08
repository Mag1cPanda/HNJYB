//
//  MainTabBarController.m
//  CZT_IOS_Longrise
//
//  Created by 程三 on 15/11/27.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "MainTabBarController.h"

@implementation MainTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:CRTextColor} forState:UIControlStateSelected];

    NSArray *names = @[ @"应用首页", @"汽车档案", @"企业查询", @"个人中心" ];
    NSArray *imgAry = @[ @"nav1", @"nav2", @"nav3", @"nav4" ];
    NSArray *selectedImgAry = @[ @"nav1-active", @"nav2-active", @"nav3-active", @"nav4-active" ];
    for (int i = 0; i < 4; i++)
    {
        UINavigationController *nav = self.viewControllers[i];
        UIViewController *vc = nav.viewControllers[0];
        UIImage *image = [UIImage imageNamed:imgAry[i]];
        UIImage *selectedImage = [[UIImage imageNamed:selectedImgAry[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:names[i] image:image selectedImage:selectedImage];
    }
}

@end
