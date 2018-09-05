//
//  MYYTypeDetailsHeaderTableCell.h
//  BaseFrame
//
//  Created by apple on 17/5/4.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
#import "MYYDetailsWebModel.h"
typedef void(^ShopcartCountViewEditBlock)(NSInteger count);


@interface MYYTypeDetailsHeaderTableCell : UITableViewCell<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet SDCycleScrollView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *collectBtn;
- (IBAction)collectBtnClick:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UIButton *addBtn;
- (IBAction)addBtnClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *reduceBtn;
- (IBAction)reduceBtnClick:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *payCountLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, copy) ShopcartCountViewEditBlock shopcartCountViewEditBlock;
@property (nonatomic,copy) void (^transVaule)(BOOL isClick,UIButton* btn);
- (void)configureShopcartCountViewWithProductCount:(NSInteger)productCount productStock:(NSInteger)productStock;

- (void)upDataWith:(MYYDetailsWebModel *)promodel;
@end
