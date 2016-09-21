//
//  IngCaseCell.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/4.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "IngCaseCell.h"

@implementation IngCaseCell

- (void)awakeFromNib {
    // Initialization code
    _jxclBtn.layer.borderColor = HNBlue.CGColor;
    [_jxclBtn setTitleColor:HNBlue forState:0];
    _jxclBtn.layer.borderWidth = 1;
}

-(void)setModel:(CaseModel *)model{
    _model = model;
    if ([model.state isEqualToString:@"9"]) {
        _icon.image = [UIImage imageNamed:@"ajxx"];
    }
    
    else if ([model.state isEqualToString:@"7"]) {
        _icon.image = [UIImage imageNamed:@"txt08"];
    }
    
    else if ([model.state isEqualToString:@"10"]){
        _icon.image = [UIImage imageNamed:@"scxy"];
    }
    _jfcp.text = [NSString stringWithFormat:@"甲方车牌:%@",model.ocasecarno];
    _yfcp.text = [NSString stringWithFormat:@"乙方车牌:%@",model.casecarno];
    
    //时间格式处理，服务器返回的时间对了后面.0
    if ([model.casehaptime hasSuffix:@".0"]) {
        NSMutableString *mStr = [NSMutableString stringWithString:model.casehaptime];
        model.casehaptime = [mStr substringToIndex:mStr.length-2];
    }
    _tjsj.text = [NSString stringWithFormat:@"提交时间:%@",model.casehaptime];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
