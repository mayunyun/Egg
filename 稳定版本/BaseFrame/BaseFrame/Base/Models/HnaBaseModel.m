//
//  HnaBaseModel.m
//  hnatravel
//
//  Created by cuilidong on 15/6/10.
//  Copyright (c) 2015年 hna. All rights reserved.
//

#import "HnaBaseModel.h"
//#import "NSObject+AutoCoding.h"
#import <objc/runtime.h>
@implementation HnaBaseModel
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

- (id)deepCopyAllPropertyValue
{
    id newObjec = [[[self class] alloc] init];
    unsigned int outCount = 0,i = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        //数组拷贝
        if ([propertyValue isKindOfClass:[NSArray class]]) {
            //unsigned int
            NSInteger arrayCount = [propertyValue count];
            NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:arrayCount];
            for (NSInteger a = 0; a < arrayCount; a++) {
                id objcInArray = propertyValue[a];
                if ([objcInArray respondsToSelector:@selector(deepCopyAllPropertyValue)]) {
                    id newObjecInArray = [objcInArray deepCopyAllPropertyValue];
                    [newArray addObject:newObjecInArray];
                }
            }
            propertyValue = newArray;
            //字典拷贝
        }else if ([propertyValue isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            NSArray *keys = [propertyValue allKeys];
            for (NSInteger a = 0; a < [keys count]; a++) {
                NSString *key = keys[a];
                id value = propertyValue[key];
                id newValue;
                if ([value respondsToSelector:@selector(deepCopyAllPropertyValue)]) {
                    newValue = [value deepCopyAllPropertyValue];
                }else if ([value respondsToSelector:@selector(mutableCopy)]) {
                    newValue = [value mutableCopy];
                }else {
                    newValue = [value copy];
                }
                [dict setObject:newValue forKey:key];
            }
            propertyValue = dict;
            //自定义对象拷贝
        }else if ([propertyValue respondsToSelector:@selector(deepCopyAllPropertyValue)]) {
            propertyValue = [propertyValue deepCopyAllPropertyValue];
        }
        
        [newObjec setValue:propertyValue forKey:propertyName];
    }
    free(properties);
    return newObjec;
}

@end
