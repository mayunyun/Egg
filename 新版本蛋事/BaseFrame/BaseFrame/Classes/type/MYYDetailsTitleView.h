//
//  MYYDetailsTitleView.h
//  BaseFrame
//
//  Created by apple on 17/5/4.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MYYDetailsTitleView;

@protocol MYYDetailsTitleViewDelegate <NSObject>

@optional
- (void)titleView:(MYYDetailsTitleView *)titleView scollToIndex:(NSInteger)tagIndex;

@end
@interface MYYDetailsTitleView : UIView
@property (nonatomic,weak) id<MYYDetailsTitleViewDelegate>delegate;

-(void)wanerSelected:(NSInteger)tagIndex;
@end
