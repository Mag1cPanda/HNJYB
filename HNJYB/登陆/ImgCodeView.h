//
//  ImgCodeView.h
//  CZT_IOS_Longrise
//
//  Created by OSch on 16/1/14.
//  Copyright © 2016年 程三. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImgCodeViewDelegate <NSObject>

@required
-(void)requestImgCodeViewID:(NSString *)imgId;

@end
@interface ImgCodeView : UIView
{
    UIImageView *imgCodeView;
    UIImageView *loadCodeView;
}

@property (nonatomic,weak) id<ImgCodeViewDelegate> delegate;
@end
