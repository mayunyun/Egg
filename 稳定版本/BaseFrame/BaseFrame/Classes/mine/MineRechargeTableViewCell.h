//
//  MineRechargeTableViewCell.h
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/15.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYYMineRechrageModel.h"
@interface MineRechargeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;

@property (nonatomic,strong)MYYMineRechrageModel *model;
@end
