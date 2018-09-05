//
//  MYYShopAddrModel.h
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/12.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface MYYShopAddrModel : BaseModel
@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* villageid;
@property (nonatomic,strong)NSString* provinceid;
@property (nonatomic,strong)NSString* phone;
@property (nonatomic,strong)NSString* province;
@property (nonatomic,strong)NSString* custid;
@property (nonatomic,strong)NSString* area;
@property (nonatomic,strong)NSString* address;
@property (nonatomic,strong)NSString* cityid;
@property (nonatomic,strong)NSString* city;
@property (nonatomic,strong)NSString* areaid;
@property (nonatomic,strong)NSString* village;
@property (nonatomic,strong)NSString* isdefault;
@property (nonatomic,strong)NSString* custname;
/*
 id = 59;
 villageid = 3667;
 provinceid = 2;
 phone = "18353130831";
 province = "北京市";
 custid = 41;
 area = "东城区";
 address = "";
 cityid = 3647;
 city = "北京市";
 areaid = 146;
 village = "东城二";
 isdefault = 1;
 custname = "18353130831"
 */
@end
