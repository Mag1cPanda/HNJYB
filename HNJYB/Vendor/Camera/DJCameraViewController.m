//
//  ViewController.m
//  照相机demo
//
//  Created by Jason on 11/1/16.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "DJCameraViewController.h"
#import "UIButton+DJBlock.h"
#import "DJCameraManager.h"
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define AppWidth [[UIScreen mainScreen] bounds].size.width
#define AppHeigt [[UIScreen mainScreen] bounds].size.height

#define AutoScaleX [UIScreen mainScreen].bounds.size.width/320
#define AutoScaleY [UIScreen mainScreen].bounds.size.height/568

@interface DJCameraViewController () <DJCameraManagerDelegate>
@property (nonatomic,strong)DJCameraManager *manager;
@end

@implementation DJCameraViewController
/**
 *  在页面结束或出现记得开启／停止摄像
 *
 *  @param animated
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![self.manager.session isRunning]) {
        [self.manager.session startRunning];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.manager.session isRunning]) {
        [self.manager.session stopRunning];
    }
}


- (void)dealloc
{
    NSLog(@"照相机释放了");
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self initLayout];
    [self initPickButton];
    [self initFlashButton];
//    [self initCameraFontOrBackButton];
    [self initDismissButton];
}

- (void)initLayout
{
    self.view.backgroundColor = [UIColor blackColor];
    
    UIView *pickView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, AppWidth, AppWidth+100)];
    [self.view addSubview:pickView];
    if (_isShowWarnImage) {
        CGFloat imageX = (AppWidth - 380 * AutoScaleX) * 0.5;
        CGFloat imageY = ((pickView.frame.size.height + 40) - 210 * AutoScaleY) * 0.5;
        UIImageView *guideImageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageX, imageY, 380 * AutoScaleX, 210 * AutoScaleY)];
        guideImageView.backgroundColor = [UIColor clearColor];
        guideImageView.image = [UIImage imageNamed:_guideImageName];
        guideImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
        [pickView.superview addSubview:guideImageView];
        
        //顶部照片类型
        UILabel *noticelabels = [[UILabel alloc]initWithFrame:CGRectMake(AppWidth - 150, AppHeigt * 0.5, 260, 37)];
        noticelabels.text = self.noticeString;
        noticelabels.textColor = [UIColor blackColor];
        noticelabels.transform = CGAffineTransformMakeRotation(M_PI/2);
        [pickView.superview addSubview:noticelabels];
        
        //危险提示
        UIView *stadicView = [[UIView alloc]initWithFrame:CGRectMake(-110, (AppHeigt- 106 - 37) * 0.5, 300, 37)];
        stadicView.transform = CGAffineTransformMakeRotation(M_PI/2);
        UIImageView *stadicImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 37)];
        stadicImageView.image = [UIImage imageNamed:@"tptips"];
        [stadicView addSubview:stadicImageView];
        UILabel *labels = [[UILabel alloc]initWithFrame:CGRectMake(55, 0, 260, 37)];
        labels.text = @"请在保证安全的情况下拍摄！";
        labels.textColor = [UIColor whiteColor];
        [stadicImageView addSubview:labels];
        [pickView.superview addSubview:stadicView];
    }
    // 传入View的frame 就是摄像的范围
    DJCameraManager *manager = [[DJCameraManager alloc] initWithParentView:pickView];
    manager.delegate = self;
    manager.canFaceRecognition = YES;
    [manager setFaceRecognitonCallBack:^(CGRect faceFrame) {
        NSLog(@"你的脸在%@",NSStringFromCGRect(faceFrame));
    }];
    
    self.manager = manager;
}

/**
 *  拍照按钮
 */
- (void)initPickButton
{
    static CGFloat buttonW = 80;
    UIButton *button = [self buildButton:CGRectMake(AppWidth/2-buttonW/2, AppWidth+120+(AppHeigt-AppWidth-100-20)/2 - buttonW/2, buttonW, buttonW)
                            normalImgStr:@"shot.png"
                         highlightImgStr:@"shot_h.png"
                          selectedImgStr:@""
                              parentView:self.view];
    if (_isLandscape) {
        button.transform = CGAffineTransformMakeRotation(M_PI/2);
    }
    WS(weak);
    [button addActionBlock:^(id sender) {
        [weak.manager takePhotoWithImageBlock:^(UIImage *originImage, UIImage *scaledImage, UIImage *croppedImage) {
            if (croppedImage) {
                
                //Block
                if (_isLandscape) {
                    if (_block) {
                        _block([self tranFormImage:croppedImage rotation:UIImageOrientationLeft]);
                    }
                }
                else
                {
                    if (_block) {
                        _block(croppedImage);
                    }
                }
                
                //Delegate
                if (self.delegate&&[_delegate respondsToSelector:@selector(cameraViewController:ToObtainCameraPhotos:)]) {
                    if (_isLandscape) {
                        [_delegate cameraViewController:self ToObtainCameraPhotos:[self tranFormImage:croppedImage rotation:UIImageOrientationLeft]];
                    }
                    else
                    {
                        [_delegate cameraViewController:self ToObtainCameraPhotos:croppedImage];
                    }
                    
                }
                [self dismissViewControllerAnimated:YES completion:^{}];
            }
        }];
    } forControlEvents:UIControlEventTouchUpInside];
}
/**
 *  切换闪光灯按钮
 */
- (void)initFlashButton
{
    static CGFloat buttonW = 40;
    UIButton *button = [self buildButton:CGRectMake(AppWidth - buttonW - 30, AppWidth+120+(AppHeigt-AppWidth-100-20)/2 - 20, buttonW, buttonW)
                            normalImgStr:@"flashing_off.png"
                         highlightImgStr:@""
                          selectedImgStr:@""
                              parentView:self.view];
    if (_isLandscape) {
        button.transform = CGAffineTransformMakeRotation(M_PI/2);
    }
    WS(weak);
    [button addActionBlock:^(id sender) {
        [weak.manager switchFlashMode:sender];
    } forControlEvents:UIControlEventTouchUpInside];
}
/**
 *  切换前后镜按钮
 */
- (void)initCameraFontOrBackButton
{
    static CGFloat buttonW = 40;
    UIButton *button = [self buildButton:CGRectMake(50, AppWidth+125, buttonW, buttonW)
                            normalImgStr:@"switch_camera.png"
                         highlightImgStr:@""
                          selectedImgStr:@""
                              parentView:self.view];
    if (_isLandscape) {
        button.transform = CGAffineTransformMakeRotation(M_PI/2);
    }
    WS(weak);
    [button addActionBlock:^(id sender) {
        UIButton *bu = sender;
        bu.enabled = NO;
        bu.selected = !bu.selected;
        [weak.manager switchCamera:bu.selected didFinishChanceBlock:^{
            bu.enabled = YES;
        }];
    } forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)initDismissButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(30, AppWidth+120+(AppHeigt-AppWidth-100-20)/2 - 11, 40, 22);
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (_isLandscape) {
        button.transform = CGAffineTransformMakeRotation(M_PI/2);
    }
    WS(weak);
    [button addActionBlock:^(id sender) {
        [weak dismissViewControllerAnimated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
/**
 *  点击对焦
 *
 *  @param touches
 *  @param event
 */

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    [self.manager focusInPoint:point];
}

- (UIButton*)buildButton:(CGRect)frame
            normalImgStr:(NSString*)normalImgStr
         highlightImgStr:(NSString*)highlightImgStr
          selectedImgStr:(NSString*)selectedImgStr
              parentView:(UIView*)parentView {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    if (normalImgStr.length > 0) {
        [btn setImage:[UIImage imageNamed:normalImgStr] forState:UIControlStateNormal];
    }
    if (highlightImgStr.length > 0) {
        [btn setImage:[UIImage imageNamed:highlightImgStr] forState:UIControlStateHighlighted];
    }
    if (selectedImgStr.length > 0) {
        [btn setImage:[UIImage imageNamed:selectedImgStr] forState:UIControlStateSelected];
    }
    [parentView addSubview:btn];
    return btn;
}

#pragma -mark DJCameraDelegate
- (void)cameraDidFinishFocus
{
//    NSLog(@"对焦结束了");
}
- (void)cameraDidStareFocus
{
//    NSLog(@"开始对焦");
}


#pragma mark - 旋转UIImage
- (UIImage *)tranFormImage:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}


@end
