//
//  JFCreateProtocolVC.h
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/2.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "CaseBaseViewController.h"
#import "InfoModel.h"

@interface JFCreateProtocolVC : CaseBaseViewController
@property (nonatomic, strong) InfoModel *jfModel;
@property (nonatomic, strong) InfoModel *yfModel;

@property (nonatomic, copy) NSString *jfDutyType;
@property (nonatomic, copy) NSString *yfDutyType;

@property (nonatomic, assign) BOOL isHistoryPush;
@property (nonatomic, copy) NSString *casenumber;//用来查询历史案件信息

@property (nonatomic, copy) NSString *titleStr;
@end
