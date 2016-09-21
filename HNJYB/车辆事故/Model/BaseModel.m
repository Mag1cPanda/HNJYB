//
//  BaseModel.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/4.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"forUndefinedKey -> %@",key);
}

-(instancetype)initWithDict:(NSDictionary *)dic{
    [self setValuesForKeysWithDictionary:dic];
    return self;
}
@end
