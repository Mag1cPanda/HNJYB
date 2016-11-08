//
//  HNButton.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/3.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "HNButton.h"

@implementation HNButton

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = (HNButton *)[UIButton buttonWithType:UIButtonTypeCustom];
    if (self)
    {
        self.frame = frame;
        self.backgroundColor = HNBlue;
        [self setTitleColor:[UIColor whiteColor] forState:0];
        [self setTitle:title forState:0];
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title handleBlock:(HNClickedHandle)block
{
    self = (HNButton *)[UIButton buttonWithType:UIButtonTypeCustom];
    self.block = block;
    self.frame = frame;
    self.backgroundColor = HNBlue;
    [self addTarget:self action:@selector(buttonClicked:) forControlEvents:1 << 6];
    [self setTitleColor:[UIColor whiteColor] forState:0];
    [self setTitle:title forState:0];
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    return self;
}

- (void)buttonClicked:(HNButton *)btn
{
    if (_block)
    {
        _block(btn);
    }
}

@end
