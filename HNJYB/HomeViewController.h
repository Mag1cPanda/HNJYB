//
//  HomeViewController.h
//  CZT_HN_Longrise
//
//  Created by OSch on 16/5/12.
//  Copyright © 2016年 OSch. All rights reserved.
//

#import "PublicViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>         //引入base相关所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h> //引入定位功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>           //引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>     //引入检索功能所有的头文件

@interface HomeViewController : PublicViewController < UIAlertViewDelegate,
                                                       BMKLocationServiceDelegate,
                                                       BMKGeoCodeSearchDelegate >
{
    //定位服务类
    BOOL locationSuccess;
    //定位服务类
    BMKLocationService *_locService;
    //地理编码
    BMKGeoCodeSearch *_geocodesearch;
    float lat;
    float lon;
    NSString *imageAddress;
    MBProgressHUD *locHud;
}
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIView *userInfoView;
@property (weak, nonatomic) IBOutlet UIView *caseDealView;
@property (weak, nonatomic) IBOutlet UIView *myCaseInfoView;

@end
