//
//  lconsCollectionViewCell.m
//  BaseFrame
//
//  Created by LONG on 2018/3/22.
//  Copyright © 2018年 济南联祥技术有限公司. All rights reserved.
//

#import "lconsCollectionViewCell.h"

@implementation lconsCollectionViewCell

- (void)setData:(MYYMineCollectModel *)data
{
    _data = data;
    
    self.titleLab.text = [NSString stringWithFormat:@"%@",_data.proname];
    self.priceLab.text = [NSString stringWithFormat:@"￥ %@",_data.saleprice];
    NSString* baseUrl = HTImgUrl;
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",baseUrl,@"productimages",_data.autoname]] placeholderImage:[UIImage imageNamed:@"default_img_cell"]];
    self.imageview.contentMode = UIViewContentModeScaleAspectFit;

}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
