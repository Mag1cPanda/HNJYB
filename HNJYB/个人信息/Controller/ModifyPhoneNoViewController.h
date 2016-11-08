//
//  ModifyPhoneNoViewController.h
//  CZT_HN_Longrise
//
//  Created by OSch on 16/5/13.
//  Copyright © 2016年 OSch. All rights reserved.
//

#import "PublicViewController.h"

typedef void (^ChangePhoneBlock)(NSString *phone);

@interface ModifyPhoneNoViewController : PublicViewController

@property (weak, nonatomic) IBOutlet UIImageView *tipsIcon;
@property (weak, nonatomic) IBOutlet UILabel *tipsLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneNoLabel;

@property (weak, nonatomic) IBOutlet UITextField *PhoneNoNew;

@property (weak, nonatomic) IBOutlet UITextField *imageCodeTextField;

@property (weak, nonatomic) IBOutlet UIButton *imageCodeBtn;

@property (weak, nonatomic) IBOutlet UITextField *veficationTextfield;

@property (weak, nonatomic) IBOutlet UIButton *phoneCodeBtn;

@property (weak, nonatomic) IBOutlet UIButton *sureNextBtn;

@property (nonatomic, copy) ChangePhoneBlock block;

@end
