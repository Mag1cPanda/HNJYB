//
//  IDyz.h
//  baobaotong
//
//  Created by likang on 16/1/18.
//  Copyright © 2016年 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDyz : NSObject
/**
 *  校验身份证号合法性
 *
 *  @param value 身份证号字符串
 *
 *  @return YES/NO
 */
+ (BOOL)validateIDCardNumber:(NSString *)value;

/**
 *  校验手机号合法性
 *
 *  @param mobileNum 手机号
 *
 *  @return YES/NO
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
+ (BOOL)checkPassword:(NSString *) password;

+(NSString *)changeIdcardNumber:(NSString *)value;
@end
