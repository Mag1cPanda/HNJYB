//
//  ImgCodeView.m
//  CZT_IOS_Longrise
//
//  Created by OSch on 16/1/14.
//  Copyright © 2016年 程三. All rights reserved.
//

#import "ImgCodeView.h"
#import "UIImageView+WebCache.h"

@implementation ImgCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self loadImgCodeView];
        [self requestCodeView:0];
    }
    return self;
}

- (void)loadImgCodeView
{
    imgCodeView = [[UIImageView alloc] initWithFrame:self.frame];
    imgCodeView.userInteractionEnabled = YES;
    imgCodeView.tag = 1;
    imgCodeView.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(imgCodeViewClick)];
    [imgCodeView addGestureRecognizer:tap];
    [self addSubview:imgCodeView];

    //获取中
    loadCodeView = [[UIImageView alloc] initWithFrame:self.frame];
    loadCodeView.image = [UIImage imageNamed:@"load_codeView"];
    loadCodeView.tag = 2;
    loadCodeView.userInteractionEnabled = YES;
    loadCodeView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    loadCodeView.layer.borderWidth = 1;
    loadCodeView.layer.masksToBounds = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] init];
    [tap1 addTarget:self action:@selector(loadCodeViewClick)];
    [loadCodeView addGestureRecognizer:tap1];
    [self addSubview:loadCodeView];
}

#pragma mark - 图片验证码
- (void)imgCodeViewClick
{
    [self requestCodeView:1];
}

#pragma mark - 图片验证码获取中
- (void)loadCodeViewClick
{
    [self requestCodeView:2];
}

- (void)requestCodeView:(int)codeIndex
{
    if (codeIndex == 1)
    {
        imgCodeView.hidden = YES;
        loadCodeView.hidden = NO;
    }

    [LSHttpManager requestUrl:HNServiceURL serviceName:@"appcodecreater" parameters:nil complete:^(id result, ResultType resultType) {

      if (result)
      {
          NSLog(@"图片验证码 ~ %@", [Util objectToJson:result]);
          if ([result[@"restate"] isEqualToString:@"1"])
          {
              [imgCodeView sd_setImageWithURL:[NSURL URLWithString:result[@"data"][@"img"]] placeholderImage:[UIImage imageNamed:@"unload_codeView"]];
              imgCodeView.hidden = NO;
              loadCodeView.hidden = YES;

              if (self.delegate != nil)
              {
                  [self.delegate requestImgCodeViewID:result[@"data"][@"imgid"]];
              }
          }
          else
          {
              imgCodeView.image = [UIImage imageNamed:@"unload_codeView"];
          }
      }
      else
      {
          imgCodeView.image = [UIImage imageNamed:@"unload_codeView"];
      }

    }];
}

@end
