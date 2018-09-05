//
//  HomeBannerModel.h
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/8.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface HomeBannerModel : BaseModel
@property (nonatomic,strong)NSString* folder;           //文件夹
@property (nonatomic,strong)NSString* status;
@property (nonatomic,strong)NSString* note;             //备注
@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* uuid;
@property (nonatomic,strong)NSString* picname;          //图片名
@property (nonatomic,strong)NSString* autoname;
@property (nonatomic,strong)NSString* subjectname;
@property (nonatomic,strong)NSString* phoneautoname;
/*
 {
 folder = "productSpecialImg/";
 status = "subject";
 note = "";
 id = 19;
 uuid = "bc88978e-4ac5-40e0-a3ae-d2bf100b52af";
 picname = "鸡蛋首页改版恢复_01.png";
 autoname = "00bb3e93835e4bc2a75570c034f021f2.png";
 subjectname = "专题2"
	},
 */

@end
