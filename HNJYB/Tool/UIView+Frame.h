//
//  UIView+Frame.h
//  SRLibrary
//
//  Created by Mag1cPanda on 16/3/16.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIView (Frame)
@property (nonatomic, assign) CGFloat  x;
@property (nonatomic, assign) CGFloat  y;
@property (nonatomic, assign) CGFloat  width;
@property (nonatomic, assign) CGFloat  height;
@property (nonatomic, assign, readonly) CGFloat  maxX;
@property (nonatomic, assign, readonly) CGFloat  maxY;
@end
