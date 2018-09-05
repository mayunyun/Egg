//
//  MYYShopOrderModel.h
//  BaseFrame
//
//  Created by apple on 17/5/11.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYYShopOrderModel : NSObject

@property(nonatomic,copy)NSString *custid;
@property(nonatomic,copy)NSString *proid;
@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *proname;
@property(nonatomic,copy)NSString *count;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *specification;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *autoname;
@property(nonatomic,copy)NSString *money;

/*
 {
 custid = 31;
 proid = 16;
 id = 81;
 proname = "山鸡蛋";
 count = 1;
 price = 11;
 specification = "125";
 type = 0;
 autoname = "9f046bcf1bfc4a16b0c806967843c3d5.jpg";
 money = 11
	}
 */

@end
