//
//  MoreSGSCViewController.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/2.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "MoreSGSCViewController.h"
#import "MoreSGSCGroup.h"
#import "ZRRDViewController.h"
#import "InfoModel.h"
#import "IDyz.h"
#import "JCAlertView.h"

@interface MoreSGSCViewController ()<UITextFieldDelegate>
{
    UIScrollView *scroll;
    MoreSGSCGroup *partyAGroup;
    MoreSGSCGroup *partyBGroup;
}
@end

@implementation MoreSGSCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"事故上传";
    
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    [self.view addSubview:scroll];
    
    
    partyAGroup = [[MoreSGSCGroup alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 570) groupId:@"partyAGroup"];
    partyAGroup.title = @"甲方信息";
    partyAGroup.cphView.field.delegate = self;
    partyAGroup.lxdhView.field.keyboardType = UIKeyboardTypePhonePad;
    [scroll addSubview:partyAGroup];
    
    partyBGroup = [[MoreSGSCGroup alloc] initWithFrame:CGRectMake(0, partyAGroup.maxY, ScreenWidth, 570) groupId:@"partyBGroup"];
    partyBGroup.title = @"乙方信息";
    partyBGroup.cphView.field.delegate = self;
    partyBGroup.lxdhView.field.keyboardType = UIKeyboardTypePhonePad;
    [scroll addSubview:partyBGroup];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame  = CGRectMake(10, partyBGroup.maxY+25, ScreenWidth-20, 50);
    [btn setTitle:@"提交" forState:0];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    [btn addTarget:self action:@selector(confirmBtnClicked) forControlEvents:1<<6];
    btn.backgroundColor = HNBlue;
    btn.layer.cornerRadius = 5;
    [scroll addSubview:btn];
    
    scroll.contentSize = CGSizeMake(ScreenWidth, btn.maxY+25);
    [self ocrAutofill];
}

-(void)ocrAutofill{
    //填充甲方
    if ([GlobleInstance.jfocrcartype hasPrefix:@"小型"]) {
        partyAGroup.radio1.checked = YES;
    }
    else {
        partyAGroup.radio2.checked = YES;
    }
    partyAGroup.xmView.field.text = GlobleInstance.jfocrname;
    if (GlobleInstance.jfocrcarno.length == 7) {
        NSString *jfRegion = [GlobleInstance.jfocrcarno substringWithRange:NSMakeRange(0, 1)];
        NSString *jfCarNumber = [GlobleInstance.jfocrcarno substringFromIndex:1];
        partyAGroup.selectList.contentLab.text = jfRegion;
        partyAGroup.cphView.field.text = jfCarNumber;
    }
    partyAGroup.jszView.field.text = GlobleInstance.jfocrcardno;
    partyAGroup.cjhView.field.text = GlobleInstance.jfocrvin;
    
    //填充乙方
    if ([GlobleInstance.yfocrcartype hasPrefix:@"小型"]) {
        partyBGroup.radio1.checked = YES;
    }
    else {
        partyBGroup.radio2.checked = YES;
    }
    partyBGroup.xmView.field.text = GlobleInstance.yfocrname;
    if (GlobleInstance.yfocrcarno.length == 7) {
        NSString *yfRegion = [GlobleInstance.yfocrcarno substringWithRange:NSMakeRange(0, 1)];
        NSString *yfCarNumber = [GlobleInstance.yfocrcarno substringFromIndex:1];
        partyBGroup.selectList.contentLab.text = yfRegion;
        partyBGroup.cphView.field.text = yfCarNumber;
    }
    partyBGroup.jszView.field.text = GlobleInstance.yfocrcardno;
    partyBGroup.cjhView.field.text = GlobleInstance.yfocrvin;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == partyAGroup.cphView.field || textField == partyBGroup.cphView.field) {
        textField.text = [textField.text uppercaseString];
    }
}

#pragma mark - 提交按钮点击事件
-(void)confirmBtnClicked
{
    InfoModel *jfModel = [InfoModel new];
    jfModel.carType = partyAGroup.selectedIndex;
    jfModel.name = partyAGroup.xmView.field.text;
    jfModel.carNum = [NSString stringWithFormat:@"%@%@",partyAGroup.selectList.contentLab.text,partyAGroup.cphView.field.text];
    jfModel.phoneNum = partyAGroup.lxdhView.field.text;
    jfModel.driveNum = partyAGroup.jszView.field.text;
    jfModel.vinNum = partyAGroup.cjhView.field.text;
    jfModel.recordNum = partyAGroup.daView.field.text;
    
    InfoModel *yfModel = [InfoModel new];
    yfModel.carType = partyBGroup.selectedIndex;
    yfModel.name = partyBGroup.xmView.field.text;
    yfModel.carNum = [NSString stringWithFormat:@"%@%@",partyBGroup.selectList.contentLab.text,partyBGroup.cphView.field.text];
    yfModel.phoneNum = partyBGroup.lxdhView.field.text;
    yfModel.driveNum = partyBGroup.jszView.field.text;
    yfModel.vinNum = partyBGroup.cjhView.field.text;
    yfModel.recordNum = partyBGroup.daView.field.text;
    
    //甲方Judge
    if (!jfModel.carType) {
        SHOWALERT(@"请选择甲方车型");
        return;
    }
    
    if (jfModel.name.length<1) {
        SHOWALERT(@"请填写甲方姓名");
        return;
    }
    
    if (![Util cheackLicense:jfModel.carNum]) {
        SHOWALERT(@"请填写正确的甲方车牌号");
        return ;
    }
    
    if (![Util isMobileNumber:jfModel.phoneNum]) {
        SHOWALERT(@"请填写正确的甲方联系电话");
        return ;
    }
    
    if (![IDyz validateIDCardNumber:jfModel.driveNum]) {
        SHOWALERT(@"请填写正确的甲方驾驶证号");
        return ;
    }
    
    if (![Util checkChaimsNO:jfModel.vinNum]) {
        SHOWALERT(@"请填写正确的甲方车架号");
        return ;
    }
    
    if (jfModel.recordNum.length<1) {
        SHOWALERT(@"请填写甲方档案编号");
        return;
    }
    
    //乙方Judge
    if (!yfModel.carType) {
        SHOWALERT(@"请选择乙方车型");
        return;
    }
    
    if (yfModel.name.length<1) {
        SHOWALERT(@"请填写乙方姓名");
        return;
    }
    
    if (![Util cheackLicense:yfModel.carNum]) {
        SHOWALERT(@"请填写正确的乙方车牌号");
        return ;
    }
    
    if (![Util isMobileNumber:yfModel.phoneNum]) {
        SHOWALERT(@"请填写正确的乙方联系电话");
        return ;
    }
    
    if (![IDyz validateIDCardNumber:yfModel.driveNum]) {
        SHOWALERT(@"请填写正确的乙方驾驶证号");
        return ;
    }
    
    if (![Util checkChaimsNO:yfModel.vinNum]) {
        SHOWALERT(@"请填写正确的乙方车架号");
        return ;
    }
    
    if (yfModel.recordNum.length<1) {
        SHOWALERT(@"请填写乙方档案编号");
        return;
    }
    
    if ([jfModel.carNum isEqualToString:yfModel.carNum]) {
        SHOWALERT(@"甲乙双方车牌号不能相同");
        return;
    }
    
    if ([jfModel.phoneNum isEqualToString:yfModel.phoneNum]) {
        SHOWALERT(@"甲乙双方手机号不能相同");
        return;
    }
    
    if ([jfModel.driveNum isEqualToString:yfModel.driveNum]) {
        SHOWALERT(@"甲乙双方驾驶证号不能相同");
        return;
    }
    
    if ([jfModel.vinNum isEqualToString:yfModel.vinNum]) {
        SHOWALERT(@"甲乙双方车架号不能相同");
        return;
    }
    
    if ([jfModel.recordNum isEqualToString:yfModel.recordNum]) {
        SHOWALERT(@"甲乙双方档案编号不能相同");
        return;
    }
    
    ZRRDViewController *vc = [ZRRDViewController new];
    vc.jfModel = jfModel;
    vc.yfModel = yfModel;
    vc.selectedItem = _selectedItem;
    vc.caseDes = _caseDes;
    [self.navigationController pushViewController:vc animated:YES];
}

JCAlertView *jcAlert;
#pragma mark - 返回按钮点击事件（返回首页）
-(void)backAction{
    [self showEndThisCaseAlert];
}

-(void)showEndThisCaseAlert{
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
    [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:1<<6];
    [customView addSubview:cancelBtn];
    
    jcAlert = [[JCAlertView alloc] initWithCustomView:customView dismissWhenTouchedBackground:YES];
    [jcAlert show];
}

-(void)jumpToHome{
    [jcAlert dismissWithCompletion:^{
        NSArray *arr = self.navigationController.viewControllers;
        [self.navigationController popToViewController:arr[1] animated:YES];
    }];
}

-(void)dismiss{
    [jcAlert dismissWithCompletion:nil];
}
@end
