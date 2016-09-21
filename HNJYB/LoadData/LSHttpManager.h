//
//  LSHttpManager.h
//  CarRecord_Longrise
//
//  Created by Mag1cPanda on 16/6/8.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetWorkServiceCar.h"

typedef void (^CompleteBlock)(id result, ResultType resultType);

@interface LSHttpManager : NSObject
+ (void)requestUrl:(NSString *)urlString serviceName:(NSString *)serviceName parameters:(NSMutableDictionary *)parameters complete:(CompleteBlock)block;
@end
