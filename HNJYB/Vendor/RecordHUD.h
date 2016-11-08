//
//  RecordHUD.h
//  D3RecordButtonDemo
//
//  Created by bmind on 15/7/29.
//  Copyright (c) 2015年 bmind. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HudStopRecord)();

@interface RecordHUD : UIView{
    UIImageView *imgView;
    UILabel *timeLabel;
}
@property (nonatomic, strong) UIButton *titleBtn;
@property (nonatomic, strong, readonly) UIWindow *overlayWindow;

@property (nonatomic, copy) HudStopRecord stopRecord;
+ (RecordHUD *)shareView;

+ (void)show;

+ (void)dismiss;

//+ (void)stopRecord:(StopRecord)block;

+ (void)setTitle:(NSString*)title;

+ (void)setTimeTitle:(NSString*)time;

+ (void)setImage:(NSString*)imgName;
@end
