//
//  HNButton.h
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/3.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HNButton;

typedef void (^HNClickedHandle)(HNButton *btn);

@interface HNButton : UIButton

@property (nonatomic, copy) HNClickedHandle block;

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title handleBlock:(HNClickedHandle)block;

@end
