//
//  MYYPiodetailViewController.h
//  BaseFrame
//
//  Created by apple on 17/5/4.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYYPiodetailViewController : UIViewController
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
