//
//  MYYMineRechargeView.h
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/10.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//
#import <UIKit/UIKit.h>
@class MYYMineRechargeView;
@protocol MYYMineRechargeViewDelegate <NSObject>

@optional
- (void)titleView:(MYYMineRechargeView *)titleView scollToIndex:(NSInteger)tagIndex;

@end

@interface MYYMineRechargeView : UIView

@property (nonatomic,weak) id<MYYMineRechargeViewDelegate>delegate;

-(void)wanerSelected:(NSInteger)tagIndex;
@end
