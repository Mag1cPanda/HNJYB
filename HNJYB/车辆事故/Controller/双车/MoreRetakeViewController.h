//
//  MoreRetakeViewController.h
//  HNJYB
//
//  Created by Mag1cPanda on 2016/10/19.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "CaseBaseViewController.h"

@interface MoreRetakeViewController : CaseBaseViewController
@property (nonatomic, strong) NSArray *qualifiedArr;
@property (nonatomic, strong) NSArray *unQualifiedArr;
@property (nonatomic, assign) BOOL isRetake;
@end
