//
//  MYYMyOrderClassModer.h
//  BaseFrame
//
//  Created by apple on 17/5/15.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYYMyOrderClassModer : NSObject
//
@property (nonatomic, copy) NSString *proid;//商品Id
@property (nonatomic, copy) NSString *type;//类型
@property (nonatomic, copy) NSString *orderid;//订单id
@property (nonatomic, copy) NSString *proname;//名称
@property (nonatomic, copy) NSString *count;//数量
@property (nonatomic, copy) NSString *price;//价格
@property (nonatomic, copy) NSString *autoname;//图片
@property (nonatomic, copy) NSString *specification;//规格

/*
 autoname = "";
 changezonescore = 0;
 count = 1;
 id = 696;
 money = 100;
 note = "";
 orderid = 515;
 price = 100;
 proid = 18;
 proname = "\U672c\U5bb6\U86cb";
 specification = 1201;
 type = 1;
 */
@end
