//
//  SRBlockButton.h
//  动态行高&图文混排
//
//  Created by Mag1cPanda on 16/5/10.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SRBlockButton;

typedef void (^ButtonClicked)(SRBlockButton *btn);
@interface SRBlockButton : UIButton

@property (nonatomic, copy) ButtonClicked block;

-(instancetype)initWithFrame:(CGRect)frame
                       title:(NSString *)title
                  titleColor:(UIColor *)color
                 handleBlock:(ButtonClicked)block;

@end
