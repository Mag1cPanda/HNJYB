//
//  ForgotPasswordViewController.m
//  CZT_IOS_Longrise
//
//  Created by 张博林 on 15/12/29.
//  Copyright © 2015年 程三. All rights reserved.
//

#import "DESCript.h"
#import "ForgotPasswordViewController.h"
#import "UIButton+WebCache.h"

@interface ForgotPasswordViewController () < UITextFieldDelegate, UIAlertViewDelegate >
{
    //定时器
    NSTimer *codeTimer;
    NSString *imgCodeID;
    NSString *url;
    NSInteger count;
}

@end

@implementation ForgotPasswordViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"找回密码";
    count = 60;

    [self getImageCode];
    [self.imageCode addTarget:self action:@selector(getImageCode) forControlEvents:1 << 6];

    [self.phoneCodeBtn addTarget:self action:@selector(getVerifyBtnClicked:) forControlEvents:1 << 6];
    [self.phoneCodeBtn setTitleColor:HNBlue forState:0];
}

#pragma mark - 是否显示密码
- (IBAction)showOrHide1Click:(id)sender
{
    self.pwdField.secureTextEntry = !self.pwdField.secureTextEntry;
    [self.showOrHide1 setImage:self.pwdField.secureTextEntry == YES ? [UIImage imageNamed:@"eyes"] : [UIImage imageNamed:@"eyes_select"] forState:UIControlStateNormal];
}

- (IBAction)showOrHide2Click:(id)sender
{
    self.insureField.secureTextEntry = !self.insureField.secureTextEntry;
    [self.showOrHide2 setImage:self.insureField.secureTextEntry == YES ? [UIImage imageNamed:@"eyes"] : [UIImage imageNamed:@"eyes_select"] forState:UIControlStateNormal];
}

#pragma mark - 图片验证码
- (void)getImageCode
{
    self.imageCode.userInteractionEnabled = false;
    [LSHttpManager requestUrl:HNServiceURL serviceName:@"appcodecreater" parameters:nil complete:^(id result, ResultType resultType) {

      self.imageCode.userInteractionEnabled = true;
      NSLog(@"图片验证码 ~ %@", [Util objectToJson:result]);
      if ([result[@"restate"] isEqualToString:@"1"])
      {
          NSURL *codeUrl = [NSURL URLWithString:result[@"data"][@"img"]];
          [self.imageCode sd_setBackgroundImageWithURL:codeUrl forState:0];
          imgCodeID = result[@"data"][@"imgid"];
      }
    }];
}

#pragma mark - 获取验证码
- (void)getVerifyBtnClicked:(UIButton *)sender
{
    if (!self.imgCodeField.text.length)
    {
        SHOWALERT(@"图片验证码不能为空");
        return;
    }

    if (_phoneField.text.length == 11)
    {
        //        [sender startWithTime:120 title:@"获取验证码" countDownTitle:@"S" mainColor:[UIColor redColor] countColor:HNBlue];

        NSMutableDictionary *bean = [NSMutableDictionary dictionary];
        [bean setValue:_phoneField.text forKey:@"mobilenumber"];
        [bean setValue:_imgCodeField.text forKey:@"imgcode"];
        [bean setValue:imgCodeID forKey:@"imgid"];

        [LSHttpManager requestUrl:HNServiceURL serviceName:@"jjappgetforgetpwdcode" parameters:bean complete:^(id result, ResultType resultType) {

          BOOL isSucess = false;
          if (result)
          {
              NSLog(@"忘记密码 -> %@", [Util objectToJson:result]);
              NSDictionary *bigDic = result;
              if ([bigDic[@"restate"] isEqualToString:@"1"])
              {
                  SHOWALERT(@"请耐心等待验证码的发送！");
                  //开始计时
                  //                     [self.phoneCodeBtn setTitle:@"60S" forState:0];
                  codeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
                  isSucess = true;
              }
              else
              {
                  SHOWALERT(bigDic[@"redes"]);
              }
          }

        }];
    }

    else
    {
        SHOWALERT(@"您输入的手机号不正确！");
    }
}

- (void)countDown
{
    if (count == 1)
    {
        _phoneCodeBtn.userInteractionEnabled = YES;
        [_phoneCodeBtn setTitle:@"获取验证码" forState:0];
        count = 60;
        [codeTimer invalidate];
    }
    else
    {
        _phoneCodeBtn.userInteractionEnabled = NO;
        count--;
        NSString *title = [NSString stringWithFormat:@"%ziS", count];
        [_phoneCodeBtn setTitle:title forState:0];
    }
}

#pragma mark - AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 确认按钮点击事件
- (IBAction)confrimBtnClicked:(id)sender
{
    if (_imgCodeField.text.length != 4)
    {
        [self showHudWithMessage:@"请输入正确的图片验证码"];
        return;
    }

    if (_phoneField.text.length != 11)
    {
        [self showHudWithMessage:@"请输入正确的手机号"];
        return;
    }

    if (_msgField.text.length != 6)
    {
        [self showHudWithMessage:@"请输入正确的短信验证码"];
        return;
    }

    if (!_pwdField.text.length)
    {
        [self showHudWithMessage:@"新密码不能为空!"];
        return;
    }

    if (![self checkPassWordRationality:_pwdField.text])
    {
        [self showHudWithMessage:@"请输入6~15位由字母和数字组合的新密码"];
        return;
    }

    if (!_insureField.text.length)
    {
        [self showHudWithMessage:@"确认密码不能为空!"];
        return;
    }

    if (![_pwdField.text isEqualToString:_insureField.text])
    {
        SHOWALERT(@"两次输入的密码不一致，请重新输入");
        return;
    }

    NSMutableDictionary *bean = [NSMutableDictionary dictionary];

    //    NSDictionary *bigDic = [UserDefaultsUtil getDataForKey:LoginFileName];
    //    NSDictionary *userdic = [bigDic objectForKey:@"userinfo"];
    //    NSString *userflag = [userdic objectForKey:@"userflag"];
    //    [bean setValue:userflag forKey:@"userflag"];

    [bean setValue:_phoneField.text forKey:@"phonenumber"];
    [bean setValue:_msgField.text forKey:@"code"];

    NSString *pwdStr = [DESCript encrypt:_pwdField.text encryptOrDecrypt:kCCEncrypt key:[Util getKey]];
    [bean setValue:pwdStr forKey:@"userpwd"];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [LSHttpManager requestUrl:HNServiceURL serviceName:@"jjappforgetpassword" parameters:bean complete:^(id result, ResultType resultType) {

      [hud hide:YES];

      if (result)
      {
          NSLog(@"找回密码 -> %@", [Util objectToJson:result]);
      }

      if ([result[@"restate"] isEqualToString:@"1"])
      {
          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"密码找回成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
          [alert show];
      }
      else
      {
          SHOWALERT(result[@"redes"]);
      }

    }];
}

#pragma mark - 正则验证用户名和密码
- (BOOL)checkPassWordRationality:(NSString *)rationalityString
{
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z_]{6,15}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [predicate evaluateWithObject:rationalityString];
    return isMatch;
}

- (void)showHudWithMessage:(NSString *)msg
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    [hud hide:YES afterDelay:1.5];
}

@end
