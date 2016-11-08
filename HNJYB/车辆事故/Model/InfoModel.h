//
//  InfoModel.h
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/4.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "BaseModel.h"

@interface InfoModel : BaseModel

@property (nonatomic, copy) NSString *carType;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *carNum;
@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, copy) NSString *driveNum;
@property (nonatomic, copy) NSString *vinNum;
//@property (nonatomic, copy) NSString *recordNum;
@property (nonatomic, copy) NSString *bdhNum;

@end
