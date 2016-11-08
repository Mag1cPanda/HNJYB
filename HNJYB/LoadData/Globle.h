//
//  Globle.h
//  TBRJL
//
//  Created by 程三 on 15/6/13.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InfoModel.h"

typedef NS_ENUM(NSInteger, HNUserType) {
    TrafficPolice   = 0,
    AuxiliaryPolice = 1,
};

@interface Globle : NSObject

//升级平台地址
@property(nonatomic,copy)NSString *updateURL;
//登陆对象
@property(nonatomic,retain)NSDictionary *loginData;
//经度
@property(nonatomic,assign)float imagelon;
//纬度
@property(nonatomic,assign)float imagelat;
//事故地址
@property(nonatomic,copy) NSString *imageaddress;
//外层的用户名和密码，该值时不变的
@property(nonatomic,copy) NSString *loadDataName;
@property(nonatomic,copy) NSString *loadDataPass;

@property (nonatomic, assign) HNUserType userType;
@property (nonatomic, assign) BOOL isOneCar;

@property(nonatomic,copy)NSString *token;
@property (nonatomic, copy) NSString *policeno;
@property(nonatomic,copy)NSString *userflag;
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *cardno;
@property (nonatomic, copy) NSString *armyname;
@property (nonatomic, copy) NSString *showname;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *mobilephone;
@property(nonatomic,copy) NSString *areaid;

@property (nonatomic, copy) NSString *appcaseno;
@property (nonatomic, copy) NSString *casehaptime;

@property (nonatomic, copy) NSString *jfjszStr;//甲方驾驶证
@property (nonatomic, copy) NSString *jfxszStr;//甲方行驶证
@property (nonatomic, copy) NSString *yfjszStr;//乙方驾驶证
@property (nonatomic, copy) NSString *yfxszStr;//乙方行驶证
@property (nonatomic, strong) InfoModel *jfModel;
@property (nonatomic, strong) InfoModel *yfModel;
//@property (nonatomic, assign) NSInteger photoCount;

@property (nonatomic, copy) NSString *jfocrname;
@property (nonatomic, copy) NSString *jfocrcardno;
@property (nonatomic, copy) NSString *jfocrcarno;
@property (nonatomic, copy) NSString *jfocrvin;
@property (nonatomic, copy) NSString *jfocrcartype;

@property (nonatomic, copy) NSString *yfocrname;
@property (nonatomic, copy) NSString *yfocrcardno;
@property (nonatomic, copy) NSString *yfocrcarno;
@property (nonatomic, copy) NSString *yfocrvin;
@property (nonatomic, copy) NSString *yfocrcartype;

+(Globle *)getInstance;

@end
