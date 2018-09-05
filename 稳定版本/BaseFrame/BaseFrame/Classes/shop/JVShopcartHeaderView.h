//
//  JVShopcartHeaderView.h
//  JVShopcart
//
//  Created by AVGD-Jarvi on 17/3/23.
//  Copyright © 2017年 AVGD-Jarvi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ShopcartHeaderViewBlock)(BOOL isSelected);

@interface JVShopcartHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) ShopcartHeaderViewBlock shopcartHeaderViewBlock;

@property (nonatomic, strong) UIButton *allSelectButton;
@property (nonatomic, strong) UILabel *brandLable;
@property (nonatomic, strong) UILabel *xiaojiLab;
@property (nonatomic, strong) UILabel *moneyLable;

- (void)configureShopcartHeaderViewWithBrandName:(NSString *)brandName
                                     brandSelect:(BOOL)brandSelect;

@end
