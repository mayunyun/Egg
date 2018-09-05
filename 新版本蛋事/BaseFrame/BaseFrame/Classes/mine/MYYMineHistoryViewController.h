//
//  MYYMineHistoryViewController.h
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/15.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface MYYMineHistoryViewController : BaseViewController

//block声明
@property (nonatomic, copy) void (^transVaule)(BOOL isClick);

@end
