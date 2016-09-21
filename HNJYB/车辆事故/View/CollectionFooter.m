//
//  CollectionFooter.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/2.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "CollectionFooter.h"

@implementation CollectionFooter
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake(10, 25, ScreenWidth-20, 50);
        _btn.backgroundColor = HNBlue;
        [_btn setTitle:@"上传" forState:0];
        [_btn setTitleColor:[UIColor whiteColor] forState:0];
        _btn.titleLabel.font = HNFont(15);
        _btn.layer.cornerRadius = 5;
        [self addSubview:_btn];
        
    }
    
    return self;
}
@end
