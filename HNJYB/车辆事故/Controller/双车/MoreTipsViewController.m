//
//  MoreTipsViewController.m
//  HNJYB
//
//  Created by Mag1cPanda on 2016/11/1.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "MoreTipsViewController.h"

@interface MoreTipsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tipsLab;

@end

@implementation MoreTipsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"温馨提示";
    self.tipsLab.text = [NSString stringWithFormat:@"定责环节结束\n请告知车主查收短信并按短信提示操作！"];
}

- (IBAction)btnClicked:(id)sender
{
    NSArray *arr = self.navigationController.viewControllers;
    [self.navigationController popToViewController:arr[1] animated:YES];
}

- (void)didReceiveMemoryWarning
{
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
