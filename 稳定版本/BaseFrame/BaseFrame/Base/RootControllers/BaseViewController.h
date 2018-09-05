//
//  BaseViewController.h
//  hnatravel
//
//  Created by cuilidong on 15/5/31.
//  Copyright (c) 2015年 hna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

/* 出行人来源 */
typedef NS_ENUM(NSUInteger, TravellerSourceType) {
    inlandFlight = 1,   //国内机票
    internationFlight,  //国际机票
    inlandVacaton,      //国内度假
    internationVacaton, //国际度假
};

typedef NS_ENUM(NSInteger, TravelType)
{
    TravelFlight = 1,    //机票
    TravelHotel,  //酒店
    TravelVacation //度假
};

/* 订单来源 */
typedef NS_ENUM(NSUInteger, orderSourceType) {
    flightOrder = 1,         //机票
    vacationOrder,           //度假
    hotelOrder,              //酒店
    GateTicketOrder,         //门票
    travelCardOrder,          //旅游卡
    cruise,   //邮轮
    AppointOrder,  //预约游订单
    GolfOrder,     //高尔夫订单
    CopterOrder,   //直升机订单
    BigGiftOrder   //大礼包订单
};

typedef enum{
    
    City_Type_All = 0,   //0 全国
    City_Type_Flight = 1,    //1 机票
    City_Type_Vacation= 2,   //2 度假
    City_Type_Piao= 5,   //门票
    
} CityType;


//--------------选择城市相关--------------
@protocol PCCityDelegate <NSObject>
@required
- (void)setCityChanged;
- (void)resetCityChanged;
@optional

@end

@interface BaseViewController : UIViewController


/**
 *  自定义alertView
 *
 *  @param title           标题
 *  @param message         内容
 *  @param cancelTitle     取消按钮
 *  @param array           其他按钮
 *  @param block_AlertView 点击按钮触发的事件
 */
- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSArray *)array buttonClick:(void(^)(UIAlertController *alertView,NSInteger buttonIndex))block_AlertView;


- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message buttonArray:(NSArray *)buttonArray cancelButton:(NSString *)cancelButton buttonEvent:(void (^)(NSInteger buttonIndex))alertViewEvent;

@property (nonatomic, strong) Reachability *rechablity;

//返回上级VC
- (void)backToLastViewController:(UIButton *)button;

/**
 *  自定义提示框
 *
 *  @param msg 提示信息
 */
- (void)customAlert:(NSString*)msg;

/** 禁用view的延伸*/
- (void)disabledEdgesForExtended;


- (void)rightBarTitleButtonTarget:(id)target action:(SEL)action text:(NSString*)str;
- (void)backBarTitleButtonTarget:(id)target action:(SEL)action;
- (void)showAlert:(NSString *)message;

@end
