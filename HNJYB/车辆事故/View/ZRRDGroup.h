//
//  XSDZGroup.h
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/2.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZRRDView.h"
#import "QRadioButton.h"

typedef void (^SelectHandle)(NSInteger index);

@interface ZRRDGroup : UIView
<QRadioButtonDelegate>

@property (nonatomic, strong) QRadioButton *radio1;
@property (nonatomic, strong) QRadioButton *radio2;
@property (nonatomic, strong) QRadioButton *radio3;
@property (nonatomic, strong) QRadioButton *radio4;
@property (nonatomic, strong) QRadioButton *radio5;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) ZRRDView *xmView;
@property (nonatomic, strong) ZRRDView *cphView;
@property (nonatomic, strong) ZRRDView *lxdhView;
@property (nonatomic, strong) ZRRDView *zrlxView;


@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *groupId;

@property (nonatomic, copy) SelectHandle block;

@property (nonatomic, copy) NSString *selectedIndex;

-(instancetype)initWithFrame:(CGRect)frame groupId:(NSString *)groupId;
@end
