//
//  MYYMyOrderViewController.h
//  BaseFrame
//
//  Created by apple on 17/5/10.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "MYYMyOrderHeaderTitleView.h"
#import "MYYAllOrderViewController.h"
#import "MYYPayMentOrderViewController.h"
#import "MYYFaHuoViewController.h"
#import "MYYGoodsOrderViewController.h"
#import "MYYCompleteOrderViewController.h"

@interface MYYMyOrderViewController : BaseViewController<MYYMyOrderHeaderTitleViewDelegate,UIScrollViewDelegate>
//头部的选项卡
@property(nonatomic,strong) MYYMyOrderHeaderTitleView *titleView;

//滚动条
@property(nonatomic,strong) UIScrollView *scrollView;

//大数组，子控制器的
@property(nonatomic,strong) NSMutableArray *childViews;

@end
