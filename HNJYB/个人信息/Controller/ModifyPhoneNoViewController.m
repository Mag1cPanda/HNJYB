//
//  ModifyPhoneNoViewController.m
//  CZT_HN_Longrise
//
//  Created by OSch on 16/5/13.
//  Copyright © 2016年 OSch. All rights reserved.
//

#import "ModifyPhoneNoViewController.h"
#import "DESCript.h"
#import "UIButton+WebCache.h"

@interface ModifyPhoneNoViewController ()<UIAlertViewDelegate>
{
    NSInteger count;
    NSTimer *codeTimer;
    UIButton *codeButton;
    NSString *imgCodeID; //图片验证码id
    NSString *phoneString;
    MBProgressHUD *activityHud;
    MBProgressHUD *hudView;
    UIAlertView *successAlert;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;
@end

@implementation ModifyPhoneNoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *mobilephone = [NSString stringWithFormat:@"%@",GlobleInstance.mobilephone];
    if (mobilephone.length == 11) {
        self.title = @"修改手机号";
        self.tipsIcon.hidden = false;
        self.tipsLab.hidden = false;
    }
    else {
        _topSpace.constant = 20;
        self.title = @"绑定手机号";
        self.tipsIcon.hidden = true;
        self.tipsLab.hidden = true;
    }
    
    count = 60;
    
    self.phoneNoLabel.text = GlobleInstance.mobilephone;
    
    self.PhoneNoNew.layer.cornerRadius = 5;
    self.PhoneNoNew.layer.masksToBounds = YES;
    
    self.sureNextBtn.layer.cornerRadius = 5;
    self.sureNextBtn.layer.masksToBounds = YES;
    
    [self getImageCode];
    [self.imageCodeBtn addTarget:self action:@selector(getImageCode) forControlEvents:1<<6];
    
    [self.phoneCodeBtn addTarget:self action:@selector(getVerifyBtnClicked:) forControlEvents:1<<6];
    [self.phoneCodeBtn setTitleColor:HNBlue forState:0];
    
}

#pragma mark - 修改手机号码
- (IBAction)sureNextClick:(id)sender {
    
    [self.view endEditing:YES];
    
    if (!self.imageCodeTextField.text.length) {
        [self showHudWithMessage:@"请先输入图片验证码!" afterDelay:1];
        return;
    }
    if (!self.PhoneNoNew.text) {
        [self showHudWithMessage:@"手机号码不能为空!" afterDelay:1];
        return;
    }
    if (![Util isMobileNumber:self.PhoneNoNew.text]) {
        [self showHudWithMessage:@"请输入正确的手机号!" afterDelay:1];
        return;
    }
    if ([self.PhoneNoNew.text isEqualToString:self.phoneNoLabel.text]) {
        [self showHudWithMessage:@"您修改的手机号码不能与原手机号码一致!" afterDelay:2];
        return;
    }
    
    if (!self.veficationTextfield.text.length) {
        hudView = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        hudView.mode = MBProgressHUDModeText;
        hudView.labelText = @"验证码不能为空!";
        [hudView hide:YES afterDelay:1.0];
        return;
    }
    
    activityHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    activityHud.labelText = @"正在上传...";
    
    NSMutableDictionary *bean = [[NSMutableDictionary alloc] init];
    [bean setValue:GlobleInstance.userflag forKey:@"userflag"];
    [bean setValue:self.phoneNoLabel.text forKey:@"mobilephoneold"];
    [bean setValue:self.PhoneNoNew.text forKey:@"mobilephone"];
    [bean setValue:self.veficationTextfield.text forKey:@"code"];
    [bean setValue:[Globle getInstance].token forKey:@"token"];
    NSString *password =  [DESCript encrypt:[UserDefaultsUtil getDataForKey:@"password"] encryptOrDecrypt:kCCEncrypt key:[Util getKey]];
    [bean setValue:password forKey:@"password"];
    
    [LSHttpManager requestUrl:HNServiceURL serviceName:@"jjappmodifyphone" parameters:bean complete:^(id result, ResultType resultType) {
       
        [activityHud hide:YES];
        if (result) {
            
            NSLog(@"%@",JsonResult);
            
            if ([result[@"restate"] isEqualToString:@"1"]) {
                
                phoneString = self.PhoneNoNew.text;
                if (_block) {
                    _block(phoneString);
                }
                NSString *noticeStr;
                if ([self.title isEqualToString:@"修改手机号"]) {
                    noticeStr = @"修改成功";
                }
                else {
                    noticeStr = @"绑定成功";
                }
                
                successAlert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:noticeStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [successAlert show];
                
            }
            else
            {
                hudView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hudView.labelText = result[@"redes"];
                [hudView hide:YES afterDelay:1.0];
            }
        }
        else
        {
            hudView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hudView.labelText = @"手机号码修改失败，请检查您的网络!";
            [hudView hide:YES afterDelay:1.0];
        }

    }];
    
}

-(void)showHudWithMessage:(NSString *)msg afterDelay:(NSTimeInterval)second
{
    hudView = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    hudView.mode = MBProgressHUDModeText;
    hudView.labelText = msg;
    [hudView hide:YES afterDelay:second];
}

#pragma mark - 图片验证码
-(void)getImageCode{
    self.imageCodeBtn.userInteractionEnabled = false;
    [LSHttpManager requestUrl:HNServiceURL serviceName:@"appcodecreater" parameters:nil complete:^(id result, ResultType resultType) {
        
        self.imageCodeBtn.userInteractionEnabled = true;
        NSLog(@"图片验证码 ~ %@",[Util objectToJson:result]);
        if ([result[@"restate"]isEqualToString:@"1"])
        {
            NSURL *codeUrl = [NSURL URLWithString:result[@"data"][@"img"]];
            [self.imageCodeBtn sd_setBackgroundImageWithURL:codeUrl forState:0];
            imgCodeID = result[@"data"][@"imgid"];
        }
    }];
}


#pragma mark - 获取验证码
- (void)getVerifyBtnClicked:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    if (!self.imageCodeTextField.text.length) {
        [self showHudWithMessage:@"请先输入图片验证码!" afterDelay:1];
    }
    else if (!self.PhoneNoNew.text) {
        [self showHudWithMessage:@"手机号码不能为空!" afterDelay:1];
    }
    else if (![Util isMobileNumber:self.PhoneNoNew.text]) {
        [self showHudWithMessage:@"请输入正确的手机号!" afterDelay:1];
    }
    else if ([self.PhoneNoNew.text isEqualToString:self.phoneNoLabel.text]) {
        [self showHudWithMessage:@"您修改的手机号码不能与原手机号码一致!" afterDelay:2];
    }
    else {
        sender.enabled = NO;
        activityHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        activityHud.labelText = @"正在上传...";
        [activityHud hide:YES afterDelay:1.0];
        
        NSMutableDictionary *bean = [[NSMutableDictionary alloc] init];
        [bean setValue:self.PhoneNoNew.text forKey:@"mobilenumber"];
        [bean setObject:self.imageCodeTextField.text forKey:@"imgcode"];
        [bean setObject:imgCodeID forKey:@"imgid"];
        
        [LSHttpManager requestUrl:HNServiceURL serviceName:@"jjappgetmodfiyphonecode" parameters:bean complete:^(id result, ResultType resultType) {
            
            [activityHud hide:YES];
            
            if (result) {
                
                NSLog(@"%@",JsonResult);
                
                if ([result[@"restate"] isEqualToString:@"1"]) {
                    [self showHudWithMessage:@"验证码发送成功！" afterDelay:1];
                    codeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
                }
                else
                {
                    sender.enabled = YES;
                    sender.hidden = NO;
                    [self showHudWithMessage:result[@"redes"] afterDelay:1];
                }
            }
            else
            {
                sender.enabled = YES;
                sender.hidden = NO;
                [self showHudWithMessage:@"验证码发送失败，请检查您的网络!" afterDelay:1];
            }

        }];
        
    }
}

-(void)countDown{
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
        NSString *title = [NSString stringWithFormat:@"%ziS",count];
        [_phoneCodeBtn setTitle:title forState:0];
    }
}

#pragma mark- AlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == successAlert) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
