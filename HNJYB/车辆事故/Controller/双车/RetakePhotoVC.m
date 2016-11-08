//
//  RetakePhotoVC.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/29.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "MoreRetakeViewController.h"
#import "OneRetakeViewController.h"
#import "RetakePhotoVC.h"

@interface RetakePhotoVC () < UIActionSheetDelegate >

@property (weak, nonatomic) IBOutlet UIButton *retakeBtn;
@property (weak, nonatomic) IBOutlet UIButton *callPolice;
@property (weak, nonatomic) IBOutlet UILabel *tipsLab;

@end

@implementation RetakePhotoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.title = @"事故照片审核";

    //    if (!_notice) {
    //        _notice = @"";
    //    }
    //
    //    if (!_remarks) {
    //        _remarks = @"";
    //    }

    if (_notice)
    {
        if (!_notice)
        {
            _notice = @"";
        }

        if (!_remarks)
        {
            _remarks = @"";
        }

        self.tipsLab.text = [NSString stringWithFormat:@"%@\n由于以上原因，%@交警无法判定责任，您可以选择：", _notice, _remarks];
    }
    else
    {
        self.tipsLab.text = @"抱歉！\n由于您提交的照片不清晰，交警无法判定责任，\n您可以选择：";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)retakePhoto:(id)sender
{
    if (GlobleInstance.isOneCar)
    {
        OneRetakeViewController *vc = [OneRetakeViewController new];
        vc.qualifiedArr = _qualifiedArr;
        vc.unQualifiedArr = _unQualifiedArr;
        vc.isRetake = true;
        [self.navigationController pushViewController:vc animated:YES];
    }

    else
    {
        MoreRetakeViewController *vc = [MoreRetakeViewController new];
        vc.qualifiedArr = _qualifiedArr;
        vc.unQualifiedArr = _unQualifiedArr;
        vc.isRetake = true;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)callPolice:(id)sender
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"确定拨打电话？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
    [action showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex -> %zi", buttonIndex);
    if (buttonIndex == 0)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://122"]]];
    }
}

@end
