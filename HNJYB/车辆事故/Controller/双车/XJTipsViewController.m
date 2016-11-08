//
//  XJTipsViewController.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/24.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "OneSGSCViewController.h"
#import "XJTipsViewController.h"
//#import "XZQXViewController.h"
#import "AccidentHeader.h"
#import "XJSGXTViewController.h"

@interface XJTipsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@property (weak, nonatomic) IBOutlet UIView *header;

@end

@implementation XJTipsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"温馨提示";
    self.tipLab.text = @"您的现场拍照信息已经通过审核！\n请快速将车辆移至不影响交通的安全地点！\n引起交通拥堵可能会受到处罚！";
    self.backBtn.hidden = YES;

    AccidentHeader *header = [[AccidentHeader alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    header.topLab.text = @"请您将车辆快速移至";
    header.topLab.layer.cornerRadius = 0;
    header.topLab.layer.borderColor = nil;
    header.topLab.layer.borderWidth = 0;
    header.topLab.font = HNFont(15);
    header.bottemLab.text = @"不影响交通安全的地点";
    [self.header addSubview:header];
}

- (void)backAction
{
}

- (IBAction)carMoved:(id)sender
{
    if (GlobleInstance.isOneCar)
    {
        OneSGSCViewController *vc = [OneSGSCViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }

    else
    {
        XJSGXTViewController *vc = [XJSGXTViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
