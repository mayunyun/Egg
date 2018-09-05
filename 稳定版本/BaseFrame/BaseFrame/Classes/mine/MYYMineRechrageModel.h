//
//  MYYMineRechrageModel.h
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/15.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface MYYMineRechrageModel : BaseModel

@property (nonatomic,strong)NSString* custid;
@property (nonatomic,strong)NSString* rechargeno;
@property (nonatomic,strong)NSString* trace_no;
@property (nonatomic,strong)NSString* money;
@property (nonatomic,strong)NSString* createtime;
@property (nonatomic,strong)NSString* type;
@property (nonatomic,strong)NSString* Id;

/*
 {"custid":31,"rechargeno":"WX201705050001-31","trace_no":"4002422001201705059647650965","money":1,"createtime":"2017-05-05 13:35:28","type":1,"id":4}
 */
@end
