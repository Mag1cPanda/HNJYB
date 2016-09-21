//
//  IDyz.m
//  baobaotong
//
//  Created by likang on 16/1/18.
//  Copyright © 2016年 zzy. All rights reserved.
//

#import "IDyz.h"
@implementation IDyz
+(NSString *)changeIdcardNumber:(NSString *)value
{
    NSInteger length = [value length];
    if (length == 15 ) {
     NSString *a =  [NSString stringWithFormat:@"%c",[value characterAtIndex:14]];
        NSString *b = [value substringToIndex:14];
        if ([a isEqualToString:@"x"]) {
            value = [NSString stringWithFormat:@"%@%@",b,@"X"];
        }
        
    }
  else if (length == 18 ) {
        NSString *a =  [NSString stringWithFormat:@"%c",[value characterAtIndex:17]];
        NSString *b = [value substringToIndex:17];
        if ([a isEqualToString:@"x"]) {
            value = [NSString stringWithFormat:@"%@%@",b,@"X"];
        }

    }
    return value;
}
+ (BOOL)validateIDCardNumber:(NSString *)value {
    value = [self changeIdcardNumber:value];
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger length =0;
    
    if (!value) {
        
        return NO;
        
    }else {
        
        length = value.length;
        
        if (length !=15 && length !=18) {
            
            return NO;
        }
        
    }
    // 省份代码
    
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41",@"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    
    BOOL areaFlag =NO;
    
    for (NSString *areaCode in areasArray) {
        
        if ([areaCode isEqualToString:valueStart2]) {
            
            areaFlag =YES;
            
            break;
            
        }
    }
    
    if (!areaFlag) {
        
        return false;
        
    }
    
    NSRegularExpression *regularExpression;
    
    NSUInteger numberofMatch;
    
    int year =0;
  
    switch (length) {
            
        case 15:
            
        {
            year = [[value substringWithRange:NSMakeRange(6,2)]intValue]+1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {

                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                            options:NSRegularExpressionCaseInsensitive
                             error:nil];//测试出生日期的合法性
            }
            else {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                     
                                                                        options:NSRegularExpressionCaseInsensitive
                                     
                                                                          error:nil];//测试出生日期的合法性
            }
            
            numberofMatch = [regularExpression numberOfMatchesInString:value options:NSMatchingReportProgress
                  range:NSMakeRange(0, value.length)];

            if(numberofMatch >0) {
                
                return YES;
                
            }else {
                
                return NO;
            }
        }
        case 18:
        {
            year =(int) [[value substringWithRange:NSMakeRange(6,4)] integerValue];
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {

                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                     
                                                                        options:NSRegularExpressionCaseInsensitive
                                     
                                                                          error:nil];//测试出生日期的合法性
                
            }else {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                     
                                                                        options:NSRegularExpressionCaseInsensitive
                                     
                                                                          error:nil];//测试出生日期的合法性
                
            }
            
            numberofMatch = [regularExpression numberOfMatchesInString:value
                             
                                                               options:NSMatchingReportProgress                 range:NSMakeRange(0, value.length)];
   
            if(numberofMatch >0) {
                
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                
                int Y = S %11;
                
                NSString *M =@"F";
                
                NSString *JYM =@"10X98765432";
                
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    
                    return YES;// 检测ID的校验位
                    
                }else {
                    
                    return NO;
                    
                }

            }else {
                
                return NO;
                
            }
        }
            
        default:
            
            return false;
    }
    
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum {
//    NSString * phoneRegex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
//    BOOL isMatch = [pred evaluateWithObject:mobileNum];
//    return isMatch;
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
/**
 * 中国移动：China Mobile
 * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
 */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
/**
 * 中国联通：China Unicom
 * 130,131,132,152,155,156,185,186
 */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
/**
 * 中国电信：China Telecom
 * 133,1349,153,180,189
 */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
/**
 * 大陆地区固话及小灵通
 * 区号：010,020,021,022,023,024,025,027,028,029
 * 号码：七位或八位
 */
// NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
+ (BOOL)checkPassword:(NSString *) password
{
    NSMutableString * mupass = [NSMutableString stringWithString:password];
    for (NSInteger i = 0 ; i< password.length ; i++) {
        if (([mupass characterAtIndex:i] >= 48 && [mupass characterAtIndex:i]  <=57)  || ([mupass characterAtIndex:i] >= 65 && [mupass characterAtIndex:i] <= 90) || ([mupass characterAtIndex:i] >= 97 && [mupass characterAtIndex:i] <= 122) || [mupass characterAtIndex:i] == 95) {
            if (password.length >=6 && password.length<=18 && i == password.length -1)
            {
                return YES;
            }
        }
        else
        {
            return  NO;
        }

    }
    return NO ;
}
@end
