//
//  MerchantCollectionViewCell.h
//
//  Created by Root on 2017/10/24.
//  Copyright © 2017年 whwy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllProModel.h"

@interface MerchantCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ImgHeight;
@property (weak, nonatomic) IBOutlet UIImageView *GoodImg;
@property (weak, nonatomic) IBOutlet UILabel *GoodTitle;
@property (weak, nonatomic) IBOutlet UILabel *PriceLabel;

@property (nonatomic,strong)AllProModel * model;
@end
