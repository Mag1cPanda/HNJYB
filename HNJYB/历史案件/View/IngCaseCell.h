//
//  IngCaseCell.h
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/4.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaseModel.h"

@interface IngCaseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *jfcp;
@property (weak, nonatomic) IBOutlet UILabel *yfcp;
@property (weak, nonatomic) IBOutlet UILabel *tjsj;

@property (weak, nonatomic) IBOutlet UIButton *jxclBtn;

@property (nonatomic, strong) CaseModel *model;

@end
