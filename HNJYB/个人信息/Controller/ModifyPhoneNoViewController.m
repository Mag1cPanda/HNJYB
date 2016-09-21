//
//  ModifyPhoneNoViewController.m
//  CZT_HN_Longrise
//
//  Created by OSch on 16/5/13.
//  Copyright © 2016年 OSch. All rights reserved.
//

#import "ModifyPhoneNoViewController.h"
#import "DESCript.h"
#import "ImgCodeView.h"

@interface ModifyPhoneNoViewController ()<ImgCodeViewDelegate>
{
    NSInteger seconds;
    NSTimer *codeTimer;
    UIButton *codeButton;
    NSString *imgCodeViewId; //图片验证码id
    NSString *phoneString;
    MBProgressHUD *activityHud;
    MBProgressHUD *hudView;
}
@end

@implementation ModifyPhoneNoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self init_UI];
}

- (void)init_UI
{
    self.title = @"修改手机号";
    seconds = 60;
    
    self.phoneNoLabel.text = self.oldPhoneNO;
    
    self.PhoneNoNew.layer.cornerRadius = 5;
    self.PhoneNoNew.layer.masksToBounds = YES;
    
    self.sureNextBtn.layer.cornerRadius = 5;
    self.sureNextBtn.layer.masksToBounds = YES;
    
    ImgCodeView *imgCodeView = [[ImgCodeView alloc]initWithFrame:CGRectMake(0, 1, self.codeImageView.frame.size.width,self.codeImageView.frame.size.height - 4)];
    imgCodeView.delegate = self;
    [self.codeImageView addSubview:imgCodeView];
    
    [self initVefificationCodeButton];
}

#pragma mark - 修改手机号码
- (IBAction)sureNextClick:(id)sender {
    
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
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"绑定成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alertView show];
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

#pragma mark - 创建发送验证码按钮
-(void)initVefificationCodeButton
{
    codeButton = [[UIButton alloc]initWithFrame:self.veficationCodeView.bounds];
    [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeButton setTitleColor:[UIColor colorWithRed:91/255.0 green:177/255.0 blue:36/255.0 alpha:1] forState:UIControlStateNormal];
    codeButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [codeButton addTarget:self action:@selector(SendVification:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.veficationCodeView addSubview:codeButton];
}

#pragma mark -  获取图片验证码
- (void)requestImgCodeViewID:(NSString *)imgId
{
    imgCodeViewId = imgId;
}

-(void)showHudWithMessage:(NSString *)msg afterDelay:(NSTimeInterval)second
{
    hudView = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    hudView.mode = MBProgressHUDModeText;
    hudView.labelText = msg;
    [hudView hide:YES afterDelay:second];
}

#pragma mark - 发送请求
- (void)SendVification:(UIButton *)sender
{
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
        [bean setObject:imgCodeViewId forKey:@"imgid"];
        
        [LSHttpManager requestUrl:HNServiceURL serviceName:@"jjappgetmodfiyphonecode" parameters:bean complete:^(id result, ResultType resultType) {
            
            [activityHud hide:YES];
            
            if (result) {
                
                NSLog(@"%@",JsonResult);
                
                if ([result[@"restate"] isEqualToString:@"1"]) {
                    [self showHudWithMessage:@"验证码发送成功！" afterDelay:1];
                    codeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(retransmissiontimer:) userInfo:nil repeats:YES];
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

- (void)retransmissiontimer:(NSTimer *)timer
{
    seconds--;
    if (seconds == 0){
        [codeTimer invalidate];
        codeTimer = nil;
        seconds = 60;
        [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        codeButton.enabled = YES;
        
    }else{
        [codeButton setTitle:[NSString stringWithFormat:@"%zis后重发",seconds] forState:UIControlStateNormal];
    }
}

#pragma mark- alertView

- (void)showAlertView:(NSString *)noticeText
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:noticeText delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:phoneString forKey:@"phone"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
