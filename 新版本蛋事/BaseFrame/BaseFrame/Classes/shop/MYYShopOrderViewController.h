//
//  MYYShopOrderViewController.h
//  BaseFrame
//
//  Created by apple on 17/5/9.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface MYYShopOrderViewController : BaseViewController
@property (nonatomic, assign)NSInteger next;//1 来自购物车  0来自商品
@property (nonatomic, strong)NSArray *dataArr;//购物车
@property (nonatomic, assign)float xiaojicount;//小计

//立即购买
@property (nonatomic, strong)NSString *Id;
@property (nonatomic, strong)NSString *type;
@property (nonatomic, strong)NSString *proid;
@property (nonatomic, strong)NSString *count;
@property (nonatomic, strong)NSString *proprice;
@property (nonatomic, strong)NSString *proname;
@property (nonatomic, strong)NSString *specification;



@end
