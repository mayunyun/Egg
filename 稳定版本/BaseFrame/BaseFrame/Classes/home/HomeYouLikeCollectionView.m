//
//  HomeYouLikeCollectionView.m
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/3.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "HomeYouLikeCollectionView.h"
#import "HomeYouLikeCollectionViewCell.h"

@interface HomeYouLikeCollectionView ()
{
    CGFloat _width;
    CGFloat _height;
}
@end
@implementation HomeYouLikeCollectionView

- (id)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0; //列间距
    flowLayout.minimumLineSpacing = 0;//行间距
    
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        //隐藏滑块
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        //设置背景颜色（默认黑色）
        self.backgroundColor = [UIColor whiteColor];
        self.dataSource = self;
        //注册单元格
        _width = self.frame.size.width;
        _height = self.frame.size.height;
        //注册单元格
        [self registerNib:[UINib nibWithNibName:@"HomeYouLikeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeYouLikeCollectionViewCellID"];
    }
    
    return self;
}

//协议中的方法，用于返回分区中的单元格个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *HomeSelarCellID = @"HomeYouLikeCollectionViewCellID";
    //在这里注册自定义的XIBcell 否则会提示找不到标示符指定的cell
    UINib *nib = [UINib nibWithNibName:@"HomeYouLikeCollectionViewCell" bundle: [NSBundle mainBundle]];
    [self registerNib:nib forCellWithReuseIdentifier:HomeSelarCellID];
    
    HomeYouLikeCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeSelarCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    [self framAdd:cell];
    if (_dataArr.count!=0) {
        HomeFavorableModel* model = _dataArr[indexPath.row];
        model.proname = [self convertNull:model.proname];
        model.saleprice = [self convertNull:model.saleprice];
        
        cell.titleLabel.text = nil;
        cell.imgView.image = nil;
        cell.priceLabel.text = nil;
        cell.titleLabel.text = model.proname;
        if (!IsEmptyValue(model.saleprice)) {
            cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.saleprice];
        }else{
            cell.priceLabel.text = [NSString stringWithFormat:@"￥0"];
        }
        NSString* url = HTImgUrl;
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",url,@"productimages",model.autoname]] placeholderImage:[UIImage imageNamed:@"default_img_cell"]];
        [cell setTransVaule:^(BOOL isClick) {
            if (_transVaule) {
                _transVaule(model);
            }
        }];
    }
//        cell.titleLabel.text = @"笨鸡蛋";
//        cell.imgView.image = [UIImage imageNamed:@"00"];
//        cell.priceLabel.text = @"￥ 10.00";
    
    return cell;
    
}

//格式话小数 四舍五入类型
- (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setPositiveFormat:format];
    
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}

- (void)framAdd:(id)sender
{
    CALayer *layer = [sender layer];
    layer.borderColor = SecondBackGorundColor.CGColor;
    layer.borderWidth = .5f;
    //    //添加四个边阴影
    //    imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    //    imageView.layer.shadowOffset = CGSizeMake(0,0);
    //    imageView.layer.shadowOpacity = 0.5;
    //    imageView.layer.shadowRadius = 10.0;//给imageview添加阴影和边框
    //    //添加两个边的阴影
    //    imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    //    imageView.layer.shadowOffset = CGSizeMake(4,4);
    //    imageView.layer.shadowOpacity = 0.5;
    //    imageView.layer.shadowRadius=2.0;
    
}

-(NSString*)convertNull:(id)object{
    
    // 转换空串
    
    if ([object isEqual:[NSNull null]]) {
        return @"";
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    else if (object==nil){
        return @"";
    }
    return object;
    
}
@end
