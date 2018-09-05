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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_isstatus) {
        return _dataArray.count;
    }
    return _dataArray.count+1;
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
    if (self.dataArray.count == indexPath.row) {
        UILabel *back = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 10)];
        back.backgroundColor = UIColorFromRGB(0xefefef);
        [hotcell.contentView addSubview:back];
        
        UILabel *hottitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, mScreenWidth, 20)];
        hottitle.backgroundColor = [UIColor whiteColor];
        hottitle.text = @"  今日热销";
        hottitle.textColor = UIColorFromRGB(0x666666);
        hottitle.font = [UIFont systemFontOfSize:15];
        [hotcell.contentView addSubview:hottitle];
        
        CGFloat cellHeight = 140;
        //横向滑动网格
        UIScrollView* scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, mScreenWidth, cellHeight)];
        scrollView.delegate = self;
        scrollView.backgroundColor = [UIColor clearColor];
        [hotcell.contentView addSubview:scrollView];
        if (_HotsellingCollectionView == nil) {
             _HotsellingCollectionView = [[MYYShopHotsellingCollectionView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, cellHeight)];
        }
        _HotsellingCollectionView.delegate = self;
        _HotsellingCollectionView.bounces = NO;
        _HotsellingCollectionView.scrollsToTop = NO;
        _HotsellingCollectionView.scrollEnabled = NO;
        _HotsellingCollectionView.userInteractionEnabled = YES;
        _HotsellingCollectionView.backgroundColor = [UIColor whiteColor];
        if (!IsEmptyValue(_everyDataArray)) {
            _HotsellingCollectionView.dataArr = _everyDataArray;
            [_HotsellingCollectionView reloadData];
            _HotsellingCollectionView.frame = CGRectMake(0, 0, _everyDataArray.count*100+100, cellHeight);
            scrollView.contentSize = CGSizeMake(_everyDataArray.count*100+100, cellHeight);

        }
        [scrollView addSubview:_HotsellingCollectionView];

        return hotcell;
    }
    JVShopcartBrandModel *brandModel = self.dataArray[indexPath.row];

    JVShopcartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JVShopcartCell"];
    if (self.dataArray.count > indexPath.row) {
        
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    JVShopcartHeaderView *shopcartHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"JVShopcartHeaderView"];
    if (self.dataArray.count>0) {
        JVShopcartBrandModel *brandModel = self.dataArray[0];
        [shopcartHeaderView configureShopcartHeaderViewWithBrandName:[NSString stringWithFormat:@"￥%.2f",self.xiaojiCount] brandSelect:brandModel.sectionisSelected];
        shopcartHeaderView.allSelectButton.selected = brandModel.sectionisSelected;
    }else{
        [shopcartHeaderView configureShopcartHeaderViewWithBrandName:[NSString stringWithFormat:@"￥%@",@"0"] brandSelect:NO];
        shopcartHeaderView.allSelectButton.selected = NO;
    }
    
    
    __weak __typeof(self) weakSelf = self;
    shopcartHeaderView.shopcartHeaderViewBlock = ^(BOOL isSelected){
        if (weakSelf.shopcartProxyBrandSelectBlock) {
            NSLog(@"%d",isSelected);

            weakSelf.shopcartProxyBrandSelectBlock(isSelected);
        }
    };
    
    return shopcartHeaderView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count == indexPath.row) {
        return 180;
    }
    return 120;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
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
    if (_dataArray.count == indexPath.row) {
        return NO;
    }
    return YES;
}
#pragma mark ---UIcollectionViewLayoutDelegate
//协议中的方法，用于返回单元格的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isKindOfClass:[_HotsellingCollectionView class]]){
        return CGSizeMake(100, 120);
    }
    else{
        return CGSizeMake(0, 0);
    }
}

//协议中的方法，用于返回整个CollectionView上、左、下、右距四边的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //上、左、下、右的边距
    //    if ([collectionView isKindOfClass:[HomeHotCollectionView class]]) {
    //        return UIEdgeInsetsMake(0, 0, 0, 0);
    //    }else if([collectionView isKindOfClass:[HomeYouLikeCollectionView class]]){
    //        return UIEdgeInsetsMake(0, 0, 0, 0);
    //    }else if ([collectionView isKindOfClass:[HomeBenefitCollectionView class]]){
    //        return UIEdgeInsetsMake(0, 0, 0, 0);
    //    }else{
    return UIEdgeInsetsMake(10, 5, 10, 5);
    //    }
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MYYDetailsAndCommentViewController* vc = [[MYYDetailsAndCommentViewController alloc]init];
    MYYDetailEveryoneModel* model = _everyDataArray[indexPath.row];
    vc.proid = [NSString stringWithFormat:@"%@",model.proid];
    vc.type = [NSString stringWithFormat:@"%@",model.type];
    vc.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

@end
