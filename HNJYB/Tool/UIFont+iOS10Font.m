//
//  UIFont+iOS10Font.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/9/21.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "UIFont+iOS10Font.h"
#import <objc/runtime.h>

@implementation UIFont (iOS10Font)

//+(void)load{
//    Method fromMethod = class_getClassMethod([UIFont class], @selector(systemFontOfSize:));
//    Method toMethod = class_getClassMethod([UIFont class], @selector(sr_SystemFontOfSize:));
//    method_exchangeImplementations(fromMethod, toMethod);
//}
//
//+ (UIFont *)sr_SystemFontOfSize:(CGFloat)fontSize{
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0f) {
//        fontSize -= 0.5;
//        return [UIFont systemFontOfSize:fontSize];
//        
//    }else{
//        return [UIFont systemFontOfSize:fontSize];
//    }
//}

@end
