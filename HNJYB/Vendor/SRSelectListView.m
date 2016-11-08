//
//  SRSelectListView.m
//  下拉控件
//
//  Created by Mag1cPanda on 16/5/23.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "SRSelectListView.h"

//获取设备的物理高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

//获取设备的物理宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@implementation SRSelectListView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setup];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    
    show = NO;
    _showCheckMark = YES;
    
//    self.contentLab = [[UILabel alloc] initWithFrame:CGRectMake(0, SRHeight/2-10, SRWidth-25, 20)];
    self.contentLab = [[UILabel alloc] init];
    if (!self.title) {
        self.title = @"请设置标题";
    }
    
    CGSize size = [self getStringSizeWith:_title boundingRectWithSize:CGSizeMake(self.bounds.size.width-25, self.bounds.size.height) font:[UIFont systemFontOfSize:13.0f]];
    self.contentLab.frame = CGRectMake(0, 0, size.width, self.bounds.size.height);
    self.contentLab.text = self.title;
    [self addSubview:_contentLab];
    
//    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(SRWidth-25, SRHeight/2-2.5, 10, 5)];
    self.icon = [[UIImageView alloc] init];
    self.icon.frame = CGRectMake(_contentLab.maxX+2, self.frame.size.height/2-2.5, 10, 5);
    if (!self.iconName) {
        self.iconName = @"mark1";
    }
    self.icon.image = [UIImage imageNamed:self.iconName];
    [self addSubview:_icon];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}

//计算字符串size
- (CGSize)getStringSizeWith:(NSString*)_mystr boundingRectWithSize:(CGSize)_boundSize font:(UIFont*)font{
    
    if ([_mystr isEqual: [NSNull null]] || _mystr == nil || [_mystr isEqualToString: @""] || [_mystr isEqualToString: @"<null>"])
    {
        return CGSizeMake(_boundSize.width, 20);
    }
    
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize size = [_mystr  boundingRectWithSize:_boundSize options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    
    //    NSDictionary *attribute1 = @{NSFontAttributeName: [UIFont systemFontOfSize:18]};
    //
    //    CGSize size1 = [_mystr boundingRectWithSize:_boundSize options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return size;
}

#pragma mark - view点击事件
-(void)onClick{
    NSLog(@"tap");
    
    if (!self.currentView) {
        NSAssert(NO, @"没有设置显示的view,请设置currentView，参考：selectListView.currentView = self.view");
        return;
    }
    
    _bodyView.hidden = NO;
    table.hidden = NO;
    
    if (!_bodyView) {
        _bodyView = [UIButton new];
        _bodyView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        _bodyView.alpha = 0.5;
        _bodyView.backgroundColor = [UIColor blackColor];
        [_bodyView addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
        
        table = [[UITableView alloc] initWithFrame:CGRectZero];
        table.backgroundColor = [UIColor whiteColor];
        table.delegate = self;
        table.dataSource = self;
        table.tableFooterView = [UIView new];
        table.layer.cornerRadius = 5;
        
        [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        
    }
    
    if(show)
    {
        if([_bodyView superview])
        {
            [_bodyView removeFromSuperview];
        }
        if([table superview])
        {
            [table removeFromSuperview];
        }
    }
    
    else{
        //默认宽度
        if (_dropWidth > ScreenWidth) {
            _dropWidth = ScreenWidth;
        }
        //默认高度
        CGFloat tableHeight = 200;
        
        UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
        CGRect rect=[self convertRect: self.bounds toView:window];;
        
        //设置tableView的位置
        if([UIScreen mainScreen].bounds.size.height - (rect.origin.y + self.frame.size.height) < 200)
        {
            table.frame = CGRectMake(rect.origin.x, ScreenHeight - 200, _dropWidth, tableHeight);
        }
        else
        {
            table.frame = CGRectMake(rect.origin.x, rect.origin.y + self.frame.size.height, _dropWidth, tableHeight);
        }
        
        [self.currentView.window addSubview:_bodyView];
        [self.currentView.window addSubview:table];
    }
    
    show = !show;
    
}


#pragma mark - setter
-(void)setFont:(UIFont *)font{
    _font = font;
    _contentLab.font = font;
}

-(void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    _contentLab.textColor = textColor;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    _contentLab.text = title;
    if (_changeTitle) {
        CGSize size = [self getStringSizeWith:_title boundingRectWithSize:CGSizeMake(self.bounds.size.width-25, self.bounds.size.height) font:[UIFont systemFontOfSize:14.0f]];
        self.contentLab.frame = CGRectMake(0, 0, size.width, self.bounds.size.height);
    }
}

-(void)setIconName:(NSString *)iconName{
    _iconName = iconName;
    _icon.image = [UIImage imageNamed:iconName];
}


-(void)setTextAlignment:(NSInteger)textAlignment{
    _textAlignment = textAlignment;
    _contentLab.textAlignment = textAlignment;
}

-(void)setCanEdit:(BOOL)canEdit{
    
    _canEdit = canEdit;
    //设置选取后能否再次编辑
    if (_icon) {
        //不能编辑则隐藏图标
        _icon.hidden = !canEdit;
    }
    //根据能否编辑决定是否打开交互
    self.userInteractionEnabled = canEdit;
}



#pragma mark UITableView 代理回调函数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_dataArray)
    {
        return _dataArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.tintColor = [UIColor orangeColor];
    
    if (_dropFont) {
        cell.textLabel.font = _dropFont;
    }
    
    if (_dropTextColor) {
        cell.textLabel.textColor = _dropTextColor;
    }
    
    if (_dropTextAlignment) {
        cell.textLabel.textAlignment = _textAlignment;
    }
    
    if (_dataArray.count > indexPath.row) {
        cell.textLabel.text = _dataArray[indexPath.row];
    }
    return  cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (_showCheckMark) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    if (_selectedTextColor) {
        cell.textLabel.textColor = _selectedTextColor;
    }
    
    if (_dataArray.count > indexPath.row) {
        if (_changeTitle) {
            _contentLab.text = _dataArray[indexPath.row];
        }
        if(_delegate && [_delegate respondsToSelector:@selector(selectListView:index:content:)])
        {
            [self.delegate selectListView:self index:indexPath.row content:_dataArray[indexPath.row]];
        }
        
        if (_block) {
            _block(indexPath.row,_dataArray[indexPath.row]);
        }
    }
    _bodyView.hidden = YES;
    table.hidden = YES;
    show = NO;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(void)sr_SelectItemAt:(NSInteger)index{
    if (_dataArray[index] != nil) {
        _contentLab.text = _dataArray[index];
    }
}




@end
