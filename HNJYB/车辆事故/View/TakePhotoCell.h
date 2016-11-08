//
//  TakePhotoCell.h
//  CollectionTest
//
//  Created by Mag1cPanda on 16/8/2.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TakePhotoCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (nonatomic, assign) BOOL isShoot;

@property (nonatomic, assign) BOOL isRecord;

@end
