//
//  HomeProNewModel.h
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/8.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface HomeProNewModel : BaseModel
@property (nonatomic,strong)NSString* typename;
@property (nonatomic,strong)NSString* typeid;
@property (nonatomic,strong)NSString* folder;
@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* status;
@property (nonatomic,strong)NSString* picname;
@property (nonatomic,strong)NSString* autoname;
@property (nonatomic,strong)NSString* list;

/*
 {
 typename = "专题产品";
 typeid = 1;
 folder = "indeximages/";
 id = 22;
 status = "subject";
 sorts = 1;
 picname = "鸡蛋首页改版恢复_01.png";
 autoname = "3bcf727ac7c948ae8aad233ec2def754.png";
 list = "[{"subjectname":"专题2","picname":"鸡蛋首页改版恢复_01.png","folder":"productSpecialImg/","note":"","autoname":"00bb3e93835e4bc2a75570c034f021f2.png","id":19,"uuid":"bc88978e-4ac5-40e0-a3ae-d2bf100b52af","status":"subject"},
 */
@end
