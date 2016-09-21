//
//  ForgotPasswordViewController.m
//  CZT_IOS_Longrise
//
//  Created by 张博林 on 15/12/29.
//  Copyright © 2015年 程三. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "Globle.h"
//#import "ImgCodeView.h"
#import "UIButton+countDown.h"
//#import "IDyz.h"

@interface ForgotPasswordViewController ()
<UITextFieldDelegate,UIAlertViewDelegate>
{
    NSString *imgCodeID;
    NSString *url;
}

@end

@implementation ForgotPasswordViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
    
    ImgCodeView *imgCodeView = [[ImgCodeView alloc]initWithFrame:CGRectMake(0, 0, self.backCodeView.frame.size.width,self.backCodeView.frame.size.height)];
    imgCodeView.delegate = self;
    [self.backCodeView addSubview:imgCodeView];
    
    UIButton *getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [getCodeBtn addTarget:self action:@selector(getVerifyBtnClicked:) forControlEvents:1<<6];
    getCodeBtn.frame = self.verCodeBtnBack.bounds;
    [getCodeBtn setTitle:@"获取验证码" forState:0];
    [getCodeBtn setTitleColor:HNBlue forState:0];
    getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.verCodeBtnBack addSubview:getCodeBtn];
}

#pragma mark - 图片验证码代理
-(void)requestImgCodeViewID:(NSString *)imgId
{
    imgCodeID = imgId;
}

#pragma mark - 获取验证码
- (void)getVerifyBtnClicked:(UIButton *)sender {
    
    if (!self.imgCodeField.text.length)
    {
        SHOWALERT(@"图片验证码不能为空");
        return;
    }

    if (_phoneField.text.length == 11) {
        
        [sender startWithTime:120 title:@"获取验证码" countDownTitle:@"S" mainColor:[UIColor whiteColor] countColor:HNBlue];
        
        NSMutableDictionary *bean = [NSMutableDictionary dictionary];
        [bean setValue:_phoneField.text forKey:@"mobilenumber"];
        [bean setValue:_imgCodeField.text forKey:@"imgcode"];
        [bean setValue:imgCodeID forKey:@"imgid"];
        
        [LSHttpManager requestUrl:HNServiceURL serviceName:@"jjappgetforgetpwdcode" parameters:bean complete:^(id result, ResultType resultType) {
           
            BOOL isSucess = false;
            if (result) {
                NSLog(@"忘记密码 -> %@",[Util objectToJson:result]);
                NSDictionary *bigDic = result;
                if ([bigDic[@"restate"]isEqualToString:@"1"]) {
                    SHOWALERT(@"请耐心等待验证码的发送！");
                    isSucess = true;
                }
                else{
                    SHOWALERT(bigDic[@"redes"]);
                }
                
            }
            
        }];
    }
    
    else{
        SHOWALERT(@"您输入的手机号不正确！");
    }
}

#pragma mark - AlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 确认按钮点击事件
- (IBAction)confrimBtnClicked:(id)sender {
    
    _confirmBtn.userInteractionEnabled = NO;
    
    NSMutableDictionary *bean = [NSMutableDictionary dictionary];
    
    NSDictionary *bigDic = [UserDefaultsUtil getDataForKey:LoginFileName];
    NSDictionary *userdic = [bigDic objectForKey:@"userinfo"];
    NSString *userflag = [userdic objectForKey:@"userflag"];
    
    [bean setValue:userflag forKey:@"userflag"];
    [bean setValue:_phoneField.text forKey:@"mobilephone"];
    [bean setValue:_msgField.text forKey:@"code"];
    [bean setValue:@"0" forKey:@"flag"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [LSHttpManager requestUrl:HNServiceURL serviceName:@"appforgetpwd" parameters:bean complete:^(id result, ResultType resultType) {
        
        [hud hide:YES];
        
        if (result) {
            NSLog(@"找回密码 -> %@",[Util objectToJson:result]);
        }
        
        if ([result[@"restate"]isEqualToString:@"1"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请耐心等待新密码的发送！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            _confirmBtn.userInteractionEnabled = YES;
        }
        else{
            SHOWALERT(result[@"redes"]);
            _confirmBtn.userInteractionEnabled = YES;
        }
     
    }];
    
}


@end
