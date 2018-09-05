//
//  MYYDetailProPicDetailModel.h
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/10.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface MYYDetailProPicDetailModel : BaseModel
@property (nonatomic,strong)NSString* proid;
@property (nonatomic,strong)NSString* picname;
@property (nonatomic,strong)NSString* folder;
@property (nonatomic,strong)NSString* type;
@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* autoname;

/*
 [{"proid":58,"picname":"001.jpg","folder":"productimages/","type":0,"id":144,"autoname":"d5818e380f73413f9196ccfb127c1551.jpg"}]
 */
@end
