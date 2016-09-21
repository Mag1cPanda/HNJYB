//
//  AFNetWorkServiceCar.h
//  LongriseHttpManageIOS
//
//  Created by 程三 on 16/5/18.
//  Copyright © 2016年 程三. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetWorkService.h"

@interface AFNetWorkServiceCar : AFNetWorkService

@property(nonatomic,assign)BOOL showNotice;

-(void)requestWithServiceIP2:(NSString *)serviceIP ServiceName:(NSString *)serviceName params:(NSMutableDictionary *)params httpMethod:(NSString *)httpMethod resultIsDictionary:(BOOL)resultIsDictionary completeBlock:(RequestCompelete2)block2;

+ (AFNetWorkServiceCar *)getAFNetWorkServiceCar;

@end
