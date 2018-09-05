//
//  JVShopcartBrandModel.h
//  JVShopcart
//
//  Created by AVGD-Jarvi on 17/3/23.
//  Copyright © 2017年 AVGD-Jarvi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVShopcartBrandModel : NSObject


@property (nonatomic, assign)BOOL sectionisSelected; //记录相应section是否全选（自定义）

@property (nonatomic, strong) NSMutableArray *selectedArray;    //结算时筛选出选中的商品（自定义）



@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *custid;

@property (nonatomic, copy) NSString *proid;

@property (nonatomic, copy) NSString *money;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, assign) NSInteger specification;      //规格

@property (nonatomic, assign) NSInteger count;         //商品数

@property (nonatomic, assign) float price;       //价格

@property (nonatomic, copy) NSString *proname; //名称

@property (nonatomic, copy) NSString *autoname;   //图片url

@property(nonatomic, assign)BOOL isSelected;    //记录相应row是否选中（自定义）

@end
