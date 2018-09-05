//
//  MYYAddManageTableViewCell.m
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/11.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYAddManageTableViewCell.h"

@implementation MYYAddManageTableViewCell

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
    self.titleLabel.text = [NSString stringWithFormat:@"%@",self.model.custname];
    self.phoneLabel.text = [NSString stringWithFormat:@"%@",self.model.phone];
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@",self.model.province,self.model.city,self.model.area,self.model.village,self.model.address];
    if (!IsEmptyValue(self.model.isdefault)&&[self.model.isdefault integerValue]==1) {
        [self.defaultBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
    }else{
        [self.defaultBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    }
    
}

- (IBAction)defaultBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(defaultBtnClick:Id:)]) {
        [_delegate defaultBtnClick:sender Id:[NSString stringWithFormat:@"%@",self.model.Id]];
    }
}
- (IBAction)editBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(editBtnClick:model:)]) {
        [_delegate editBtnClick:sender model:self.model];
    }
}
- (IBAction)deleteBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(deleteBtnClick:model:)]) {
        [_delegate deleteBtnClick:sender model:self.model];
    }
}
@end
