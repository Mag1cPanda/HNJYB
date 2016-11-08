//
//  AccidentHeader.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/7/29.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "AccidentHeader.h"
#import "UIView+Frame.h"

@implementation AccidentHeader

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blue"]];

    _icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, self.height - 20, self.height - 20)];
    _icon.image = [UIImage imageNamed:@"IP013"];
    [self addSubview:_icon];

    _topLab = [[UILabel alloc] initWithFrame:CGRectMake(_icon.maxX + 10, self.height / 2 - 20, ScreenWidth - _icon.maxX - 20, 20)];
    _topLab.textColor = [UIColor whiteColor];
    _topLab.text = @"请您在保证自身安全的情况下拍摄";
    _topLab.textAlignment = NSTextAlignmentCenter;
    _topLab.layer.cornerRadius = 10;
    _topLab.layer.borderColor = [UIColor whiteColor].CGColor;
    _topLab.layer.borderWidth = 1.0;
    _topLab.font = [UIFont systemFontOfSize:13];
    [self addSubview:_topLab];

    _bottemLab = [[UILabel alloc] initWithFrame:CGRectMake(_icon.maxX + 10, self.height / 2 + 10, ScreenWidth - _icon.maxX - 20, 20)];
    _bottemLab.textColor = [UIColor whiteColor];
    _bottemLab.textAlignment = NSTextAlignmentCenter;
    _bottemLab.text = @"点击相机图标，模仿样图拍照";
    _bottemLab.font = [UIFont systemFontOfSize:15];
    [self addSubview:_bottemLab];
}

@end
