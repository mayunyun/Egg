//
//  MerchantCollectionViewCell.m
//
//  Created by Root on 2017/10/24.
//  Copyright © 2017年 whwy. All rights reserved.
//

#import "MerchantCollectionViewCell.h"

@implementation MerchantCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}
-(void)setModel:(AllProModel *)model{
    _model = model;
    NSString* url = HTImgUrl;
    NSString * folder = @"productimages/";
    NSURL * urls = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",url,folder,model.autoname]];
    [self.GoodImg sd_setImageWithURL:urls placeholderImage:[UIImage imageNamed:@""]];
    self.GoodTitle.text = model.proname;
    self.PriceLabel.text = [NSString stringWithFormat:@"%@",model.saleprice];
}


@end
