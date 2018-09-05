//
//  MYYMineCollectModel.h
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/15.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface MYYMineCollectModel : BaseModel
@property (nonatomic,strong)NSString* collectid;
@property (nonatomic,strong)NSString* type;
@property (nonatomic,strong)NSString* proid;
@property (nonatomic,strong)NSString* proname;
@property (nonatomic,strong)NSString* saleprice;
@property (nonatomic,strong)NSString* autoname;
@property (nonatomic,strong)NSString* count;
@property (nonatomic,strong)NSString* evalutecount;
@property (nonatomic,strong)NSString* isselect;

/*
 [{"collectid":32,"type":3,"proid":6,"proname":"3","saleprice":3,"autoname":"65fc55efc5364abc88e38a76b9114bd8.png","count":126,"evalutecount":72}]
 */
@end
