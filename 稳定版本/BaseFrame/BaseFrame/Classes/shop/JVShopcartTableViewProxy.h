//
//  JVShopcartTableViewProxy.h
//  JVShopcart
//
//  Created by AVGD-Jarvi on 17/3/23.
//  Copyright © 2017年 AVGD-Jarvi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MYYShopHotsellingCollectionView.h"
typedef void(^ShopcartProxyProductSelectBlock)(BOOL isSelected, NSIndexPath *indexPath);
typedef void(^ShopcartProxyBrandSelectBlock)(BOOL isSelected);
typedef void(^ShopcartProxyChangeCountBlock)(NSInteger count, NSIndexPath *indexPath);
typedef void(^ShopcartProxyDeleteBlock)(NSIndexPath *indexPath);
typedef void(^ShopcartProxyStarBlock)(NSIndexPath *indexPath);

@interface JVShopcartTableViewProxy : NSObject <UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *everyDataArray;
@property (nonatomic, assign) float xiaojiCount;//商品小计

@property (nonatomic, strong) UIViewController *viewController;

@property (nonatomic, copy) ShopcartProxyProductSelectBlock shopcartProxyProductSelectBlock;
@property (nonatomic, copy) ShopcartProxyBrandSelectBlock shopcartProxyBrandSelectBlock;
@property (nonatomic, copy) ShopcartProxyChangeCountBlock shopcartProxyChangeCountBlock;
@property (nonatomic, copy) ShopcartProxyDeleteBlock shopcartProxyDeleteBlock;
@property (nonatomic, copy) ShopcartProxyStarBlock shopcartProxyStarBlock;

@property (nonatomic,strong)MYYShopHotsellingCollectionView* HotsellingCollectionView;
@property (nonatomic,assign) BOOL isstatus;
- (void)changeShopcarTableViewWithStatus:(BOOL)status;

@end
