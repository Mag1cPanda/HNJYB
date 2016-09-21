//
//  YFCreateProtocolVC.h
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/2.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "PublicViewController.h"
#include "InfoModel.h"
#import "OwnerModel.h"

@interface YFCreateProtocolVC : PublicViewController
@property (nonatomic, strong) InfoModel *jfModel;
@property (nonatomic, strong) InfoModel *yfModel;

@property (nonatomic, strong) OwnerModel *partyBModel;

@property (nonatomic, copy) NSString *jfDutyType;
@property (nonatomic, copy) NSString *yfDutyType;

@property (nonatomic, copy) NSString *jfJuqian;
@property (nonatomic, copy) NSString *jfImgStr;
@property (nonatomic, copy) NSString *jfCode;
@property (nonatomic, copy) NSString *jfAudioStr;
@end
