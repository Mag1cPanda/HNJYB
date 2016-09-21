//
//  AFNetWorkServiceCar.m
//  LongriseHttpManageIOS
//
//  Created by 程三 on 16/5/18.
//  Copyright © 2016年 程三. All rights reserved.
//

#import "AFNetWorkServiceCar.h"
#import "AFHTTPRequestOperationManager.h"

//登录通知
#define LoginForGetCookId @"LoginForGetCookId"
//帐号被挤掉
#define LoginOutNotifaction @"LoginOutNotifaction"

static AFNetWorkServiceCar *serviceCar;

@implementation AFNetWorkServiceCar

+ (AFNetWorkServiceCar *)getAFNetWorkServiceCar
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!serviceCar)
        {
            serviceCar = [[AFNetWorkServiceCar alloc]init];
        }
    });
    return serviceCar;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        _showNotice = YES;
    }
    return self;
}

-(void)requestWithServiceIP2:(NSString *)serviceIP ServiceName:(NSString *)serviceName params:(NSMutableDictionary *)params httpMethod:(NSString *)httpMethod resultIsDictionary:(BOOL)resultIsDictionary completeBlock:(RequestCompelete2)block2
{
    
    //判断网络
    if([self getNetState] == 0)
    {
        if(_showNotice)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有网络连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
        if(block2 != nil)
        {
            self.count = 0;
            block2(nil,Failure);
        }
        return;
    }
    //拼接URL
    NSString *url = [NSString stringWithFormat:@"%@/%@/query",serviceIP,serviceName];
    
    NSLog(@"请求的完整链接 -> %@",url);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if(!resultIsDictionary)
    {
        manager.responseSerializer = [AFCompoundResponseSerializer serializer];//响应
    }
    else
    {
        //manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    
    //设置相应内容类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/html",@"text/plain",@"text/javascript",nil];
    
    NSArray *array = [params allKeys];
    if(array.count != 0)
    {
        for (int  i = 0; i < array.count; i++)
        {
            NSString *key = array[i];
            id object = [params objectForKey:key];
            
            //判断参数类型
            if([object isKindOfClass:[NSNumber class]])
            {
                
            }
            else if([object isKindOfClass:[NSString class]])
            {
                
            }
            else if([object isKindOfClass:[NSData class]])
            {
                
            }
            else
            {
                NSString *string = [self objectToJson:object];
                [params setValue:string forKey:key];
            }
        }
    }
    
    
    //添加版本号到head里面
    [manager.requestSerializer setValue:(nil == self.versionStr?@"":self.versionStr) forHTTPHeaderField:@"App-Version"];
    
    //处理POST的参数
    NSComparisonResult compareRet = [httpMethod caseInsensitiveCompare:@"POST"];
    if(NSOrderedSame == compareRet)
    {
        [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             
             if(responseObject != nil)
             {
                 NSDictionary *dic = responseObject;
                 if(dic == nil)
                 {
                     self.count = 0;
                     if(block2 != nil)
                     {
                         block2(responseObject,Failure);
                     }
                 }
                 else
                 {
                     // 调用需要token 的方法的时候， 返回-4表示账号被挤掉， -5表示登录超时了
                     NSString *restate = [dic objectForKey:@"restate"];
                     if([@"1" isEqualToString:restate])
                     {
                         self.count = 0;
                         if(block2 != nil)
                         {
                             block2(responseObject,Success);
                         }
                     }
                     else if([@"-1" isEqualToString:restate] || [@"-2" isEqualToString:restate] || [@"-3" isEqualToString:restate] || [@"-4" isEqualToString:restate] || [@"-4" isEqualToString:restate] || [@"-6" isEqualToString:restate] || [@"-7" isEqualToString:restate])
                     {
                         NSLog(@"通知LoginOutNotifaction");
                         //发送通知
                         NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                         [center postNotificationName:LoginOutNotifaction object:responseObject];
                         self.count = 0;
                         if(block2 != nil)
                         {
                             block2(nil,Failure);
                         }
                     }
                     else if([@"-5" isEqualToString:restate])
                     {
                         //防止无限循环
                         self.count++;
                         if(self.count > 3)
                         {
                             self.count = 0;
                             block2(responseObject,Failure);
                         }
                         else
                         {
                             //获取新的cookID
                             [self getCookIdSeviceIP2:serviceIP ServiceName:serviceName params:params httpMethod:httpMethod resultIsDictionary:resultIsDictionary completeBlock:block2];
                         }
                         
                         return;
                     }
                     else
                     {
                         if(block2 != nil)
                         {
                             self.count = 0;
                             block2(responseObject,Success);
                         }
                     }
                     
                 }
             }
             else
             {
                 if(block2 != nil)
                 {
                     self.count = 0;
                     block2(responseObject,Success);
                 }
             }
             
         }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"调用服务出错(POST)");
             if(block2 != nil)
             {
                 self.count = 0;
                 block2(nil,Failure);
             }
         }];
    }
    else
    {
        [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             if(responseObject != nil)
             {
                 NSDictionary *dic = responseObject;
                 if(dic == nil)
                 {
                     self.count = 0;
                     if(block2 != nil)
                     {
                         block2(responseObject,Failure);
                     }
                 }
                 else
                 {
                     // 调用需要token 的方法的时候， 返回-4表示账号被挤掉， -5表示登录超时了
                     NSString *restate = [dic objectForKey:@"restate"];
                     if([@"1" isEqualToString:restate])
                     {
                         self.count = 0;
                         if(block2 != nil)
                         {
                             block2(responseObject,Success);
                         }
                     }
                     else if([@"-1" isEqualToString:restate] || [@"-2" isEqualToString:restate] || [@"-3" isEqualToString:restate] || [@"-4" isEqualToString:restate] || [@"-4" isEqualToString:restate] || [@"-6" isEqualToString:restate] || [@"-7" isEqualToString:restate])
                     {
                         //发送通知
                         NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                         [center postNotificationName:LoginOutNotifaction object:responseObject];
                         self.count = 0;
                         if(block2 != nil)
                         {
                             block2(nil,Failure);
                         }
                     }
                     else if([@"-5" isEqualToString:restate])
                     {
                         //防止无限循环
                         self.count++;
                         if(self.count > 3)
                         {
                             self.count = 0;
                             block2(nil,Failure);
                         }
                         else
                         {
                             //获取新的cookID
                             [self getCookIdSeviceIP2:serviceIP ServiceName:serviceName params:params httpMethod:httpMethod resultIsDictionary:resultIsDictionary completeBlock:block2];
                         }
                         
                         return;
                     }
                     else
                     {
                         self.count = 0;
                         if(block2 != nil)
                         {
                             block2(nil,Failure);
                         }
                     }
                     
                 }
             }
             else
             {
                 self.count = 0;
                 if(block2 != nil)
                 {
                     block2(nil,Failure);
                 }
             }
         }
             failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"调用服务出错(GET)");
             self.count = 0;
             if(block2 != nil)
             {
                 block2(nil,Failure);
             }
         }];
    }
}


-(void)getCookIdSeviceIP2:(NSString *) serviceIP ServiceName:(NSString *)serviceName params:(NSMutableDictionary *)params httpMethod:(NSString *)httpMethod resultIsDictionary:(BOOL)resultIsDictionary completeBlock:(RequestCompelete2)block2
{
    //拼接URL
    NSString *url = [NSString stringWithFormat:@"%@%@/query",self.requestInfo.serviceIP,self.requestInfo.serviceName];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if(!resultIsDictionary)
    {
        manager.responseSerializer = [AFCompoundResponseSerializer serializer];//响应
    }
    else
    {
        //manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    
    //设置相应内容类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/html",@"text/plain",@"text/javascript",nil];
    
    NSArray *array = [self.requestInfo.params allKeys];
    if(array.count != 0)
    {
        for (int  i = 0; i < array.count; i++)
        {
            NSString *key = array[i];
            id object = [self.requestInfo.params objectForKey:key];
            
            //判断参数类型
            if([object isKindOfClass:[NSNumber class]])
            {
                
            }
            else if([object isKindOfClass:[NSString class]])
            {
                
            }
            else if([object isKindOfClass:[NSData class]])
            {
                
            }
            else
            {
                NSString *string = [self objectToJson:object];
                [self.requestInfo.params setValue:string forKey:key];
            }
        }
    }
    
    
    //处理POST的参数
    NSComparisonResult compareRet = [self.requestInfo.httpMethod caseInsensitiveCompare:@"POST"];
    if(NSOrderedSame == compareRet)
    {
        [manager POST:url parameters:self.requestInfo.params success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"通知重新登录成功");
             //发送成功通知
             NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
             [center postNotificationName:@"LoginForGetCookId" object:resultIsDictionary ? responseObject:operation.responseString];
             
             //成功，继续调用当前服务
             [self requestWithServiceIP2:serviceIP ServiceName:serviceName params:params httpMethod:httpMethod resultIsDictionary:resultIsDictionary completeBlock:block2];
             
         }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"通知重新登录失败");
             //发送失败通知
             NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
             [center postNotificationName:@"LoginForGetCookId" object:nil];
             
             if(block2 != nil)
             {
                 block2(nil,Failure);
             }
         }];
    }
    else
    {
        [manager GET:url parameters:self.requestInfo.params success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             //发送成功通知
             NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
             [center postNotificationName:LoginForGetCookId object:resultIsDictionary ? responseObject:operation.responseString];
             
             //成功，继续调用当前服务
             [self requestWithServiceIP2:serviceIP ServiceName:serviceName params:params httpMethod:httpMethod resultIsDictionary:resultIsDictionary completeBlock:block2];
         }
             failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             //发送失败通知
             NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
             [center postNotificationName:LoginForGetCookId object:nil];
             
             if(block2 != nil)
             {
                 block2(nil,Failure);
             }
         }];
    }
}


@end
