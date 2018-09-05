//
//  Paydetail.h
//  lx
//
//  Created by 邱 德政 on 16/2/2.
//  Copyright © 2016年 lx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

@interface Paydetail : NSObject
//noticeID:0:订单，1:充值
+ (void)zhiFuBaoname: (NSString*)name titile:(NSString*)title price:(NSString*)price orderId:(NSString*)orderId notice:(NSString*)noticeID;
+ (void)wxname: (NSString*)name titile:(NSString*)title price:(NSString*)price orderId:(NSString*)orderId notice:(NSString*)noticeID;
@end
