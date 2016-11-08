//
//  HNTextField.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/7/28.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "HNTextField.h"

@implementation HNTextField
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
    self.borderStyle = UITextBorderStyleRoundedRect;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.font = [UIFont systemFontOfSize:14];
}

//控制清除按钮的位置
//-(CGRect)clearButtonRectForBounds:(CGRect)bounds
//{
//    return CGRectMake(bounds.origin.x + bounds.size.width - 50, bounds.origin.y + bounds.size.height -20, 16, 16);
//}

//控制placeHolder的位置，左右缩20

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    //return CGRectInset(bounds, 20, 0);
    CGRect inset = CGRectMake(bounds.origin.x + 50, bounds.origin.y, bounds.size.width - 10, bounds.size.height); //更好理解些
    return inset;
}

//控制显示文本的位置
- (CGRect)textRectForBounds:(CGRect)bounds
{
    //return CGRectInset(bounds, 50, 0);
    CGRect inset = CGRectMake(bounds.origin.x + 50, bounds.origin.y, bounds.size.width - 10, bounds.size.height); //更好理解些
    return inset;
}

//控制编辑文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    //return CGRectInset( bounds, 10 , 0 );

    CGRect inset = CGRectMake(bounds.origin.x + 50, bounds.origin.y, bounds.size.width - 10, bounds.size.height);
    return inset;
}

//控制左视图位置
- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x + 20, bounds.size.height / 2 - 10, 20, 20);
    return inset;
}

@end
