//
//  MYYMyOrderHeaderTitleView.h
//  BaseFrame
//
//  Created by apple on 17/5/10.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MYYMyOrderHeaderTitleView;

@protocol MYYMyOrderHeaderTitleViewDelegate <NSObject>

@optional
- (void)titleView:(MYYMyOrderHeaderTitleView *)titleView scollToIndex:(NSInteger)tagIndex;

@end
@interface MYYMyOrderHeaderTitleView : UIView
@property (nonatomic,weak) id<MYYMyOrderHeaderTitleViewDelegate>delegate;

-(void)wanerSelected:(NSInteger)tagIndex;
@end
