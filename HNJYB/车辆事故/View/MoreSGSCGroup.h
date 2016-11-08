//
//  MoreSGSCGroup.h
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/2.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGSCView.h"
#import "SRSelectListView.h"
#import "QRadioButton.h"

@interface MoreSGSCGroup : UIView<SRSelectListViewDelegate>

@property (nonatomic, strong) QRadioButton *radio1;
@property (nonatomic, strong) QRadioButton *radio2;
@property (nonatomic, strong) SGSCView *xmView;
@property (nonatomic, strong) SGSCView *cphView;
@property (nonatomic, strong) SGSCView *lxdhView;
@property (nonatomic, strong) SGSCView *jszView;
@property (nonatomic, strong) SGSCView *cjhView;
//@property (nonatomic, strong) SGSCView *daView;
@property (nonatomic, strong) SGSCView *bdhView;
@property (nonatomic, strong) SRSelectListView *selectList;

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *groupId;

@property (nonatomic, copy) NSString *carType;
@property (nonatomic, copy) NSString *carNo;
@property (nonatomic, copy) NSString *selectedIndex;

@property (nonatomic, strong) UIButton *codeBtn;

-(instancetype)initWithFrame:(CGRect)frame groupId:(NSString *)groupId;

@end
