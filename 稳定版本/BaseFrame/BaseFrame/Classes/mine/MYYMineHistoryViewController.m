//
//  MYYMineHistoryViewController.m
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/15.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYMineHistoryViewController.h"
#import "MineCollectAndHistoryTableViewCell.h"
#import "MYYMineCollectModel.h"
#import "MYYDetailsAndCommentViewController.h"
@interface MYYMineHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _page;
    NSMutableArray* _dataArray;
    NSMutableArray* _selectArray;
    NSMutableIndexSet* _indexSetToDel;
    BOOL _isdelectBtn;
}

@property (nonatomic,strong)UITableView* tbView;

@end

@implementation MYYMineHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectArray = [[NSMutableArray alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    _indexSetToDel = [[NSMutableIndexSet alloc]init];
    _page = 1;
    [self creatUI];
    [self dataRequest];
}

- (void)creatUI{
   
    [self rightBarTitleButtonTarget:self action:@selector(rightBarClick:) text:@"编辑"];
    self.title = @"我的足迹";
    [self tbView];
    
}

- (void)rightBarClick:(UIButton*)sender
{
    if ([sender.titleLabel.text isEqualToString:@"编辑"]) {
        _isdelectBtn = YES;
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        [_tbView setEditing:YES animated:YES];
        [_indexSetToDel removeAllIndexes];//清空上次推出编辑状态之前选中的那些行（下标）
    }else{
        _isdelectBtn = NO;
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        [_tbView setEditing:NO animated:YES];
#pragma mark删除接口
        if (_selectArray.count!=0) {
            [self delproductbrowerRequest];
        }
    }
    [_tbView reloadData];
}

- (UITableView*)tbView{
    if (_tbView == nil) {
        _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64) style:UITableViewStylePlain];
        _tbView.delegate = self;
        _tbView.dataSource = self;
        _tbView.showsVerticalScrollIndicator = NO;
        _tbView.showsHorizontalScrollIndicator = NO;
        _tbView.rowHeight = 80;
        [self.view addSubview:_tbView];
        //    //隐藏多余cell
        _tbView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        //下拉刷新
        _tbView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page = 1;
            if (!IsEmptyValue(_dataArray)) {
                [_dataArray removeAllObjects];
            }
            [self dataRequest];
            [_tbView.mj_header endRefreshing];
            
        }];
        //
        _tbView.mj_header.automaticallyChangeAlpha = YES;
        //
        _tbView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _page ++;
            [self dataRequest];
            [_tbView.mj_footer endRefreshing];
        }];
    }
    return _tbView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"cellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    MineCollectAndHistoryTableViewCell* mycell = [tableView dequeueReusableCellWithIdentifier:@"MineCollectAndHistoryTableViewCellID"];
    if (!mycell) {
        mycell = [[[NSBundle mainBundle]loadNibNamed:@"MineCollectAndHistoryTableViewCell" owner:self options:nil]firstObject];
    }
    mycell.deleteBtn.selected = _isdelectBtn;
    if (tableView == _tbView) {
        if (!IsEmptyValue(_dataArray)) {
            MYYMineCollectModel* model = _dataArray[indexPath.row];
            mycell.model = model;
            [mycell setTransVaule:^(BOOL isClick) {
                if (_isdelectBtn == YES) {
                    //是编辑状态，记录选中的行号做数组下标
                    //MYYMineCollectModel* model = _dataArray[indexPath.row];
                    model.isselect = @"1";
                    [_selectArray addObject:model];
                    [_indexSetToDel addIndex:indexPath.row];
                    if (_selectArray!=0) {
                        [self delproductbrowerRequest];
                    }
                }else{
                    [self addCarRequest:model];
                }
                
            }];
        }

        return mycell;
    }

    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;//表示多选状态
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_tbView.editing) {
        //是编辑状态，记录选中的行号做数组下标
        MYYMineCollectModel* model = _dataArray[indexPath.row];
        model.isselect = @"1";
        [_selectArray addObject:model];
        [_indexSetToDel addIndex:indexPath.row];
        if (_selectArray.count) {
            [self rightBarTitleButtonTarget:self action:@selector(rightBarClick:) text:@"删除"];
        }else{
            [self rightBarTitleButtonTarget:self action:@selector(rightBarClick:) text:@"完成"];
        }
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:NO];

        MYYDetailsAndCommentViewController *details = [[MYYDetailsAndCommentViewController alloc]init];
        MYYMineCollectModel* model = _dataArray[indexPath.row];
        details.proid = [NSString stringWithFormat:@"%@",model.proid];
        details.type = [NSString stringWithFormat:@"%@",model.type];
        details.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:details animated:YES];
        
    }
}

//协议中取消选中tableView中某行时被调用
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_tbView.editing) {
        //把之前选中的行号扔掉
        MYYMineCollectModel* model = _dataArray[indexPath.row];
        model.isselect = @"0";
        [_selectArray removeObject:model];
        [_indexSetToDel removeIndex:indexPath.row];
        if (_selectArray.count) {
            [self rightBarTitleButtonTarget:self action:@selector(rightBarClick:) text:@"删除"];
        }else{
            [self rightBarTitleButtonTarget:self action:@selector(rightBarClick:) text:@"完成"];
        }
    }
}
//加入购物车
- (void)addCarRequest:(MYYMineCollectModel*)model{
    /*
     /shoppingcart?action=addShoppingCart  添加购物车接口
     参数：proid,proname,price,count,type,specification
     */
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"proid\":\"%@\",\"proname\":\"%@\",\"price\":\"%@\",\"count\":\"%@\",\"type\":\"%@\",\"specification\":\"%@\"}",model.proid,model.proname,model.saleprice,@"1",model.type,@""]};
    [HTNetWorking postWithUrl:@"shoppingcart?action=addShoppingCart" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            [Command customAlert:@"加入购物车成功"];
        }else if ([str rangeOfString:@"false"].location!=NSNotFound){
            [Command customAlert:@"删除购物车"];
        }
    } fail:^(NSError *error) {
        
    }];
    
    
}
//查询接口
- (void)dataRequest{
    /*
     lookhistory?action=searchLookHistory
     */
    NSDictionary* params = @{@"page":[NSString stringWithFormat:@"%li",(long)_page],@"rows":@"20"};
    [HTNetWorking postWithUrl:@"lookhistory?action=searchLookHistory" refreshCache:YES  params:params success:^(id response) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (_page == 1) {
            [_dataArray removeAllObjects];
        }
        if (!IsEmptyValue(dic[@"rows"])) {
            for (NSDictionary* dict in dic[@"rows"])  {
                MYYMineCollectModel* model = [[MYYMineCollectModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_dataArray addObject:model];
            }
            [_tbView reloadData];
        }
    } fail:^(NSError *error) {
        
    }];
}
//删除接口
- (void)delproductbrowerRequest{
    /*
     lookhistory?action=deleteLookHistory
     */
    NSMutableString* idstr = [[NSMutableString alloc]init];
    //列出NSIndexSet的值
    for (int i = 0 ; i < _selectArray.count ;i ++)  {
        MYYMineCollectModel* model = _selectArray[i];
        [idstr appendString:[NSString stringWithFormat:@"%@,",model.collectid]];
    }
    NSString* idsstr = idstr;
    NSRange range = {0,idsstr.length - 1};
    if (idsstr.length!=0) {
        idsstr = [idsstr substringWithRange:range];
    }
    NSDictionary* parmas = @{@"data":[NSString stringWithFormat:@"{\"ids\":\"%@\"}",idsstr]};
    [HTNetWorking postWithUrl:@"lookhistory?action=deleteLookHistory" refreshCache:YES  params:parmas success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"删除收藏数据%@",str);
        if ([str rangeOfString:@"true"].location != NSNotFound){
            //从_dataSource数组中删除下标集合_indexSetToDel指定的所有下标的元素
            [_dataArray removeObjectsAtIndexes:_indexSetToDel];
            
        }else if ([str rangeOfString:@"false"].location != NSNotFound){
            //            [self showAlert:@"删除历史失败"];
        }
        [_indexSetToDel removeAllIndexes];//清空集合
        [_tbView reloadData];
    } fail:^(NSError *error) {
        [_indexSetToDel removeAllIndexes];//清空集合
        [_tbView reloadData];
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
