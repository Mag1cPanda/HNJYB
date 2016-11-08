//
//  LSHttpManager.m
//  CarRecord_Longrise
//
//  Created by Mag1cPanda on 16/6/8.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "LSHttpManager.h"

@implementation LSHttpManager
+ (void)requestUrl:(NSString *)urlString serviceName:(NSString *)serviceName parameters:(NSMutableDictionary *)parameters complete:(CompleteBlock)block
{
    [AFNetWorkServiceCar getAFNetWorkServiceCar].showNotice = NO;

    [[AFNetWorkServiceCar getAFNetWorkServiceCar] requestWithServiceIP2:urlString ServiceName:serviceName params:parameters httpMethod:@"POST" resultIsDictionary:YES completeBlock:^(id result, ResultType resultType) {

      //        block(result,resultType);

      if (resultType == -1)
      {
          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"无法联网，请检查您的网络连接" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
          [alert show];
      }

      else
      {
          block(result, resultType);
      }

    }];
}
@end
