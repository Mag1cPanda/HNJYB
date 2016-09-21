//
//  ChooseViewCell.m
//  CZT_IOS_Longrise
//
//  Created by Mag1cPanda on 16/2/25.
//  Copyright © 2016年 程三. All rights reserved.
//

#import "ChooseViewCell.h"

@implementation ChooseViewCell

- (void)awakeFromNib {
    // Initialization code
    _chooseTitle.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = 1;
    self.layer.borderColor = HNBoardColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
