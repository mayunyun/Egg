//
//  MYYPiodetailViewController.m
//  BaseFrame
//
//  Created by apple on 17/5/4.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYPiodetailViewController.h"
#import "MYYTypeDetailsHeaderTableCell.h"
#import "MYYTypeDetailsCemmentTableViewCell.h"
#import "MYYTypeShangBiaoVIew.h"
#import "MYYTypeDetailsCollectionView.h"
#import "MYYDetailEveryoneModel.h"
#import "MYYDetailsWebModel.h"
#import "MYYDetailProPicDetailModel.h"
#import "MYYLoginViewController.h"
#import "MYYDetailProCommentModel.h"
#import "MYYShopOrderViewController.h"
#import "MYYShopCarViewController.h"

@interface MYYPiodetailViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,SDCycleScrollViewDelegate>
{
    NSMutableArray* _dataArray;
    MBProgressHUD* _hud;
    NSInteger _page;
    NSString* _salecount;
    NSMutableArray* _everyDataArray;
    MYYDetailsWebModel* _promodel;
    NSMutableArray* _imageArray;
    BOOL isCollection;
    NSMutableArray* _dataCommentArray;
}
@property (nonatomic,strong)UITableView* tbView;
@property (nonatomic,strong)MYYTypeShangBiaoVIew *ShangBiaoVIew;
@property (nonatomic,strong)MYYTypeDetailsCollectionView* detailsCollectionView;

@end

@implementation MYYPiodetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    _everyDataArray = [[NSMutableArray alloc]init];
    _promodel = [[MYYDetailsWebModel alloc]init];
    _imageArray = [[NSMutableArray alloc]init];
    _dataCommentArray = [[NSMutableArray alloc]init];
    _page = 1;
    //    进度HUD
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    设置模式
    _hud.mode = MBProgressHUDModeIndeterminate;
    //    _hud.labelText = @"网络不给力，正在加载中...";
    [_hud showAnimated:YES];
    [self creatUI];
    [self dataRequest];
    [self CommentRequest];
    [self everyoneLookRequest];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataBase:) name:IsLogin object:nil];
}
- (void)setUpView{
    _dataArray = [[NSMutableArray alloc]init];
    _everyDataArray = [[NSMutableArray alloc]init];
    _promodel = [[MYYDetailsWebModel alloc]init];
    _imageArray = [[NSMutableArray alloc]init];
    _dataCommentArray = [[NSMutableArray alloc]init];
    _page = 1;
    
    [self dataRequest];
    [self CommentRequest];
    [self everyoneLookRequest];
    [self historyDataRequest];
    [self checkCollectionRequest];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataBase:) name:IsLogin object:nil];
}
- (void) viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IsLogin object:nil];
}

- (void)creatUI
{
    if (_tbView==nil) {
        _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64-45) style:UITableViewStylePlain];
        _tbView.delegate = self;
        _tbView.dataSource = self;
        _tbView.separatorStyle = NO;
        _tbView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_tbView];
        //     下拉刷新
        _tbView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page = 1;
            [_dataArray removeAllObjects];
            [self dataRequest];
            [self CommentRequest];
            [self everyoneLookRequest];
            [self historyDataRequest];
            [self checkCollectionRequest];
            // 结束刷新
            [_tbView.mj_header endRefreshing];
            
        }];
        
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        _tbView.mj_header.automaticallyChangeAlpha = YES;
        // 上拉刷新
        _tbView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            _page ++ ;
            [self dataRequest];
            [_tbView.mj_footer endRefreshing];
            
        }];
        _tbView.mj_footer.hidden = YES;
    }
    
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tbView) {
        return 4;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbView) {
        if (indexPath.row == 0) {
            return mScreenWidth + 70;
        }else if (indexPath.row == 1){
            return 120;
        }else if (indexPath.row == 2){
            if (_dataCommentArray.count) {
                return 210;
            }
            return 40;
        }else if (indexPath.row == 3){
            return mScreenWidth/30*14;
        }
    }
    
    return 44;
    
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 定义cell标识  每个cell对应一个自己的标识
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    // 通过不同标识创建cell实例
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    MYYTypeDetailsHeaderTableCell* headerCell = [tableView dequeueReusableCellWithIdentifier:@"MYYTypeDetailsHeaderTableCell"];
    if (!headerCell) {
        headerCell = [[[NSBundle mainBundle] loadNibNamed:@"MYYTypeDetailsHeaderTableCell" owner:self options:nil]firstObject];
    }
    MYYTypeDetailsCemmentTableViewCell *CemmentCell = [tableView dequeueReusableCellWithIdentifier:@"MYYTypeDetailsCemmentTableViewCell"];
    if (!CemmentCell) {
        CemmentCell = [[[NSBundle mainBundle] loadNibNamed:@"MYYTypeDetailsCemmentTableViewCell" owner:self options:nil]firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (tableView == _tbView) {
        if (indexPath.row == 0) {
            if (!IsEmptyValue(_promodel.proname)) {
                [headerCell upDataWith:_promodel];
                headerCell.priceLabel.text = [NSString stringWithFormat:@"￥ %@",_promodel.proprice];
                if (!IsEmptyValue(_salecount)) {
                    headerCell.countLabel.text = [NSString stringWithFormat:@"销量%@",_salecount];
                }
                if ([[[NSUserDefaults standardUserDefaults]objectForKey:IsLogin] isEqualToString:@"1"]) {
//                    headerCell.collectBtn.hidden = NO;
                    if (isCollection) {
                        [headerCell.collectBtn setImage:[UIImage imageNamed:@"星星1"] forState:UIControlStateNormal];
                        //headerCell.collectLabel.textColor = NavBarItemColor;
                    }else{
                        [headerCell.collectBtn setImage:[UIImage imageNamed:@"星星2"] forState:UIControlStateNormal];
                        //headerCell.collectLabel.textColor = GrayTitleColor;
                    }
                }else{
//                    headerCell.collectBtn.hidden = YES;
                }
                __weak typeof (self)weakself = self;
                [headerCell setTransVaule:^(BOOL isClick,UIButton* btn) {
                    if ([[[NSUserDefaults standardUserDefaults]objectForKey:IsLogin] isEqualToString:@"1"]) {
                        if (isCollection) {
                            UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"已收藏" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
                            
                            [NSTimer scheduledTimerWithTimeInterval:1.5f
                                                             target:self
                                                           selector:@selector(timerFireMethod:)
                                                           userInfo:promptAlert
                                                            repeats:YES];
                            [promptAlert show];
                        }else{
                            [weakself addCollectionRequest:btn];
                        }
                    }else{
                        [weakself pushtologin];
                    }
                }];
                
                [headerCell configureShopcartCountViewWithProductCount:1 productStock:100000];
                __weak __typeof(MYYTypeDetailsHeaderTableCell*) weakheaderCell = headerCell;
                headerCell.shopcartCountViewEditBlock = ^(NSInteger count){
                    weakheaderCell.payCountLabel.text = [NSString stringWithFormat:@"%li",(long)count];
                    [weakheaderCell configureShopcartCountViewWithProductCount:count productStock:100000];
                };
            }
            // 情景二：采用网络图片实现
            NSMutableArray *imagesURLStrings = [[NSMutableArray alloc]init];
            for (MYYDetailProPicDetailModel* model in _imageArray) {
                NSString *serverAddress = HTImgUrl;
                NSString* imageurl = [NSString stringWithFormat:@"%@%@%@",serverAddress,model.folder,model.autoname];
                [imagesURLStrings addObject:imageurl];
                
            }
            // 网络加载 --- 创建带标题的图片轮播器
            headerCell.imgView.delegate = self;
            headerCell.imgView.placeholderImage = [UIImage imageNamed:@"placeholder"];
            headerCell.imgView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
            headerCell.imgView.currentPageDotColor = NavBarItemColor; // 自定义分页控件小圆标颜色
            headerCell.imgView.imageURLStringsGroup = imagesURLStrings;
            headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return headerCell;
            
        }else if (indexPath.row == 1){
            
            [_ShangBiaoVIew removeFromSuperview];
            _ShangBiaoVIew = [[MYYTypeShangBiaoVIew alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 50)];
            [cell.contentView addSubview:_ShangBiaoVIew];
            _ShangBiaoVIew.backgroundColor = [UIColor whiteColor];
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(mScreenWidth-40, 70, 40, 30)];
            [btn setImage:[UIImage imageNamed:@"homemore"] forState:UIControlStateNormal];
            [cell addSubview:btn];
            [btn addTarget:self action:@selector(canshuClick) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }else if (indexPath.row == 2){
            if (_dataCommentArray.count) {
                if (!IsEmptyValue(_dataCommentArray)) {
                    MYYDetailProCommentModel* model = _dataCommentArray[0];
                    CemmentCell.evaluateLab.text = [NSString stringWithFormat:@"商品评价(%@)",_promodel.evaluate];
                    CemmentCell.titleLabel.text = [NSString stringWithFormat:@"%@",model.custname];
                    CemmentCell.dateLabel.text = [NSString stringWithFormat:@"%@",model.createtime];
                    CemmentCell.contentLabel.text = [NSString stringWithFormat:@"%@",model.comments];
                    CemmentCell.contentLabel.numberOfLines = 2;
                    CemmentCell.headerLab.text = [NSString stringWithFormat:@"V%@",model.scores];
                    CemmentCell.starView.markType = EMarkTypeDecimal;
                    CemmentCell.starView.currentPercent =  [model.scores floatValue]/5;
                    CemmentCell.starView.userInteractionEnabled = NO;

                }
                [CemmentCell setTransVaule:^(BOOL isClick) {
                    if (_transVaule) {
                        _transVaule(YES);
                    }
                }];
                CemmentCell.selectionStyle = UITableViewCellSelectionStyleNone;
                return CemmentCell;
            }else{
                
                UILabel *titleview;
                if (titleview == nil) {
                    titleview = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 40)];
                    titleview.backgroundColor = UIColorFromRGB(0xFFFFFF);
                    titleview.text = @"  大家都在买";
                    titleview.textColor = [UIColor blackColor];
                    titleview.font = [UIFont systemFontOfSize:14];
                }
                [cell addSubview:titleview];
            }
            
        }else if (indexPath.row == 3){
            UIScrollView* scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenWidth/30*14)];
            scrollView.delegate = self;
            scrollView.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:scrollView];
            //纵向网格
            [_detailsCollectionView removeFromSuperview];
            _detailsCollectionView = [[MYYTypeDetailsCollectionView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenWidth/30*14)];
            _detailsCollectionView.delegate = self;
            _detailsCollectionView.bounces = NO;
            _detailsCollectionView.scrollsToTop = NO;
            _detailsCollectionView.scrollEnabled = NO;
            _detailsCollectionView.userInteractionEnabled = YES;
            [scrollView addSubview:_detailsCollectionView];
            _detailsCollectionView.backgroundColor = [UIColor clearColor];
            if (!IsEmptyValue(_everyDataArray)) {
                _detailsCollectionView.dataArr = _everyDataArray;
                [_detailsCollectionView reloadData];
                _detailsCollectionView.frame = CGRectMake(0, 0, _everyDataArray.count/3*mScreenWidth, mScreenWidth/30*14);
                scrollView.contentSize = CGSizeMake(_everyDataArray.count/3*mScreenWidth, mScreenWidth/30*14);

            }
        }
    }
    
    return cell;
}
- (void)canshuClick{
    if (_headerTitleNumer) {
        _headerTitleNumer(1);
    }
}
- (NSInteger)array:(NSArray*)array rowNum:(NSInteger)index
{
    if (array.count == 0||array == nil || index == (NSInteger)nil ) {
        return 0;
    }else{
        if (array.count%index!=0) {
            return array.count/index+1;
        }else{
            return array.count/index;
        }
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbView) {
        [_tbView deselectRowAtIndexPath:indexPath animated:NO];
    }
}


#pragma mark ---UIcollectionViewLayoutDelegate
//协议中的方法，用于返回单元格的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isKindOfClass:[MYYTypeDetailsCollectionView class]]) {
        return CGSizeMake(mScreenWidth/3, mScreenWidth/30*14);
    }
    else{
        return CGSizeMake(0, 0);
    }
}

//协议中的方法，用于返回整个CollectionView上、左、下、右距四边的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isKindOfClass:[MYYTypeDetailsCollectionView class]]) {
        MYYDetailEveryoneModel* model = _everyDataArray[indexPath.row];

        if (_recommendBlock) {
            _recommendBlock(model.proid,model.type);
        }
    }
}

- (void)dataRequest{
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"proid\":\"%@\",\"type\":\"%@\"}",self.proid,self.type]};
    NSLog(@"%@",params);
    [HTNetWorking postWithUrl:@"mall/showproduct?action=productDetail" refreshCache:YES params:params success:^(id response) {
        //NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"详情%@",array);

        if (!IsEmptyValue(array)) {
            NSDictionary* dict = array[0];
            [_promodel setValuesForKeysWithDictionary:dict];
            [self countRequest];
            [self imageUrlRequest];
            [_tbView reloadData];
        }
    } fail:^(NSError *error) {
        
    }];
}

- (void)everyoneLookRequest{
    [HTNetWorking postWithUrl:@"mall/showproduct?action=getOrderProduct" refreshCache:YES params:nil success:^(id response) {
//        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
//        NSLog(@"大家都在看%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (!IsEmptyValue(array)) {
            [_everyDataArray removeAllObjects];
            for (NSDictionary* dict in array) {
                MYYDetailEveryoneModel* model = [[MYYDetailEveryoneModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_everyDataArray addObject:model];
            }
            NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
            [_tbView reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] withRowAnimation:NO];
        }
        
    } fail:^(NSError *error) {
        
    }];
}

- (void)countRequest{
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"proid\":\"%@\",\"type\":\"%@\"}",self.proid,self.type]};
    [HTNetWorking postWithUrl:@"mall/showproduct?action=getTotalMonthCount" refreshCache:YES params:params success:^(id response) {
        //NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSDictionary* dict = array[0];
        _salecount = [NSString stringWithFormat:@"%@",dict[@"count"]];
        NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_tbView reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] withRowAnimation:NO];
        
    } fail:^(NSError *error) {
        
    }];
}

- (void)imageUrlRequest{
/*
 /mall/showproduct?action=productPicDetail
 */
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"proid\":\"%@\",\"type\":\"%@\"}",self.proid,self.type]};
    [HTNetWorking postWithUrl:@"mall/showproduct?action=productPicDetail" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"图片%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (!IsEmptyValue(array)) {
            for (NSDictionary* dict in array) {
                MYYDetailProPicDetailModel* model = [[MYYDetailProPicDetailModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_imageArray addObject:model];
            }
            NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [_tbView reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] withRowAnimation:NO];
        }
        
    } fail:^(NSError *error) {
        
    }];
    
}

- (void)historyDataRequest{
/*
 /lookhistory?action=insertLookHistory
 proid 和type
 */
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"proid\":\"%@\",\"type\":\"%@\"}",self.proid,self.type]};
    [HTNetWorking postWithUrl:@"lookhistory?action=insertLookHistory" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"true"].location != NSNotFound) {
            NSLog(@"加入历史记录成功");
        }else{
            NSLog(@"加入历史记录不成功");
        }
    } fail:^(NSError *error) {
        
    }];
}

- (void)checkCollectionRequest{
/*
 collect?action=checkCollection
 proid和type
 */
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"proid\":\"%@\",\"type\":\"%@\"}",self.proid,self.type]};
    [HTNetWorking postWithUrl:@"collect?action=checkCollection" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"true"].location != NSNotFound) {
            NSLog(@"收藏了");
            isCollection = YES;
        }else{
            NSLog(@"未收藏");
            isCollection = NO;
        }
        NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_tbView reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] withRowAnimation:YES];
    } fail:^(NSError *error) {
        
    }];
 
}

- (void)addCollectionRequest:(UIButton*)btn{
/*
  /collect?action=addCollection
    proid和type
 */
    btn.enabled = NO;
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"proid\":\"%@\",\"type\":\"%@\"}",self.proid,self.type]};
    [HTNetWorking postWithUrl:@"collect?action=addCollection" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"true"].location != NSNotFound) {
            NSLog(@"加入收藏成功");
            isCollection = YES;
            NSIndexPath* reloadIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [_tbView reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] withRowAnimation:YES];
            [Command customAlert:@"加入收藏成功"];
        }else{
            NSLog(@"加入收藏不成功");
            [Command customAlert:@"加入收藏不成功"];
        }
        btn.enabled = YES;
    } fail:^(NSError *error) {
        btn.enabled = YES;
    }];
}

//- (void)delectCollectionRequest{
///*
// /collect?action=deleteCollection  删除收藏
// ids
// */
//    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"proid\":\"%@\",\"type\":\"%@\"}",self.proid,self.type]};
//    [HTNetWorking postWithUrl:@"collect?action=deleteCollection" refreshCache:YES showHUD:@"添加中" params:params success:^(id response) {
//        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
//        if ([str rangeOfString:@"true"].location != NSNotFound) {
//            NSLog(@"加入收藏成功");
//        }else{
//            NSLog(@"加入收藏不成功");
//        }
//    } fail:^(NSError *error) {
//        
//    }];
//}


//评论
- (void)CommentRequest{
        //good,middle,bad
    
    //NSSLog(@"%@",params);

        
        NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"proid\":\"%@\",\"type\":\"%@\",\"flag\":\"\",\"page\":\"1\",\"rows\":\"20\"}",self.proid,self.type]};
        [HTNetWorking postWithUrl:@"evaulteManage?action=searchEvalute" refreshCache:YES  params:params success:^(id response) {
            NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
            NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"评价%@",str);
            if (!IsEmptyValue(array)) {
                for (NSDictionary* dict in array) {
                    MYYDetailProCommentModel* model = [[MYYDetailProCommentModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [_dataCommentArray addObject:model];
                }
                NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
                [_tbView reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] withRowAnimation:NO];
            }
            
        } fail:^(NSError *error) {
            
        }];
}

- (void)addCarRequest{
    [Command isloginRequest:^(bool flag) {
        if (flag) {
            
            NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"proid\":\"%@\",\"proname\":\"%@\",\"price\":\"%@\",\"count\":\"%@\",\"type\":\"%@\",\"specification\":\"%@\"}",_promodel.proid,_promodel.proname,_promodel.proprice,self.count,self.type,_promodel.specification]};
            [HTNetWorking postWithUrl:@"shoppingcart?action=addShoppingCart" refreshCache:YES params:params success:^(id response) {
                NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
                if ([str rangeOfString:@"true"].location!=NSNotFound) {
                    [Command customAlert:@"加入购物车成功"];
                }else if ([str rangeOfString:@"false"].location!=NSNotFound){
                    [Command customAlert:@"删除购物车"];
                }
            } fail:^(NSError *error) {
                
            }];
            
        }else{
            NSLog(@"登录失败");
            MYYLoginViewController* vc = [[MYYLoginViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];

/*
 /shoppingcart?action=addShoppingCart  添加购物车接口
 参数：proid,proname,price,count,type,specification
 */
    
    
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"轮播%li",(long)index);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [Command isloginRequest:^(bool flag) {
        if (flag) {
            NSLog(@"登录成功");
            [self historyDataRequest];
            [self checkCollectionRequest];
        }else{
            NSLog(@"登录失败");
        }
    }];
}

- (void)getLoadDataBase:(NSNotificationCenter*)sender{

}

- (void)setButtonClick:(UIButton*)sender{
    [Command isloginRequest:^(bool islogin) {
        if (islogin) {
            [self addCarRequest];
        }else{
            [self pushtologin];
        }
    }];
}
//立即购买
- (void)payProClick:(UIButton*)sender{
    //NSLog(@"%@",_promodel.proid);
    [Command isloginRequest:^(bool flag) {
        if (flag) {
            
            MYYShopOrderViewController* vc = [[MYYShopOrderViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.proid = _promodel.proid;
            vc.proprice = _promodel.proprice;
            vc.type = self.type;
            vc.count = self.count;
            vc.proname = _promodel.proname;
            vc.specification = _promodel.specification;
            vc.next = 0;
            vc.xiaojicount = [_promodel.proprice intValue]*[self.count intValue];
            vc.Id = [NSString stringWithFormat:@"%@",_promodel.Id];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            NSLog(@"登录失败");
            [self pushtologin];
        }
    }];
    
}

- (void)pushtologin{
    NSArray *titleArray = @[@"确定"];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"请您先进行登录！" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancelAction];
    for (NSString *str in titleArray) {
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            MYYLoginViewController* vc = [[MYYLoginViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [alert addAction:cancelAction];
    }
    [self presentViewController:alert animated:YES completion:nil];
}

//提示弹出框
- (void)timerFireMethod:(NSTimer*)theTimer
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert = NULL;
}
@end
