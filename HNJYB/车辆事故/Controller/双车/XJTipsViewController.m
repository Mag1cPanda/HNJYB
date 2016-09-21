//
//  XJTipsViewController.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/24.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "XJTipsViewController.h"
#import "OneSGSCViewController.h"
#import "XZQXViewController.h"

@interface XJTipsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tipLab;

@end

@implementation XJTipsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"事故审核";
    self.tipLab.text = @"您的现场拍照信息已经通过审核！\n请快速将车辆移至不影响交通的安全地点！\n引起交通拥堵可能会受到处罚！";
}

- (IBAction)carMoved:(id)sender {
    if (GlobleInstance.isOneCar) {
        OneSGSCViewController *vc = [OneSGSCViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    else {
        XZQXViewController *vc = [XZQXViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
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
