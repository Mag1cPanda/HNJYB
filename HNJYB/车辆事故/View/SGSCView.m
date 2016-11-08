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
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 70, 20)];
        _titleLab.font = [UIFont systemFontOfSize:16];
        [self addSubview:_titleLab];
        _field = [[UITextField alloc] initWithFrame:CGRectMake(_titleLab.maxX+5, 10, self.width-_titleLab.width, 40)];
        _field.font = [UIFont systemFontOfSize:16];
        [self addSubview:_field];
        
    }
    return self;
}
@end
