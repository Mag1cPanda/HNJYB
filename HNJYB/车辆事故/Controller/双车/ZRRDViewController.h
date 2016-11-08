//
//  ZRRDViewController.h
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/3.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "CaseBaseViewController.h"
#import "InfoModel.h"

@interface ZRRDViewController : CaseBaseViewController

@property (nonatomic, strong) InfoModel *jfModel;
@property (nonatomic, strong) InfoModel *yfModel;

@property (nonatomic, assign) BOOL isHistoryPush;
@property (nonatomic, copy) NSString *casenumber;

@property (nonatomic, strong) NSArray *selectedItem;
@property (nonatomic, copy) NSString *caseDes;
@end
