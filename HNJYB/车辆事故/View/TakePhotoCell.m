//
//  TakePhotoCell.m
//  CollectionTest
//
//  Created by Mag1cPanda on 16/8/2.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "TakePhotoCell.h"

@implementation TakePhotoCell

- (void)awakeFromNib {
    // Initialization code
    self.icon.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1;
}


//-(void)setIsShoot:(BOOL)isShoot{
//    _isShoot = isShoot;
//}
//
//
//-(void)setIsRecord:(BOOL)isRecord{
//    _isRecord = isRecord;
//}

@end
