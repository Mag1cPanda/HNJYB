//
//  WarmTipsViewController.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/7/29.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "PZNCViewController.h"
#import "SituationView.h"
#import "WarmTipsViewController.h"

@interface WarmTipsViewController () < UIActionSheetDelegate >
{
    UIScrollView *scroll;
    NSMutableArray *viewArr;
}
@end

@implementation WarmTipsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"温馨提示";
    viewArr = [NSMutableArray array];
    NSArray *iconArr = @[ @"IP036", @"IP037", @"IP038", @"IP039", @"IP040", @"IP041" ];
    NSArray *titleArr = @[ @"机动车无号牌的，机动车无检验合格标志的，机动车无有效交强险标志的；",
                           @"驾驶人无有效机动车驾驶证的；",
                           @"驾驶人饮酒、服用国家管制的精神药品或麻醉品的；",
                           @"涉及载运爆炸物品、易燃易爆化学药品以及毒害性、放射性、腐蚀性、传染病病原体等危险物品车辆的；",
                           @"碰撞建筑物、公共设施或者其他设施的；",
                           @"有人身伤亡事故；" ];

    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    scroll.scrollEnabled = YES;
    [self.view addSubview:scroll];

    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, ScreenWidth - 20, 20)];
    lab.textColor = HNBlue;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"有以下情景之一的，不适用简易流程处理";
    if (ScreenWidth == 320)
    {
        lab.font = HNFont(15);
    }
    [scroll addSubview:lab];

    for (NSInteger i = 0; i < 6; i++)
    {
        SituationView *view = [[SituationView alloc] initWithFrame:CGRectMake(10, 50 + 110 * i, ScreenWidth - 20, 100)];
        view.backgroundColor = [UIColor whiteColor];
        view.icon.image = [UIImage imageNamed:iconArr[i]];
        view.titleLab.text = titleArr[i];
        [scroll addSubview:view];
        [viewArr addObject:view];
    }

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 735, ScreenWidth - 20, 50);
    btn.titleLabel.font = HNFont(16);
    btn.layer.cornerRadius = 5;
    btn.clipsToBounds = YES;
    [btn setTitle:@"符合快速流程，进入快撤" forState:0];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    [btn setBackgroundImage:[UIImage imageNamed:@"blue"] forState:0];
    [btn addTarget:self action:@selector(nextStep) forControlEvents:1 << 6];
    [scroll addSubview:btn];

    UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    callBtn.frame = CGRectMake(10, btn.maxY + 10, ScreenWidth - 20, 50);
    callBtn.titleLabel.font = HNFont(16);
    callBtn.layer.cornerRadius = 5;
    callBtn.clipsToBounds = YES;
    [callBtn setTitle:@"不符合快速流程，报警" forState:0];
    [callBtn setTitleColor:[UIColor whiteColor] forState:0];
    [callBtn setBackgroundImage:[UIImage imageNamed:@"blue"] forState:0];
    [callBtn addTarget:self action:@selector(callPolice) forControlEvents:1 << 6];
    [scroll addSubview:callBtn];

    scroll.contentSize = CGSizeMake(ScreenWidth, callBtn.maxY + 25);
}

- (void)nextStep
{
    PZNCViewController *vc = [PZNCViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 拨打电话
- (void)callPolice
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
