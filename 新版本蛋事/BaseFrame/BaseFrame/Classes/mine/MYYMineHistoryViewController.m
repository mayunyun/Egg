//
//  MYYMineHistoryViewController.m
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/15.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYMineHistoryViewController.h"
#import "lconsCollectionViewCell.h"
#import "MYYMineCollectModel.h"
#import "MYYDetailsAndCommentViewController.h"
#import "ProductDetailPageVC.h"
@interface MYYMineHistoryViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray* _dataArray;
    BOOL _isdelectBtn;
    
    UIView *_fooderView;
}


@property (nonatomic ,strong)UICollectionView *IconsCollectionView;
@end

@implementation MYYMineHistoryViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置状态栏颜色
    [self setStatusBarBackgroundColor:UIColorFromRGB(0xFFA500)];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.barTintColor = NavBarItemColor;

    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self setStatusBarBackgroundColor:[UIColor whiteColor]];
}

- (UICollectionView *)IconsCollectionView{
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 8*MYWIDTH;//行间距
    flowLayout.minimumLineSpacing = 8*MYWIDTH;//列间距
    if (_IconsCollectionView == nil) {
        _IconsCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight-NavBarHeight) collectionViewLayout:flowLayout];
        
        //隐藏滑块
        _IconsCollectionView.showsVerticalScrollIndicator = NO;
        _IconsCollectionView.showsHorizontalScrollIndicator = NO;
        
        _IconsCollectionView.backgroundColor = UIColorFromRGB(0xEEEEEE);
        _IconsCollectionView.dataSource = self;
        _IconsCollectionView.delegate = self;
        //注册单元格
        [_IconsCollectionView registerNib:[UINib nibWithNibName:@"lconsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"lconsCollectionViewCellID"];
        [_IconsCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];  //  一定要设置
        
        [self.view addSubview:_IconsCollectionView];
    }
    return _IconsCollectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(backToLastViewController:)];
    [self.navigationItem.leftBarButtonItem setTintColor:UIColorFromRGB(0xffffff)];
    
    [self creatUI];
    [self dataRequest];
}
- (void)backToLastViewController:(UIButton *)button
{
    //[Public hideLoadingView];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)creatUI{
   
    [self rightBarTitleButtonTarget:self action:@selector(rightBarClick:) text:@"编辑" textColor:[UIColor whiteColor]];
    self.title = @"我的足迹";
    [self IconsCollectionView];
    
}

- (void)rightBarClick:(UIButton*)sender
{
    if ([sender.titleLabel.text isEqualToString:@"编辑"]) {
        _isdelectBtn = YES;
        [sender setTitle:@"取消" forState:UIControlStateNormal];
        [self fooderWithView];
    }else{
        _isdelectBtn = NO;
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        [_fooderView removeFromSuperview];
    }
    [_IconsCollectionView reloadData];
}
- (void)fooderWithView{
    
    _fooderView = [[UIView alloc]initWithFrame:CGRectMake(0, mScreenHeight-NavBarHeight-55*MYWIDTH, mScreenWidth, 55*MYWIDTH)];
    _fooderView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_fooderView];
    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 1*MYWIDTH)];
    xian.backgroundColor = UIColorFromRGB(0xEFEFEF);
    [_fooderView addSubview:xian];
    UIButton *quanBut = [[UIButton alloc]initWithFrame:CGRectMake(0, xian.bottom, 90*MYWIDTH, 54*MYWIDTH)];
    [quanBut setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [quanBut setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    [quanBut setTitle:@"  全选" forState:UIControlStateNormal];
    [quanBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [quanBut addTarget:self action:@selector(quanBut:) forControlEvents:UIControlEventTouchUpInside];
    quanBut.tag = 1101;
    [_fooderView addSubview:quanBut];
    
    UIButton *shanchuBut = [[UIButton alloc]initWithFrame:CGRectMake(mScreenWidth-80*MYWIDTH, xian.bottom+12*MYWIDTH, 70*MYWIDTH, 30*MYWIDTH)];
    shanchuBut.layer.masksToBounds = YES;
    shanchuBut.layer.cornerRadius = 15*MYWIDTH;
    shanchuBut.layer.borderColor = [UIColorFromRGB(0xFF0000) CGColor];
    shanchuBut.layer.borderWidth = 0.6f;
    [shanchuBut setTitle:@"删除" forState:UIControlStateNormal];
    shanchuBut.titleLabel.font = [UIFont systemFontOfSize:15];
    [shanchuBut setTitleColor:UIColorFromRGB(0xFF0000) forState:UIControlStateNormal];
    [shanchuBut addTarget:self action:@selector(delproductbrowerRequest) forControlEvents:UIControlEventTouchUpInside];
    [_fooderView addSubview:shanchuBut];
}
- (void)quanBut:(UIButton*)but{
    if (but.selected) {
        but.selected = NO;
        for (int i=0; i<_dataArray.count; i++) {
            MYYMineCollectModel* model = _dataArray[i];
            model.select = @"0";
        }
    }else{
        but.selected = YES;
        for (int i=0; i<_dataArray.count; i++) {
            MYYMineCollectModel* model = _dataArray[i];
            model.select = @"1";
        }
    }
    [_IconsCollectionView reloadData];
}


//查询接口
- (void)dataRequest{
    /*
     lookhistory?action=searchLookHistory
     */
    [_dataArray removeAllObjects];

    [HTNetWorking postWithUrl:@"lookhistory?action=searchLookHistory" refreshCache:YES  params:nil success:^(id response) {
        NSArray* arr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (arr.count) {
            for (NSDictionary* dict in arr)  {
                MYYMineCollectModel* model = [[MYYMineCollectModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_dataArray addObject:model];
            }
        }
        [_IconsCollectionView reloadData];

    } fail:^(NSError *error) {
        
    }];
}
//删除接口
- (void)delproductbrowerRequest{
    
    UIAlertController* aleart = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [aleart addAction:action];
    UIAlertAction* action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        /*
        collect?action=deleteCollection
        */
        NSMutableString* idstr = [[NSMutableString alloc]init];
        //列出NSIndexSet的值
        for (int i = 0 ; i < _dataArray.count ;i ++)  {
            MYYMineCollectModel* model = _dataArray[i];
            if ([model.select isEqualToString:@"1"]) {
                [idstr appendString:[NSString stringWithFormat:@"%@,",model.collectid]];
            }
        }
        NSString* idsstr = idstr;
        NSRange range = {0,idsstr.length - 1};
        if (idsstr.length!=0) {
            idsstr = [idsstr substringWithRange:range];
        }else{
            return;
        }
        NSDictionary* parmas = @{@"data":[NSString stringWithFormat:@"{\"ids\":\"%@\"}",idsstr]};
        [HTNetWorking postWithUrl:@"lookhistory?action=deleteLookHistory" refreshCache:YES  params:parmas success:^(id response) {
            NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
            NSLog(@"删除收藏数据%@",str);
            if ([str rangeOfString:@"true"].location != NSNotFound){
                //从_dataSource数组中删除下标集合_indexSetToDel指定的所有下标的元素
                
                [self dataRequest];
            }
            [_IconsCollectionView reloadData];
        } fail:^(NSError *error) {
            
        }];
    }];
    [aleart addAction:action1];
    [self presentViewController:aleart animated:YES completion:nil];
    
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_dataArray count];
}
//调整Item的位置 使Item不紧挨着屏幕
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //在原有基础上进行调整 上 左 下 右
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(mScreenWidth/2-4*MYWIDTH, mScreenWidth/2+35*MYWIDTH);
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *HomeSelarCellID = @"lconsCollectionViewCellID";
    
    //在这里注册自定义的XIBcell 否则会提示找不到标示符指定的cell
    UINib *nib = [UINib nibWithNibName:@"lconsCollectionViewCell" bundle: [NSBundle mainBundle]];
    [_IconsCollectionView registerNib:nib forCellWithReuseIdentifier:HomeSelarCellID];
    
    lconsCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeSelarCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [cell.seletbut addTarget:self action:@selector(seletbutClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.seletbut.tag = indexPath.row;
    
    if (_dataArray.count) {
        MYYMineCollectModel *model = _dataArray[indexPath.row];
        [cell setData:model];
        if ([model.select isEqualToString:@"1"]) {
            [cell.seletbut setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
            
        }else{
            [cell.seletbut setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        }
        
    }
    if (_isdelectBtn) {
        cell.seletbut.hidden = NO;
    }else{
        cell.seletbut.hidden = YES;
    }
    return cell;
}
- (void)seletbutClick:(UIButton *)but{
    UIButton *quanBut = [self.view viewWithTag:1101];
    MYYMineCollectModel* model = _dataArray[but.tag];
    if ([model.select isEqualToString:@"1"]) {
        [but setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        model.select = @"0";
        quanBut.selected = NO;
    }else{
        [but setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
        model.select = @"1";
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ProductDetailPageVC * vc = [[ProductDetailPageVC alloc]init];
    MYYMineCollectModel *model = _dataArray[indexPath.row];
    vc.type = model.type;
    vc.proid = model.proid;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
