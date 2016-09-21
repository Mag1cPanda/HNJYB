//
//  PublicViewController.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/7/28.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "PublicViewController.h"

@interface PublicViewController ()

@end

@implementation PublicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    
    NSArray *arr = self.navigationController.viewControllers;
    if (arr.count > 1) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 0, 40, 40);
        [backBtn addTarget:self action:@selector(backAction) forControlEvents:1<<6];
        
        [backBtn setImage:[UIImage imageNamed:@"IP020"] forState:0];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        self.navigationItem.leftBarButtonItem = item;
    }
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
