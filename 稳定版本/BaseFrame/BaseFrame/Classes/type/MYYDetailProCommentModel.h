//
//  MYYDetailProCommentModel.h
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/10.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface MYYDetailProCommentModel : BaseModel
@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* proid;
@property (nonatomic,strong)NSString* proname;
@property (nonatomic,strong)NSString* custid;
@property (nonatomic,strong)NSString* custname;
@property (nonatomic,strong)NSString* comments;
@property (nonatomic,strong)NSString* scores;
@property (nonatomic,strong)NSString* createtime;
@property (nonatomic,strong)NSString* type;
@property (nonatomic,strong)NSString* folder;
@property (nonatomic,strong)NSString* autoname;

//autoname = "";
//comments = "\U54ce";
//createtime = "2017-05-16 17:06:36";
//custid = 64;
//custname = 123;
//folder = "";
//id = 46;
//proid = 27;
//proname = "\U91d1\U86cb";
//scores = 1;
//type = 0;
@end
