//
//  CaseBaseViewController.m
//  HNJYB
//
//  Created by Mag1cPanda on 2016/10/26.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "CaseBaseViewController.h"
#import "JCAlertView.h"

@interface CaseBaseViewController ()
{
    JCAlertView *jcAlert;
}
@end

@implementation CaseBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];

    NSArray *arr = self.navigationController.viewControllers;
    if (arr.count > 1)
    {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(0, 0, 40, 40);
        [_backBtn addTarget:self action:@selector(backAction) forControlEvents:1 << 6];

        [_backBtn setImage:[UIImage imageNamed:@"IP020"] forState:0];

        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
        self.navigationItem.leftBarButtonItem = item;
    }
}

#pragma mark - 返回按钮点击事件（返回首页）
- (void)backAction
{
    [self showEndThisCaseAlert];
}

- (void)showEndThisCaseAlert
{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 60, 200)];
    customView.backgroundColor = [UIColor whiteColor];
    customView.layer.cornerRadius = 5;
    customView.clipsToBounds = YES;

    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(customView.width / 2 - 30, 20, 60, 60)];
    icon.image = [UIImage imageNamed:@"warn"];
    [customView addSubview:icon];

    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, icon.maxY + 20, customView.width, 20)];
    lab.font = HNFont(14);
    lab.text = @"是否结束本次快处";
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
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(0, lab.maxY + 21, customView.width / 2, 60);
    [confirmBtn setTitle:@"确认" forState:0];
    [confirmBtn setTitleColor:color forState:0];
    [confirmBtn addTarget:self action:@selector(jumpToHome) forControlEvents:1 << 6];
    [customView addSubview:confirmBtn];

    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(confirmBtn.maxX + 1, lab.maxY + 21, customView.width / 2, 60);
    [cancelBtn setTitle:@"暂不" forState:0];
    [cancelBtn setTitleColor:color forState:0];
    [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:1 << 6];
    [customView addSubview:cancelBtn];

    jcAlert = [[JCAlertView alloc] initWithCustomView:customView dismissWhenTouchedBackground:YES];
    [jcAlert show];
}

- (void)jumpToHome
{
    [jcAlert dismissWithCompletion:^{
      NSArray *arr = self.navigationController.viewControllers;
      [self.navigationController popToViewController:arr[1] animated:YES];
    }];
}

- (void)dismiss
{
    [jcAlert dismissWithCompletion:nil];
}
@end
