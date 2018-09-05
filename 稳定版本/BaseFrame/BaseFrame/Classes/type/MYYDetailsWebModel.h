//
//  MYYDetailsWebModel.h
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/10.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface MYYDetailsWebModel : BaseModel
@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* prono;
@property (nonatomic,strong)NSString* protypename;
@property (nonatomic,strong)NSString* note;
@property (nonatomic,strong)NSString* proid;
@property (nonatomic,strong)NSString* proname;
@property (nonatomic,strong)NSString* effectname;
@property (nonatomic,strong)NSString* specification;
@property (nonatomic,strong)NSString* proprice;
@property (nonatomic,strong)NSString* mainunitname;
@property (nonatomic,strong)NSString* evaluate;//评价总数量

/*
 {
 prono = "2";
 protypename = "宝宝蛋";
 note = "<p><img src="/danshi1/ueditor/jsp/upload/image/20170322/1490153366674077693.png" title="1490153366674077693.png" alt="Android.png"/>222</p>";
 proid = 2;
 proname = "2";
 effectname = "功效一";
 specification = "2";
 proprice = 2;
 mainunitname = "箱";
 evaluate = 0
	}
 */
@end
