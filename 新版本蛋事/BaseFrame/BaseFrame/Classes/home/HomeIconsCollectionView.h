//
//  HomeIconsCollectionView.h
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/3.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeIconsCollectionView : UICollectionView<UICollectionViewDataSource>

@property (nonatomic,strong)NSArray* dataArr;
- (id)initWithFrame:(CGRect)frame;

@end
