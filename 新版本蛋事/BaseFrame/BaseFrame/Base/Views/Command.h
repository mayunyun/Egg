//
//  Command.h
//  BaseFrame
//
//  Created by apple on 17/5/5.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Command : NSObject

//新版正则表达式代码：
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
//转换成空串
+ (NSString*)convertNull:(id)object;
+ (NSString *)replaceAllOthers:(NSString *)responseString;


+(void)isloginRequest:(void(^)(bool))string;
+ (void)customAlert:(NSString*)msg;
+ (BOOL)isValidateNmuber:(NSString *)candidate length:(NSInteger) length;
+ (BOOL)isPassword:(NSString *) candidate;
@end
