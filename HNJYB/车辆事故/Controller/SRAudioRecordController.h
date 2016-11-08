//
//  SRAudioRecordController.h
//  HNJYB
//
//  Created by Mag1cPanda on 2016/11/2.
//  Copyright © 2016年 Mag1cPanda. All rights reserved.
//

#import "CaseBaseViewController.h"

typedef void (^AudioDidUploaded)();

@interface SRAudioRecordController : CaseBaseViewController

@property (nonatomic, copy) AudioDidUploaded audioDidUploaded;

@end
