//
//  MYYTypeDetailsTableViewCell.h
//  BaseFrame
//
//  Created by apple on 17/5/3.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeFavorableModel.h"
@interface MYYTypeDetailsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIButton *shopCarBtn;
- (IBAction)shopCarBtnClick:(id)sender;

@property (nonatomic,strong)HomeFavorableModel* model;
//block声明
@property (nonatomic, copy) void (^transVaule)(HomeFavorableModel* model);
@end
