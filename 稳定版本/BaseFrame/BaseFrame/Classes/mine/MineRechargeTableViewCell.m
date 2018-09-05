//
//  MineRechargeTableViewCell.m
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/15.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MineRechargeTableViewCell.h"

@implementation MineRechargeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if ([[NSString stringWithFormat:@"%@",self.model.type] integerValue] == 0) {
        self.typeLabel.text= @"支付宝充值";
    }else if ([[NSString stringWithFormat:@"%@",self.model.type] integerValue] == 1){
        self.typeLabel.text = @"微信充值";
    }else if ([[NSString stringWithFormat:@"%@",self.model.type] integerValue] == 2){
        self.typeLabel.text = @"蛋事卡充值";
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"+ %@",self.model.money];
    self.dateLabel.text = [NSString stringWithFormat:@"%@",self.model.createtime];
}

@end
