//
//  RemoteDutyViewController.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/31.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "JCAlertView.h"
#import "RemoteDutyViewController.h"
#import "WaitDutyViewController.h"

@interface RemoteDutyViewController () < UIActionSheetDelegate >
{
    JCAlertView *endAlert;
}
@end

@implementation RemoteDutyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"远程定责";
}

- (IBAction)confirmBtnClicked:(id)sender
{
    WaitDutyViewController *vc = [WaitDutyViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
