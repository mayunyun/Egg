//
//  MineCollectAndHistoryTableViewCell.m
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/15.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MineCollectAndHistoryTableViewCell.h"

@interface MineCollectAndHistoryTableViewCell()
{
    BOOL _isClick;
}
@end

@implementation MineCollectAndHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.imgView.layer.cornerRadius = 5;
    self.imgView.clipsToBounds = YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.deleteBtn setImage:[UIImage imageNamed:@"homeShopCar"] forState:UIControlStateNormal];
    [self.deleteBtn setImage:[UIImage imageNamed:@"垃圾桶"] forState:UIControlStateSelected];
    self.titleLabel.text = [NSString stringWithFormat:@"%@",_model.proname];
    self.priceLabel.text = [NSString stringWithFormat:@"￥ %@",_model.saleprice];
    NSString* baseUrl = HTImgUrl;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",baseUrl,@"productimages",_model.autoname]] placeholderImage:[UIImage imageNamed:@"default_img_cell"]];
    
}

- (IBAction)deleteBtnClick:(id)sender {
    _isClick = !_isClick;
    if (_transVaule) {
        _transVaule(_isClick);
    }
}
@end
