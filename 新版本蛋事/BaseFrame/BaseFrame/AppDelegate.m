//
//  AppDelegate.m
//  BaseFrame
//
//  Created by 邱 德政 on 17/3/2.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import "HTServerConfig.h"
#import "IQKeyboardManager.h"
#import "HTLBSManager.h"
#import <JSPatchPlatform/JSPatch.h>
#import "ShopTabBarController.h"

#import <AlipaySDK/AlipaySDK.h>//支付宝
#import "WXApi.h"//微信
#import "WXApiManager.h"

@interface AppDelegate ()<HTLBSManagerDelegate>
@property (strong, nonatomic) HTLBSManager *lbs;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 设置服务器环境 01:生产环境  00:测试环境
    [HTServerConfig setHTConfigEnv:@"01"];
    
    // 获取定位信息
    self.lbs = [HTLBSManager startGetLBSWithDelegate:self];
    // 配置JSPatch
//    [self configurationJSPatch];
    
     [IQKeyboardManager sharedManager].enable = YES;
    [self setStatusBarBackgroundColor:[UIColor whiteColor]];
    //向微信注册
    [WXApi registerApp:WXPay_APPID withDescription:@"demo 2.0"];
    [self rootViewControllerUI];
    return YES;
}
//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

- (void)rootViewControllerUI
{
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[ShopTabBarController alloc]init];//baseNav;
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:IsLogin];
}


- (void)configurationJSPatch
{
    [JSPatch setupCallback:^(JPCallbackType type, NSDictionary *data, NSError *error) {
        if (type == JPCallbackTypeJSException) {
            NSAssert(NO, data[@"msg"]);
        }
    }];
    if ([[HTServerConfig HTConfigEnv] isEqualToString:@"01"]) {
        
        [JSPatch startWithAppKey:@"7daa6e2fdcfc64e9"];
        [JSPatch sync];
    }else{
        [JSPatch testScriptInBundle];
        [JSPatch showDebugView];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"BaseFrame"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

//支付宝回调接口
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
                NSLog(@"支付成功== %@",resultDic);
//                NSString* str = [resultDic objectForKey:@"result"];
//                NSArray *array = [str componentsSeparatedByString:@"&"]; //从字符A中分隔成2个元素的数组
//                NSLog(@"array:%@",array); //结果是adfsfsfs和dfsdf
//                NSString*string =array[2];
//                NSRange range = [string rangeOfString:@"out_trade_no="];//匹配得到的下标
//                NSLog(@"rang:%@",NSStringFromRange(range));
//                NSInteger start = range.length - range.location;
//                string = [string substringFromIndex:start];//截取范围类的字符串
//                NSLog(@"截取的值为：%@",string);
//                NSString* fee = array[5];
//                NSRange range1 = [fee rangeOfString:@"total_fee="];
//                NSInteger feestart = range1.length - range1.location;
//                fee = [fee substringFromIndex:feestart];
//                NSLog(@"截取的值为fee：%@",fee);
//                NSString* stopstr = [self replaceAllOthers:string];
//                NSLog(@"最终字符串：%@",stopstr);
//                [self shangChuan:string paymethod:@"1" money:fee];
                //创建一个消息对象
                NSNotification * notice = [NSNotification notificationWithName:AliPayTrue object:nil userInfo:nil];
                //发送消息
                [[NSNotificationCenter defaultCenter]postNotification:notice];
            }
        }];
    }
    
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
                NSLog(@"支付成功== %@",resultDic);
//                NSString* str = [resultDic objectForKey:@"result"];
//                NSArray *array = [str componentsSeparatedByString:@"&"]; //从字符A中分隔成2个元素的数组
//                NSLog(@"array:%@",array); //结果是adfsfsfs和dfsdf
//                NSString*string =array[2];
//                NSRange range = [string rangeOfString:@"out_trade_no="];//匹配得到的下标
//                NSLog(@"rang:%@",NSStringFromRange(range));
//                NSInteger start = range.length - range.location;
//                string = [string substringFromIndex:start];//截取范围类的字符串
//                NSLog(@"截取的值为：%@",string);
//                NSString* stopstr = [self replaceAllOthers:string];
//                NSLog(@"最终字符串：%@",stopstr);
//                NSString* fee = array[5];
//                NSRange range1 = [fee rangeOfString:@"total_fee="];
//                NSInteger feestart = range1.length - range1.location;
//                fee = [fee substringFromIndex:feestart];
//                NSLog(@"截取的值为fee：%@",fee);
//                [self shangChuan:string paymethod:@"1" money:fee];
                //创建一个消息对象
                NSNotification * notice = [NSNotification notificationWithName:AliPayTrue object:nil userInfo:nil];
                //发送消息
                [[NSNotificationCenter defaultCenter]postNotification:notice];
            }
        }];
    }
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    return YES;
}


//请求到的是字符串需要处理一下
- (NSString *)replaceAllOthers:(NSString *)responseString
{
    NSString * returnString = [responseString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    return returnString;
}

#pragma mark - - - - - - 微信openURL
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}


@end
