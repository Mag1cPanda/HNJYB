//
//  ZRRDViewController.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/3.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "DESCript.h"
#import "JCAlertView.h"
#import "JFCreateProtocolVC.h"
#import "RemoteDutyViewController.h"
#import "SRBlockButton.h"
#import "ZRRDGroup.h"
#import "ZRRDViewController.h"

@interface ZRRDViewController ()
{
    UIScrollView *scroll;
    JCAlertView *jcAlert;
    JCAlertView *endAlert;

    NSMutableDictionary *bean;

    NSString *jfDutyType;
    NSString *yfDutyType;

    BOOL isArgue;
}
@property (nonatomic, strong) ZRRDGroup *partyAGroup;
@property (nonatomic, strong) ZRRDGroup *partyBGroup;
@end

@implementation ZRRDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"责任认定";
    bean = [NSMutableDictionary dictionary];
    NSString *appcaseno = GlobleInstance.appcaseno;
    [bean setValue:appcaseno forKey:@"appcaseno"];

    NSString *imagelon = [NSString stringWithFormat:@"%f", GlobleInstance.imagelon];
    NSString *imagelat = [NSString stringWithFormat:@"%f", GlobleInstance.imagelat];
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
    NSLog(@"%@", currentDateStr);
    [bean setValue:currentDateStr forKey:@"alarmtime"];
    [bean setValue:GlobleInstance.areaid forKey:@"areaid"];

    [bean setValue:GlobleInstance.userflag forKey:@"username"];
    NSString *pwd = [UserDefaultsUtil getDataForKey:@"password"];
    pwd = [DESCript encrypt:pwd encryptOrDecrypt:kCCEncrypt key:[Util getKey]];
    [bean setValue:pwd forKey:@"password"];

    NSLog(@"事故形态 -> %@", _selectedItem);

    NSMutableArray *selectArr = [NSMutableArray array];
    for (int i = 0; i < _selectedItem.count; i++)
    {
        NSString *str = _selectedItem[i];
        if ([str isEqualToString:@"1"])
        {
            [selectArr addObject:[NSString stringWithFormat:@"%d", i + 1]];
        }
    }
    NSString *accidenttype = [selectArr componentsJoinedByString:@","];
    NSLog(@"accidenttype -> %@", accidenttype);
    NSString *token = [NSString stringWithFormat:@"%@", GlobleInstance.token];
    [bean setValue:token forKey:@"token"];
    [bean setValue:accidenttype forKey:@"accidenttype"];

    if (!_caseDes)
    {
        _caseDes = @"";
    }

    [bean setValue:_caseDes forKey:@"accidentdes"];

    [self initScroll];

    //如果为历史案件Push，则加载历史案件数据
    if (_isHistoryPush)
    {
        self.jfModel = [[InfoModel alloc] init];
        self.yfModel = [[InfoModel alloc] init];
        [self loadHistoryData];
    }
}

- (void)initScroll
{
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    [self.view addSubview:scroll];

    scroll.contentSize = CGSizeMake(ScreenWidth, 880);

    __unsafe_unretained typeof(self) weakSelf = self;
    _partyAGroup = [[ZRRDGroup alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 360) groupId:@"partyAGroup"];
    _partyAGroup.title = @"甲方驾驶人及车辆信息";
    _partyAGroup.xmView.contentLab.text = _jfModel.name;
    _partyAGroup.cphView.contentLab.text = _jfModel.carNum;
    _partyAGroup.lxdhView.contentLab.text = _jfModel.phoneNum;
    _partyAGroup.block = ^(NSInteger index) {
      if (index == 0)
      {
          weakSelf.partyBGroup.radio2.checked = YES;
      }
      if (index == 1)
      {
          weakSelf.partyBGroup.radio1.checked = YES;
      }
      if (index == 2)
      {
          weakSelf.partyBGroup.radio3.checked = YES;
      }
      if (index == 3)
      {
          weakSelf.partyBGroup.radio5.checked = YES;
      }
      if (index == 4)
      {
          weakSelf.partyBGroup.radio4.checked = YES;
      }
    };
    [scroll addSubview:_partyAGroup];

    _partyBGroup = [[ZRRDGroup alloc] initWithFrame:CGRectMake(0, _partyAGroup.maxY, ScreenWidth, 360) groupId:@"partyBGroup"];
    _partyBGroup.title = @"乙方驾驶人及车辆信息";
    _partyBGroup.xmView.contentLab.text = _yfModel.name;
    _partyBGroup.cphView.contentLab.text = _yfModel.carNum;
    _partyBGroup.lxdhView.contentLab.text = _yfModel.phoneNum;
    _partyBGroup.block = ^(NSInteger index) {
      if (index == 0)
      {
          weakSelf.partyAGroup.radio2.checked = YES;
      }
      if (index == 1)
      {
          weakSelf.partyAGroup.radio1.checked = YES;
      }
      if (index == 2)
      {
          weakSelf.partyAGroup.radio3.checked = YES;
      }
      if (index == 3)
      {
          weakSelf.partyAGroup.radio5.checked = YES;
      }
      if (index == 4)
      {
          weakSelf.partyAGroup.radio4.checked = YES;
      }

    };
    [scroll addSubview:_partyBGroup];

    UIButton *noArgueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    noArgueBtn.frame = CGRectMake(10, _partyBGroup.maxY + 25, ScreenWidth - 20, 50);
    [noArgueBtn setTitle:@"无争议" forState:0];
    [noArgueBtn setTitleColor:[UIColor whiteColor] forState:0];
    [noArgueBtn addTarget:self action:@selector(confirmBtnClicked) forControlEvents:1 << 6];
    noArgueBtn.backgroundColor = HNBlue;
    noArgueBtn.layer.cornerRadius = 5;
    //    [scroll addSubview:noArgueBtn];

    UIButton *argueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    argueBtn.frame = CGRectMake(10, noArgueBtn.maxY + 10, ScreenWidth - 20, 50);
    if (GlobleInstance.userType == TrafficPolice)
    {
        //交警
        [argueBtn setTitle:@"现场定责" forState:0];
    }
    else
    {
        //协警
        [argueBtn setTitle:@"远程定责" forState:0];
    }
    [argueBtn setTitleColor:[UIColor whiteColor] forState:0];
    [argueBtn addTarget:self action:@selector(argueBtnClicked) forControlEvents:1 << 6];
    argueBtn.backgroundColor = HNBlue;
    argueBtn.layer.cornerRadius = 5;
    [scroll addSubview:argueBtn];
}

#pragma mark - 加载数据(继续处理)
- (void)loadHistoryData
{
    NSMutableDictionary *historyBean = [NSMutableDictionary dictionary];
    [historyBean setValue:GlobleInstance.token forKey:@"token"];
    [historyBean setValue:GlobleInstance.userflag forKey:@"username"];
    [historyBean setValue:_casenumber forKey:@"casenumber"];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [LSHttpManager requestUrl:HNServiceURL serviceName:@"kckpjjAccidentDetails" parameters:historyBean complete:^(id result, ResultType resultType) {

      [hud hide:YES];
      if ([result[@"restate"] isEqualToString:@"1"])
      {
          NSLog(@"History -> %@", JsonResult);
          NSDictionary *data = result[@"data"];
          GlobleInstance.casehaptime = data[@"casehaptime"];
          NSArray *casecarlist = data[@"casecarlist"];
          NSDictionary *jfDic = casecarlist[0];
          NSDictionary *yfDic = casecarlist[1];

          self.jfModel.name = jfDic[@"carownname"];
          self.jfModel.phoneNum = jfDic[@"carownphone"];
          self.jfModel.carNum = jfDic[@"casecarno"];

          self.yfModel.name = yfDic[@"carownname"];
          self.yfModel.phoneNum = yfDic[@"carownphone"];
          self.yfModel.carNum = yfDic[@"casecarno"];

          _partyAGroup.xmView.contentLab.text = _jfModel.name;
          _partyAGroup.cphView.contentLab.text = _jfModel.carNum;
          _partyAGroup.lxdhView.contentLab.text = _jfModel.phoneNum;

          _partyBGroup.xmView.contentLab.text = _yfModel.name;
          _partyBGroup.cphView.contentLab.text = _yfModel.carNum;
          _partyBGroup.lxdhView.contentLab.text = _yfModel.phoneNum;
      }

    }];
}

#pragma mark - 有争议
- (void)argueBtnClicked
{
    isArgue = YES;
    if (!_partyAGroup.selectedIndex && GlobleInstance.userType == TrafficPolice)
    {
        SHOWALERT(@"请选择责任类型");
        return;
    }

    if (GlobleInstance.userType == TrafficPolice)
    {
        //交警 -> 现场定责
        [bean setValue:@"3" forKey:@"disposetype"];
    }
    else
    {
        //协警 -> 远程定责
        _partyAGroup.selectedIndex = @""; //设为空字符串，避免为nil导致闪退
        _partyBGroup.selectedIndex = @""; //同上
        [bean setValue:@"2" forKey:@"disposetype"];
    }
    [self showAlertView];
}

#pragma mark - 无争议
- (void)confirmBtnClicked
{
    isArgue = NO;
    //交警账号没有选择责任类型时提示用户
    if (!_partyAGroup.selectedIndex)
    {
        SHOWALERT(@"请选择责任类型");
        return;
    }
    [bean setValue:@"1" forKey:@"disposetype"];
    [self showAlertView];
}

- (void)showAlertView
{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 60, 200)];
    customView.backgroundColor = [UIColor whiteColor];
    customView.layer.cornerRadius = 5;
    customView.clipsToBounds = YES;

    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(customView.width / 2 - 30, 20, 60, 60)];
    icon.image = [UIImage imageNamed:@"IP030"];
    [customView addSubview:icon];

    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, icon.maxY + 20, customView.width, 20)];
    lab.font = HNFont(14);
    lab.text = @"确认提交吗？";
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

    SRBlockButton *confirmBtn = [[SRBlockButton alloc] initWithFrame:CGRectMake(0, lab.maxY + 21, customView.width / 2, 60) title:@"确认" titleColor:color handleBlock:^(SRBlockButton *btn) {

      [jcAlert dismissWithCompletion:^{

        [bean setValue:_yfModel.carNum forKey:@"casecarno"];
        [bean setValue:_yfModel.phoneNum forKey:@"appphone"];

        NSArray *arr = @[ @{ @"carownname" : _jfModel.name,
                             @"carownphone" : _jfModel.phoneNum,
                             @"casecarno" : _jfModel.carNum,
                             @"cartype" : _jfModel.carType,
                             @"frameno" : _jfModel.vinNum,
                             @"cardno" : _jfModel.driveNum,
//                             @"driverfileno":_jfModel.recordNum,
                             @"policyno" : _jfModel.bdhNum,
                             @"driverlicence" : _jfModel.driveNum,
                             @"dutytype" : _partyAGroup.selectedIndex,
                             @"party" : @"1" },
                          @{ @"carownname" : _yfModel.name,
                             @"carownphone" : _yfModel.phoneNum,
                             @"casecarno" : _yfModel.carNum,
                             @"cartype" : _yfModel.carType,
                             @"frameno" : _yfModel.vinNum,
                             @"cardno" : _yfModel.driveNum,
//                             @"driverfileno":_yfModel.recordNum,
                             @"policyno" : _yfModel.bdhNum,
                             @"driverlicence" : _yfModel.driveNum,
                             @"dutytype" : _partyBGroup.selectedIndex,
                             @"party" : @"0" } ];

        [bean setValue:arr forKey:@"casecarlist"];

        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [LSHttpManager requestUrl:HNServiceURL serviceName:@"jjappsubmitCaseInfor" parameters:bean complete:^(id result, ResultType resultType) {

          [hud hide:YES];
          if (result)
          {
              NSLog(@"%@", JsonResult);
          }

          if ([result[@"restate"] isEqualToString:@"1"])
          {
              //协警
              if (GlobleInstance.userType == AuxiliaryPolice)
              {
                  if (isArgue)
                  {
                      //有争议 -> 远程定责
                      RemoteDutyViewController *vc = [RemoteDutyViewController new];
                      GlobleInstance.jfModel = _jfModel;
                      GlobleInstance.yfModel = _yfModel;
                      [self.navigationController pushViewController:vc animated:YES];
                  }
                  else
                  {
                      //无争议 -> 生成协议书
                      JFCreateProtocolVC *vc = [JFCreateProtocolVC new];
                      vc.jfModel = _jfModel;
                      vc.yfModel = _yfModel;
                      vc.jfDutyType = _partyAGroup.selectedIndex;
                      vc.yfDutyType = _partyBGroup.selectedIndex;
                      [self.navigationController pushViewController:vc animated:YES];
                  }
              }

              //交警
              else
              {
                  JFCreateProtocolVC *vc = [JFCreateProtocolVC new];
                  vc.jfModel = _jfModel;
                  vc.yfModel = _yfModel;
                  vc.jfDutyType = _partyAGroup.selectedIndex;
                  vc.yfDutyType = _partyBGroup.selectedIndex;
                  [self.navigationController pushViewController:vc animated:YES];
              }
          }

          else
          {
              SHOWALERT(result[@"redes"]);
          }

        }];

      }];

    }];
    [customView addSubview:confirmBtn];

    SRBlockButton *cancelBtn = [[SRBlockButton alloc] initWithFrame:CGRectMake(confirmBtn.maxX + 1, lab.maxY + 21, customView.width / 2, 60) title:@"返回" titleColor:color handleBlock:^(SRBlockButton *btn) {

      [jcAlert dismissWithCompletion:^{

      }];

    }];
    [customView addSubview:cancelBtn];

    jcAlert = [[JCAlertView alloc] initWithCustomView:customView dismissWhenTouchedBackground:YES];
    [jcAlert show];
}

@end
