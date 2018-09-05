//
//  MYYAddManageViewController.h
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/11.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//


#import "BaseViewController.h"
#import "MYYMinesearchAddressModel.h"

@interface MYYAddManageViewController : BaseViewController

@property (nonatomic,strong)NSString* controller;//@"1"订单，@"0"个人中心
@property (nonatomic, copy) void (^transVaule)(MYYMinesearchAddressModel* model);
@end
