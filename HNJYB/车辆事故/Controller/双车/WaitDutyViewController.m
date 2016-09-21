//
//  WaitDutyViewController.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/31.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "WaitDutyViewController.h"
#import "RemoteDutyViewController.h"

@interface WaitDutyViewController ()

@end

@implementation WaitDutyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"等待定责";
}
- (IBAction)confimBtnClicked:(id)sender {
    RemoteDutyViewController *vc = [RemoteDutyViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
