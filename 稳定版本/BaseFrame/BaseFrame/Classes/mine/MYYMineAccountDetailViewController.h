//
//  MYYMineAccountDetailViewController.h
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/16.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "RegistReferModel.h"

@interface MYYMineAccountDetailViewController : BaseViewController

@property (nonatomic,strong)NSString* controller;//1,账户2，姓名3，电话4，修改密码
@property (nonatomic,strong)RegistReferModel* usermodel;
@end
