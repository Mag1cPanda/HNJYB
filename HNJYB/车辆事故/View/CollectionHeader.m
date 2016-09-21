//
//  CollectionHeader.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/2.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "CollectionHeader.h"

@implementation CollectionHeader

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _accidentView = [[AccidentHeader alloc] initWithFrame:self.bounds];
        [self addSubview:_accidentView];
    }
    return self;
}

@end
