//
//  ProvinceModel.h
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/9.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface ProvinceModel : BaseModel
@property (nonatomic,strong)NSString* areaid;
@property (nonatomic,strong)NSString* areaname;
@end

@interface CityModel : BaseModel
@property (nonatomic,strong)NSString* areaid;
@property (nonatomic,strong)NSString* areaname;
@end

@interface ContryModel : BaseModel
@property (nonatomic,strong)NSString* areaid;
@property (nonatomic,strong)NSString* areaname;
@end

@interface ViligeModel : BaseModel
@property (nonatomic,strong)NSString* areaid;
@property (nonatomic,strong)NSString* areaname;
@end

@interface ChargeModel : BaseModel
@property (nonatomic,strong)NSString* accountid;
@property (nonatomic,strong)NSString* accountname;
@end

