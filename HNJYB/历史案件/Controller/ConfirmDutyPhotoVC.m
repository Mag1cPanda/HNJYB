//
//  ConfirmDutyPhotoVC.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/9.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "ConfirmDutyPhotoVC.h"
#import "TakePhotoCell.h"

@interface ConfirmDutyPhotoVC ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>
{
    UICollectionView *collection;
    NSArray *iconArr;
    NSArray *titleArr;
    
    NSArray *sortedArr;
}
@end

@implementation ConfirmDutyPhotoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"定责照片";
    sortedArr = [_imgArr sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1,NSDictionary *obj2) {
        NSString *str1 = obj1[@"imagetype"];
        NSString *str2 = obj2[@"imagetype"];
        NSComparisonResult result = [str1 compare:str2];
        return result;
    }];
    
    NSLog(@"sortedArr -> %@",sortedArr);
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 10;
    
    collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) collectionViewLayout:layout];
    collection.backgroundColor = [UIColor clearColor];
    collection.delegate = self;
    collection.dataSource = self;
    [self.view addSubview:collection];
    
    [collection registerNib:[UINib nibWithNibName:@"TakePhotoCell" bundle:nil] forCellWithReuseIdentifier:@"TakePhotoCell"];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    if (section == 0) {
//        return 9;
//    }
//    else return 1;
    return sortedArr.count;;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TakePhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TakePhotoCell" forIndexPath:indexPath];
    cell.layer.borderColor = HNBoardColor;
    cell.layer.borderWidth = 0.5;
    
    NSDictionary *imgDic = sortedArr[indexPath.row];
    
    //利用子线程并发加载图片
    dispatch_queue_t queue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [cell.icon sd_setImageWithURL:[NSURL URLWithString:imgDic[@"imageurl"]]];
    });
    
    cell.titleLab.text = imgDic[@"imagetypename"];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%zi",indexPath.item);
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (ScreenWidth-30)/2;
    return (CGSize){width, width/1.64+20};
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

@end
