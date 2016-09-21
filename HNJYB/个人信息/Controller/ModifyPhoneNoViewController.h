//
//  ModifyPhoneNoViewController.h
//  CZT_HN_Longrise
//
//  Created by OSch on 16/5/13.
//  Copyright © 2016年 OSch. All rights reserved.
//

#import "PublicViewController.h"

@interface ModifyPhoneNoViewController : PublicViewController

@property (copy, nonatomic) NSString *oldPhoneNO;
@property (weak, nonatomic) IBOutlet UILabel *phoneNoLabel;


@property (weak, nonatomic) IBOutlet UITextField *PhoneNoNew;

@property (weak, nonatomic) IBOutlet UIView *codeImageView;

@property (weak, nonatomic) IBOutlet UITextField *imageCodeTextField;

@property (weak, nonatomic) IBOutlet UIView *veficationCodeView;

@property (weak, nonatomic) IBOutlet UITextField *veficationTextfield;

@property (weak, nonatomic) IBOutlet UIButton *sureNextBtn;





@end
