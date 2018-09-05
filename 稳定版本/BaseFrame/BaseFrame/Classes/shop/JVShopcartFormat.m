//
//  JVShopcartFormat.m
//  JVShopcart
//
//  Created by AVGD-Jarvi on 17/3/23.
//  Copyright © 2017年 AVGD-Jarvi. All rights reserved.
//

#import "JVShopcartFormat.h"
#import "JVShopcartBrandModel.h"
#import "MJExtension.h"
#import <UIKit/UIKit.h>
#import "MYYDetailEveryoneModel.h"

@interface JVShopcartFormat ()

@property (nonatomic, strong) NSMutableArray *shopcartListArray;    /**< 购物车数据源 */
@property (nonatomic, strong) NSMutableArray *everyDataArray;    /**< 今日热销数据源 */

@end

@implementation JVShopcartFormat

- (void)requestShopcartProductList {
    
    //商品列表
    [HTNetWorking postWithUrl:@"shoppingcart?action=searchShoppingCart" refreshCache:YES params:nil success:^(id response) {
        //NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",array);

        if (!IsEmptyValue(array)) {
            self.shopcartListArray = [JVShopcartBrandModel mj_objectArrayWithKeyValuesArray:array];
            //成功之后回调
            [self.delegate shopcartFormatRequestProductListDidSuccessWithArray:self.shopcartListArray nsarry:array];
            [self selectAllProductWithStatus:NO];
        }
        
    } fail:^(NSError *error) {
        NSLog(@"购物车请求失败");
    }];
    
//    //商品小计
//    [HTNetWorking postWithUrl:@"shoppingcart?action=totalMoney" refreshCache:YES params:nil success:^(id response) {
//        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
//        
//        if (!IsEmptyValue(array)) {
//            //成功之后回调
//            [self.delegate shopcartFormatRequestProductListDidSuccessWithDictionary:array[0]];
//            NSLog(@"%@",self.shopcartListArray);
//            [self selectAllProductWithStatus:NO];
//        }
//        
//        
//    } fail:^(NSError *error) {
//        NSLog(@"购物车请求失败");
//    }];
}
- (void)requestShopgetOrderProduct{
    //今日热销
    [HTNetWorking postWithUrl:@"mall/showproduct?action=getOrderProduct" refreshCache:YES params:nil success:^(id response) {
        //        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        //        NSLog(@"大家都在看%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (!IsEmptyValue(array)) {
            [_everyDataArray removeAllObjects];
            
            self.everyDataArray = [MYYDetailEveryoneModel mj_objectArrayWithKeyValuesArray:array];

            [self.delegate shopcartFormatRequestgetOrderProductDidSuccessWithArray:self.everyDataArray nsarry:array];
            
        }
        
    } fail:^(NSError *error) {
        
    }];
}
- (void)selectProductAtIndexPath:(NSIndexPath *)indexPath isSelected:(BOOL)isSelected {
    JVShopcartBrandModel *brandModel = self.shopcartListArray[indexPath.row];
    brandModel.isSelected = isSelected;
    BOOL isBrandSelected = YES;
    
    for (JVShopcartBrandModel *aProductModel in self.shopcartListArray) {
        if (aProductModel.isSelected == NO) {
            isBrandSelected = NO;
        }
    }
    
    brandModel.sectionisSelected = isBrandSelected;

    [self.delegate shopcartFormatAccountForTotalPrice:[self accountTotalPrice] totalCount:[self accountTotalCount] isAllSelected:[self isAllSelected]];
}

//生鲜自营
- (void)selectBrandAtSectionisSelected:(BOOL)isSelected {
    for (JVShopcartBrandModel *brandModel in self.shopcartListArray) {
        
        brandModel.sectionisSelected = isSelected;
        brandModel.isSelected = brandModel.sectionisSelected;

    }

    [self.delegate shopcartFormatAccountForTotalPrice:[self accountTotalPrice] totalCount:[self accountTotalCount] isAllSelected:[self isAllSelected]];
}

- (void)changeCountAtIndexPath:(NSIndexPath *)indexPath count:(NSInteger)count {
    JVShopcartBrandModel *brandModel = self.shopcartListArray[indexPath.row];
    if (count <= 0) {
        count = 1;
    }
//    else if (count > brandModel.specification) {
//        count = brandModel.specification;
//    }
    
    //根据请求结果决定是否改变数据
    brandModel.count = count;
    
    [self.delegate shopcartFormatAccountForTotalPrice:[self accountTotalPrice] totalCount:[self accountTotalCount] isAllSelected:[self isAllSelected]];
}

- (void)deleteProductAtIndexPath:(NSIndexPath *)indexPath {
    JVShopcartBrandModel *brandModel = self.shopcartListArray[indexPath.row];
    
    //根据请求结果决定是否删除
   // [brandModel.products removeObject:productModel];
    if (self.shopcartListArray.count == 0) {
        [self.shopcartListArray removeObject:brandModel];
    }
    
    [self.delegate shopcartFormatAccountForTotalPrice:[self accountTotalPrice] totalCount:[self accountTotalCount] isAllSelected:[self isAllSelected]];
    
    if (self.shopcartListArray.count == 0) {
        [self.delegate shopcartFormatHasDeleteAllProducts];
    }
}

- (void)beginToDeleteSelectedProducts {
    NSMutableArray *selectedArray = [[NSMutableArray alloc] init];
    for (JVShopcartBrandModel *brandModel in self.shopcartListArray) {
        if (brandModel.isSelected) {
            [selectedArray addObject:brandModel];
        }
    }
    [self.delegate shopcartFormatWillDeleteSelectedProducts:selectedArray];
}

- (void)deleteSelectedProducts:(NSArray *)selectedArray {
    //网络请求
    NSString *str = [[NSString alloc]init];
    for (JVShopcartBrandModel *brandModel in self.shopcartListArray) {
        if (brandModel.isSelected == YES) {
            str = [str stringByAppendingFormat:@"%@,",brandModel.id];
        }
    }
    NSDictionary *params = @{@"data":[NSString stringWithFormat:@"{\"ids\":\"%@\"}",[str substringToIndex:[str length]- 1]]};
    [HTNetWorking postWithUrl:@"shoppingcart?action=deleteShoppingCart" refreshCache:YES params:params success:^(id response) {
       // NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        //NSLog(@"购物车删除>>>>%@",str);
        //根据请求结果决定是否批量删除
        [self.shopcartListArray removeObjectsInArray:selectedArray];
        
        [self.delegate shopcartFormatAccountForTotalPrice:[self accountTotalPrice] totalCount:[self accountTotalCount] isAllSelected:[self isAllSelected]];
        
        if (self.shopcartListArray.count == 0) {
            [self.delegate shopcartFormatHasDeleteAllProducts];
        }
        
    } fail:^(NSError *error) {
        NSLog(@"购物车请求失败");
    }];
    
}

- (void)starProductAtIndexPath:(NSIndexPath *)indexPath {
    //这里写收藏的网络请求
    
}

- (void)starSelectedProducts {
    //这里写批量收藏的网络请求
    
}

//全选
- (void)selectAllProductWithStatus:(BOOL)isSelected {
    for (JVShopcartBrandModel *brandModel in self.shopcartListArray) {
        
        brandModel.sectionisSelected = isSelected;
        brandModel.isSelected = brandModel.sectionisSelected;
        
    }
    
    [self.delegate shopcartFormatAccountForTotalPrice:[self accountTotalPrice] totalCount:[self accountTotalCount] isAllSelected:[self isAllSelected]];
}

- (void)settleSelectedProducts {
    NSMutableArray *settleArray = [[NSMutableArray alloc] init];
    for (JVShopcartBrandModel *brandModel in self.shopcartListArray) {
        NSMutableArray *selectedArray = [[NSMutableArray alloc] init];
        if (brandModel.isSelected) {
            [selectedArray addObject:brandModel];
        }
    
        brandModel.selectedArray = selectedArray;
        
        if (selectedArray.count) {
            [settleArray addObject:brandModel];
        }
    }
    
    [self.delegate shopcartFormatSettleForSelectedProducts:settleArray];
}

#pragma mark private methods

- (float)accountTotalPrice {
    float totalPrice;
    for (JVShopcartBrandModel *brandModel in self.shopcartListArray) {
        if (brandModel.isSelected) {
            totalPrice += brandModel.price * brandModel.count;
        }
    }
    return totalPrice;
}

- (NSInteger)accountTotalCount {
    NSInteger totalCount = 0;
    
    for (JVShopcartBrandModel *brandModel in self.shopcartListArray) {
        if (brandModel.isSelected) {
            totalCount += brandModel.count;
        }
    }
    
    return totalCount;
}

- (BOOL)isAllSelected {
    if (self.shopcartListArray.count == 0) return NO;
    
    BOOL isAllSelected = YES;
    
    for (JVShopcartBrandModel *brandModel in self.shopcartListArray) {
        if (brandModel.sectionisSelected == NO) {
            isAllSelected = NO;
        }
    }
    
    return isAllSelected;
}

@end
