//
//  JVShopcartHeaderView.m
//  JVShopcart
//
//  Created by AVGD-Jarvi on 17/3/23.
//  Copyright © 2017年 AVGD-Jarvi. All rights reserved.
//

#import "JVShopcartHeaderView.h"
#import "Masonry.h"

@interface JVShopcartHeaderView ()

@property (nonatomic, strong) UIView *shopcartHeaderBgView;



@end

@implementation JVShopcartHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self addSubview:self.shopcartHeaderBgView];
    [self.shopcartHeaderBgView addSubview:self.allSelectButton];
    [self.shopcartHeaderBgView addSubview:self.brandLable];
    [self.shopcartHeaderBgView addSubview:self.xiaojiLab];
    [self.shopcartHeaderBgView addSubview:self.moneyLable];

}

- (void)configureShopcartHeaderViewWithBrandName:(NSString *)brandName brandSelect:(BOOL)brandSelect {
    self.allSelectButton.selected = brandSelect;
    self.brandLable.text = @"生鲜自营";
    self.moneyLable.text = brandName;
}

- (void)allSelectButtonAction {
    self.allSelectButton.selected = !self.allSelectButton.isSelected;
    
    if (self.shopcartHeaderViewBlock) {
        self.shopcartHeaderViewBlock(self.allSelectButton.selected);
    }
}

- (UIView *)shopcartHeaderBgView {
    if (_shopcartHeaderBgView == nil){
        _shopcartHeaderBgView = [[UIView alloc] init];
        _shopcartHeaderBgView.backgroundColor = [UIColor whiteColor];
    }
    return _shopcartHeaderBgView;
}

- (UIButton *)allSelectButton {
    if (_allSelectButton == nil){
        _allSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allSelectButton setImage:[UIImage imageNamed:@"Unselected"] forState:UIControlStateNormal];
        [_allSelectButton setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
        [_allSelectButton addTarget:self action:@selector(allSelectButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allSelectButton;
}

- (UILabel *)brandLable {
    if (_brandLable == nil){
        _brandLable = [[UILabel alloc] init];
        _brandLable.font = [UIFont systemFontOfSize:14];
        _brandLable.textColor = [UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1];
    }
    return _brandLable;
}
- (UILabel *)xiaojiLab {
    if (_xiaojiLab == nil){
        _xiaojiLab = [[UILabel alloc] init];
        _xiaojiLab.text = @"小计:";
        _xiaojiLab.font = [UIFont systemFontOfSize:13];
        _xiaojiLab.textColor = UIColorFromRGB(0x333333);
    }
    return _xiaojiLab;
}
- (UILabel *)moneyLable {
    if (_moneyLable == nil){
        _moneyLable = [[UILabel alloc] init];
        _moneyLable.font = [UIFont systemFontOfSize:15];
        _moneyLable.textColor = [UIColor redColor];
    }
    return _moneyLable;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.shopcartHeaderBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.allSelectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopcartHeaderBgView).offset(10);
        make.centerY.equalTo(self.shopcartHeaderBgView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.brandLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopcartHeaderBgView).offset(50);
        make.top.bottom.equalTo(self.shopcartHeaderBgView);
    }];
    [self.moneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shopcartHeaderBgView).offset(-15);
        make.top.bottom.equalTo(self.shopcartHeaderBgView);
    }];
    [self.xiaojiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moneyLable.mas_left).offset(-1);
        make.top.bottom.equalTo(self.shopcartHeaderBgView);
    }];
}


@end
