//
//  HTShowMessageView.m
//  HeartTrip
//
//  Created by 熊彬 on 16/9/18.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTShowMessageView.h"

#import "MMProgressHUD.h"

@implementation HTShowMessageView
+ (void)showErrorWithMessage:(NSString *)message
{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleSwingRight];
    [MMProgressHUD setDisplayStyle:MMProgressHUDDisplayStyleBordered];
    [MMProgressHUD dismissWithError:nil title:message afterDelay:0.5];
    
}
+ (void)showSuccessWithMessage:(NSString *)message
{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleSwingRight];
    [MMProgressHUD setDisplayStyle:MMProgressHUDDisplayStyleBordered];
    [MMProgressHUD dismissWithSuccess:nil title:message afterDelay:0.5];
}
+ (void)showStatusWithMessage:(NSString *)message
{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
    [MMProgressHUD showWithTitle:nil status:message];
}
+ (void)dismissSuccessView:(NSString *)message
{
   [MMProgressHUD dismissWithSuccess:message];
}
+ (void)dismissErrorView:(NSString *)message
{
    [MMProgressHUD dismissWithError:message];
}
@end
