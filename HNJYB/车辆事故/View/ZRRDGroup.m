//
//  XSDZGroup.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/2.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "ZRRDGroup.h"

@implementation ZRRDGroup

- (instancetype)initWithFrame:(CGRect)frame groupId:(NSString *)groupId
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGFloat viewWidth = ScreenWidth - 20;

        ZRRDView *titleView = [[ZRRDView alloc] initWithFrame:CGRectMake(10, 10, viewWidth, 50)];
        titleView.titleLab.hidden = YES;
        titleView.contentLab.hidden = YES;
        [self addSubview:titleView];

        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 50)];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [titleView addSubview:_titleLab];

        _xmView = [[ZRRDView alloc] initWithFrame:CGRectMake(10, titleView.maxY + 10, viewWidth, 50)];
        _xmView.titleLab.text = @"姓名:";
        [self addSubview:_xmView];

        _cphView = [[ZRRDView alloc] initWithFrame:CGRectMake(10, _xmView.maxY + 10, viewWidth, 50)];
        _cphView.titleLab.text = @"车牌号:";
        [self addSubview:_cphView];

        _lxdhView = [[ZRRDView alloc] initWithFrame:CGRectMake(10, _cphView.maxY + 10, viewWidth, 50)];
        _lxdhView.titleLab.text = @"联系电话:";
        [self addSubview:_lxdhView];

        _zrlxView = [[ZRRDView alloc] initWithFrame:CGRectMake(10, _lxdhView.maxY + 10, viewWidth, 100)];
        _zrlxView.titleLab.text = @"责任类型:";
        _zrlxView.contentLab.hidden = YES;

        [self addSubview:_zrlxView];

        CGFloat labWidth = (_zrlxView.width - 110) / 3 - 20;
        CGFloat btnWidth = 20;
        CGFloat btnHeight = 20;
        CGFloat btnY = 20;

        _radio1 = [[QRadioButton alloc] initWithDelegate:self groupId:groupId];
        _radio1.frame = CGRectMake(110, btnY, btnWidth, btnHeight);
        [_zrlxView addSubview:_radio1];
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(_radio1.maxX, btnY, labWidth, btnHeight)];
        lab1.text = @"全责";
        lab1.font = HNFont(14);
        [_zrlxView addSubview:lab1];

        _radio2 = [[QRadioButton alloc] initWithDelegate:self groupId:groupId];
        _radio2.frame = CGRectMake(lab1.maxX, btnY, btnWidth, btnHeight);
        [_zrlxView addSubview:_radio2];
        UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(_radio2.maxX, btnY, labWidth, btnHeight)];
        lab2.text = @"无责";
        lab2.font = HNFont(14);
        [_zrlxView addSubview:lab2];

        _radio3 = [[QRadioButton alloc] initWithDelegate:self groupId:groupId];
        _radio3.frame = CGRectMake(lab2.maxX, btnY, btnWidth, btnHeight);
        [_zrlxView addSubview:_radio3];
        UILabel *lab3 = [[UILabel alloc] initWithFrame:CGRectMake(_radio3.maxX, btnY, labWidth, btnHeight)];
        lab3.text = @"同责";
        lab3.font = HNFont(14);
        [_zrlxView addSubview:lab3];

        _radio4 = [[QRadioButton alloc] initWithDelegate:self groupId:groupId];
        _radio4.frame = CGRectMake(_radio1.x, btnY + 50, btnWidth, btnHeight);
        [_zrlxView addSubview:_radio4];
        UILabel *lab4 = [[UILabel alloc] initWithFrame:CGRectMake(_radio4.maxX, btnY + 50, labWidth, btnHeight)];
        lab4.text = @"主责";
        lab4.font = HNFont(14);
        [_zrlxView addSubview:lab4];

        _radio5 = [[QRadioButton alloc] initWithDelegate:self groupId:groupId];
        _radio5.frame = CGRectMake(lab4.maxX, btnY + 50, btnWidth, btnHeight);
        [_zrlxView addSubview:_radio5];
        UILabel *lab5 = [[UILabel alloc] initWithFrame:CGRectMake(_radio5.maxX, btnY + 50, labWidth, btnHeight)];
        lab5.text = @"次责";
        lab5.font = HNFont(14);
        [_zrlxView addSubview:lab5];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLab.text = title;
}

#pragma mark - QRadioButtonDelegate
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId
{
    if (radio == _radio1)
    {
        _selectedIndex = @"0";
        if (_block)
        {
            _block(0);
        }
    }

    else if (radio == _radio2)
    {
        _selectedIndex = @"1";
        if (_block)
        {
            _block(1);
        }
    }

    else if (radio == _radio3)
    {
        _selectedIndex = @"2";
        if (_block)
        {
            _block(2);
        }
    }

    else if (radio == _radio4)
    {
        _selectedIndex = @"3";
        if (_block)
        {
            _block(3);
        }
    }

    else
    {
        _selectedIndex = @"4";
        if (_block)
        {
            _block(4);
        }
    }

    NSLog(@"%@ selectIndex -> %@", self, _selectedIndex);
}

@end
