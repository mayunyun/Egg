//
//  MYYTypeDetailsTableViewCell.m
//  BaseFrame
//
//  Created by apple on 17/5/3.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYTypeDetailsTableViewCell.h"

@implementation MYYTypeDetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.imgView.layer.cornerRadius = 5;
    self.imgView.clipsToBounds = YES;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@",_model.proname];
    if (!IsEmptyValue(_model.saleprice)) {
        self.priceLabel.text = [NSString stringWithFormat:@"￥ %@",_model.saleprice];
    }else{
        self.priceLabel.text = [NSString stringWithFormat:@"￥ 0"];
    }
    NSString* baseurl = HTImgUrl;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",baseurl,@"productimages",_model.autoname]] placeholderImage:[UIImage imageNamed:@"default_img_cell"]];
}

- (IBAction)shopCarBtnClick:(id)sender {
    if (_transVaule) {
        _transVaule(_model);
    }
}
@end
