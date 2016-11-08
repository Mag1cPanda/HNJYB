//
//  InfoModel.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/4.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "InfoModel.h"

@implementation InfoModel

-(NSString *)description{
    return [NSString stringWithFormat:@"%@\n%@ \n%@ \n%@ \n%@ \n%@ \n%@ \n ",self.name, self.carType, self.carNum, self.phoneNum, self.driveNum, self.vinNum, self.bdhNum];
}

@end
