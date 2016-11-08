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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.titleStr;
    self.carNo.text = _partyBDic[@"casecarno"];
    self.carUser.text = _partyBDic[@"carownname"];
    self.phoneNum.text = _partyBDic[@"carownphone"];

    NSString *dutyState = _partyBDic[@"dutytype"];
    NSLog(@"dutyState -> %@", dutyState);

    if ([dutyState isEqualToString:@"0"])
    {
        self.dutyState.text = @"全责";
    }

    else if ([dutyState isEqualToString:@"1"])
    {
        self.dutyState.text = @"无责";
    }

    else if ([dutyState isEqualToString:@"2"])
    {
        self.dutyState.text = @"同责";
    }

    else if ([dutyState isEqualToString:@"3"])
    {
        self.dutyState.text = @"主责";
    }

    else if ([dutyState isEqualToString:@"4"])
    {
        self.dutyState.text = @"次责";
    }

    else
    {
        self.dutyState.text = @"未知";
    }

    //单车事故责任状态全部为全责
    if ([self.titleStr isEqualToString:@"车主事故信息"])
    {
        self.dutyState.text = @"全责";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
