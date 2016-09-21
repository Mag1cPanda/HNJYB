//
//  LoginViewController.m
//  CZT_IOS_Longrise
//
//  Created by 程三 on 15/11/30.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "LoginViewController.h"
#import "Globle.h"
#import "ForgotPasswordViewController.h"
#import "NavViewController.h"
#import "MainTabBarController.h"
#import "DESCript.h"
#import "HomeViewController.h"

@interface LoginViewController ()
<UIGestureRecognizerDelegate,
UITextFieldDelegate>
{
    UIImageView *leftView1;
    UIImageView *leftView2;
    NSMutableDictionary *bean;
    NSString *url;
}
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    bean = [[NSMutableDictionary alloc] init];
    
    leftView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    leftView1.image = [UIImage imageNamed:@"login_user"];
    self.usrField.leftView = leftView1;
    self.usrField.leftViewMode = UITextFieldViewModeAlways;
    self.usrField.text = [UserDefaultsUtil getDataForKey:@"username"];
    
    leftView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    leftView2.image = [UIImage imageNamed:@"login_pw"];
    self.pwdField.leftView = leftView2;
    self.pwdField.leftViewMode = UITextFieldViewModeAlways;
    self.pwdField.text = [UserDefaultsUtil getDataForKey:@"password"];
    
    UIButton *pwdRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pwdRightBtn.frame = CGRectMake(0, 0, 46, 30);
    [pwdRightBtn setImage:[UIImage imageNamed:@"eyes"] forState:0];
    [pwdRightBtn addTarget:self action:@selector(pwdRightBtnClicked:) forControlEvents:1<<6];
    self.pwdField.rightView = pwdRightBtn;
    self.pwdField.rightViewMode = UITextFieldViewModeAlways;
    
}

-(void)pwdRightBtnClicked:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [btn setImage:[UIImage imageNamed:@"eyes_select"] forState:0];
        self.pwdField.secureTextEntry = NO;
    }
    else{
        [btn setImage:[UIImage imageNamed:@"eyes"] forState:0];
        self.pwdField.secureTextEntry = YES;
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)loginBtnClicked:(id)sender {
    
    if (_usrField.text.length < 1) {
        SHOWALERT(@"请输入用户名");
        return;
    }
    
    if (_pwdField.text.length < 1) {
        SHOWALERT(@"请输入密码");
        return;
    }
    
    NSString *userflag = _usrField.text;
    NSString *password = [DESCript encrypt:_pwdField.text encryptOrDecrypt:kCCEncrypt key:[Util getKey]];
    NSLog(@"密码：%@",password);
    [bean setValue:userflag forKey:@"userflag"];
    [bean setValue:password forKey:@"password"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [LSHttpManager requestUrl:HNServiceURL serviceName:@"jjapplogin" parameters:bean complete:^(id result, ResultType resultType) {
        
        [hud hide:YES];
        if (result) {
            NSLog(@"登录 -> %@",[Util objectToJson:result]);
            if ([result[@"restate"] isEqualToString:@"1"]) {
                
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
                
                NSString *userType = result[@"data"][@"usertype"];
                if ([userType isEqualToString:@"9"]) {
                    UserType = TrafficPolice;
                }
                if ([userType isEqualToString:@"12"]) {
                    UserType = AuxiliaryPolice;
                }
                
                [UserDefaultsUtil saveNSUserDefaultsForObject:_usrField.text forKey:@"username"];
                [UserDefaultsUtil saveNSUserDefaultsForObject:_pwdField.text forKey:@"password"];
                
                HomeViewController *vc = [HomeViewController new];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else {
                SHOWALERT(result[@"redes"]);
            }
        }
        
    }];
    
}


#pragma mark - 忘记密码点击事件
- (IBAction)forgotPasswordBtnClicked:(id)sender {
    ForgotPasswordViewController *vc = [[ForgotPasswordViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
