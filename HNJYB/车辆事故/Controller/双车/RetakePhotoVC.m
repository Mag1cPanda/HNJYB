//
//  RetakePhotoVC.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/29.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "RetakePhotoVC.h"
#import "OneCarViewController.h"
#import "MoreCarViewController.h"

@interface RetakePhotoVC () <UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIButton *retakeBtn;
@property (weak, nonatomic) IBOutlet UIButton *callPolice;
@property (weak, nonatomic) IBOutlet UILabel *tipsLab;

@end

@implementation RetakePhotoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"事故审核";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)retakePhoto:(id)sender {
    if (GlobleInstance.isOneCar) {
        OneCarViewController *vc = [OneCarViewController new];
        vc.qualifiedArr = _qualifiedArr;
        vc.unQualifiedArr = _unQualifiedArr;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    else {
        MoreCarViewController *vc = [MoreCarViewController new];
        vc.qualifiedArr = _qualifiedArr;
        vc.unQualifiedArr = _unQualifiedArr;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)callPolice:(id)sender {
    
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"确定拨打电话？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles: nil];
    action.delegate = self;
    [action showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"buttonIndex -> %zi",buttonIndex);
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://122"]]];
    }
    
}

@end
