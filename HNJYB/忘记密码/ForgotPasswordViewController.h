//
//  ForgotPasswordViewController.h
//  CZT_IOS_Longrise
//
//  Created by 张博林 on 15/12/29.
//  Copyright © 2015年 程三. All rights reserved.
//

#import "PublicViewController.h"

@interface ForgotPasswordViewController : PublicViewController

@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *imgCodeField;
@property (weak, nonatomic) IBOutlet UITextField *msgField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UITextField *insureField;

@property (weak, nonatomic) IBOutlet UIButton *showOrHide1;
@property (weak, nonatomic) IBOutlet UIButton *showOrHide2;

@property (weak, nonatomic) IBOutlet UIButton *imageCode;
@property (weak, nonatomic) IBOutlet UIButton *phoneCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end
