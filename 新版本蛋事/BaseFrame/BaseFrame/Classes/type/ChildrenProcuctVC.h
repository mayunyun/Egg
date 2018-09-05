//
//  ChildrenProcuctVC.h
//  BaseFrame
//
//  Created by 钱龙 on 2018/3/14.
//  Copyright © 2018年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface ChildrenProcuctVC : UIViewController
@property (nonatomic,strong)NSString* proid;
@property (nonatomic,strong)NSString* type;
@property (nonatomic,strong)NSString* count;
@property (nonatomic,copy) void (^transVaule)(BOOL isClick);
- (void)setButtonClick:(UIButton*)sender;
- (void)payProClick:(UIButton*)sender;
@property (nonatomic,copy) void (^headerTitleNumer)(NSInteger integer);
@property (nonatomic, copy) void (^recommendBlock)(NSString *proid,NSString *type);

- (void)setUpView;
@end
