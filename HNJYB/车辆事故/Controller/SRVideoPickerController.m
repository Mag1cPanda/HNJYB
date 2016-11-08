//
//  SRVideoPickerController.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/22.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "SRVideoPickerController.h"

@interface SRVideoPickerController ()

@end

@implementation SRVideoPickerController
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.sourceType = UIImagePickerControllerSourceTypeCamera;                                                                    //sourcetype有三种分别是camera，photoLibrary和photoAlbum
        NSArray *availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]; //Camera所支持的Media格式都有哪些,共有两个分别是@"public.image",@"public.movie"
        self.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];                                                                //设置媒体类型为public.movie
        self.videoMaximumDuration = 10.0f;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
