//
//  ForgotPasswordViewController.h
//  CZT_IOS_Longrise
//
//  Created by 张博林 on 15/12/29.
//  Copyright © 2015年 程三. All rights reserved.
//

#import "PublicViewController.h"
#import "ImgCodeView.h"

@interface ForgotPasswordViewController : PublicViewController<ImgCodeViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *imgCodeField;
@property (weak, nonatomic) IBOutlet UITextField *msgField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UITextField *insureField;

@property (weak, nonatomic) IBOutlet UIView *backCodeView;
@property (weak, nonatomic) IBOutlet UIView *verCodeBtnBack;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end
