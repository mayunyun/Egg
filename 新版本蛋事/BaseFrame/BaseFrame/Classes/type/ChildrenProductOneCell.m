//
//  ChildrenProductOneCell.m
//  BaseFrame
//
//  Created by 钱龙 on 2018/3/14.
//  Copyright © 2018年 济南联祥技术有限公司. All rights reserved.
//

#import "ChildrenProductOneCell.h"

@implementation ChildrenProductOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)collectionBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (_CollectionBlock) {
        self.CollectionBlock();
    }
    
}

- (IBAction)downBtnClicked:(UIButton *)sender {
    NSInteger count = self.count.text.integerValue;
    -- count;
    [self configureShopcartCountViewWithProductCount:count];
}
- (IBAction)upBtnClicked:(UIButton *)sender {
    NSInteger count = self.count.text.integerValue;
    ++ count;
    [self configureShopcartCountViewWithProductCount:count];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self configureShopcartCountViewWithProductCount:[self.count.text integerValue]];
}
- (void)configureShopcartCountViewWithProductCount:(NSInteger)productCount {
    if (productCount == 1) {
        self.down.enabled = NO;
        self.up.enabled = YES;
    } else {
        self.down.enabled = YES;
        self.up.enabled = YES;
    }
    self.count.text = [NSString stringWithFormat:@"%ld", (long)productCount];
    if (_upBlock) {
        self.upBlock(productCount);
    }
    if (_downBlock) {
        self.downBlock(productCount);
    }
}
-(void)setModel:(MYYDetailsWebModel *)model{
    _model = model;
    self.proname.text = model.proname;
    self.proprice.text = [NSString stringWithFormat:@"￥%@",model.proprice];
    self.guige.text = [NSString stringWithFormat:@"%@",model.specification];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
