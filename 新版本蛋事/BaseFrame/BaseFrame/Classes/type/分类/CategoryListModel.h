//
//  CategoryListModel.h
//  categories
//
//  Created by 贺心元 on 2017/7/4.
//  Copyright © 2017年 ichina. All rights reserved.
//

#import "JSONModel.h"

@interface CategoryListModel : JSONModel


@property (copy, nonatomic) NSMutableArray *prolist;

@property (strong, nonatomic) NSString * typename;
@property (strong, nonatomic) NSString * typeid;

@end


@interface SecondaryCateModel : JSONModel

@property (copy, nonatomic) NSString *pid;
@property (copy, nonatomic) NSString *proname;
@property (copy, nonatomic) NSString *protypeid;
@property (copy, nonatomic) NSString *type;


@end
