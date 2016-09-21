//
//  JFCreateProtocolVC.h
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/2.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "PublicViewController.h"
#import "InfoModel.h"

@interface JFCreateProtocolVC : PublicViewController
@property (nonatomic, strong) InfoModel *jfModel;
@property (nonatomic, strong) InfoModel *yfModel;

@property (nonatomic, copy) NSString *jfDutyType;
@property (nonatomic, copy) NSString *yfDutyType;

@property (nonatomic, assign) BOOL isHistoryPush;
@end
