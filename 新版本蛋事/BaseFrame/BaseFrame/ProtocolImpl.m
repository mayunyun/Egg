//
//  ProtocolImpl.m
//  BaseFrame
//
//  Created by 邱 德政 on 17/3/23.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "ProtocolImpl.h"

@interface ProtocolImpl ()

/*
 * 数据
 */
@property (nonatomic,strong)NSMutableArray* videosData;

@end

@implementation ProtocolImpl


- (RACSignal *)requestExploreVideosDataSignal:(NSString *)requestUrl
{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSString *lng = [CommonUtils getStrValueInUDWithKey:Longitudekey];
        NSString *lat = [CommonUtils getStrValueInUDWithKey:Latitudekey];
        NSDictionary *params = @{@"count":@"20",
                                 @"lat":lat ? lat : @"22.53512980326447",
                                 @"lng":lng ? lng : @"114.0598045463555",
                                 @"start":@"0"
                                 };
        
        HTURLSessionTask *task = [HTNetWorking getWithUrl:requestUrl refreshCache:YES showHUD:@"loading..." params:params success:^(id response) {
            
            [self.videosData removeAllObjects];
            
            //数据
            
            //循环
            // video数据
            //            [videosArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //
            //                HTFindVideosModel *videoModel = [HTFindVideosModel mj_objectWithKeyValues:obj];
            //                [self.videosData addObject:videoModel];
            //            }];
            
            [subscriber sendNext:self.videosData];
            [subscriber sendCompleted];
            
        } fail:^(NSError *error) {
            
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            
            [task cancel];
        }];
    }];
}

@end
