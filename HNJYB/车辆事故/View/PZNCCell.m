//
//  PZNCCell.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/1.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "PZNCCell.h"

@implementation PZNCCell

- (void)awakeFromNib
{
    // Initialization code
    self.layer.borderColor = RGB(235, 235, 235).CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
