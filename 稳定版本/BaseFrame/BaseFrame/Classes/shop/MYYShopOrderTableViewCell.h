//
//  MYYShopOrderTableViewCell.h
//  BaseFrame
//
//  Created by apple on 17/5/9.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYYShopOrderModel.h"
#import "JVShopcartBrandModel.h"
@interface MYYShopOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *otherLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@property (weak, nonatomic) IBOutlet UILabel *countLab;

- (void)setDataCount:(NSInteger )count WithModel:(MYYShopOrderModel *)model gouWuCheModel:(JVShopcartBrandModel *)BrandModel;

@end
