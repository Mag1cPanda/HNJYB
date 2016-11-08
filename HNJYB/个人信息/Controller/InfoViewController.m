//
//  InfoViewController.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/7/28.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "InfoOtherCell.h"
#import "InfoPhotoCell.h"
#import "InfoViewController.h"
#import "LoginViewController.h"
#import "ModifyPassWordViewController.h"
#import "ModifyPhoneNoViewController.h"
#import "NavViewController.h"

@interface InfoViewController () < UITableViewDataSource,
                                   UITableViewDelegate,
                                   UIAlertViewDelegate >
{
    UITableView *table;
    NSArray *titleArr0;
    NSArray *titleArr1;

    NSArray *contentArr0;
    NSArray *contentArr1;
}
@end

@implementation InfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view
    //    titleArr0 = @[@"",@"用户名",@"真实姓名"];
    titleArr0 = @[ @"用户名", @"真实姓名" ];
    //    titleArr1 = @[@"警号",@"所属大队",@"修改手机号",@"修改密码",@"版本"];
    titleArr1 = @[ @"修改手机号", @"修改密码", @"版本" ];
    contentArr0 = @[ GlobleInstance.userflag,
                     GlobleInstance.armyname ];
    //    contentArr1 = @[GlobleInstance.policeno,
    //                    @"",
    //                    GlobleInstance.mobilephone,
    //                    @"",
    //                    @"1.0"];

    contentArr1 = @[ GlobleInstance.mobilephone,
                     @"",
                     @"1.0" ];

    self.title = @"个人信息";

    CGFloat viewWidth = ScreenWidth - 20;

    table = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, viewWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    table.backgroundColor = [UIColor clearColor];
    table.delegate = self;
    table.dataSource = self;
    table.layer.cornerRadius = 5;
    [self.view addSubview:table];

    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    footer.backgroundColor = [UIColor clearColor];
    table.tableFooterView = footer;

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 25, viewWidth, 50);
    [btn setTitle:@"退出登录" forState:0];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    btn.titleLabel.font = HNFont(16);
    [btn addTarget:self action:@selector(loginOut) forControlEvents:1 << 6];
    btn.backgroundColor = HNBlue;
    btn.layer.cornerRadius = 5;
    [footer addSubview:btn];

    [table registerNib:[UINib nibWithNibName:@"InfoPhotoCell" bundle:nil] forCellReuseIdentifier:@"InfoPhotoCell"];
    [table registerNib:[UINib nibWithNibName:@"InfoOtherCell" bundle:nil] forCellReuseIdentifier:@"InfoOtherCell"];
}

#pragma mark - 退出登录
- (void)loginOut
{
    UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:nil message:@"确定退出登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定退出", nil];
    [logoutAlert show];
}

#pragma mark - alertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
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

#pragma mark - tableView Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return titleArr0.count;
    }
    else
    {
        return titleArr1.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*暂时隐藏头像*/
    //    if (indexPath.section == 0 && indexPath.row == 0) {
    //        InfoPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoPhotoCell"];
    //        [cell.icon sd_setImageWithURL:[NSURL URLWithString:GlobleInstance.photo] placeholderImage:[UIImage imageNamed:@"IP008"]];
    //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //        return cell;
    //    }

    //    else {
    InfoOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoOtherCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0)
    {
        cell.titleLab.text = titleArr0[indexPath.row];
        cell.contentLab.text = contentArr0[indexPath.row];
    }
    else
    {
        cell.titleLab.text = titleArr1[indexPath.row];
        //            if (indexPath.row == 0 || indexPath.row == 1) {
        //                cell.contentLab.text = @"未绑定";
        //                cell.contentLab.textColor = [UIColor redColor];
        //            }

        if (indexPath.row == 0)
        {
            if ([GlobleInstance.mobilephone isEqualToString:@""])
            {
                cell.contentLab.text = @"绑定";
                cell.titleLab.text = @"绑定手机号";
            }
            else
            {
                cell.contentLab.text = @"修改";
                cell.titleLab.text = [NSString stringWithFormat:@"修改手机号 %@", GlobleInstance.mobilephone];
            }
        }

        if (indexPath.row == 1)
        {
            cell.contentLab.text = @"修改";
        }
    }
    return cell;
    //    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (indexPath.section == 0 && indexPath.row == 0) {
    //        return 100;
    //    }

    //    else {
    return 50;
    //    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 20;
    }
    else
    {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 20, 20)];
    view.backgroundColor = HNBackColor;
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        //        if (indexPath.row == 0) {
        //            if ([GlobleInstance.policeno isEqualToString:@""]) {
        //                [self showHudWithMessage:@"警号尚未分配"];
        //            }
        //        }
        //        if (indexPath.row == 1) {
        //            [self showHudWithMessage:@"所属大队尚未分配"];
        //        }
        if (indexPath.row == 0)
        {
            ModifyPhoneNoViewController *vc = [ModifyPhoneNoViewController new];
            vc.block = ^(NSString *phone) {

              //手机号绑定（修改）成功后的回调
              GlobleInstance.mobilephone = phone;
              InfoOtherCell *cell = [tableView cellForRowAtIndexPath:indexPath];
              if ([GlobleInstance.mobilephone isEqualToString:@""])
              {
                  cell.contentLab.text = @"绑定";
                  cell.titleLab.text = @"绑定手机号";
              }
              else
              {
                  cell.contentLab.text = @"修改";
                  cell.titleLab.text = [NSString stringWithFormat:@"修改手机号 %@", GlobleInstance.mobilephone];
              }

            };
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 1)
        {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ModifyPassWordViewController" bundle:nil];
            ModifyPassWordViewController *vc = [sb instantiateInitialViewController];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 2)
        {
            [self showHudWithMessage:@"暂未查询到新版本"];
        }
    }

    else
    {
        if (indexPath.row == 0)
        {
            [self showHudWithMessage:@"暂不支持修改用户名"];
        }
        else
        {
            [self showHudWithMessage:@"暂不支持修改真实姓名"];
        }
    }
}

- (void)showHudWithMessage:(NSString *)msg
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    [hud hide:YES afterDelay:1.5];
}

@end
