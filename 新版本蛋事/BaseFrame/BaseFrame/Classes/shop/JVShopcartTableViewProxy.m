//
//  JVShopcartTableViewProxy.m
//  JVShopcart
//
//  Created by AVGD-Jarvi on 17/3/23.
//  Copyright © 2017年 AVGD-Jarvi. All rights reserved.
//

#import "JVShopcartTableViewProxy.h"
#import "JVShopcartBrandModel.h"
#import "JVShopcartCell.h"
#import "JVShopcartHeaderView.h"
#import "MYYDetailsAndCommentViewController.h"
#import "MYYDetailEveryoneModel.h"
@implementation JVShopcartTableViewProxy

#pragma mark UITableViewDataSource

- (void)changeShopcarTableViewWithStatus:(BOOL)status{

    _isstatus = status;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 定义cell标识  每个cell对应一个自己的标识
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    // 通过不同标识创建cell实例
    UITableViewCell *hotcell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!hotcell) {
        hotcell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    JVShopcartBrandModel *brandModel = self.dataArray[indexPath.section];
    JVShopcartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JVShopcartCell"];
    if (self.dataArray.count) {
        
        [cell configureShopcartCellWithProductURL:brandModel.autoname productName:brandModel.proname productPrice:brandModel.price productCount:brandModel.count productStock:brandModel.specification productSelected:brandModel.isSelected];
    }
    
    __weak __typeof(self) weakSelf = self;
    cell.shopcartCellBlock = ^(BOOL isSelected){
        if (weakSelf.shopcartProxyProductSelectBlock) {
            weakSelf.shopcartProxyProductSelectBlock(isSelected, indexPath);
        }
    };
    
    cell.shopcartCellEditBlock = ^(NSInteger count){
        if (weakSelf.shopcartProxyChangeCountBlock) {
            weakSelf.shopcartProxyChangeCountBlock(count, indexPath);
        }
    };
    
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if (self.shopcartProxyDeleteBlock) {
            self.shopcartProxyDeleteBlock(indexPath);
        }
    }];
    
    UITableViewRowAction *starAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"收藏" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if (self.shopcartProxyStarBlock) {
            self.shopcartProxyStarBlock(indexPath);
        }
    }];
    
    return @[deleteAction, starAction];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
@end
