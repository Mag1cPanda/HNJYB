//
//  PartyBCaseInfoVC.h
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/9.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "PublicViewController.h"

@interface PartyBCaseInfoVC : PublicViewController
@property (weak, nonatomic) IBOutlet UILabel *carNo;
@property (weak, nonatomic) IBOutlet UILabel *carUser;
@property (weak, nonatomic) IBOutlet UILabel *phoneNum;
@property (weak, nonatomic) IBOutlet UILabel *dutyState;

@property (nonatomic, copy) NSString *titleStr;

@property (nonatomic, strong) NSDictionary *partyBDic;
@end
