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
/*
 [{"proid":16,"type":0,"orderid":179,"proname":"山鸡蛋","count":1,"price":11,"autoname":"9f046bcf1bfc4a16b0c806967843c3d5.jpg"}]
 */
@end
