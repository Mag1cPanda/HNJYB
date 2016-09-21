//
//  CaseDetailViewController.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/9.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "CaseDetailViewController.h"
#import "CaseDetailCell.h"
#import "PartyBCaseInfoVC.h"
#import "ConfirmDutyPhotoVC.h"
#import "CaseDetailModel.h"

@interface CaseDetailViewController ()
<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table;
    CaseDetailModel *model;
    
    NSDictionary *dataDic;
    NSArray *casecarlist;
}
@end

@implementation CaseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"事故详细信息";
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    table.backgroundColor = RGB(250, 250, 250);
    table.tableFooterView = [UIView new];
//    table.delegate = self;
//    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    
    [table registerNib:[UINib nibWithNibName:@"CaseDetailCell" bundle:nil] forCellReuseIdentifier:@"CaseDetailCell"];
    
    [self loadData];
}

-(void)loadData{
    NSMutableDictionary *bean = [NSMutableDictionary dictionary];
    [bean setValue:_casenumber forKey:@"casenumber"];
    [bean setValue:GlobleInstance.policeno forKey:@"policeno"];
    [bean setValue:GlobleInstance.token forKey:@"token"];
    [bean setValue:GlobleInstance.userflag forKey:@"username"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [LSHttpManager requestUrl:HNServiceURL serviceName:@"kckpjjAccidentDetails" parameters:bean complete:^(id result, ResultType resultType) {
        
        [hud hide:YES];
        
        if (result) {
            NSLog(@"案件详情 -> %@",JsonResult);
        }
        
        if ([result[@"restate"] isEqualToString:@"1"]) {
            dataDic = result[@"data"];
            casecarlist = dataDic[@"casecarlist"];
            table.delegate = self;
            table.dataSource = self;
            [table reloadData];
        }
        
    }];
}

#pragma mark - tableView Delegate & DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (casecarlist.count == 2) {
        return 4;
    }
    else {
        return 3;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CaseDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CaseDetailCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (dataDic) {
            cell.dataDic = dataDic;
        }
        
        if ([_caseState isEqualToString:@"9"]) {
            cell.caseState.text = @"案件信息未上传";
        }
        
        if ([_caseState isEqualToString:@"10"]) {
            cell.caseState.text = @"未生成协议书";
        }
        
        if ([_caseState isEqualToString:@"5"]) {
            cell.caseState.text = @"完成";
        }
        
        return cell;
    }
    
    else{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = HNBlue;
        
        if (casecarlist.count == 2) {
            if (indexPath.section == 1) {
                cell.textLabel.text = @"甲方事故信息";
            }
            if (indexPath.section == 2) {
                cell.textLabel.text = @"乙方事故信息";
            }
            if (indexPath.section == 3) {
                cell.textLabel.text = @"定责照片";
            }
        }
        else {
            if (indexPath.section == 1) {
                cell.textLabel.text = @"车主事故信息";
            }
            if (indexPath.section == 2) {
                cell.textLabel.text = @"定责照片";
            }
        }
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 175;
    }
    
    else {
        return 44;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        //案件信息
    }
    
    else {
        //双车
        if (casecarlist.count == 2) {
            //甲方
            if (indexPath.section == 1) {
                PartyBCaseInfoVC *vc = [PartyBCaseInfoVC new];
                vc.partyBDic = dataDic[@"casecarlist"][0];
                vc.titleStr = @"甲方事故信息";
                [self.navigationController pushViewController:vc animated:YES];
            }
            //乙方
            if (indexPath.section == 2) {
                PartyBCaseInfoVC *vc = [PartyBCaseInfoVC new];
                vc.partyBDic = dataDic[@"casecarlist"][1];
                vc.titleStr = @"乙方事故信息";
                [self.navigationController pushViewController:vc animated:YES];
            }
            //定责照片
            if (indexPath.section == 3) {
                [self photoCellSelectAction];
            }
        }
        //单车
        else {
            //车主
            if (indexPath.section == 1) {
                PartyBCaseInfoVC *vc = [PartyBCaseInfoVC new];
                vc.partyBDic = dataDic[@"casecarlist"][0];
                vc.titleStr = @"车主事故信息";
                [self.navigationController pushViewController:vc animated:YES];
            }
            //定责照片
            if (indexPath.section == 2) {
                [self photoCellSelectAction];
            }
        }
    }
}

-(void)photoCellSelectAction{
    if (!dataDic[@"accidentimagelist"]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"暂无照片信息";
        [hud hide:YES afterDelay:1];
    }
    else{
        ConfirmDutyPhotoVC *vc = [ConfirmDutyPhotoVC new];
        vc.imgArr = dataDic[@"accidentimagelist"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
