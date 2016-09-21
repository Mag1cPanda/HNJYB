//
//  OneSGSCViewController.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/2.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "OneSGSCViewController.h"
#import "SGSCView.h"
#import "SRBlockButton.h"
#import "JCAlertView.h"
#import "QRadioButton.h"
#import "MoreSGSCGroup.h"
#import "DESCript.h"
#import "IDyz.h"

@interface OneSGSCViewController ()<UITextFieldDelegate>
{
    UIScrollView *scroll;
    
    JCAlertView *jcAlert;
    
    QRadioButton *smallBtn;
    QRadioButton *bigBtn;
    
    NSMutableDictionary *bean;
    
    MoreSGSCGroup *partyAGroup;
    
    JCAlertView *endAlert;
}
@end

@implementation OneSGSCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"事故上传";
    bean = [NSMutableDictionary dictionary];
    NSString *appcaseno = GlobleInstance.appcaseno;
    [bean setValue:appcaseno forKey:@"appcaseno"];
    
    NSString *imagelon = [NSString stringWithFormat:@"%f",GlobleInstance.imagelon];
    NSString *imagelat = [NSString stringWithFormat:@"%f",GlobleInstance.imagelat];
    [bean setValue:imagelon forKey:@"caselon"];
    [bean setValue:imagelat forKey:@"caselat"];
    [bean setValue:GlobleInstance.imageaddress forKey:@"accidentplace"];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    //输出格式为：2010-10-27 10:22:13
    NSLog(@"%@",currentDateStr);
    [bean setValue:currentDateStr forKey:@"alarmtime"];
    
    [bean setValue:GlobleInstance.areaid forKey:@"areaid"];
    [bean setValue:GlobleInstance.userflag forKey:@"username"];
    NSString *pwd = [UserDefaultsUtil getDataForKey:@"password"];
    pwd = [DESCript encrypt:pwd encryptOrDecrypt:kCCEncrypt key:[Util getKey]];
    [bean setValue:pwd forKey:@"password"];
    
    [bean setValue:GlobleInstance.token forKey:@"token"];
//    [bean setValue:@"1" forKey:@"accidenttype"];
    [bean setValue:@"1" forKey:@"disposetype"];
    
    [self initScroll];
    
    [self ocrAutofill];
}

-(void)ocrAutofill{
    if ([GlobleInstance.jfocrcartype hasPrefix:@"小型"]) {
        partyAGroup.radio1.checked = YES;
    }
    else {
        partyAGroup.radio2.checked = YES;
    }
    partyAGroup.xmView.field.text = GlobleInstance.jfocrname;
    if ([Util cheackLicense:GlobleInstance.jfocrcardno]) {
        NSString *region = [GlobleInstance.jfocrcarno substringWithRange:NSMakeRange(0, 1)];
        NSString *carNumber = [GlobleInstance.jfocrcarno substringFromIndex:1];
        partyAGroup.selectList.contentLab.text = region;
        partyAGroup.cphView.field.text = carNumber;
    }
    
    partyAGroup.jszView.field.text = GlobleInstance.jfocrcardno;
    partyAGroup.cjhView.field.text = GlobleInstance.jfocrvin;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == partyAGroup.cphView.field) {
        textField.text = [textField.text uppercaseString];
    }
}

-(void)initScroll {
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    scroll.backgroundColor = HNBackColor;
    [self.view addSubview:scroll];
    
    partyAGroup = [[MoreSGSCGroup alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 570) groupId:@"partyAGroup"];
    partyAGroup.title = @"事故车主信息";
    partyAGroup.cphView.field.delegate = self;
    partyAGroup.lxdhView.field.keyboardType = UIKeyboardTypePhonePad;
    [scroll addSubview:partyAGroup];
    
    SRBlockButton *submitBtn = [[SRBlockButton alloc] initWithFrame:CGRectMake(10, partyAGroup.maxY+10, ScreenWidth-20, 50) title:@"提交" titleColor:[UIColor whiteColor] handleBlock:^(SRBlockButton *btn) {
        
        NSString *carno = [NSString stringWithFormat:@"%@%@",partyAGroup.selectList.contentLab.text,partyAGroup.cphView.field.text];
        
        if (!partyAGroup.selectedIndex) {
            SHOWALERT(@"请选择车型");
            return ;
        }
        
        if ([partyAGroup.xmView.field.text isEqualToString:@""]) {
            SHOWALERT(@"请填写姓名");
            return ;
        }
        
        if (![Util cheackLicense:carno]) {
            SHOWALERT(@"请填写正确的车牌号");
            return ;
        }
        
        if (![Util isMobileNumber:partyAGroup.lxdhView.field.text]) {
            SHOWALERT(@"请填写正确的联系电话");
            return ;
        }
        
        if (![IDyz validateIDCardNumber:partyAGroup.jszView.field.text]) {
            SHOWALERT(@"请填写正确的驾驶证号");
            return ;
        }
        
        if (![Util checkChaimsNO:partyAGroup.cjhView.field.text]) {
            SHOWALERT(@"请填写正确的车架号");
            return ;
        }
        
        if ([partyAGroup.daView.field.text isEqualToString:@""]) {
            SHOWALERT(@"请填写档案编号");
            return ;
        }
        
        [bean setValue:carno forKey:@"casecarno"];
        [bean setValue:partyAGroup.lxdhView.field.text forKey:@"appphone"];
        
        NSArray *arr = @[@{@"carownname":partyAGroup.xmView.field.text,
                         @"carownphone":partyAGroup.lxdhView.field.text,
                         @"casecarno":carno,
                         @"cartype":partyAGroup.selectedIndex,
                         @"frameno":partyAGroup.cjhView.field.text,
                         @"cardno":partyAGroup.jszView.field.text,
                         @"driverfileno":partyAGroup.daView.field.text,
                         @"driverlicence":partyAGroup.jszView.field.text,
                         @"dutytype":@"0"}];
        
        [bean setObject:arr forKey:@"casecarlist"];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [LSHttpManager requestUrl:HNServiceURL serviceName:@"jjappsubmitCaseInfor" parameters:bean complete:^(id result, ResultType resultType) {
            
            [hud hide:YES];
            if (result) {
                NSLog(@"%@",JsonResult);
            }
            
            if ([result[@"restate"] isEqualToString:@"1"]) {
                [self showAlertView];
            }
            else {
                SHOWALERT(result[@"redes"]);
            }
            
        }];
        
    }];
    submitBtn.backgroundColor = HNBlue;
    submitBtn.layer.cornerRadius = 5;
    submitBtn.clipsToBounds = YES;
    [scroll addSubview:submitBtn];
    
    scroll.contentSize = CGSizeMake(ScreenWidth, submitBtn.maxY+20);
    
    NSLog(@"%f",scroll.contentSize.height);
}

-(void)showAlertView
{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-60, 200)];
    customView.backgroundColor = [UIColor whiteColor];
    customView.layer.cornerRadius = 5;
    customView.clipsToBounds = YES;
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(customView.width/2-30, 20, 60, 60)];
    icon.image = [UIImage imageNamed:@"IP030"];
    [customView addSubview:icon];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, icon.maxY+20, customView.width, 20)];
    lab.font = HNFont(14);
    lab.text = @"事故上传成功，是否立即返回首页";
    lab.textColor = [UIColor darkGrayColor];
    lab.textAlignment = NSTextAlignmentCenter;
    [customView addSubview:lab];
    
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, lab.maxY+20, customView.width, 1)];
    horizontalLine.backgroundColor = RGB(235, 235, 235);
    [customView addSubview:horizontalLine];
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(customView.width/2, lab.maxY+20, 1, 60)];
    verticalLine.backgroundColor = RGB(235, 235, 235);
    [customView addSubview:verticalLine];
    
    
    UIColor *color = [UIColor blackColor];
    
    SRBlockButton *confirmBtn = [[SRBlockButton alloc] initWithFrame:CGRectMake(0, lab.maxY+21, customView.width/2, 60) title:@"确认" titleColor:color handleBlock:^(SRBlockButton *btn) {
        
        [jcAlert dismissWithCompletion:^{
            
            NSArray *arr = self.navigationController.viewControllers;
            [self.navigationController popToViewController:arr[1] animated:YES];
            
        }];
        
    }];
    [customView addSubview:confirmBtn];
    
    SRBlockButton *cancelBtn = [[SRBlockButton alloc] initWithFrame:CGRectMake(confirmBtn.maxX+1, lab.maxY+21, customView.width/2, 60) title:@"暂不" titleColor:color handleBlock:^(SRBlockButton *btn) {
        
        [jcAlert dismissWithCompletion:^{
            
        }];
        
    }];
    [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:1<<6];
    [customView addSubview:cancelBtn];
    
    jcAlert = [[JCAlertView alloc] initWithCustomView:customView dismissWhenTouchedBackground:YES];
    [jcAlert show];
}

-(void)dismiss{
    [jcAlert dismissWithCompletion:^{
        
    }];
}


#pragma mark - 返回按钮点击事件（返回首页）
-(void)backAction{
    [self showEndThisCaseAlert];
}

-(void)showEndThisCaseAlert
{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-60, 200)];
    customView.backgroundColor = [UIColor whiteColor];
    customView.layer.cornerRadius = 5;
    customView.clipsToBounds = YES;
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(customView.width/2-30, 20, 60, 60)];
    icon.image = [UIImage imageNamed:@"warn"];
    [customView addSubview:icon];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, icon.maxY+20, customView.width, 20)];
    lab.font = HNFont(14);
    lab.text = @"是否结束本次快处";
    lab.textColor = [UIColor darkGrayColor];
    lab.textAlignment = NSTextAlignmentCenter;
    [customView addSubview:lab];
    
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, lab.maxY+20, customView.width, 1)];
    horizontalLine.backgroundColor = RGB(235, 235, 235);
    [customView addSubview:horizontalLine];
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(customView.width/2, lab.maxY+20, 1, 60)];
    verticalLine.backgroundColor = RGB(235, 235, 235);
    [customView addSubview:verticalLine];
    
    UIColor *color = [UIColor blackColor];
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(0, lab.maxY+21, customView.width/2, 60);
    [confirmBtn setTitle:@"确认" forState:0];
    [confirmBtn setTitleColor:color forState:0];
    [confirmBtn addTarget:self action:@selector(jumpToHome) forControlEvents:1<<6];
    [customView addSubview:confirmBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(confirmBtn.maxX+1, lab.maxY+21, customView.width/2, 60);
    [cancelBtn setTitle:@"暂不" forState:0];
    [cancelBtn setTitleColor:color forState:0];
    [cancelBtn addTarget:self action:@selector(endDismiss) forControlEvents:1<<6];
    [customView addSubview:cancelBtn];
    
    endAlert = [[JCAlertView alloc] initWithCustomView:customView dismissWhenTouchedBackground:YES];
    [endAlert show];
}

-(void)jumpToHome{
    [endAlert dismissWithCompletion:^{
        NSArray *arr = self.navigationController.viewControllers;
        [self.navigationController popToViewController:arr[1] animated:YES];
    }];
}

-(void)endDismiss{
    [endAlert dismissWithCompletion:nil];
}

@end
