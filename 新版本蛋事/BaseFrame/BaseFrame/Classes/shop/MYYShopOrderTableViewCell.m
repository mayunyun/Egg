//
//  MYYShopOrderTableViewCell.m
//  BaseFrame
//
//  Created by apple on 17/5/9.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYShopOrderTableViewCell.h"

@implementation MYYShopOrderTableViewCell

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.headerImage.layer.cornerRadius = 5;
    self.headerImage.clipsToBounds = YES;
}

- (void)setDataCount:(NSInteger )count WithModel:(MYYShopOrderModel *)model gouWuCheModel:(JVShopcartBrandModel *)BrandModel{
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",HTImgUrl,@"productimages/",model.autoname]] placeholderImage:[UIImage imageNamed:@"01.png"]];
    
    self.titleName.text = [NSString stringWithFormat:@"%@",model.proname];
    self.priceLab.text = [NSString stringWithFormat:@"￥%@",model.price];
    if (BrandModel.count>0) {
        self.countLab.text = [NSString stringWithFormat:@"x%d",BrandModel.count];
    }else{
        self.countLab.text = [NSString stringWithFormat:@"x%d",count];
    }
}
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
    
}


@end
