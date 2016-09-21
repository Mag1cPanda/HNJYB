//
//  ZRRDViewController.h
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/3.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "PublicViewController.h"
#import "InfoModel.h"

@interface ZRRDViewController : PublicViewController

@property (nonatomic, strong) InfoModel *jfModel;
@property (nonatomic, strong) InfoModel *yfModel;

@property (nonatomic, strong) NSArray *selectedItem;
@property (nonatomic, copy) NSString *caseDes;
@end
