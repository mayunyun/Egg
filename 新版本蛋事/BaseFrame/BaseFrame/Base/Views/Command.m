//
//  Command.m
//  BaseFrame
//
//  Created by apple on 17/5/5.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "Command.h"

@implementation Command

//新版正则表达式代码：
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    if (mobileNum.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (NSString*)convertNull:(id)object{
    
    // 转换空串
    
    if ([object isEqual:[NSNull null]]) {
        return @"";
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    else if (object==nil){
        return @"";
    }
    return object;
    
}

//请求到的是字符串需要处理一下
+ (NSString *)replaceAllOthers:(NSString *)responseString
{
    NSString * returnString = [responseString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    return returnString;
}
+(void)isloginRequest:(void(^)(bool))string{
    __block BOOL flag = NO;
    NSString* LoginID= [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    NSString* user= [[NSUserDefaults standardUserDefaults]objectForKey:USERPHONE];
    NSString* pwd= [[NSUserDefaults standardUserDefaults]objectForKey:PASSWORD];
    
    [HTNetWorking postWithUrl:@"/mallLogin?action=isLogin" refreshCache:YES params:nil success:^(id response) {
        
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"登录状态%@",str);
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            
            flag = YES;
            string(flag);
            return ;
        }
        
        if ([str rangeOfString:@"false"].location!=NSNotFound) {
            if ([[self convertNull:user] isEqualToString:@""]) {
                flag = NO;
                string(flag);
                return ;
            }else{
                
                /*
                 登录接口：/mbtwz/mallLogin?action=checkMallLogin"+callback1
                 参数：account  ，password放在data中
                 */
                NSString *urlstr = @"/mallLogin?action=checkMallLogin";
                NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"accountname\":\"%@\",\"password\":\"%@\"}",user,pwd]};
                [HTNetWorking postWithUrl:urlstr refreshCache:YES params:params success:^(id response) {
                    
                    NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"用户信息%@",array);
                    if (!IsEmptyValue(array)) {
                        
                        flag = YES;
                       
                        
                    }else{
                        flag = NO;
                    }
                    string(flag);
                    return ;
                } fail:^(NSError *error) {
                    flag = NO;
                    string(flag);
                    return ;
                }];
            }
        }
        
    } fail:^(NSError *error) {
        flag = NO;
        string(flag);
    }];
}


/**
 *  自定义提示框
 *
 *  @param msg 提示信息
 */
+ (void)customAlert:(NSString*)msg {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alert show];
}

//校验字符串长度
+ (BOOL)isValidateNmuber:(NSString *)candidate length:(NSInteger) length

{
    NSString *numberRegex =[NSString stringWithFormat:@"\\w{%ld}",(long)length];
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    return [emailTest evaluateWithObject:candidate];
}

+ (BOOL)isPassword:(NSString *) candidate
{
    NSString *      regex = @"(^[A-Za-z0-9]{6,20}$)";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:candidate];
}

@end
