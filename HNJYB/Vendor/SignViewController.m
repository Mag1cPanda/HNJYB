//
//  SignViewController.m
//  qianming
//
//  Created by 张博林 on 15/12/5.
//  Copyright © 2015年 张博林. All rights reserved.
//

#import "SignViewController.h"
#import "Masonry.h"

@interface SignViewController ()

@end

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setButton];
    [self addSignatureView];
    // Do any additional setup after loading the view from its nib.
}


-(BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark - 添加自定义View
-(void)addSignatureView{
    
    signatureView = [[PJRSignatureView alloc] initWithFrame:CGRectMake(0, 44, ScreenHeight, ScreenWidth-84)];
    signatureView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:signatureView];
    
}

#pragma mark - 设置button的边框和圆角
-(void)setButton{
    
    self.sureButton.layer.masksToBounds = YES;
    self.sureButton.layer.cornerRadius = 3;
    self.resignButton.layer.masksToBounds = YES;
    self.resignButton.layer.cornerRadius = 3;

}

#pragma mark - 点击事件
- (IBAction)sure:(id)sender {
    
    if (signatureView.lblSignature.superview == signatureView) {
        [self dismissViewControllerAnimated:YES completion:nil];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请签名!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    UIImage *image = [[UIImage alloc]init];
    image = [[signatureView getSignatureImage]resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1) resizingMode:UIImageResizingModeStretch];
    if (self.delegate && [_delegate respondsToSelector:@selector(passSignImage:)]) {
        [_delegate passSignImage:image];
    }
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)resign:(id)sender {
     [signatureView clearSignature];
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 设置屏幕为横屏
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
}

- (BOOL)shouldAutorotate
{
    return NO;
}







@end
