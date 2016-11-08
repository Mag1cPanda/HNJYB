//
//  MoreSGSCGroup.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/2.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "Masonry.h"
#import "MoreSGSCGroup.h"

@implementation MoreSGSCGroup
- (instancetype)initWithFrame:(CGRect)frame groupId:(NSString *)groupId
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGFloat viewWidth = ScreenWidth - 20;
        CGFloat viewHeight = 60;

        SGSCView *titleView = [[SGSCView alloc] initWithFrame:CGRectMake(10, 20, viewWidth, viewHeight)];
        titleView.titleLab.hidden = YES;
        titleView.field.hidden = YES;
        [self addSubview:titleView];

        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
        _titleLab.textColor = HNBlue;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [titleView addSubview:_titleLab];

        //----------车型--------------
        SGSCView *cxView = [[SGSCView alloc] initWithFrame:CGRectMake(10, titleView.maxY + 10, viewWidth, viewHeight)];
        cxView.titleLab.text = @"车型:";
        cxView.field.hidden = YES;
        [self addSubview:cxView];

        CGFloat btnWidth = 20;
        CGFloat btnHeight = 20;
        CGFloat btnY = 20;

        _radio1 = [[QRadioButton alloc] initWithDelegate:self groupId:groupId];
        _radio1.frame = CGRectMake(100, btnY, btnWidth, btnHeight);
        [cxView addSubview:_radio1];
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(_radio1.maxX, btnY, 80, btnHeight)];
        lab1.text = @"小型汽车";
        lab1.font = HNFont(15);
        [cxView addSubview:lab1];

        _radio2 = [[QRadioButton alloc] initWithDelegate:self groupId:groupId];
        _radio2.frame = CGRectMake(lab1.maxX, btnY, btnWidth, btnHeight);
        [cxView addSubview:_radio2];
        UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(_radio2.maxX, btnY, 80, btnHeight)];
        lab2.text = @"大型汽车";
        lab2.font = HNFont(15);
        [cxView addSubview:lab2];

        //----------姓名--------------
        _xmView = [[SGSCView alloc] initWithFrame:CGRectMake(10, cxView.maxY + 10, viewWidth, viewHeight)];
        _xmView.titleLab.text = @"姓名:";
        _xmView.field.placeholder = @"请输入姓名";
        [self addSubview:_xmView];

        //----------车牌号--------------
        _cphView = [[SGSCView alloc] initWithFrame:CGRectMake(10, _xmView.maxY + 10, viewWidth, viewHeight)];
        _cphView.titleLab.text = @"车牌号:";
        _cphView.field.placeholder = @"请输入车牌号";
        _cphView.field.frame = CGRectMake(_cphView.field.x + 50, _cphView.field.y, _cphView.field.width - 50, _cphView.field.height);
        [self addSubview:_cphView];

        _selectList = [[SRSelectListView alloc] initWithFrame:CGRectMake(100, 0, 50, _cphView.height)];
        _selectList.currentView = self;
        _selectList.delegate = self;
        _selectList.font = HNFont(14);
        _selectList.dropWidth = 100;
        _selectList.title = @"豫";
        _selectList.changeTitle = YES;
        _selectList.iconName = @"mark1";
        _selectList.showCheckMark = NO;
        _selectList.dataArray = @[ @"豫", @"京", @"津", @"沪", @"渝", @"冀", @"云", @"辽", @"黑", @"湘", @"皖", @"鲁", @"新", @"苏", @"浙", @"赣", @"鄂", @"桂", @"甘", @"晋", @"蒙", @"陕", @"吉", @"闽", @"贵", @"粤", @"青", @"藏", @"川", @"宁", @"琼" ];
        [_cphView addSubview:_selectList];

        //----------联系电话--------------
        _lxdhView = [[SGSCView alloc] initWithFrame:CGRectMake(10, _cphView.maxY + 10, viewWidth, viewHeight)];
        _lxdhView.titleLab.text = @"联系电话:";
        _lxdhView.field.placeholder = @"请输入联系电话";
        [self addSubview:_lxdhView];

        //----------驾驶证号--------------
        _jszView = [[SGSCView alloc] initWithFrame:CGRectMake(10, _lxdhView.maxY + 10, viewWidth, viewHeight)];
        _jszView.titleLab.text = @"驾驶证号:";
        _jszView.field.placeholder = @"请输入驾驶证号";
        [self addSubview:_jszView];

        //----------车架号--------------
        _cjhView = [[SGSCView alloc] initWithFrame:CGRectMake(10, _jszView.maxY + 10, viewWidth, viewHeight)];
        _cjhView.titleLab.text = @"车架号:";
        _cjhView.field.placeholder = @"请输入车架号";
        [self addSubview:_cjhView];

        //----------保单号--------------
        _bdhView = [[SGSCView alloc] initWithFrame:CGRectMake(10, _cjhView.maxY + 10, viewWidth, viewHeight)];
        _bdhView.titleLab.text = @"保单号:";
        _bdhView.field.placeholder = @"请获取保单号(选填)";
        _bdhView.field.width =  _bdhView.field.width-70;
        
        [self addSubview:_bdhView];

        _codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _codeBtn.frame = CGRectMake(_bdhView.width - 70, _bdhView.height / 2 - 15, 60, 30);
        _codeBtn.titleLabel.font = HNFont(13);
        [_codeBtn setTitle:@"获取" forState:0];
        [_codeBtn setTitleColor:HNGreen forState:0];
        [_bdhView addSubview:_codeBtn];

        //        _daView = [[SGSCView alloc] initWithFrame:CGRectMake(10, _cjhView.maxY+10, viewWidth, viewHeight)];
        //        _daView.titleLab.text = @"档案编号:";
        //        _daView.field.placeholder = @"请输入档案编号";
        //        [self addSubview:_daView];
    }
    return self;
}

- (void)selectListView:(SRSelectListView *)selectListView index:(NSInteger)index content:(NSString *)content
{
}

#pragma mark - QRadioButtonDelegate
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId
{
    if (radio == _radio1)
    {
        self.selectedIndex = @"1";
        self.carType = @"小型汽车";
    }
    else
    {
        self.selectedIndex = @"2";
        self.carType = @"大型汽车";
    }

    NSLog(@"_selectedIndex:%@ _evaluate:%@", _selectedIndex, _carType);
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLab.text = title;
}

@end
