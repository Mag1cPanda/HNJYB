//
//  MoreRetakeViewController.m
//  HNJYB
//
//  Created by Mag1cPanda on 2016/10/19.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "AccidentHeader.h"
#import "CaseAuditViewController.h"
#import "CollectionFooter.h"
#import "CollectionHeader.h"
#import "DJCameraManager.h"
#import "DJCameraViewController.h"
#import "JCAlertView.h"
#import "MoreRetakeViewController.h"
#import "OneSGSCViewController.h"
#import "SRBlockButton.h"
#import "TakePhotoCell.h"
#import "XZQXViewController.h"

@interface MoreRetakeViewController () < DJCameraViewControllerDelegate,
                                         UICollectionViewDataSource,
                                         UICollectionViewDelegate,
                                         UICollectionViewDelegateFlowLayout,
                                         UIImagePickerControllerDelegate,
                                         UINavigationControllerDelegate >
{
    UICollectionView *collection;
    AccidentHeader *header;
    NSArray *iconArr;
    NSArray *titleArr;
    NSArray *tipsArr;
    JCAlertView *jcAlert;

    NSMutableDictionary *uploadBean;
    NSMutableDictionary *videoBean;
    NSMutableDictionary *photoDic;
    NSInteger successCount;

    NSString *jfocrname;
    NSString *jfocrcardno;
    NSString *jfocrcarno;
    NSString *jfocrvin;
    NSString *jfocrcartype;

    NSString *yfocrname;
    NSString *yfocrcardno;
    NSString *yfocrcarno;
    NSString *yfocrvin;
    NSString *yfocrcartype;

    NSString *jfjszStr;
    NSString *jfxszStr;
    NSString *yfjszStr;
    NSString *yfxszStr;
    NSString *jfcjhStr;
    NSString *yfcjhStr;

    MBProgressHUD *hud;
    BOOL isSuccess;
}
@end

static NSString *const headerId = @"headerId";
static NSString *const footerId = @"footerId";

@implementation MoreRetakeViewController

#pragma mark - LifeCycle
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    self.title = @"重拍事故照片";
    successCount = 0;
    photoDic = [NSMutableDictionary dictionary];
    uploadBean = [NSMutableDictionary dictionary];
    [self initUploadBean:uploadBean];

    iconArr = @[ @"ctqf", @"IP015", @"IP016", @"IP017", @"jsz", @"IP018", @"jsz", @"IP018", @"IP018", @"IP018", @"add02", @"video", @"add02", @"add02", @"add02" ];
    titleArr = @[ @"车头前方照片", @"车尾后方照片", @"擦碰点照片", @"事故侧方照片", @"甲方驾驶证照片", @"甲方行驶证照片", @"乙方驾驶证照片", @"乙方行驶证照片", @"甲方车架号照片", @"乙方车架号照片", @"录音", @"选拍现场视频", @"其他现场照片(选拍)", @"其他现场照片(选拍)", @"其他现场照片(选拍)" ];
    tipsArr = @[ @"car_double_font",
                 @"car_double_behind",
                 @"car_double_zhuang",
                 @"car_double_other",
                 @"jsznf",
                 @"xsznf",
                 @"jsznf",
                 @"xsznf",
                 @"",
                 @"",
                 @"",
                 @"",
                 @"",
                 @"",
                 @"" ];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 10;
    [layout setHeaderReferenceSize:CGSizeMake(ScreenWidth, 100)];
    [layout setFooterReferenceSize:CGSizeMake(ScreenWidth, 100)];

    collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) collectionViewLayout:layout];
    collection.backgroundColor = [UIColor clearColor];
    collection.delegate = self;
    collection.dataSource = self;
    //    collection.bounces = NO;
    [self.view addSubview:collection];

    for (NSInteger i = 0; i < 10; i++)
    {
        NSString *cellId = [NSString stringWithFormat:@"TakePhotoCell%zi", i];
        [collection registerNib:[UINib nibWithNibName:@"TakePhotoCell" bundle:nil] forCellWithReuseIdentifier:cellId];
    }

    [collection registerClass:[CollectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
    [collection registerClass:[CollectionFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
}

- (void)initUploadBean:(NSMutableDictionary *)bean
{
    NSString *imagelat = [NSString stringWithFormat:@"%f", GlobleInstance.imagelat];
    NSString *imagelon = [NSString stringWithFormat:@"%f", GlobleInstance.imagelon];
    NSString *imageaddress = [NSString stringWithFormat:@"%@", GlobleInstance.imageaddress];
    NSString *appcaseno = [NSString stringWithFormat:@"%@", GlobleInstance.appcaseno];

    [bean setValue:appcaseno forKey:@"appcaseno"];
    [bean setValue:imagelat forKey:@"imagelat"];
    [bean setValue:imagelon forKey:@"imagelon"];
    [bean setValue:imageaddress forKey:@"imageaddress"];
    [bean setValue:@"1" forKey:@"shoottype"];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    //输出格式为：2010-10-27 10:22:13
    NSLog(@"%@", currentDateStr);

    NSString *username = [NSString stringWithFormat:@"%@", GlobleInstance.userflag];
    NSString *token = [NSString stringWithFormat:@"%@", GlobleInstance.token];
    NSString *areaid = [NSString stringWithFormat:@"%@", GlobleInstance.areaid];

    [bean setValue:token forKey:@"token"];
    [bean setValue:currentDateStr forKey:@"imagedate"];
    [bean setValue:username forKey:@"username"];
    [bean setValue:areaid forKey:@"areaid"];
}

#pragma mark - 拍照
- (void)takePhotoWithIndex:(NSIndexPath *)indexPath
{
    DJCameraViewController *cameraVC = [DJCameraViewController new];
    cameraVC.guideImageName = tipsArr[indexPath.item];
    cameraVC.isLandscape = YES;
    cameraVC.isShowWarnImage = YES;
    cameraVC.noticeString = titleArr[indexPath.item];
    cameraVC.delegate = self;
    cameraVC.index = indexPath.item;
    [self presentViewController:cameraVC animated:YES completion:nil];
}

#pragma mark - 相机代理
- (void)cameraViewController:(DJCameraViewController *)cameraVC ToObtainCameraPhotos:(UIImage *)image
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:cameraVC.index inSection:0];
    TakePhotoCell *cell = (TakePhotoCell *)[collection cellForItemAtIndexPath:indexPath];
    cell.icon.image = image;

    NSString *indexStr = [NSString stringWithFormat:@"%zi", cameraVC.index];
    if (cameraVC.index < 4)
    {
        [photoDic setObject:image forKey:indexStr];
    }
    
    else
    {
        if (cameraVC.index == 4)
        {
            [photoDic setObject:image forKey:@"6"];
        }
        
        if (cameraVC.index == 5)
        {
            [photoDic setObject:image forKey:@"7"];
        }
        
        if (cameraVC.index == 6)
        {
            [photoDic setObject:image forKey:@"8"];
        }
        
        if (cameraVC.index == 7)
        {
            [photoDic setObject:image forKey:@"9"];
        }
        
        if (cameraVC.index == 8)
        {
            [photoDic setObject:image forKey:@"14"];
        }
        
        if (cameraVC.index == 9)
        {
            [photoDic setObject:image forKey:@"15"];
        }
        
    }
}

#pragma mark - 上传按钮点击事件
- (void)uploadBtnClicked
{
    //再次点击按钮，如果已经上传成功，则直接弹出对话框
    if (isSuccess)
    {
        [self showAlertView];
        return;
    }

    NSLog(@"点击上传按钮");

    //使用循环查找是否拍摄了所有必拍照片
    for (NSInteger i = 0; i < _unQualifiedArr.count; i++)
    {
        NSDictionary *dic = _unQualifiedArr[i];
        NSNumber *imagetype = dic[@"imagetype"];
        NSString *tmpStr = [NSString stringWithFormat:@"%@", imagetype];

        UIImage *image = photoDic[tmpStr];

        if (!image)
        {
            NSString *msg = [NSString stringWithFormat:@"%@", dic[@"value"]];
            SHOWALERT(msg);
            return; //终止循环
        }
    }

    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在上传...";

    for (NSInteger i = 0; i < _unQualifiedArr.count; i++)
    {
        NSDictionary *dic = _unQualifiedArr[i];
        NSNumber *num = dic[@"imagetype"];
        NSInteger imagetype = [num integerValue];
        [self uploadImageWith:imagetype];
    }
}

#pragma mark - 上传照片
- (void)uploadImageWith:(NSInteger)index
{
    NSString *indexStr = [NSString stringWithFormat:@"%zi", index];
    UIImage *image = photoDic[indexStr];
    NSString *imageWidth = [NSString stringWithFormat:@"%f", image.size.width];
    NSString *imageHeight = [NSString stringWithFormat:@"%f", image.size.height];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.25);
    NSString *imageBig = [NSString stringWithFormat:@"%zi", imageData.length / 1024];

    NSString *imageStr = [Util imageToString:image];

    //-----------------------

    NSNumber *type;

    if (index == 0 || index == 1 || index == 2 || index == 3)
    {
        type = [NSNumber numberWithInteger:index];
    }
    else if (index == 6)
    {
        jfjszStr = imageStr;
        type = @6;
    }
    else if (index == 7)
    {
        jfxszStr = imageStr;
        type = @7;
    }
    else if (index == 8)
    {
        yfjszStr = imageStr;
        type = @8;
    }
    else if (index == 9)
    {
        yfxszStr = imageStr;
        type = @9;
    }

    else if (index == 14)
    {
        jfcjhStr = imageStr; //甲方车架号
        type = @14;
    }
    else if (index == 15)
    {
        yfcjhStr = imageStr; //乙方车架号
        type = @15;
    }

    //    else {
    //        NSLog(@"上传了其他照片");
    //        type = @20;//其他现场照片
    //    }

    NSString *token = [NSString stringWithFormat:@"%@", GlobleInstance.token];
    [uploadBean setValue:token forKey:@"token"];
    [uploadBean setValue:imageStr forKey:@"imageurl"];
    [uploadBean setValue:imageBig forKey:@"imagebig"];
    [uploadBean setValue:imageWidth forKey:@"imagewide"];
    [uploadBean setValue:imageHeight forKey:@"imageheigth"];
    [uploadBean setValue:type forKey:@"imagetype"];

    [LSHttpManager requestUrl:HNServiceURL serviceName:@"jjzdsubmitcaseimageinfor" parameters:uploadBean complete:^(id result, ResultType resultType) {

      if (result)
      {
          NSLog(@"index -> %zi, result-> %@", index, [Util objectToJson:result]);
      }
      if ([result[@"restate"] isEqualToString:@"1"])
      {
          successCount++;

          NSDictionary *dataDic = result[@"data"];
          if ([dataDic[@"imagetype"] isEqual:@6])
          {
              jfocrname = dataDic[@"ocrname"];
              jfocrcardno = dataDic[@"ocrcardno"];
          }
          if ([dataDic[@"imagetype"] isEqual:@7])
          {
              jfocrcarno = dataDic[@"ocrcarno"];
              jfocrvin = dataDic[@"ocrvin"];
              jfocrcartype = dataDic[@"ocrcartype"];
          }
          if ([dataDic[@"imagetype"] isEqual:@8])
          {
              yfocrname = dataDic[@"ocrname"];
              yfocrcardno = dataDic[@"ocrcardno"];
          }
          if ([dataDic[@"imagetype"] isEqual:@9])
          {
              yfocrcarno = dataDic[@"ocrcarno"];
              yfocrvin = dataDic[@"ocrvin"];
              yfocrcartype = dataDic[@"ocrcartype"];
          }

          hud.labelText = [NSString stringWithFormat:@"%zi/%zi", successCount, photoDic.allKeys.count];
          if (successCount == photoDic.allKeys.count)
          {
              [hud hide:YES];
              isSuccess = YES;
              //                GlobleInstance.photoCount = photoDic.allKeys.count;
              [self showAlertView];

              //照片上传完成
              //                NSMutableDictionary *bean = [NSMutableDictionary dictionary];
              //                [bean setValue:GlobleInstance.appcaseno forKey:@"appcaseno"];
              //                [bean setValue:@"data" forKey:@"data"];
              //                [bean setValue:@"issingle" forKey:@"issingle"];
              //
              //                [LSHttpManager requestUrl:HNServiceURL serviceName:@"jjappUploadImgIsover" parameters:bean complete:^(id result, ResultType resultType) {
              //
              //                    if ([result[@"restate"] isEqualToString:@"1"]) {
              //                        NSLog(@"上传结果 -> %@",[Util objectToJson:result]);
              //                        NSString *appcaseno = [NSString stringWithFormat:@"%@",result[@"data"][@"appcaseno"]];
              //                        GlobleInstance.appcaseno = appcaseno;
              //                        [uploadBean setValue:appcaseno forKey:@"appcaseno"];
              //                    }
              //
              //                }];
          }
      }

      else
      {
          [hud hide:YES];
          SHOWALERT(result[@"redes"]);
          return;
      }
    }];
}

#pragma mark - 显示上传完成提示框
- (void)showAlertView
{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 60, 200)];
    customView.backgroundColor = [UIColor whiteColor];
    customView.layer.cornerRadius = 5;
    customView.clipsToBounds = YES;

    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(customView.width / 2 - 30, 20, 60, 60)];
    icon.image = [UIImage imageNamed:@"IP030"];
    [customView addSubview:icon];

    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, icon.maxY + 20, customView.width, 20)];
    lab.font = HNFont(14);
    lab.text = @"事故照片上传成功，请进入下一步。";
    lab.textColor = [UIColor darkGrayColor];
    lab.textAlignment = NSTextAlignmentCenter;
    [customView addSubview:lab];

    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, lab.maxY + 20, customView.width, 1)];
    horizontalLine.backgroundColor = RGB(235, 235, 235);
    [customView addSubview:horizontalLine];
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(customView.width / 2, lab.maxY + 20, 1, 60)];
    verticalLine.backgroundColor = RGB(235, 235, 235);
    [customView addSubview:verticalLine];

    UIColor *color = [UIColor blackColor];

    SRBlockButton *confirmBtn = [[SRBlockButton alloc] initWithFrame:CGRectMake(0, lab.maxY + 21, customView.width / 2, 60) title:@"确认" titleColor:color handleBlock:^(SRBlockButton *btn) {

      [jcAlert dismissWithCompletion:^{

        //甲方识别结果
        GlobleInstance.jfocrname = jfocrname;
        GlobleInstance.jfocrcardno = jfocrcardno;
        GlobleInstance.jfocrcarno = jfocrcarno;
        GlobleInstance.jfocrvin = jfocrvin;
        GlobleInstance.jfocrcartype = jfocrcartype;

        //乙方识别结果
        GlobleInstance.yfocrname = yfocrname;
        GlobleInstance.yfocrcardno = yfocrcardno;
        GlobleInstance.yfocrcarno = yfocrcarno;
        GlobleInstance.yfocrvin = yfocrvin;
        GlobleInstance.yfocrcartype = yfocrcartype;

        //协警
        if (GlobleInstance.userType == AuxiliaryPolice)
        {
            CaseAuditViewController *vc = [CaseAuditViewController new];
            vc.photoCount = photoDic.allKeys.count;
            [self.navigationController pushViewController:vc animated:YES];
        }
        //交警
        else
        {
            GlobleInstance.jfjszStr = jfjszStr;
            GlobleInstance.jfxszStr = jfxszStr;
            GlobleInstance.yfjszStr = yfjszStr;
            GlobleInstance.yfxszStr = yfxszStr;

            XZQXViewController *vc = [XZQXViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }

      }];

    }];
    [customView addSubview:confirmBtn];

    SRBlockButton *cancelBtn = [[SRBlockButton alloc] initWithFrame:CGRectMake(confirmBtn.maxX + 1, lab.maxY + 21, customView.width / 2, 60) title:@"返回" titleColor:color handleBlock:^(SRBlockButton *btn) {

      [jcAlert dismissWithCompletion:^{

      }];

    }];
    [customView addSubview:cancelBtn];

    jcAlert = [[JCAlertView alloc] initWithCustomView:customView dismissWhenTouchedBackground:YES];
    [jcAlert show];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = [NSString stringWithFormat:@"TakePhotoCell%zi", indexPath.item];
    TakePhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];

    UIImage *image = cell.icon.image;

    if (!image)
    {
        cell.titleLab.text = titleArr[indexPath.row];
        cell.icon.image = [UIImage imageNamed:iconArr[indexPath.row]];
    }

    for (NSDictionary *dic in _qualifiedArr)
    {
        if ([dic[@"imagetype"] isEqualToString:@"0"] && indexPath.row == 0)
        {
            [cell.icon sd_setImageWithURL:[NSURL URLWithString:dic[@"imageurl"]] placeholderImage:[UIImage imageNamed:iconArr[indexPath.row]]];
        }

        if ([dic[@"imagetype"] isEqualToString:@"1"] && indexPath.row == 1)
        {
            [cell.icon sd_setImageWithURL:[NSURL URLWithString:dic[@"imageurl"]] placeholderImage:[UIImage imageNamed:iconArr[indexPath.row]]];
        }

        if ([dic[@"imagetype"] isEqualToString:@"2"] && indexPath.row == 2)
        {
            [cell.icon sd_setImageWithURL:[NSURL URLWithString:dic[@"imageurl"]] placeholderImage:[UIImage imageNamed:iconArr[indexPath.row]]];
        }

        if ([dic[@"imagetype"] isEqualToString:@"3"] && indexPath.row == 3)
        {
            [cell.icon sd_setImageWithURL:[NSURL URLWithString:dic[@"imageurl"]] placeholderImage:[UIImage imageNamed:iconArr[indexPath.row]]];
        }

        if ([dic[@"imagetype"] isEqualToString:@"6"] && indexPath.row == 4)
        {
            [cell.icon sd_setImageWithURL:[NSURL URLWithString:dic[@"imageurl"]] placeholderImage:[UIImage imageNamed:iconArr[indexPath.row]]];
        }

        if ([dic[@"imagetype"] isEqualToString:@"7"] && indexPath.row == 5)
        {
            [cell.icon sd_setImageWithURL:[NSURL URLWithString:dic[@"imageurl"]] placeholderImage:[UIImage imageNamed:iconArr[indexPath.row]]];
        }

        if ([dic[@"imagetype"] isEqualToString:@"8"] && indexPath.row == 6)
        {
            [cell.icon sd_setImageWithURL:[NSURL URLWithString:dic[@"imageurl"]] placeholderImage:[UIImage imageNamed:iconArr[indexPath.row]]];
        }

        if ([dic[@"imagetype"] isEqualToString:@"9"] && indexPath.row == 7)
        {
            [cell.icon sd_setImageWithURL:[NSURL URLWithString:dic[@"imageurl"]] placeholderImage:[UIImage imageNamed:iconArr[indexPath.row]]];
        }

        if ([dic[@"imagetype"] isEqualToString:@"14"] && indexPath.row == 8)
        {
            [cell.icon sd_setImageWithURL:[NSURL URLWithString:dic[@"imageurl"]] placeholderImage:[UIImage imageNamed:iconArr[indexPath.row]]];
        }

        if ([dic[@"imagetype"] isEqualToString:@"14"] && indexPath.row == 9)
        {
            [cell.icon sd_setImageWithURL:[NSURL URLWithString:dic[@"imageurl"]] placeholderImage:[UIImage imageNamed:iconArr[indexPath.row]]];
        }
    }

    return cell;
}

// 和UITableView类似，UICollectionView也可设置段头段尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        //        if (indexPath.section == 0) {
        CollectionHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
        return headerView;
        //        }
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        //        if (indexPath.section == 1) {
        CollectionFooter *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerId forIndexPath:indexPath];
        [footerView.btn addTarget:self action:@selector(uploadBtnClicked) forControlEvents:1 << 6];
        return footerView;
        //        }
    }

    return nil;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //拍摄照片
    [self takePhotoWithIndex:indexPath];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (ScreenWidth - 30) / 2;
    return (CGSize){width, width / 1.64 + 20};
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){ScreenWidth, 100};
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return (CGSize){ScreenWidth, 100};
}

@end
