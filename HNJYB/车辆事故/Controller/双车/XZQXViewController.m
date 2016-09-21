//
//  XZQXViewController.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/2.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "XZQXViewController.h"
#import "ChooseViewCell.h"
#import "MoreSGSCViewController.h"

@interface XZQXViewController ()
<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table;
    NSArray *titleArr;
    
    NSMutableArray *selectArr;
    NSMutableDictionary *selectDic;
    UITextView *textView;
}
@end

@implementation XZQXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择事故形态";
    selectDic = [NSMutableDictionary dictionary];
    [self initDataArray];
    
    CGFloat viewWidth = ScreenWidth-20;
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, viewWidth, ScreenHeight-64) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource  = self;
    table.backgroundColor = HNBackColor;
    table.showsVerticalScrollIndicator = NO;
    table.allowsMultipleSelection = YES;
    [self.view addSubview:table];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 300)];
    footer.backgroundColor = HNBackColor;
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, viewWidth, 20)];
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor blackColor];
    lab.text = @"补充情形描述(选填，限80字以内):";
    lab.font = HNFont(16);
    [footer addSubview:lab];
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(0, lab.maxY+10, viewWidth, 150)];
    textView.layer.borderColor = HNBoardColor;
    textView.layer.borderWidth = 1.0;
    textView.layer.cornerRadius = 5;
    [footer addSubview:textView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame  = CGRectMake(0, textView.maxY+25, viewWidth, 50);
    [btn setTitle:@"提交" forState:0];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    [btn addTarget:self action:@selector(submitBtnClicked) forControlEvents:1<<6];
    btn.backgroundColor = HNBlue;
    btn.layer.cornerRadius = 5;
    [footer addSubview:btn];
    table.tableFooterView = footer;
    
    
    for (int i=0; i<titleArr.count; i++) {
        NSString *cellId = [NSString stringWithFormat:@"ChooseViewCell%d",i];
        [table registerNib:[UINib nibWithNibName:@"ChooseViewCell" bundle:nil] forCellReuseIdentifier:cellId];
    }
    
}

-(void)initDataArray{
    selectArr = [NSMutableArray array];
    titleArr = @[@"同车道行驶的车辆追撞前车尾部的",
                 @"借道通行或变更车道时未让正常行驶的车辆先行的",
                 @"通过没有交通信号的交叉路口时，未让优先通行的一方先行的",
                 @"相对方向来车左转弯车辆未让直行车辆，或右转弯车辆未让左转弯车辆先行的",
                 @"不按照交通信号指示通行的",
                 @"交叉路口先放行车辆未驶离路口时，后放行车辆未让行的",
                 @"在道路上会车不按规定通行或让行的",
                 @"逆向行驶的",
                 @"不按规定强行超车的",
                 @"行经交叉路口、窄桥、弯道、陡坡、隧道、人行横道路段时超车的",
                 @"在只有一条机动车道的道路上，从前车右侧超越的",
                 @"遇前方车辆停车排队或者缓慢行驶时，从前方车辆两侧穿插或者超越行驶的",
                 @"在车道减少的路口、路段，遇前方车辆停车排队或者缓慢行驶的，不依次交替驶入路口、路段的",
                 @"在禁止掉头或者在允许掉头的地方未让正常行驶车辆先行的",
                 @"倒车、溜车、车辆失控与其他车辆发生碰撞的",
                 @"在专用车道内行驶或驶入禁行线的",
                 @"开关车门造成交通事故的",
                 @"车辆进出停车场、停车位或者由路边、非机动车道进出道路与正常行驶车辆、停放车辆发生交通事故的，及在机动车道上违法停车的",
                 @"车辆装载货物超长、超宽、超高部分或者货物在遗洒、飘散过程中导致交通事故的",
                 @"不按规定牵引车辆造成交通事故的",
                 @"单方发生交通事故的",
                 @"其他情形",];
    
    for (int i=0; i<titleArr.count; i++) {
        [selectArr addObject:@"0"];
    }
}

-(void)submitBtnClicked
{
    if (![selectArr  containsObject:@"1"]) {
        SHOWALERT(@"请选择事故形态");
        return;
    }
    
    if (textView.text.length >80) {
        SHOWALERT(@"情形描述超出字数范围，请修改");
        return;
    }
    
    MoreSGSCViewController *vc = [MoreSGSCViewController new];
    vc.selectedItem = selectArr;
    vc.caseDes = textView.text;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - table Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return titleArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = [NSString stringWithFormat:@"ChooseViewCell%zi",indexPath.section];
    ChooseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.chooseTitle.text = titleArr[indexPath.section];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == titleArr.count-1) {
        return 10;
    }
    else return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-20, 10)];
    view.backgroundColor = HNBackColor;
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-20, 10)];
    view.backgroundColor = HNBackColor;
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.indexPathsForSelectedRows.count <= 3)
    {
        selectArr[indexPath.section] = @"1";
        
        ChooseViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithHexString:@"ffb359"];
        cell.chooseTitle.textColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.tintColor = [UIColor whiteColor];
    }
    
    else {
        [table deselectRowAtIndexPath:indexPath animated:YES];
        SHOWALERT(@"最多只能选择三种事故形态！");
    }
    NSLog(@"count -> %zi",tableView.indexPathsForSelectedRows.count);
    NSLog(@"%@",selectArr);
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectArr[indexPath.section] = @"0";
    
    ChooseViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.chooseTitle.textColor = [UIColor darkGrayColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
}


@end
