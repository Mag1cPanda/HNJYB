//
//  SafetyTipsViewController.h
//  CZT_HN_Longrise
//
//  Created by OSch on 16/5/14.
//  Copyright © 2016年 OSch. All rights reserved.
//

#import "CaseBaseViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

@interface SafetyTipsViewController : CaseBaseViewController
<UIAlertViewDelegate,
BMKLocationServiceDelegate,
BMKGeoCodeSearchDelegate>
{
    BOOL locationSuccess;
    //定位服务类
    BMKLocationService *_locService;
    //地理编码
    BMKGeoCodeSearch* _geocodesearch;
    float lat;
    float lon;
    NSString *imageAddress;
}

@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;


@property (weak, nonatomic) IBOutlet UILabel *topLabel;

@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;



@property (weak, nonatomic) IBOutlet UIButton *sureBtn;


@end
