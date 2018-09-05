//
//  ProtocolImpl.h
//  BaseFrame
//
//  Created by 邱 德政 on 17/3/23.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

@protocol HTFindProtocol <NSObject>

@optional
// 加载发现数据
- (RACSignal *)requestFindDataSignal:(NSString *)requestUrl;

// 加载发现更多数据
- (RACSignal *)requestFindMoreDataSignal:(NSString *)requestUrl;

// 加载探索视频数据
- (RACSignal *)requestExploreVideosDataSignal:(NSString *)requestUrl;

// 加载探索视频更多数据
- (RACSignal *)requestExploreVideosMoreDataSignal:(NSString *)requestUrl;

@end

#import <Foundation/Foundation.h>

@interface ProtocolImpl : NSObject<HTFindProtocol>

@end
