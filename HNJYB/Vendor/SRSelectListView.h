//
//  SRSelectListView.h
//  下拉控件
//
//  Created by Mag1cPanda on 16/5/23.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SRSelectListView;

@protocol SRSelectListViewDelegate <NSObject>

@optional
-(void)selectListView:(SRSelectListView *)selectListView index:(NSInteger)index content:(NSString *)content;
@end

typedef void (^HandleBlock)(NSInteger index,id content);

@interface SRSelectListView : UIView
<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table;
    NSInteger selectIndex;
    BOOL show;
}

@property(nonatomic,assign) id<SRSelectListViewDelegate> delegate;

@property (nonatomic, strong) UIButton *bodyView;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIView *currentView;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *iconName;

@property (nonatomic, strong) UIFont *font;//标题文字大小
@property (nonatomic, strong) UIColor *textColor;//标题文字颜色
@property (nonatomic, assign) NSInteger textAlignment;//标题文字对齐方式

//弹出view的宽度，默认和控件本身一样宽
@property (nonatomic, assign) CGFloat dropWidth;
//弹出view的文字大小
@property (nonatomic, strong) UIFont *dropFont;
//弹出view的文字颜色
@property (nonatomic, strong) UIColor *dropTextColor;
//弹出view的选中文字颜色
@property (nonatomic, strong) UIColor *selectedTextColor;
//弹出view的文字对齐方式
@property (nonatomic, assign) NSInteger dropTextAlignment;
//选取后能否再次编辑
@property (nonatomic, assign) BOOL canEdit;
//是否显示选中标签
@property (nonatomic, assign) BOOL showCheckMark;
//选中后是否改变标题
@property (nonatomic, assign) BOOL changeTitle;
//数据源
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, copy) HandleBlock block;

@end
