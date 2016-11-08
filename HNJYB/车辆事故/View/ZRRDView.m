//
//  XSDZView.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/2.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "ZRRDView.h"

@implementation ZRRDView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1;
        self.layer.borderColor = HNBoardColor;
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, self.height/2-10, 90, 20)];
        _titleLab.textColor = [UIColor darkGrayColor];
        _titleLab.font = HNFont(16);
        [self addSubview:_titleLab];
        
        _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(_titleLab.maxX+10, self.height/2-10, self.width-115, 20)];
        _contentLab.font = HNFont(16);
        _contentLab.textColor = [UIColor lightGrayColor];
        [self addSubview:_contentLab];
        
    }
    return self;
}

@end
