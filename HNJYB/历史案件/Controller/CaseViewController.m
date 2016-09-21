//
//  CaseViewController.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/7/28.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "CaseViewController.h"
#import "HMSegmentedControl.h"
#import "iCarousel.h"
#import "IngCaseCell.h"
#import "EdCaseCell.h"
#import "CaseModel.h"
#import "CaseDetailViewController.h"
#import "JFCreateProtocolVC.h"
#import "OneSGSCViewController.h"
#import "XZQXViewController.h"
#import "UIScrollView+EmptyDataSet.h"

@interface CaseViewController ()
<iCarouselDataSource,
iCarouselDelegate,
UITableViewDataSource,
UITableViewDelegate,
DZNEmptyDataSetDelegate,
DZNEmptyDataSetSource>
{
    UITableView *ingTable;
    UITableView *edTable;
    NSMutableArray *ingArr;
    NSMutableArray *edArr;
    
    MBProgressHUD *hud;
}
@property (nonatomic, strong) HMSegmentedControl *segmentControl;
@property (nonatomic, strong) iCarousel *carousel;
@end

@implementation CaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"历史案件";
    ingArr = [NSMutableArray array];
    edArr = @[].mutableCopy;
    
    [self initSegmentControlAndCarousel];
    
    [self initTableView];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self loadDataWithType:@"0"];
    [self loadDataWithType:@"1"];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - 初始化segmentControl和Carousel
-(void)initSegmentControlAndCarousel{
    
    _carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight-104)];
    _carousel.dataSource = self;
    _carousel.delegate = self;
    _carousel.decelerationRate = 0.7;
    _carousel.type = iCarouselTypeLinear;
    _carousel.pagingEnabled = YES;
    _carousel.edgeRecognition = YES;
    //    _carousel.bounceDistance = 0.4;
    _carousel.bounces = NO;
    [self.view addSubview:_carousel];
    
    _segmentControl = [[HMSegmentedControl alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    _segmentControl.sectionTitles = @[@"处理中", @"已完成"];
    _segmentControl.backgroundColor = HNBackColor;
    _segmentControl.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:15]};
    _segmentControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : HNBlue, NSFontAttributeName : [UIFont systemFontOfSize:16]};
    _segmentControl.selectionIndicatorColor = HNBlue;
    _segmentControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentControl.selectionIndicatorHeight = 2.0;
    [self.view addSubview:_segmentControl];
    
    __weak typeof(self) weakSelf = self;
    
    [self.segmentControl setIndexChangeBlock:^(NSInteger index) {
        
        [weakSelf.carousel scrollToItemAtIndex:index animated:NO];
        
    }];
}

#pragma mark - 初始化tableView
-(void)initTableView{
    
    ingTable = [[UITableView alloc] initWithFrame:_carousel.bounds style:UITableViewStylePlain];
    ingTable.delegate = self;
    ingTable.dataSource = self;
    ingTable.emptyDataSetDelegate = self;
    ingTable.emptyDataSetSource = self;
    ingTable.hidden = YES;
    ingTable.tableFooterView = [UIView new];
    [ingTable registerNib:[UINib nibWithNibName:@"IngCaseCell" bundle:nil] forCellReuseIdentifier:@"IngCaseCell"];
    
    edTable = [[UITableView alloc] initWithFrame:_carousel.bounds style:UITableViewStylePlain];
    edTable.delegate = self;
    edTable.dataSource = self;
    edTable.emptyDataSetDelegate = self;
    edTable.emptyDataSetSource = self;
    edTable.hidden = YES;
    edTable.tableFooterView = [UIView new];
    [edTable registerNib:[UINib nibWithNibName:@"EdCaseCell" bundle:nil] forCellReuseIdentifier:@"EdCaseCell"];
    
}

-(void)loadDataWithType:(NSString *)type{
    
    NSMutableDictionary *bean = [NSMutableDictionary dictionary];
    [bean setValue:GlobleInstance.userid forKey:@"userid"];
    [bean setValue:type forKey:@"querytype"];
    [bean setValue:GlobleInstance.userflag forKey:@"username"];
    [bean setValue:GlobleInstance.token forKey:@"token"];
    
    [LSHttpManager requestUrl:HNServiceURL serviceName:@"kckpjjSearchAllCase" parameters:bean complete:^(id result, ResultType resultType) {
       
        if ([type isEqualToString:@"1"]) {
            [hud hide:YES];
        }
        
        if (result) {
            NSLog(@"所有案件%@ -> %@",type,JsonResult);
            ingTable.hidden = NO;
            edTable.hidden = NO;
        }
        
        if ([result[@"restate"] isEqualToString:@"1"]) {
            
            if ([result[@"data"] isKindOfClass:[NSArray class]]) {
                NSArray *data = result[@"data"];
                for (NSDictionary *dic in data) {
                    CaseModel *model = [[CaseModel alloc] initWithDict:dic];
                    if ([type isEqualToString:@"0"]) {
                        [ingArr addObject:model];
                    }
                    else {
                        [edArr addObject:model];
                    }
                }
            }
        }
        
        if ([type isEqualToString:@"0"]) {
            [ingTable reloadData];
        }
        else {
            
            [edTable reloadData];
        }
        
    }];
}

#pragma mark - iCarousel的代理方法
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 2;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    if (index == 0 ) {
        view = ingTable;
    }
    else {
        view = edTable;
    }

    return view;
}

-(void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    [_segmentControl setSelectedSegmentIndex:carousel.currentItemIndex animated:YES];
    
//    if (carousel.currentItemIndex == 0) {
//        [ingArr removeAllObjects];
//        [self loadDataWithType:@"0"];
//    }
//    else{
//        []
//        [self loadDataWithType:@"1"];
//    }
}

#pragma mark - 继续处理
-(void)continueProcessing:(UIButton *)btn{
    CaseModel *model = ingArr[btn.tag];
    GlobleInstance.appcaseno = model.casenumber;
    //案件信息
    if ([model.state isEqualToString:@"9"]) {
        if ([model.casetype isEqualToString:@"0"]) {
            //单车
            OneSGSCViewController *vc = [OneSGSCViewController new];
            vc.isHistoryPush = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            //双车
            XZQXViewController *vc = [XZQXViewController new];
            vc.isHistoryPush = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
    //生成协议
    else if ([model.state isEqualToString:@"10"]){
//        _icon.image = [UIImage imageNamed:@"scxy"];
        JFCreateProtocolVC *vc = [JFCreateProtocolVC new];
        vc.isHistoryPush = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - tableView Delegate & DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == ingTable) {
        return ingArr.count;
    }
    
    else {
        return edArr.count;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == ingTable) {
        IngCaseCell *cell = [ingTable dequeueReusableCellWithIdentifier:@"IngCaseCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (ingArr.count > indexPath.row) {
            CaseModel *model = ingArr[indexPath.row];
            cell.model = model;
        }
        cell.jxclBtn.tag = indexPath.row;
        [cell.jxclBtn addTarget:self action:@selector(continueProcessing:) forControlEvents:1<<6];
        return cell;
    }
    
    else {
        EdCaseCell *cell = [edTable dequeueReusableCellWithIdentifier:@"EdCaseCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (edArr.count > indexPath.row) {
            CaseModel *model = edArr[indexPath.row];
            cell.model = model;
        }
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == ingTable) {
        return 120;
    }
    
    else {
        return 80;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CaseModel *model;
    if (tableView == ingTable) {
        model = ingArr[indexPath.row];
    }
    
    else {
        model = edArr[indexPath.row];
    }
    CaseDetailViewController *vc = [CaseDetailViewController new];
    vc.casenumber = model.casenumber;
    vc.caseState = model.state;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - DZNEmptyDataSetDelegate Methods
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    UIView *backView = [[UIView alloc] initWithFrame:scrollView.bounds];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 317, 280)];
    imageV.center = scrollView.center;
    imageV.image = [UIImage imageNamed:@"unfinished"];
    [backView addSubview:imageV];
    
    return  backView;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

@end
