//
//  lconsCollectionViewCell.h
//  BaseFrame
//
//  Created by LONG on 2018/3/22.
//  Copyright © 2018年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYYMineCollectModel.h"

@interface lconsCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong) MYYMineCollectModel *data;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIButton *seletbut;
- (void)setData:(MYYMineCollectModel *)data;
@end
