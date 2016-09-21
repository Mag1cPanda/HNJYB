//
//  CaseDetailCell.h
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/9.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaseDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *caseNum;
@property (weak, nonatomic) IBOutlet UILabel *submitTime;
@property (weak, nonatomic) IBOutlet UILabel *caseState;
@property (weak, nonatomic) IBOutlet UILabel *casePlace;

@property (nonatomic, strong) NSDictionary *dataDic;

@end
