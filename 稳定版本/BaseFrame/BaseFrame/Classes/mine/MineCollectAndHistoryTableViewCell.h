//
//  MineCollectAndHistoryTableViewCell.h
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/15.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYYMineCollectModel.h"
@interface MineCollectAndHistoryTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
- (IBAction)deleteBtnClick:(id)sender;
//block声明
@property (nonatomic, copy) void (^transVaule)(BOOL isClick);
@property (nonatomic,strong)MYYMineCollectModel* model;
@end
