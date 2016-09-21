//
//  FieldBack.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/1.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "FieldBack.h"

@implementation FieldBack

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.layer.cornerRadius = 5;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 0.5;
    }
    return self;
}

@end
