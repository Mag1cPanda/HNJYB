//
//  XJSGXTViewController.m
//  HNJYB
//
//  Created by Mag1cPanda on 2016/11/2.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "MoreSGSCViewController.h"
#import "XJSGXTViewController.h"

@interface XJSGXTViewController () < UITextViewDelegate >
{
    UITextView *textView;
}
@end

@implementation XJSGXTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"事故情况描述";

    CGFloat viewWidth = ScreenWidth - 20;

    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, viewWidth, 20)];
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor blackColor];
    lab.text = @"补充情形描述(选填，限80字以内):";
    lab.font = HNFont(16);
    [self.view addSubview:lab];

    textView = [[UITextView alloc] initWithFrame:CGRectMake(10, lab.maxY + 10, viewWidth, 150)];
    textView.layer.borderColor = HNBoardColor;
    textView.font = HNFont(14);
    textView.layer.borderWidth = 1.0;
    textView.layer.cornerRadius = 5;
    [self.view addSubview:textView];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, textView.maxY + 25, viewWidth, 50);
    [btn setTitle:@"提交" forState:0];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    [btn addTarget:self action:@selector(submitBtnClicked) forControlEvents:1 << 6];
    btn.backgroundColor = HNBlue;
    btn.layer.cornerRadius = 5;
    [self.view addSubview:btn];
}

- (void)submitBtnClicked
{
    [textView resignFirstResponder];

    if (textView.text.length > 80)
    {
        SHOWALERT(@"情形描述超出字数范围，请修改");
        return;
    }

    MoreSGSCViewController *vc = [MoreSGSCViewController new];
    vc.selectedItem = @[];
    vc.caseDes = textView.text;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
