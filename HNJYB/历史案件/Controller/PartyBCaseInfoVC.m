//
//  PartyBCaseInfoVC.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/9.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "PartyBCaseInfoVC.h"

@interface PartyBCaseInfoVC ()

@end

@implementation PartyBCaseInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.titleStr;
    self.carNo.text = _partyBDic[@"casecarno"];
    self.carUser.text = _partyBDic[@"carownname"];
    self.phoneNum.text = _partyBDic[@"carownphone"];
    
    NSString *dutyState = _partyBDic[@"dutytype"];
    if ([dutyState isEqualToString:@"0"]) {
        dutyState = @"全责";
    }
    
    if ([dutyState isEqualToString:@"1"]) {
        dutyState = @"无责";
    }
    
    if ([dutyState isEqualToString:@"2"]) {
        dutyState = @"同责";
    }
    
    if ([dutyState isEqualToString:@"3"]) {
        dutyState = @"主责";
    }
    
    if ([dutyState isEqualToString:@"4"]) {
        dutyState = @"次责";
    }
    
    self.dutyState.text = dutyState;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
