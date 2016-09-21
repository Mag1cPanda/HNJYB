//
//  UIView+CornerRadius.m
//  CZT_IOS_Longrise
//
//  Created by Mag1cPanda on 16/3/1.
//  Copyright © 2016年 程三. All rights reserved.
//

#import "UIView+CornerRadius.h"

@implementation UIView (CornerRadius)
- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0;
}

- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}


@end
