//
//  BaseModel.h
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/2.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface BaseModel : NSObject
- (id)initWithDictionary:(NSDictionary*)jsonDic;


//归档专用
- (id)initWithCoder:(NSCoder *)aDecoder;

- (void)encodeWithCoder:(NSCoder *)aCoder;


@end
