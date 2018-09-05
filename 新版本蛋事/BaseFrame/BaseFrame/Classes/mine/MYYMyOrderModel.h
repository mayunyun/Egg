//
//  MYYMyOrderModel.h
//  BaseFrame
//
//  Created by apple on 17/5/12.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYYMyOrderClassModer.h"
@interface MYYMyOrderModel : NSObject


@property (nonatomic, copy) NSString *Id;

@property (nonatomic, copy) NSString *createtime;//时间

@property (nonatomic, copy) NSString *orderstatus;//订单状态 0待付款 1待发货 2待收货 3待评价 4订单完成

@property (nonatomic, copy) NSString *totalmoney;

@property (nonatomic, copy) NSString *totalcount;
@property (nonatomic, copy) NSString *detcount;

@property (nonatomic, copy) NSString *custname;

@property (nonatomic,strong)NSString* orderno;
@property (nonatomic,strong)NSMutableArray<MYYMyOrderClassModer *> *orderprolist;



/*
 
 salerid = 0;
 spstatus = 0;
 totalmoney = 20;
 totalcount = 4;
 salername = "";
 orderno = "DD201705110008";
 rechargemoney = 0;
 custname = "";
 custphone = "18754153541";
 spnodename = "";
 score = 0;
 uuid = "b9b577dd-c8b5-4662-88ce-bf2158c8ef25";
 custid = 31;
 areaid = 146;
 id = 172;
 payno = "";
 provinceid = 2;
 custaddress = "erterte";
 paymethod = 2;
 cityid = 3647;
 villageid = 3666;
 orderstatus = 1;
 ispay = 1;
 note = "";
 logisticsid = 0;
 createtime = "2017-05-11 15:17:10";
 ordertype = 0;
 rechargeid = 0;
 logisticsname = ""
 
 
 */
@end
