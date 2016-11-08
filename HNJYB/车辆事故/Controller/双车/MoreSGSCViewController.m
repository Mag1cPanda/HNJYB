//
//  MoreSGSCViewController.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/2.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "IDyz.h"
#import "InfoModel.h"
#import "JCAlertView.h"
#import "MoreSGSCGroup.h"
#import "MoreSGSCViewController.h"
#import "ZRRDViewController.h"

@interface MoreSGSCViewController () < UITextFieldDelegate >
{
    UIScrollView *scroll;
    MoreSGSCGroup *partyAGroup;
    MoreSGSCGroup *partyBGroup;
    JCAlertView *jcAlert;

    NSString *jfcarno;
    NSString *yfcarno;
    NSString *jfframeno;
    NSString *yfframeno;
}
@end

@implementation MoreSGSCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"事故上传";

    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    [self.view addSubview:scroll];

    partyAGroup = [[MoreSGSCGroup alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 570) groupId:@"partyAGroup"];
    partyAGroup.title = @"甲方信息";
    partyAGroup.cphView.field.delegate = self;
    partyAGroup.cjhView.field.delegate = self;
    partyAGroup.lxdhView.field.keyboardType = UIKeyboardTypePhonePad;
    //给获取按钮添加点击事件
    [partyAGroup.codeBtn addTarget:self action:@selector(getBdhCode:) forControlEvents:1 << 6];
    [scroll addSubview:partyAGroup];

    partyBGroup = [[MoreSGSCGroup alloc] initWithFrame:CGRectMake(0, partyAGroup.maxY, ScreenWidth, 570) groupId:@"partyBGroup"];
    partyBGroup.title = @"乙方信息";
    partyBGroup.cphView.field.delegate = self;
    partyBGroup.cjhView.field.delegate = self;
    partyBGroup.lxdhView.field.keyboardType = UIKeyboardTypePhonePad;
    //给获取按钮添加点击事件
    [partyBGroup.codeBtn addTarget:self action:@selector(getBdhCode:) forControlEvents:1 << 6];
    [scroll addSubview:partyBGroup];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, partyBGroup.maxY + 25, ScreenWidth - 20, 50);
    [btn setTitle:@"提交" forState:0];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    [btn addTarget:self action:@selector(confirmBtnClicked) forControlEvents:1 << 6];
    btn.backgroundColor = HNBlue;
    btn.layer.cornerRadius = 5;
    [scroll addSubview:btn];

    scroll.contentSize = CGSizeMake(ScreenWidth, btn.maxY + 25);
    [self ocrAutofill];
}

#pragma mark - 获取保单号
- (void)getBdhCode:(UIButton *)btn
{
    if (btn == partyAGroup.codeBtn)
    {
        if (![Util cheackLicense:jfcarno])
        {
            SHOWALERT(@"请填写正确的甲方车牌号");
            return;
        }

        if (![Util checkChaimsNO:jfframeno])
        {
            SHOWALERT(@"请填写正确的甲方车架号");
            return;
        }
    }

    else
    {
        if (![Util cheackLicense:yfcarno])
        {
            SHOWALERT(@"请填写正确的乙方车牌号");
            return;
        }

        if (![Util checkChaimsNO:yfframeno])
        {
            SHOWALERT(@"请填写正确的乙方车架号");
            return;
        }
    }

    NSMutableDictionary *bdhBean = [NSMutableDictionary dictionary];

    [bdhBean setValue:GlobleInstance.appcaseno forKey:@"userflag"];
    [bdhBean setValue:GlobleInstance.token forKey:@"token"];
    [bdhBean setValue:@"" forKey:@"policyno"];
    [bdhBean setValue:GlobleInstance.appcaseno forKey:@"appcaseno"];

    if (btn == partyAGroup.codeBtn)
    {
        [bdhBean setValue:jfcarno forKey:@"casecarno"];
        [bdhBean setValue:jfframeno forKey:@"frameno"];
    }

    else
    {
        [bdhBean setValue:yfcarno forKey:@"casecarno"];
        [bdhBean setValue:yfframeno forKey:@"frameno"];
    }

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];

    [LSHttpManager requestUrl:HNServiceURL serviceName:@"jjappkckpSearchCpsNum" parameters:bdhBean complete:^(id result, ResultType resultType) {

      [hud hide:true];

      NSLog(@"获取保单号 -> %@", result);

      if ([result[@"restate"] isEqualToString:@"1"])
      {
          if (btn == partyAGroup.codeBtn)
          {
              partyAGroup.bdhView.field.text = result[@"data"][@"trafficinsno"];
          }

          else
          {
              partyBGroup.bdhView.field.text = result[@"data"][@"trafficinsno"];
          }
      }

      else
      {
          SHOWALERT(@"没有查询到保单号，请手动输入");
      }

    }];
}

- (void)ocrAutofill
{
    //填充甲方
    if ([GlobleInstance.jfocrcartype hasPrefix:@"小型"])
    {
        partyAGroup.radio1.checked = YES;
    }
    else
    {
        partyAGroup.radio2.checked = YES;
    }
    partyAGroup.xmView.field.text = GlobleInstance.jfocrname;
    if (GlobleInstance.jfocrcarno.length == 7)
    {
        NSString *jfRegion = [GlobleInstance.jfocrcarno substringWithRange:NSMakeRange(0, 1)];
        NSString *jfCarNumber = [GlobleInstance.jfocrcarno substringFromIndex:1];
        partyAGroup.selectList.contentLab.text = jfRegion;
        partyAGroup.cphView.field.text = jfCarNumber;
    }
    partyAGroup.jszView.field.text = GlobleInstance.jfocrcardno;
    partyAGroup.cjhView.field.text = GlobleInstance.jfocrvin;

    //填充乙方
    if ([GlobleInstance.yfocrcartype hasPrefix:@"小型"])
    {
        partyBGroup.radio1.checked = YES;
    }
    else
    {
        partyBGroup.radio2.checked = YES;
    }
    partyBGroup.xmView.field.text = GlobleInstance.yfocrname;
    if (GlobleInstance.yfocrcarno.length == 7)
    {
        NSString *yfRegion = [GlobleInstance.yfocrcarno substringWithRange:NSMakeRange(0, 1)];
        NSString *yfCarNumber = [GlobleInstance.yfocrcarno substringFromIndex:1];
        partyBGroup.selectList.contentLab.text = yfRegion;
        partyBGroup.cphView.field.text = yfCarNumber;
    }
    partyBGroup.jszView.field.text = GlobleInstance.yfocrcardno;
    partyBGroup.cjhView.field.text = GlobleInstance.yfocrvin;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //甲方车牌号
    if (textField == partyAGroup.cphView.field)
    {
        textField.text = [textField.text uppercaseString];
        jfcarno = [NSString stringWithFormat:@"%@%@", partyAGroup.selectList.contentLab.text, partyAGroup.cphView.field.text];
    }
    //甲方车架号
    if (textField == partyAGroup.cjhView.field)
    {
        jfframeno = textField.text;
    }
    //乙方车牌号
    if (textField == partyBGroup.cphView.field)
    {
        textField.text = [textField.text uppercaseString];
        yfcarno = [NSString stringWithFormat:@"%@%@", partyBGroup.selectList.contentLab.text, partyBGroup.cphView.field.text];
    }
    //乙方车架号
    if (textField == partyBGroup.cjhView.field)
    {
        yfframeno = textField.text;
    }
}

#pragma mark - 提交按钮点击事件
- (void)confirmBtnClicked
{
    InfoModel *jfModel = [InfoModel new];
    jfModel.carType = partyAGroup.selectedIndex;
    jfModel.name = partyAGroup.xmView.field.text;
    jfModel.carNum = jfcarno;
    jfModel.phoneNum = partyAGroup.lxdhView.field.text;
    jfModel.driveNum = partyAGroup.jszView.field.text;
    jfModel.vinNum = partyAGroup.cjhView.field.text;
    jfModel.bdhNum = partyAGroup.bdhView.field.text;

    InfoModel *yfModel = [InfoModel new];
    yfModel.carType = partyBGroup.selectedIndex;
    yfModel.name = partyBGroup.xmView.field.text;
    yfModel.carNum = yfcarno;
    yfModel.phoneNum = partyBGroup.lxdhView.field.text;
    yfModel.driveNum = partyBGroup.jszView.field.text;
    yfModel.vinNum = partyBGroup.cjhView.field.text;
    yfModel.bdhNum = partyBGroup.bdhView.field.text;

    //甲方Judge
    if (!jfModel.carType)
    {
        SHOWALERT(@"请选择甲方车型");
        return;
    }

    if (jfModel.name.length < 1)
    {
        SHOWALERT(@"请填写甲方姓名");
        return;
    }

    if (![Util cheackLicense:jfModel.carNum])
    {
        SHOWALERT(@"请填写正确的甲方车牌号");
        return;
    }

    if (![Util isMobileNumber:jfModel.phoneNum])
    {
        SHOWALERT(@"请填写正确的甲方联系电话");
        return;
    }

    if (![IDyz validateIDCardNumber:jfModel.driveNum])
    {
        SHOWALERT(@"请填写正确的甲方驾驶证号");
        return;
    }

    if (![Util checkChaimsNO:jfModel.vinNum])
    {
        SHOWALERT(@"请填写正确的甲方车架号");
        return;
    }

    //    if (jfModel.bdhNum.length<1) {
    //        SHOWALERT(@"请填写甲方保单号");
    //        return;
    //    }

    //乙方Judge
    if (!yfModel.carType)
    {
        SHOWALERT(@"请选择乙方车型");
        return;
    }

    if (yfModel.name.length < 1)
    {
        SHOWALERT(@"请填写乙方姓名");
        return;
    }

    if (![Util cheackLicense:yfModel.carNum])
    {
        SHOWALERT(@"请填写正确的乙方车牌号");
        return;
    }

    if (![Util isMobileNumber:yfModel.phoneNum])
    {
        SHOWALERT(@"请填写正确的乙方联系电话");
        return;
    }

    if (![IDyz validateIDCardNumber:yfModel.driveNum])
    {
        SHOWALERT(@"请填写正确的乙方驾驶证号");
        return;
    }

    if (![Util checkChaimsNO:yfModel.vinNum])
    {
        SHOWALERT(@"请填写正确的乙方车架号");
        return;
    }

    //    if (yfModel.bdhNum.length<1) {
    //        SHOWALERT(@"请填写乙方保单号");
    //        return;
    //    }

    if ([jfModel.carNum isEqualToString:yfModel.carNum])
    {
        SHOWALERT(@"甲乙双方车牌号不能相同");
        return;
    }

    if ([jfModel.phoneNum isEqualToString:yfModel.phoneNum])
    {
        SHOWALERT(@"甲乙双方手机号不能相同");
        return;
    }

    if ([jfModel.driveNum isEqualToString:yfModel.driveNum])
    {
        SHOWALERT(@"甲乙双方驾驶证号不能相同");
        return;
    }

    if ([jfModel.vinNum isEqualToString:yfModel.vinNum])
    {
        SHOWALERT(@"甲乙双方车架号不能相同");
        return;
    }

    if ([jfModel.bdhNum isEqualToString:yfModel.bdhNum])
    {
        if (jfModel.bdhNum.length > 1 && yfModel.bdhNum.length > 1)
        {
            SHOWALERT(@"甲乙双方保单号不能相同");
            return;
        }
    }

    ZRRDViewController *vc = [ZRRDViewController new];
    vc.jfModel = jfModel;
    vc.yfModel = yfModel;
    vc.selectedItem = _selectedItem;
    vc.caseDes = _caseDes;
    [self.navigationController pushViewController:vc animated:YES];

    //    NSMutableDictionary *bean = [NSMutableDictionary dictionary];
    //
    //    NSArray *arr = @[@{@"carownname":jfModel.name,
    //                       @"carownphone":jfModel.phoneNum,
    //                       @"casecarno":jfModel.carNum,
    //                       @"cartype":jfModel.carType,
    //                       @"frameno":jfModel.vinNum,
    //                       @"cardno":jfModel.driveNum,
    //                       @"driverfileno":jfModel.recordNum,
    //                       @"driverlicence":jfModel.driveNum,
    //                       @"party":@"1"},
    //                     @{@"carownname":yfModel.name,
    //                       @"carownphone":yfModel.phoneNum,
    //                       @"casecarno":yfModel.carNum,
    //                       @"cartype":yfModel.carType,
    //                       @"frameno":yfModel.vinNum,
    //                       @"cardno":yfModel.driveNum,
    //                       @"driverfileno":yfModel.recordNum,
    //                       @"driverlicence":yfModel.driveNum,
    //                       @"party":@"0"}];

    //    NSString *appcaseno = GlobleInstance.appcaseno;

    //    [bean setValue:arr forKey:@"casecarlist"];
    //    [bean setValue:appcaseno forKey:@"appcaseno"];
    //
    //    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //
    //    [LSHttpManager requestUrl:HNServiceURL serviceName:@"jjappcheckcbxx" parameters:bean complete:^(id result, ResultType resultType) {
    //
    //        [hud hide:YES];
    //
    //        if (result) {
    //            NSLog(@"YZ ~ %@",[Util objectToJson:result]);
    //        }
    //
    //        if ([result[@"restate"] isEqualToString:@"1"]) {
    //            ZRRDViewController *vc = [ZRRDViewController new];
    //            vc.jfModel = jfModel;
    //            vc.yfModel = yfModel;
    //            vc.selectedItem = _selectedItem;
    //            vc.caseDes = _caseDes;
    //            [self.navigationController pushViewController:vc animated:YES];
    //        }
    //
    //        else {
    //            SHOWALERT(result[@"redes"]);
    //        }
    //
    //    }];
}

@end
