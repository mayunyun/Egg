//
//  Paydetail.m
//  lx
//
//  Created by 邱 德政 on 16/2/2.
//  Copyright © 2016年 lx. All rights reserved.
//

#import "Paydetail.h"
//测试微信分享
#import "WXApi.h"
#import "WXApiObject.h"
#import "WXApiRequestHandler.h"
#define TIPSLABEL_TAG 10086
static NSString *kTextMessage = @"这是测试字段";
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access
#import "XMLDictionary.h"


@implementation Paydetail
+ (void)zhiFuBaoname: (NSString*)name titile:(NSString*)title price:(NSString*)price orderId:(NSString*)orderId notice:(NSString *)noticeID
{
    
    
    NSString *partner = Partner;//支付宝账号
    NSString *seller = Seller;//支付宝seller
    NSString *privateKey = PRIVATEKEY;//支付宝秘钥
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 || [seller length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //    /*
    //     *生成订单信息及签名
    //     */
    //    //将商品信息赋予AlixPayOrder的成员变量
    //    Order *order = [[Order alloc] init];
    //    order.appID = @"2016020201135575";
    //    order.partner = partner;
    //    order.seller = seller;
    //    order.tradeNO = orderId; //订单ID（由商家自行制定）
    //    order.productName = name; //商品标题
    //    order.productDescription = title; //商品描述
    //    order.amount = price; //商品价格
    //    NSString* baseurl = [HTServerConfig getHTServerAddr];
    ////    NSString *str = [NSString stringWithFormat:@"%@%@",baseurl,@"getNotifyAction"];
    //////     //回调URL
    ////    order.notifyURL = str;
    //    if ([noticeID isEqualToString:@"0"]) {
    //        order.notifyURL = [NSString stringWithFormat:@"%@getResultAction",baseurl];//@"http://www.shouyaoguanjia.com/danshi1/getResultAction";
    //
    //    }else if ([noticeID isEqualToString:@"1"]){
    //        order.notifyURL = [NSString stringWithFormat:@"%@rechargeGetResultAction",baseurl];//@"http://www.shouyaoguanjia.com/danshi1/rechargeGetResultAction";
    //    }
    //    NSLog(@"支付宝回调地址%@",order.notifyURL);
    //    order.service = @"mobile.securitypay.pay";
    //    order.paymentType = @"1";
    //    order.inputCharset = @"utf-8";
    //    order.itBPay = @"30m";
    //    order.showUrl = @"m.alipay.com";
    //
    //    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    //    NSString *appScheme = @"qitaoshangcheng";
    //
    //    //将商品信息拼接成字符串
    //    NSString *orderSpec = [order description];
    //    NSLog(@"orderSpec = %@",orderSpec);
    //
    //    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    //    //NSLog(@"%@",privateKey);
    //    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    //    NSString *signedString = [signer signString:orderSpec];
    //
    //    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    //    NSString *orderString = nil;
    //    if (signedString != nil) {
    //        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
    //                       orderSpec, signedString, @"RSA"];
    //        NSLog(@"str=%@",orderString);
    //
    //        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
    //
    //            if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
    //
    //                NSLog(@"支付成功== %@",resultDic);
    //                //创建一个消息对象
    //                NSNotification * notice = [NSNotification notificationWithName:AliPayTrue object:nil userInfo:nil];
    //                //发送消息
    //                [[NSNotificationCenter defaultCenter]postNotification:notice];
    //
    //            }
    //        }];
    //
    //
    //    }
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    
    // NOTE: app_id设置
    order.app_id = @"2016020201135575";
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    NSString* baseurl = [HTServerConfig getHTServerAddr];
    if ([noticeID isEqualToString:@"0"]) {
        order.notify_url = [NSString stringWithFormat:@"%@getNotifyAction",baseurl];
    }else if ([noticeID isEqualToString:@"1"]){
//        order.notify_url = @"http://zhangxiao.ngrok.cc/danshi1/shoujiNotifyUrlServlet";
        order.notify_url = [NSString stringWithFormat:@"%@shoujiNotifyUrlServlet",baseurl];
    }
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type设置
    order.sign_type = @"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = orderId;
    order.biz_content.subject = orderId;
    order.biz_content.out_trade_no = orderId; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = price; //商品价格
    order.biz_content.seller_id = seller;
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderInfo];
    
    NSLog(@"qianming%@",signedString);
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"qitaoshangcheng";
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        NSLog(@"str=%@",orderString);
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
                NSLog(@"支付成功== %@",resultDic);
                //创建一个消息对象
                NSNotification * notice = [NSNotification notificationWithName:AliPayTrue object:nil userInfo:nil];
                //发送消息
                [[NSNotificationCenter defaultCenter]postNotification:notice];
                
            }
            
        }];
    }
    
}

+ (void)wxname: (NSString*)name titile:(NSString*)title price:(NSString*)price orderId:(NSString*)orderId notice:(NSString *)noticeID{
    NSString* baseurl = [HTServerConfig getHTServerAddr];
    if([WXApi isWXAppInstalled]) // 判断 用户是否安装微信
    {
        if ([noticeID isEqualToString:@"0"]) {
            NSString* notifyurl = [NSString stringWithFormat:@"%@weixin/weixinzhifujieguo",baseurl];//@"http://zhangxiao.ngrok.cc/danshi1/weixin/weixinzhifujieguo";
            [Paydetail prepayIdRequestname:name notifyurl:notifyurl outTradeno:orderId orderMoney:price];
        }else if ([noticeID isEqualToString:@"1"]){
            NSString* notifyurl = [NSString stringWithFormat:@"%@weixin/chongzhijieguo",baseurl];//@"http://zhangxiao.ngrok.cc/danshi1/weixin/chongzhijieguo";
            [Paydetail prepayIdRequestname:name notifyurl:notifyurl outTradeno:orderId orderMoney:price];
        }
        
    }
    else
    {
        UIAlertView* aleartView = [[UIAlertView alloc]initWithTitle:@"您没有安装微信客户端" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aleartView show];
    }
}



#pragma mark  - - - - - - - 微信支付
// 此方法随机产生32位字符串， 修改代码红色数字可以改变 随机产生的位数。
+ (NSString *)ret32bitString
{
    char data[32];
    
    for (int x=0;x<32;data[x++] = (char)('A' + (arc4random_uniform(26))));
    
    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
}
+ (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

+ (NSString*)creatsign:(NSArray*)pramaArr
{
#pragma mark - - - - - - 预支付签名
    //    NSString* signstr = @"appid=wx956f59da3ba662b6&body=测试&mch_id=1230000109&nonce_str=5K8264ILTKCH16CQ2502SI8ZNMTM67VS&notify_url=http://182.92.96.58:8004/qitao/getNotifyAction&out_trade_no=11112222&spbill_create_ip=14.23.150.211&total_fee=1&trade_type=APP&key=192006250b4c09247ec02edce69f6a2d";
    NSString* signstr = [NSString stringWithFormat:@"appid=%@&body=%@&mch_id=%@&nonce_str=%@&notify_url=%@&out_trade_no=%@&spbill_create_ip=%@&total_fee=%@&trade_type=%@&key=%@",pramaArr[0],pramaArr[1],pramaArr[2],pramaArr[3],pramaArr[4],pramaArr[5],pramaArr[6],pramaArr[7],pramaArr[8],WXPay_key];
    NSLog(@"拼接的签名字符串%@",signstr);
    return [[Paydetail md5:signstr] uppercaseString];
}

+ (NSString*)creatPaysign:(NSArray*)pramaArr
{
#pragma mark - - - - - - 支付签名
    NSString* signstr = [NSString stringWithFormat:@"appid=%@&noncestr=%@&package=%@&partnerid=%@&prepayid=%@&timestamp=%@&key=%@",pramaArr[0],pramaArr[1],pramaArr[2],pramaArr[3],pramaArr[4],pramaArr[5],WXPay_key];
    NSLog(@"拼接的签名字符串%@",signstr);
    return [[Paydetail md5:signstr] uppercaseString];
}


+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (void)prepayIdRequestname:(NSString*)name notifyurl:(NSString*)notifyurl outTradeno:(NSString*)orderno1 orderMoney:(NSString*)orderMoney1
{
    //    https://api.mch.weixin.qq.com/pay/unifiedorder
    /*
     appid      应用ID：wxd678efh567hg6787
     mch_id     商户号：1230000109
     nonce_str  随机字符串：5K8264ILTKCH16CQ2502SI8ZNMTM67VS
     sign       签名：C380BEC2BFD727A4B6845133519F3AD6
     body       商品描述
     out_trade_no商户订单号
     total_fee  总金额(Int)
     spbill_create_ip终端IP
     notify_url 通知地址
     trade_type 交易类型：APP
     */
    NSString* appid = WXPay_APPID;
    NSString* body = name;
    NSString* mch_id = WXPay_mch_id;
    NSString* nonce_str = [Paydetail ret32bitString];// @"5K8264ILTKCH16CQ2502SI8ZNMTM67VS";//;//
    NSLog(@"随机字符串生成%@",nonce_str);
    //    NSString* baseurl = [HTServerConfig getHTServerAddr];
    //    NSString* notify_url = [NSString stringWithFormat:@"%@/order/payOrder1.do",baseurl];
    NSString* notify_url = notifyurl;
    NSString* out_trade_no = orderno1;
    NSString* spbill_create_ip = [Paydetail getIPAddress];
    //    int total_fee = (int)([@"0.01" floatValue]*100);//以分为单位
    int total_fee = (int)([orderMoney1 floatValue]*100);//以分为单位
    NSString* trade_type = @"APP";
    NSString* totalfeestr = [NSString stringWithFormat:@"%i",total_fee];
    NSArray* parmaArray = @[appid,body,mch_id,nonce_str,notify_url,out_trade_no,spbill_create_ip,totalfeestr,trade_type];
    NSString* sign = [Paydetail creatsign:parmaArray];//@"C380BEC2BFD727A4B6845133519F3AD6";
    NSLog(@"sign = %@",sign);
    NSString *urlStr = @"https://api.mch.weixin.qq.com/pay/unifiedorder";
    //        NSString *strURL=[[NSBundle mainBundle]pathForResource:@"xml" ofType:@"txt"];
    //        //将路径下文件得内容加载到字符串中
    //        NSString *str=[[NSString alloc]initWithContentsOfFile:strURL encoding:NSUTF8StringEncoding error:nil];
    NSString *xmlstr = [NSString stringWithFormat:@"<xml><appid>%@</appid><body>%@</body><mch_id>%@</mch_id><nonce_str>%@</nonce_str><notify_url>%@</notify_url><out_trade_no>%@</out_trade_no><spbill_create_ip>%@</spbill_create_ip><total_fee>%i</total_fee><trade_type>%@</trade_type><sign>%@</sign></xml>",appid,body,mch_id,nonce_str,notify_url,out_trade_no,spbill_create_ip,total_fee,trade_type,sign];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    //
    NSData *data = [xmlstr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnStr = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
    NSLog(@"支付宝预处理returnStr%@",returnStr);
    NSDictionary *dict = [NSDictionary dictionaryWithXMLString:returnStr];
    NSLog(@"test = %@",dict);
    NSLog(@"__name:%@,return_code:%@,return_msg:%@",[dict objectForKey:@"__name"],[dict objectForKey:@"return_code"],[dict objectForKey:@"return_msg"]);
    if ([[dict objectForKey:@"return_code"]isEqualToString:@"SUCCESS"]) {
        //预处理成功
        if ([[dict objectForKey:@"result_code"]isEqualToString:@"SUCCESS"]) {
            //            _prepay_id = [dict objectForKey:@"prepay_id"];
            
            //调起微信支付
            PayReq *req = [[PayReq alloc] init];
            req.openID=WXPay_APPID;
            req.nonceStr = dict[@"nonce_str"];
            req.partnerId = dict[@"mch_id"];
            req.package = @"Sign=WXPay";
            req.prepayId= dict[@"prepay_id"];
            //            NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
            //            NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
            //            [formatter setTimeZone:timeZone];
            NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
            req.timeStamp= [datenow timeIntervalSince1970];
            NSArray* array = @[req.openID,req.nonceStr,req.package,req.partnerId,req.prepayId,timeSp];
            req.sign= [Paydetail creatPaysign:array];
            
            if([WXApi isWXAppInstalled]) // 判断 用户是否安装微信
            {
                [WXApi sendReq:req];
                [[NSUserDefaults standardUserDefaults] setValue:out_trade_no forKey:WXout_trade_no];
                //日志输出
                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",WXPay_APPID,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                //                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderPayResult:) name:ORDER_PAY_NOTIFICATION object:nil];//监听一个通知
            }else
            {
                UIAlertView* aleartView = [[UIAlertView alloc]initWithTitle:nil message:@"您没有安装微信客户端" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [aleartView show];
            }
            
        }else{
            
        }
    }else{
        //预处理失败
        UIAlertView* aleartView = [[UIAlertView alloc]initWithTitle:nil message:[dict objectForKey:@"return_msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aleartView show];
    }
}

-(void)onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
            {
                NSLog(@"支付成功");
            }
                break;
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                break;
        }
    }
}







@end
