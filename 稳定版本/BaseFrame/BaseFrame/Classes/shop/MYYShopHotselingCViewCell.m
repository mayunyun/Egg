//
//  MYYShopHotselingCViewCell.m
//  BaseFrame
//
//  Created by apple on 17/5/9.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYShopHotselingCViewCell.h"

@implementation MYYShopHotselingCViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.headerView.layer.cornerRadius = 5;
    self.headerView.clipsToBounds = YES;
}
@end
