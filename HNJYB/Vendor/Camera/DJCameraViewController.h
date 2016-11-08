//
//  ViewController.h
//  照相机demo
//
//  Created by Jason on 11/1/16.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TakePhotoFinished)(UIImage *image);
@class DJCameraViewController;

@protocol DJCameraViewControllerDelegate <NSObject>

-(void)cameraViewController:(DJCameraViewController *)cameraVC ToObtainCameraPhotos:(UIImage *)image;

@end
@interface DJCameraViewController : UIViewController

//相机是否横屏 默认为NO 竖屏  YES 横屏
@property (nonatomic, assign,getter = isLandscape) BOOL isLandscape;
@property (nonatomic, assign,getter = isShowWarnImage) BOOL isShowWarnImage;
@property (nonatomic, copy) NSString *guideImageName;

@property (nonatomic, copy) TakePhotoFinished block;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) id<DJCameraViewControllerDelegate>delegate;

@property (nonatomic, copy) NSString *noticeString;

@end

