//
//  SituationView.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/7/29.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "SituationView.h"

@implementation SituationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.layer.cornerRadius = 5;

        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, self.height - 20, self.height - 20)];
        [self addSubview:_icon];

        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(_icon.maxX + 10, 20, self.width - _icon.maxX - 20, 60)];
        _titleLab.textColor = [UIColor darkGrayColor];
        _titleLab.numberOfLines = 0;
        _titleLab.font = HNFont(14);
        [self addSubview:_titleLab];
    }
    return self;
}

@end
