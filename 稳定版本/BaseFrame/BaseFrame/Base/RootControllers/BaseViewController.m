//
//  BaseViewController.m
//  hnatravel
//
//  Created by cuilidong on 15/5/31.
//  Copyright (c) 2015年 hna. All rights reserved.
//

#import "BaseViewController.h"
//#import "MenuViewController.h"
#import "MYYLoginViewController.h"
@interface BaseViewController ()<UIAlertViewDelegate>
@property (nonatomic, strong) void(^Block_AlertView)(UIAlertController *aleart, NSInteger n);
@property (nonatomic,copy) void (^alertViewEvent)(NSInteger buttonIndex);
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateSelected];
    [leftButton addTarget:self action:@selector(backHome) forControlEvents:UIControlEventTouchUpInside];
    leftButton.frame = CGRectMake(0, 0, 20, 20);


    UIBarButtonItem * leftBar = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBar;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
//    for (id vc in [self.navigationController viewControllers]) {
//        if (![vc isKindOfClass:[MenuViewController class]]) {
//            //判断是否连接网络
//            if (![HNANetworkHelper isConnectedToNetwork]) {
//                [self showAlertViewWithTitle:@"" message:@"网络连接链接异常，请检查网络设置" buttonArray:nil cancelButton:@"确定"buttonEvent:^(NSInteger buttonIndex) {
//                }];
//            }
//            break;
//        }
//    }
    if(IOS7)
    {
        self.navigationController.navigationBar.translucent = NO;
    }
}

-(void) backHome
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setLeftBarButtonItemWithNavigationController:(UINavigationItem *)navigationItem
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 45, 44);
    [button setImage:[UIImage imageNamed:@"public_backIcon"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backToLastViewController:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"public_backIcon"] forState:UIControlStateHighlighted];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    navigationItem.leftBarButtonItem = item;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  自定义提示框
 *
 *  @param msg 提示信息
 */
- (void)customAlert:(NSString*)msg {
//    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
//    [alert show];
    
    UIAlertController* aleart = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [aleart addAction:action];
    [self presentViewController:aleart animated:YES completion:nil];
}

- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message buttonArray:(NSArray *)buttonArray cancelButton:(NSString *)cancelButton buttonEvent:(void (^)(NSInteger buttonIndex))alertViewEvent
{
    self.alertViewEvent = alertViewEvent;
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if(_alertViewEvent){
            _alertViewEvent(0);
        }
    }];
    [alertView addAction:action];
    for (int i = 0;i < buttonArray.count;i++) {
        NSString *str = buttonArray[i];
        UIAlertAction* action = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if(_alertViewEvent){
                _alertViewEvent(i+1);
            }
        }];
        [alertView addAction:action];
    }
   [self presentViewController:alertView animated:YES completion:nil];
}


- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSArray *)array buttonClick:(void(^)(UIAlertController *alertView,NSInteger buttonIndex))block_AlertView
{
    self.Block_AlertView = block_AlertView;
    NSArray *titleArray = [NSArray arrayWithArray:array];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    alert.view.tag = 10010;
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if(_Block_AlertView){
            _Block_AlertView(alert,0);
        }
    }];
    [alert addAction:cancelAction];
    for (int i = 0;i < titleArray.count;i++) {
        NSString *str = titleArray[i];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if(_Block_AlertView){
                _Block_AlertView(alert,i+1);
            }
        }];
        [alert addAction:cancelAction];
    }
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    NSLog(@"add ----%@", NSStringFromClass([self class]) );
}

/** 禁用view的延伸*/
- (void)disabledEdgesForExtended
{
    if (DX_ISIOS7) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
        //        self.extendedLayoutIncludesOpaqueBars =NO;
        //        self.automaticallyAdjustsScrollViewInsets =NO;
    }
}

- (void)backToLastViewController:(UIButton *)button
{
    //[Public hideLoadingView];
    [self.navigationController popViewControllerAnimated:YES];
}


//+ (BOOL)isloginRequest{
//   
//    __block BOOL flag = NO;
//
//    [HTNetWorking postWithUrl:@"/mallLogin?action=isLogin" refreshCache:YES params:nil success:^(id response) {
//        
//        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
//        NSLog(@"登录状态%@",str);
//        if ([str rangeOfString:@"false"].location!=NSNotFound) {
//            flag = NO;
//            
//        }
//        if ([str rangeOfString:@"true"].location!=NSNotFound) {
//            flag = YES;
//            
//        }
//        dispatch_semaphore_signal(semaphore);
//    } fail:^(NSError *error) {
//        dispatch_semaphore_signal(semaphore);
//    }];
//    //    });
//    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//    return flag;
//}

- (void)backBarTitleButtonTarget:(id)target action:(SEL)action{
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateSelected];
    [leftButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    leftButton.frame = CGRectMake(0, 0, 20, 20);
    
    
    UIBarButtonItem * leftBar = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBar;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
}

- (void)rightBarTitleButtonTarget:(id)target action:(SEL)action text:(NSString*)str{
    
    NSDictionary* atrDict = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0]};
    CGSize size1 =  [str boundingRectWithSize:CGSizeMake(mScreenWidth - 20.0, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:atrDict context:nil].size;
    NSLog(@"size.width=%f, size.height=%f", size1.width, size1.height);
    UIButton* rightBarBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBarBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightBarBtn.frame = CGRectMake(0, 0, size1.width, 30);
    [rightBarBtn setTitle:str forState:UIControlStateNormal];
    [rightBarBtn setTitleColor:NavBarItemColor forState:UIControlStateNormal];
    [rightBarBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* right = [[UIBarButtonItem alloc]initWithCustomView:rightBarBtn];
    self.navigationItem.rightBarButtonItem = right;
}

//提示弹出框
- (void)timerFireMethod:(NSTimer*)theTimer
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert = NULL;
}

//时间
- (void)showAlert:(NSString *)message{
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}




@end
