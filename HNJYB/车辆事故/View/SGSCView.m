//
//  SGSCView.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/2.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "SGSCView.h"

@implementation SGSCView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1;
        self.layer.borderColor = HNBoardColor;
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 80, 20)];
        _titleLab.font = HNFont(16);
        [self addSubview:_titleLab];
        _field = [[UITextField alloc] initWithFrame:CGRectMake(_titleLab.maxX+10, 10, self.width-_titleLab.maxX-20, 40)];
        _field.font = HNFont(16);
        [self addSubview:_field];
        
    }
    return self;
}
@end
