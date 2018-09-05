//
//  HomeIconsCollectionView.m
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/3.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "HomeIconsCollectionView.h"
#import "IconsCollectionViewCell.h"
#import "HomeTypeModel.h"
@interface HomeIconsCollectionView ()
{
    CGFloat _width;
    CGFloat _height;
}
@end

@implementation HomeIconsCollectionView

- (id)initWithFrame:(CGRect)frame{
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 0;//行间距
    flowLayout.minimumLineSpacing = 0;//列间距
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        //隐藏滑块
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        //设置背景颜色默认是黑色
        self.backgroundColor = [UIColor whiteColor];
        self.dataSource = self;
        //注册单元格
        _width = self.frame.size.width;
        _height = self.frame.size.height;
        [self registerNib:[UINib nibWithNibName:@"IconsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"IconsCollectionViewCellID"];
        
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *HomeSelarCellID = @"IconsCollectionViewCellID";
    
    //在这里注册自定义的XIBcell 否则会提示找不到标示符指定的cell
    UINib *nib = [UINib nibWithNibName:@"IconsCollectionViewCell" bundle: [NSBundle mainBundle]];
    [self registerNib:nib forCellWithReuseIdentifier:HomeSelarCellID];
    
    IconsCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeSelarCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    //    [self framAdd:cell];
    
    cell.imgView.image = nil;
    cell.titleLabel.text = nil;
    if (_dataArr.count!=0) {
        HomeTypeModel* model = _dataArr[indexPath.row];
        if (!IsEmptyValue(model.name)) {
            cell.titleLabel.text = model.name;
        }
        NSString* url = HTImgUrl;
        NSString* imageUrl = [NSString stringWithFormat:@"%@%@%@",url,model.folder,model.autoname];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"default_img_cell"]];
    }
//    NSArray* imageArray = @[@"homeicon1",@"homeicon2",@"homeicon3",@"homeicon4",@"homeicon5"];
//    NSArray* dataArray = @[@"普通鸡蛋",@"宝宝蛋",@"土鸡蛋",@"笨鸡蛋",@"有鸡蛋"];
//    cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[indexPath.row]]];
//    cell.titleLabel.text = [NSString stringWithFormat:@"%@",dataArray[indexPath.row]];
    return cell;
}

@end
