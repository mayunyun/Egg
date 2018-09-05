//
//  HnaBaseModel.h
//  hnatravel
//
//  Created by cuilidong on 15/6/10.
//  Copyright (c) 2015年 hna. All rights reserved.
//

#import "JSONModel.h"

#define OBJC_STRINGIFY(x) @#x
#define encodeFloat(x) [aCoder encodeFloat:x forKey:OBJC_STRINGIFY(x)]
#define encodeInteger(x) [aCoder encodeInteger:x forKey:OBJC_STRINGIFY(x)]
#define encodeObject(x) [aCoder encodeObject:x forKey:OBJC_STRINGIFY(x)]

#define decodeObject(x) x = [aDecoder decodeObjectForKey:OBJC_STRINGIFY(x)]
#define decodeInteger(x) x = [aDecoder decodeIntegerForKey:OBJC_STRINGIFY(x)]
#define decodeFloat(x) x = [aDecoder decodeFloatForKey:OBJC_STRINGIFY(x)]


@interface HnaBaseModel : JSONModel

@end
