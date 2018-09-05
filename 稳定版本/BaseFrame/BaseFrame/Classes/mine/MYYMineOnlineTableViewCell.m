//
//  MYYMineOnlineTableViewCell.m
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/10.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYMineOnlineTableViewCell.h"

@interface MYYMineOnlineTableViewCell ()<UITextFieldDelegate>
{
    BOOL _isSelect1;
    BOOL _isSelect2;
    BOOL _isSelect3;
    BOOL _isSelect4;
}
@end

@implementation MYYMineOnlineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _moneyField.delegate = self;
    _moneyField.keyboardType = UIKeyboardTypeDecimalPad;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)selectBtnClick:(id)sender {
    self.moneyField.text = @"";
    _selectBtn1.selected = YES;
    if (_selectBtn1.selected) {
        _selectBtn2.selected = NO;
        _selectBtn3.selected = NO;
        _selectBtn4.selected = NO;
    }
    [self selectUI];
}
- (IBAction)selectBtn2Click:(id)sender {
    self.moneyField.text = @"";
    _selectBtn2.selected = YES;
    if (_selectBtn2.selected) {
        _selectBtn1.selected = NO;
        _selectBtn3.selected = NO;
        _selectBtn4.selected = NO;
    }
    [self selectUI];
}
- (IBAction)selectBtn3Click:(id)sender {
    self.moneyField.text = @"";
    _selectBtn3.selected = YES;
    if (_selectBtn3.selected) {
        _selectBtn1.selected = NO;
        _selectBtn2.selected = NO;
        _selectBtn4.selected = NO;
    }
    [self selectUI];
}
- (IBAction)selectBtn4Click:(id)sender {
    self.moneyField.text = @"";
    _selectBtn4.selected = YES;
    if (_selectBtn4.selected) {
        _selectBtn1.selected = NO;
        _selectBtn2.selected = NO;
        _selectBtn3.selected = NO;
    }
    [self selectUI];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _selectBtn1.selected = NO;
    _selectBtn2.selected = NO;
    _selectBtn3.selected = NO;
    _selectBtn4.selected = NO;
    [self selectUI];
    
}

- (void)selectUI
{
    if (_selectBtn1.selected) {
        [_selectBtn1 setImage:[UIImage imageNamed:@"grayselect"] forState:UIControlStateNormal];
    }else{
        [_selectBtn1 setImage:[UIImage imageNamed:@"grayunselect"] forState:UIControlStateNormal];
    }
    if (_selectBtn2.selected) {
        [_selectBtn2 setImage:[UIImage imageNamed:@"grayselect"] forState:UIControlStateNormal];
    }else{
        [_selectBtn2 setImage:[UIImage imageNamed:@"grayunselect"] forState:UIControlStateNormal];
    }
    if (_selectBtn3.selected) {
        [_selectBtn3 setImage:[UIImage imageNamed:@"grayselect"] forState:UIControlStateNormal];
    }else{
        [_selectBtn3 setImage:[UIImage imageNamed:@"grayunselect"] forState:UIControlStateNormal];
    }
    if (_selectBtn4.selected) {
        [_selectBtn4 setImage:[UIImage imageNamed:@"grayselect"] forState:UIControlStateNormal];
    }else{
        [_selectBtn4 setImage:[UIImage imageNamed:@"grayunselect"] forState:UIControlStateNormal];
    }
}




@end
