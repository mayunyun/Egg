//
//  MYYTypeDetailsHeaderTableCell.m
//  BaseFrame
//
//  Created by apple on 17/5/4.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYTypeDetailsHeaderTableCell.h"

@interface MYYTypeDetailsHeaderTableCell ()
{
    BOOL _isClick;
}
@end

@implementation MYYTypeDetailsHeaderTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.hidden = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.shopcartCountViewEditBlock) {
        self.shopcartCountViewEditBlock(self.payCountLabel.text.integerValue);
    }
}
- (void)configureShopcartCountViewWithProductCount:(NSInteger)productCount productStock:(NSInteger)productStock {
    if (productCount == 1) {
        self.reduceBtn.enabled = NO;
        self.addBtn.enabled = YES;
    } else if (productCount == productStock) {
        self.reduceBtn.enabled = YES;
        self.addBtn.enabled = NO;
    } else {
        self.reduceBtn.enabled = YES;
        self.addBtn.enabled = YES;
    }
    self.payCountLabel.text = [NSString stringWithFormat:@"%ld", (long)productCount];
}
- (IBAction)addBtnClick:(id)sender {
    NSInteger count = self.payCountLabel.text.integerValue;
    if (self.shopcartCountViewEditBlock) {
        self.shopcartCountViewEditBlock(++ count);
    }
}
- (IBAction)reduceBtnClick:(id)sender {
    NSInteger count = self.payCountLabel.text.integerValue;
    if (self.shopcartCountViewEditBlock) {
        self.shopcartCountViewEditBlock(-- count);
    }
}
- (IBAction)collectBtnClick:(id)sender {
    _isClick = !_isClick;
    if (_transVaule) {
        _transVaule(_isClick,sender);
    }
}

- (void)upDataWith:(MYYDetailsWebModel *)promodel{
    self.titleLabel.text = [NSString stringWithFormat:@"%@",promodel.proname];
    NSLog(@"%@,%@",self.titleLabel.text,promodel.proname);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}



@end
