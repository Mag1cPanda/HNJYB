//
//  CaseDetailCell.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/9.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "CaseDetailCell.h"

@implementation CaseDetailCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    _caseNum.text = dataDic[@"casenumber"];
    _submitTime.text = dataDic[@"casehaptime"];
    _casePlace.text = dataDic[@"caseaddress"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
