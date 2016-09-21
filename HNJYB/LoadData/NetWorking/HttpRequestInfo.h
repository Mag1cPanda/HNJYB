//
//  HttpRequestInfo.h
//  baobaotong
//
//  Created by zzy on 2016/02/23.
//  Copyright © 2016年 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RequestCompelete)(id result);

@interface HttpRequestInfo : NSObject

@property(nonatomic,copy)NSString *serviceIP;
@property(nonatomic,copy)NSString *serviceName;
@property(nonatomic,retain)NSMutableDictionary *params;
@property(nonatomic,copy)NSString *httpMethod;
@property(nonatomic,assign)BOOL resultIsDictionary;
@property(nonatomic,copy)RequestCompelete block;

@end
