//
//  MoreCarViewController.m
//  HNJYB
//
//  Created by Mag1cPanda on 16/8/1.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "MoreCarViewController.h"
#import "DJCameraViewController.h"
#import "DJCameraManager.h"
#import "TakePhotoCell.h"
#import "AccidentHeader.h"
#import "CollectionHeader.h"
#import "CollectionFooter.h"
#import "JCAlertView.h"
#import "SRBlockButton.h"
#import "XZQXViewController.h"
#import "CaseAuditViewController.h"
#import "SRVideoPickerController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MoreCarViewController ()
<DJCameraViewControllerDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate>
{
    UICollectionView *collection;
    NSMutableDictionary *cellDic;
    AccidentHeader *header;
    NSArray *iconArr;
    NSArray *titleArr;
    JCAlertView *jcAlert;
    NSArray *tipsArr;
    
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
    
    MBProgressHUD *hud;
    
    NSString *jfjszStr;
    NSString *jfxszStr;
    NSString *yfjszStr;
    NSString *yfxszStr;
    
    NSData *data;
    
    NSURL *sourceURL;
    NSString *resultPath;
    SRVideoPickerController *vpc;
    UIImage  *firstFrame;
}
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@end

//static NSString *cellId = @"TakePhotoCell";
static NSString *const headerId = @"headerId";
static NSString *const footerId = @"footerId";

@implementation MoreCarViewController

#pragma mark - LifeCycle
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_moviePlayer pause];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_moviePlayer play];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"上传事故照片";
    successCount = 0;
    photoDic = [NSMutableDictionary dictionary];
    uploadBean = [NSMutableDictionary dictionary];
    videoBean = [NSMutableDictionary dictionary];
    cellDic = [NSMutableDictionary dictionary];
    [self initUploadBean:uploadBean];
//    [self getCurrentAreaId];
    [self createUniqueNumber];
    
    iconArr = @[@"ctqf",@"IP015",@"IP016",@"IP017",@"jsz",@"IP018",@"jsz",@"IP018",
                @"video",@"add02",@"add02",@"add02"];
    titleArr = @[@"车头前方照片",@"车尾后方照片",@"擦碰点照片",@"事故侧方照片",@"甲方驾驶证照片",@"甲方行驶证照片",@"乙方驾驶证照片",@"乙方行驶证照片",@"选拍现场视频",@"其他现场照片(选拍)",@"其他现场照片(选拍)",@"其他现场照片(选拍)"];
    tipsArr = @[@"car_double_font",
                @"car_double_behind",
                @"car_double_zhuang",
                @"car_double_other",
                @"me_drive_photo",
                @"me_drive_license",
                @"me_drive_photo",
                @"me_drive_license",
                @""];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 10;
    [layout setHeaderReferenceSize:CGSizeMake(ScreenWidth, 100)];
    [layout setFooterReferenceSize:CGSizeMake(ScreenWidth, 100)];
    
    collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) collectionViewLayout:layout];
    collection.backgroundColor = [UIColor clearColor];
    collection.delegate = self;
    collection.dataSource = self;
//    collection.bounces = NO;
    [self.view addSubview:collection];
    
    for (NSInteger i=0; i<12; i++) {
        NSString *cellId = [NSString stringWithFormat:@"TakePhotoCell%zi",i];
        [collection registerNib:[UINib nibWithNibName:@"TakePhotoCell" bundle:nil] forCellWithReuseIdentifier:cellId];
    }
    [collection registerClass:[CollectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
    [collection registerClass:[CollectionFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
}

#pragma mark - 获取Areaid
-(void)getCurrentAreaId{
    NSMutableDictionary *bean = [NSMutableDictionary dictionary];
    
    NSString *maplon = [NSString stringWithFormat:@"%f",GlobleInstance.imagelon];
    NSString *maplat = [NSString stringWithFormat:@"%f",GlobleInstance.imagelat];
    
    [bean setValue:maplon forKey:@"maplon"];
    [bean setValue:maplat forKey:@"maplat"];
    
    [LSHttpManager requestUrl:HNServiceURL serviceName:@"jjappgetweather" parameters:bean complete:^(id result, ResultType resultType) {
        
        if ([result[@"restate"] isEqualToString:@"1"]) {
            NSLog(@"Areaid -> %@",[Util objectToJson:result]);
            NSString *areaid = result[@"data"];
            GlobleInstance.areaid = areaid;
            [uploadBean setValue:areaid forKey:@"areaid"];
            //获取到areaid之后生成caseno
            [self createUniqueNumber];
        }
        
    }];
}

#pragma mark - 获取案件编号
-(void)createUniqueNumber
{
    //    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *bean = [NSMutableDictionary dictionary];
    [bean setValue:GlobleInstance.areaid forKey:@"areaid"];
    [bean setValue:GlobleInstance.userflag forKey:@"username"];
    [bean setValue:GlobleInstance.token forKey:@"token"];
    
    [LSHttpManager requestUrl:HNServiceURL serviceName:@"kckpCreateAppCaseNo" parameters:bean complete:^(id result, ResultType resultType) {
        
        if ([result[@"restate"] isEqualToString:@"1"]) {
            NSLog(@"案件编号 -> %@",[Util objectToJson:result]);
            NSString *appcaseno = [NSString stringWithFormat:@"%@",result[@"data"][@"appcaseno"]];
            GlobleInstance.appcaseno = appcaseno;
            [uploadBean setValue:appcaseno forKey:@"appcaseno"];
        }
        
    }];
}

-(void)initUploadBean:(NSMutableDictionary *)bean{
    
    NSString *imagelat = [NSString stringWithFormat:@"%f",GlobleInstance.imagelat];
    NSString *imagelon = [NSString stringWithFormat:@"%f",GlobleInstance.imagelon];
    NSString *imageaddress = [NSString stringWithFormat:@"%@",GlobleInstance.imageaddress];
    NSString *appcaseno = [NSString stringWithFormat:@"%@",GlobleInstance.appcaseno];
    
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
    NSLog(@"%@",currentDateStr);
    
    NSString *username = [NSString stringWithFormat:@"%@",GlobleInstance.userflag];
    NSString *token = [NSString stringWithFormat:@"%@",GlobleInstance.token];
    NSString *areaid = [NSString stringWithFormat:@"%@",GlobleInstance.areaid];
    
    [bean setValue:currentDateStr forKey:@"imagedate"];
    [bean setValue:username forKey:@"username"];
    [bean setValue:token forKey:@"token"];
    [bean setValue:areaid forKey:@"areaid"];
    
}

#pragma mark - 拍照
-(void)takePhotoWithIndex:(NSIndexPath *)indexPath
{
    DJCameraViewController *cameraVC = [DJCameraViewController new];
    if (indexPath.item < 8) {
        cameraVC.guideImageName = tipsArr[indexPath.item];
    }
    else {
        cameraVC.guideImageName = @"car_one_zhuang";
    }
    cameraVC.isLandscape = YES;
    cameraVC.isShowWarnImage = YES;
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
    
    NSString *indexStr = [NSString stringWithFormat:@"%zi",cameraVC.index];
    [photoDic setObject:image forKey:indexStr];
}

#pragma mark - 返回按钮点击事件（返回首页）
-(void)backAction{
    [self showEndThisCaseAlert];
}

-(void)showEndThisCaseAlert{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-60, 200)];
    customView.backgroundColor = [UIColor whiteColor];
    customView.layer.cornerRadius = 5;
    customView.clipsToBounds = YES;
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(customView.width/2-30, 20, 60, 60)];
    icon.image = [UIImage imageNamed:@"warn"];
    [customView addSubview:icon];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, icon.maxY+20, customView.width, 20)];
    lab.font = HNFont(14);
    lab.text = @"是否结束本次快处";
    lab.textColor = [UIColor darkGrayColor];
    lab.textAlignment = NSTextAlignmentCenter;
    [customView addSubview:lab];
    
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, lab.maxY+20, customView.width, 1)];
    horizontalLine.backgroundColor = RGB(235, 235, 235);
    [customView addSubview:horizontalLine];
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(customView.width/2, lab.maxY+20, 1, 60)];
    verticalLine.backgroundColor = RGB(235, 235, 235);
    [customView addSubview:verticalLine];
    
    UIColor *color = [UIColor blackColor];
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(0, lab.maxY+21, customView.width/2, 60);
    [confirmBtn setTitle:@"确认" forState:0];
    [confirmBtn setTitleColor:color forState:0];
    [confirmBtn addTarget:self action:@selector(jumpToHome) forControlEvents:1<<6];
    [customView addSubview:confirmBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(confirmBtn.maxX+1, lab.maxY+21, customView.width/2, 60);
    [cancelBtn setTitle:@"暂不" forState:0];
    [cancelBtn setTitleColor:color forState:0];
    [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:1<<6];
    [customView addSubview:cancelBtn];
    
    jcAlert = [[JCAlertView alloc] initWithCustomView:customView dismissWhenTouchedBackground:YES];
    [jcAlert show];
}

-(void)jumpToHome{
    [jcAlert dismissWithCompletion:^{
        NSArray *arr = self.navigationController.viewControllers;
        [self.navigationController popToViewController:arr[1] animated:YES];
    }];
}

-(void)dismiss{
    [jcAlert dismissWithCompletion:nil];
}

#pragma mark - 上传按钮点击事件
-(void)uploadBtnClicked
{
    //使用循环查找是否拍摄了所有必拍照片
    for (NSInteger i=0; i<8; i++) {
        
        NSString *indexStr = [NSString stringWithFormat:@"%zi",i];
        
        if (_qualifiedArr) {
            for (NSDictionary *dic in _qualifiedArr) {
                NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:dic[@"imageurl"]]];
                UIImage *image = [UIImage imageWithData:imgData];
                if ([dic[@"imagetype"] isEqualToString:@"0"] && i == 0) {
                    [photoDic setObject:image forKey:@"0"];
                }
                if ([dic[@"imagetype"] isEqualToString:@"1"] && i == 1) {
                    [photoDic setObject:image forKey:@"1"];
                }
                if ([dic[@"imagetype"] isEqualToString:@"2"] && i == 2) {
                    [photoDic setObject:image forKey:@"2"];
                }
                if ([dic[@"imagetype"] isEqualToString:@"3"] && i == 3) {
                    [photoDic setObject:image forKey:@"3"];
                }
                if ([dic[@"imagetype"] isEqualToString:@"6"] && i == 4) {
                    [photoDic setObject:image forKey:@"4"];
                }
                if ([dic[@"imagetype"] isEqualToString:@"7"] && i == 5) {
                    [photoDic setObject:image forKey:@"5"];
                }
                if ([dic[@"imagetype"] isEqualToString:@"8"] && i == 6) {
                    [photoDic setObject:image forKey:@"6"];
                }
                if ([dic[@"imagetype"] isEqualToString:@"9"] && i == 7) {
                    [photoDic setObject:image forKey:@"7"];
                }
            }
        }
        
        UIImage *image = photoDic[indexStr];
        if (!image) {
            NSString *msg = [NSString stringWithFormat:@"请拍摄%@",titleArr[i]];
            SHOWALERT(msg);
            return;//终止循环
        }
    }
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在上传...";
    
    // 执行任务
    for (int i = 0; i<8; i++) {
        [self uploadImageWith:i];
    }
    
    //如果有视频，则上传视频
    if (self.moviePlayer) {
        [self uploadVideo];
    }
    
    //如果有选拍现场照片，则上传照片
    for (NSInteger i=9; i<12; i++) {
        NSString *indexStr = [NSString stringWithFormat:@"%zi",i];
        UIImage *image = photoDic[indexStr];
        if (image) {
            [self uploadImageWith:i];
        }
    }
    
}

-(void)uploadImageWith:(NSInteger)index{
    
    NSString *indexStr = [NSString stringWithFormat:@"%zi",index];
    UIImage *image = photoDic[indexStr];
    NSString *imageWidth = [NSString stringWithFormat:@"%f",image.size.width];
    NSString *imageHeight = [NSString stringWithFormat:@"%f",image.size.height];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.25);
    NSString *imageBig =  [NSString stringWithFormat:@"%zi",imageData.length/1024];
    
    NSString *imageStr = [Util imageToString:image];
    
    NSNumber *type;
    if (index == 0 ||index == 1 ||index == 2||index == 3) {
        type = [NSNumber numberWithInteger:index];
    }
    else if (index == 4) {
        jfjszStr = imageStr;
        type = @6;
    }
    else if (index == 5) {
        jfxszStr = imageStr;
        type = @7;
    }
    else if (index == 6) {
        yfjszStr = imageStr;
        type = @8;
    }
    else if (index == 7) {
        yfxszStr = imageStr;
        type = @9;
    }
    else {
        type = @20;
    }
    
    NSString *token = [NSString stringWithFormat:@"%@",GlobleInstance.token];
    [uploadBean setValue:token forKey:@"token"];
    [uploadBean setValue:imageStr forKey:@"imageurl"];
    [uploadBean setValue:imageBig forKey:@"imagebig"];
    [uploadBean setValue:imageWidth forKey:@"imagewide"];
    [uploadBean setValue:imageHeight forKey:@"imageheigth"];
    [uploadBean setValue:type forKey:@"imagetype"];
    
    [LSHttpManager requestUrl:HNServiceURL serviceName:@"jjzdsubmitcaseimageinfor" parameters:uploadBean complete:^(id result, ResultType resultType) {
        
        if (result) {
            NSLog(@"%zi -> %@",index,[Util objectToJson:result]);
        }
        
        if ([result[@"restate"] isEqualToString:@"1"]) {
            successCount++;
            hud.labelText = [NSString stringWithFormat:@"%zi/%zi",successCount,photoDic.allKeys.count];
            
            NSDictionary *dataDic = result[@"data"];
            if ([dataDic[@"imagetype"] isEqual:@6]) {
                jfocrname = dataDic[@"ocrname"];
                jfocrcardno = dataDic[@"ocrcardno"];
            }
            if ([dataDic[@"imagetype"] isEqual:@7]) {
                jfocrcarno = dataDic[@"ocrcarno"];
                jfocrvin = dataDic[@"ocrvin"];
                jfocrcartype = dataDic[@"ocrcartype"];
            }
            if ([dataDic[@"imagetype"] isEqual:@8]) {
                yfocrname = dataDic[@"ocrname"];
                yfocrcardno = dataDic[@"ocrcardno"];
            }
            if ([dataDic[@"imagetype"] isEqual:@9]) {
                yfocrcarno = dataDic[@"ocrcarno"];
                yfocrvin = dataDic[@"ocrvin"];
                yfocrcartype = dataDic[@"ocrcartype"];
            }
            
            if (successCount == photoDic.allKeys.count) {
                [hud hide:YES];
                GlobleInstance.photoCount = photoDic.allKeys.count;
                [self showAlertView];
            }

        }
        
    }];
}

#pragma mark - 上传视频
-(void)uploadVideo
{
    NSString *imageWidth = [NSString stringWithFormat:@"%f",firstFrame.size.width];
    NSString *imageHeight = [NSString stringWithFormat:@"%f",firstFrame.size.height];
    NSData *imageData = UIImageJPEGRepresentation(firstFrame, 0.25);
    NSString *imageBig = [NSString stringWithFormat:@"%zi",imageData.length/1024];
    NSString *imageUrl = [Util imageToString:firstFrame];
    
    NSString *videoStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    videoStr = [videoStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    videoStr = [videoStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    videoStr = [videoStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    videoStr = [videoStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    videoStr = [NSString stringWithFormat:@"\"%@\"",videoStr];
    
    NSString *imagelat = [NSString stringWithFormat:@"%f",GlobleInstance.imagelat];
    NSString *imagelon = [NSString stringWithFormat:@"%f",GlobleInstance.imagelon];
    NSString *imageaddress = [NSString stringWithFormat:@"%@",GlobleInstance.imageaddress];
    NSString *appcaseno = [NSString stringWithFormat:@"%@",GlobleInstance.appcaseno];
    NSString *areaid = [NSString stringWithFormat:@"%@",GlobleInstance.areaid];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    [videoBean setValue:appcaseno forKey:@"appcaseno"];
    [videoBean setValue:imagelat forKey:@"imagelat"];
    [videoBean setValue:imagelon forKey:@"imagelon"];
    [videoBean setValue:imageaddress forKey:@"imageaddress"];
    
    [videoBean setValue:currentDateStr forKey:@"imagedate"];
    [videoBean setValue:areaid forKey:@"areaid"];
    [videoBean setValue:videoStr forKey:@"imageurl"];
    [videoBean setValue:imageBig forKey:@"imagebig"];
    [videoBean setValue:imageWidth forKey:@"imagewide"];
    [videoBean setValue:imageHeight forKey:@"imageheigth"];
    [videoBean setValue:@13 forKey:@"imagetype"];
    [videoBean setValue:imageUrl forKey:@"videopicurl"];
    [videoBean setValue:@"" forKey:@"casetelephoe"];
    [videoBean setValue:@"" forKey:@"shoottype"];
    
    [LSHttpManager requestUrl:HNServiceURL serviceName:@"kckpsavevideoinfo" parameters:videoBean complete:^(id result, ResultType resultType) {
        
        if (result) {
            NSLog(@"kckpsavevideoinfo-> %@",[Util objectToJson:result]);
        }
        if ([result[@"restate"] isEqualToString:@"1"]) {
            
        }
        
    }];
}

#pragma mark - 显示上传完成提示框
-(void)showAlertView
{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-60, 200)];
    customView.backgroundColor = [UIColor whiteColor];
    customView.layer.cornerRadius = 5;
    customView.clipsToBounds = YES;
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(customView.width/2-30, 20, 60, 60)];
    icon.image = [UIImage imageNamed:@"IP030"];
    [customView addSubview:icon];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, icon.maxY+20, customView.width, 20)];
    lab.font = HNFont(14);
    lab.text = @"事故照片上传成功，请进入下一步";
    lab.textColor = [UIColor darkGrayColor];
    lab.textAlignment = NSTextAlignmentCenter;
    [customView addSubview:lab];
    
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, lab.maxY+20, customView.width, 1)];
    horizontalLine.backgroundColor = RGB(235, 235, 235);
    [customView addSubview:horizontalLine];
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(customView.width/2, lab.maxY+20, 1, 60)];
    verticalLine.backgroundColor = RGB(235, 235, 235);
    [customView addSubview:verticalLine];
    
    
    UIColor *color = [UIColor blackColor];
    
    SRBlockButton *confirmBtn = [[SRBlockButton alloc] initWithFrame:CGRectMake(0, lab.maxY+21, customView.width/2, 60) title:@"确认" titleColor:color handleBlock:^(SRBlockButton *btn) {
        
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
            if (GlobleInstance.userType == AuxiliaryPolice) {
                CaseAuditViewController *vc = [CaseAuditViewController new];
                [self.navigationController pushViewController:vc animated:YES];
            }
            //交警
            else {
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
    
    SRBlockButton *cancelBtn = [[SRBlockButton alloc] initWithFrame:CGRectMake(confirmBtn.maxX+1, lab.maxY+21, customView.width/2, 60) title:@"返回" titleColor:color handleBlock:^(SRBlockButton *btn) {
        
        [jcAlert dismissWithCompletion:^{
            
        }];
        
    }];
    [customView addSubview:cancelBtn];
    
    jcAlert = [[JCAlertView alloc] initWithCustomView:customView dismissWhenTouchedBackground:YES];
    [jcAlert show];
}

#pragma mark - 视频拍摄完成
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    sourceURL = [info objectForKey:UIImagePickerControllerMediaURL];
    NSLog(@"%@",[NSString stringWithFormat:@"%f s", [self getVideoLength:sourceURL]]);
    NSLog(@"%@",[NSString stringWithFormat:@"%f kb", [self getFileSize:[[sourceURL absoluteString] substringFromIndex:16]]]);
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self convert];
    
    TakePhotoCell *cell = (TakePhotoCell *)[collection cellForItemAtIndexPath:vpc.indexPath];
    cell.icon.hidden = YES;
    cell.titleLab.hidden = YES;
    
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:sourceURL];
    self.moviePlayer.view.frame = cell.contentView.bounds;
    [self.moviePlayer prepareToPlay];
    
    _moviePlayer.controlStyle = MPMovieControlStyleNone;
    _moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    [cell.contentView addSubview:self.moviePlayer.view];
    
    _moviePlayer.contentURL = sourceURL;
    
    data = [[NSData alloc] initWithContentsOfURL:sourceURL];
    
    firstFrame = [_moviePlayer thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
    
    NSLog(@"data.length %zi",data.length);
}

- (void)convert
{//转换时文件不能已存在，否则出错
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:sourceURL options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetLowQuality];
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复，在测试的时候其实可以判断文件是否存在若存在，则删除，重新生成文件即可
        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        resultPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]];
        NSLog(@"%@",resultPath);
        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        exportSession.outputFileType = AVFileTypeMPEG4;
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
         {
             NSLog(@"%zi",exportSession.status);
         }];
    }
}

//此方法可以获取文件的大小，返回的是单位是KB。
- (CGFloat)getFileSize:(NSString *)path
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024;
    }
    return filesize;
}
//此方法可以获取视频文件的时长。
- (CGFloat)getVideoLength:(NSURL *)URL
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:URL options:opts];
    float second = 0;
    second = urlAsset.duration.value/urlAsset.duration.timescale;
    return second;
}


#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = [NSString stringWithFormat:@"TakePhotoCell%zi",indexPath.item];
    TakePhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    UIImage *image = cell.icon.image;
    
    if (!image) {
        
        cell.titleLab.text = titleArr[indexPath.row];
        cell.icon.image = [UIImage imageNamed:iconArr[indexPath.row]];
    
        if (indexPath.item<9) {
            //如果为重拍的照片
            if (_qualifiedArr) {
                for (NSDictionary *dic in _qualifiedArr) {
                    if ([dic[@"imagetype"] isEqualToString:@"0"] && indexPath.row == 0) {
                        [cell.icon sd_setImageWithURL:[NSURL URLWithString:dic[@"imageurl"]] placeholderImage:[UIImage imageNamed:iconArr[indexPath.row]]];
                    }
                    
                    if ([dic[@"imagetype"] isEqualToString:@"1"] && indexPath.row == 1) {
                        [cell.icon sd_setImageWithURL:[NSURL URLWithString:dic[@"imageurl"]] placeholderImage:[UIImage imageNamed:iconArr[indexPath.row]]];
                    }
                    
                    if ([dic[@"imagetype"] isEqualToString:@"2"] && indexPath.row == 2) {
                        [cell.icon sd_setImageWithURL:[NSURL URLWithString:dic[@"imageurl"]] placeholderImage:[UIImage imageNamed:iconArr[indexPath.row]]];
                    }
                    
                    if ([dic[@"imagetype"] isEqualToString:@"3"] && indexPath.row == 3) {
                        [cell.icon sd_setImageWithURL:[NSURL URLWithString:dic[@"imageurl"]] placeholderImage:[UIImage imageNamed:iconArr[indexPath.row]]];
                    }
                    
                    if ([dic[@"imagetype"] isEqualToString:@"6"] && indexPath.row == 4) {
                        [cell.icon sd_setImageWithURL:[NSURL URLWithString:dic[@"imageurl"]] placeholderImage:[UIImage imageNamed:iconArr[indexPath.row]]];
                    }
                    
                    if ([dic[@"imagetype"] isEqualToString:@"7"] && indexPath.row == 5) {
                        [cell.icon sd_setImageWithURL:[NSURL URLWithString:dic[@"imageurl"]] placeholderImage:[UIImage imageNamed:iconArr[indexPath.row]]];
                    }
                    
                    if ([dic[@"imagetype"] isEqualToString:@"8"] && indexPath.row == 6) {
                        [cell.icon sd_setImageWithURL:[NSURL URLWithString:dic[@"imageurl"]] placeholderImage:[UIImage imageNamed:iconArr[indexPath.row]]];
                    }
                    
                    if ([dic[@"imagetype"] isEqualToString:@"9"] && indexPath.row == 7) {
                        [cell.icon sd_setImageWithURL:[NSURL URLWithString:dic[@"imageurl"]] placeholderImage:[UIImage imageNamed:iconArr[indexPath.row]]];
                    }
                    
//                    if ([dic[@"imagetype"] isEqualToString:@"20"] && (indexPath.row == 9 || indexPath.row == 10 || indexPath.row == 11)) {
//                        [cell.icon sd_setImageWithURL:[NSURL URLWithString:dic[@"imageurl"]] placeholderImage:[UIImage imageNamed:iconArr[indexPath.row]]];
//                    }
                }
            }
            
        }
//        else {
//            cell.titleLab.text = @"其他现场照片(选拍)";
//            cell.icon.image = [UIImage imageNamed:@"add02"];
//        }
    }

    return cell;
}

// 和UITableView类似，UICollectionView也可设置段头段尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        CollectionHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
     
        return headerView;
    }
    else if([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        CollectionFooter *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerId forIndexPath:indexPath];
        [footerView.btn addTarget:self action:@selector(uploadBtnClicked) forControlEvents:1<<6];
        return footerView;
    }
    
    return nil;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 8) {
        //拍摄视频
        vpc = [[SRVideoPickerController alloc] init];
        vpc.indexPath = indexPath;
        vpc.delegate = self;
        [self presentViewController:vpc animated:YES completion:nil];
        
    }
    else {
        //拍摄照片
        [self takePhotoWithIndex:indexPath];
    }
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){ScreenWidth,100};
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return (CGSize){ScreenWidth,100};
}


@end
