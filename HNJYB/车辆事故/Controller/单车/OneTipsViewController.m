//
//  OneTipsViewController.m
//  HNJYB
//
//  Created by Mag1cPanda on 2016/10/9.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "JCAlertView.h"
#import "OneTipsViewController.h"

@interface OneTipsViewController ()
{
    JCAlertView *endAlert;
}
@property (weak, nonatomic) IBOutlet UIImageView *tipsImage;
@property (weak, nonatomic) IBOutlet UILabel *tipsLab;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation OneTipsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"温馨提示";
    self.tipsLab.text = @"请告知车主查收短信并按短信提示操作即可进行保险报案！";
}

- (IBAction)btnClicked:(id)sender
{
    NSArray *arr = self.navigationController.viewControllers;
    [self.navigationController popToViewController:arr[1] animated:YES];
}

@end
