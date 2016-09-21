//
//  AFNetWorkService.h
//  TBRJL
//
//  Created by zzy on 16/01/16.
//  Copyright (c) 2016年 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequestInfo.h"

//请求类型Key
#define REQUEST_TYPE_KEY_NAME @"requestTypeKeyName"
//版本key
#define VERSION_KEY_NAME @"versionKeyName"
//IP名称
#define IP_KEY_NAME @"ipKeyName"
//服务名称
#define SERVICENAME_KEY_NAME @"serviceNameKeyName"
//参数名称
#define PARAMBEAN_KEY_NAME @"paramBeanKeyName"

//返回类型
typedef NS_ENUM(NSInteger,ResultType)
{
    UnknownNet = -1,//没有网络
    Failure = 0,//失败
    Success = 1,//成功
};

typedef void(^RequestCompelete)(id result);
typedef void(^RequestCompelete2) (id result,ResultType resultType);

@interface AFNetWorkService : NSObject

@property(nonatomic,assign)ResultType resultType;
@property(nonatomic,retain)id result;
//设置获取cookID的服务参数对象
@property(nonatomic,retain)HttpRequestInfo *requestInfo;
//版本
@property(nonatomic,copy)NSString *versionStr;
//调用登录次数，防止无限循环
@property(nonatomic,assign)int count;

-(void)requestWithServiceIP:(NSString *) serviceIP ServiceName:(NSString *)serviceName
                       params:(NSMutableDictionary *)params
                       httpMethod:(NSString *)httpMethod
                       resultIsDictionary:(BOOL)resultIsDictionary
                       completeBlock:(RequestCompelete)block;

- (void)requestWithServiceIP2:(NSString *) serviceIP ServiceName:(NSString *)serviceName
                      params:(NSMutableDictionary *)params
                      httpMethod:(NSString *)httpMethod
                      resultIsDictionary:(BOOL)resultIsDictionary
                      completeBlock:(RequestCompelete2)block2;

-(void)uploadUrl:(NSString *)url
                fileFullPath:(NSString *)fileFullpath
                params:(NSMutableDictionary *)params
                name:(NSString *)name
                fileName:(NSString *)fileName
                completeBlock:(RequestCompelete)block;

-(NSString*)objectToJson:(NSObject *)object;
-(int)getNetState;
+ (AFNetWorkService *)getAFNetWorkService;

@end
