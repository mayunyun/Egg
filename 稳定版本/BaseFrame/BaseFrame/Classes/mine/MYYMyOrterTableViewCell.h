//
//  MYYMyOrterTableViewCell.h
//  BaseFrame
//
//  Created by apple on 17/5/10.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYYMyOrderModel.h"
#import "MYYMyOrderClassModer.h"
@interface MYYMyOrterTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *ordernoLab;
@property (weak, nonatomic) IBOutlet UIButton *nextBut;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *hejiLab;
@property (weak, nonatomic) IBOutlet UILabel *ordelState;
@property (weak, nonatomic) IBOutlet UIButton *cancelBut;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgHeight;
@property (nonatomic, strong)NSArray *prolistArr;
- (void)configModel:(MYYMyOrderModel *)model;

@end
