//
//  AFNetWorkService2.h
//  LongriseHttpManageIOS
//
//  Created by 程三 on 16/6/2.
//  Copyright © 2016年 程三. All rights reserved.
//

#import "AFNetWorkService.h"

@interface AFNetWorkService2 : AFNetWorkService
@property(nonatomic,assign)BOOL showNotice;

-(void)requestWithServiceIP2:(NSString *)serviceIP ServiceName:(NSString *)serviceName params:(NSMutableDictionary *)params httpMethod:(NSString *)httpMethod resultIsDictionary:(BOOL)resultIsDictionary completeBlock:(RequestCompelete2)block2;

+ (AFNetWorkService2 *)getAFNetWorkService2;
@end
