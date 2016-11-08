//
//  Globle.m
//  TBRJL
//
//  Created by 程三 on 15/6/13.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "Globle.h"
#import "AppDelegate.h"


@implementation Globle

+(Globle *)getInstance
{
    static Globle *globle;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        globle = [[self alloc] init];
    });
    
    return globle;
}

@end
