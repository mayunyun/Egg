//
//  HomeTypeModel.h
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/8.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//  分类

#import "BaseModel.h"

@interface HomeTypeModel : BaseModel
@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* isleaf;
@property (nonatomic,strong)NSString* folder;
@property (nonatomic,strong)NSString* name;
@property (nonatomic,strong)NSString* autoname;
@property (nonatomic,strong)NSString* picname;

/*
 {
 id = 297;
 isleaf = "1";
 folder = "productimages/";
 name = "普通鸡蛋";
 autoname = "05faf8f9d781461faddfd7721628c920.png";
 picname = "putongjidan.png"
	}
 */
@end
