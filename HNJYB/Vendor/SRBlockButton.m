//
//  SRBlockButton.m
//  动态行高&图文混排
//
//  Created by Mag1cPanda on 16/5/10.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "SRBlockButton.h"

@implementation SRBlockButton

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(clickAction) forControlEvents:1 << 6];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
                       title:(NSString *)title
                  titleColor:(UIColor *)color
                 handleBlock:(ButtonClicked)block
{
//    self = (SRBlockButton *)[UIButton buttonWithType:UIButtonTypeCustom];
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:title forState:0];
        [self setTitleColor:color forState:0];
        _block = block;
        [self addTarget:self action:@selector(clickAction) forControlEvents:1 << 6];
    }
    return self;
}

-(void)clickAction{
    if (_block) {
        _block(self);
    }
}

@end
