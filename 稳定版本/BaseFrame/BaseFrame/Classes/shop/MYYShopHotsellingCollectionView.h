//
//  MYYShopHotsellingCollectionView.h
//  BaseFrame
//
//  Created by apple on 17/5/9.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYYShopHotsellingCollectionView : UICollectionView<UICollectionViewDataSource>

@property (nonatomic,strong)NSArray* dataArr;
- (id)initWithFrame:(CGRect)frame;


@end
