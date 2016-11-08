//
//  ModifyPassWordViewController.h
//  CZT_HN_Longrise
//
//  Created by OSch on 16/5/20.
//  Copyright © 2016年 OSch. All rights reserved.
//

#import "PublicViewController.h"
#import <UIKit/UIKit.h>

@interface ModifyPassWordViewController : PublicViewController

@property (weak, nonatomic) IBOutlet UITextField *oldPWTextField;

@property (weak, nonatomic) IBOutlet UITextField *pWTextField;

@property (weak, nonatomic) IBOutlet UIButton *showEntryBtn1;

@property (weak, nonatomic) IBOutlet UIButton *showEntryBtn2;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end
