//
//  AllProductPageVC.m
//  BaseFrame
//
//  Created by 钱龙 on 2018/3/13.
//  Copyright © 2018年 济南联祥技术有限公司. All rights reserved.
//

#import "AllProductPageVC.h"
#import "MerchantCollectionViewCell.h"
#import "ProductDetailPageVC.h"
#import "AllProModel.h"
@interface AllProductPageVC ()<UICollectionViewDataSource , UICollectionViewDelegate>
@property (nonatomic, strong) NSMutableArray *goosdCollectionArr;
@property (strong, nonatomic) UICollectionViewFlowLayout * flowLayout;
@end

@implementation AllProductPageVC
{
     NSInteger _page;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _page = 1;
    UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 6, 128, 32)];
    img.image = [UIImage imageNamed:@"tit"];
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, img.width, img.height)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = self.title;
    [img addSubview:title];
    self.navigationItem.titleView = img;
    [self registrationCell];
    [self requestData];
    self.allProCollectionView.collectionViewLayout = self.flowLayout;
    self.allProCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _page ++ ;
        [self requestData];
        [self.allProCollectionView.mj_footer endRefreshing];
        
    }];
}
-(void)requestData{
    NSDictionary* params = @{@"page":[NSString stringWithFormat:@"%li",(long)_page],@"rows":@"6",@"params":[NSString stringWithFormat:@"{\"getprotypeid\":\"%@\"}",self.typeId]};
    [HTNetWorking postWithUrl:@"/mall/showproduct?action=loadProductInfoByPara" refreshCache:YES params:params success:^(id response) {
        NSDictionary* diction = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (_page == 1) {
            [_goosdCollectionArr removeAllObjects];
        }
        if (!IsEmptyValue([diction objectForKey:@"rows"])) {
            for (NSDictionary* dict in [diction objectForKey:@"rows"]) {
                AllProModel* model = [[AllProModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_goosdCollectionArr addObject:model];
            }
        }
        [self.allProCollectionView reloadData];
        
    } fail:^(NSError *error) {
        
    }];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.goosdCollectionArr.count;
}
- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
        MerchantCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MerchantCollectionViewCell" forIndexPath:indexPath];
        cell.model = _goosdCollectionArr[indexPath.item];
        return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ProductDetailPageVC * vc = [[ProductDetailPageVC alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}
//懒加载
-(UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout =[[UICollectionViewFlowLayout alloc]init];
        
        self.flowLayout.minimumLineSpacing      = 8;
        self.flowLayout.minimumInteritemSpacing = 8;
        self.flowLayout.itemSize =CGSizeMake(([UIScreen mainScreen].bounds.size.width-10)/2, 202);
        self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 8, 0);
    }
    return _flowLayout;
}
-(void)registrationCell{
    [self.allProCollectionView registerNib:[UINib nibWithNibName:@"MerchantCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MerchantCollectionViewCell"];
}

-(NSMutableArray *)goosdCollectionArr{
    if (!_goosdCollectionArr) {
        _goosdCollectionArr = [NSMutableArray array];
    }
    return _goosdCollectionArr;
}

@end
