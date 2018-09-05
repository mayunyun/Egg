//
//  ProCommenPageVC.m
//  BaseFrame
//
//  Created by 钱龙 on 2018/3/17.
//  Copyright © 2018年 济南联祥技术有限公司. All rights reserved.
//

#import "ProCommenPageVC.h"
#import "MYYDetailProCommentModel.h"
#import "LEOStarView.h"
#import "MYYCommentTableViewCell.h"
@interface ProCommenPageVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ProCommenPageVC
{
    UITableView* _tbView;
    NSMutableArray* _tabBtnArray;
    NSMutableArray* _dataCommentArray;
    NSInteger _page;
    NSString* _tabFlag;
    UIView* _bgView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BackGorundColor;
    _dataCommentArray = [[NSMutableArray alloc]init];
    _page = 1;
    _tabFlag = @"";
    [self dataRequest];
    [self creatUI];
}
- (void)creatUI{
    
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64-60) style:UITableViewStyleGrouped];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.scrollsToTop = YES;
    [self.view addSubview:_tbView];
    //     下拉刷新
    _tbView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [_dataCommentArray removeAllObjects];
        [self dataRequest];
        // 结束刷新
        [_tbView.mj_header endRefreshing];
        
    }];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataCommentArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * stringCell = @"MYYCommentTableViewCell";
    MYYCommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
    }
    cell.userInteractionEnabled = NO;
    MYYDetailProCommentModel* model = _dataCommentArray[indexPath.section];
    LEOStarView *LEDstar;
    if (LEDstar == nil) {
        LEDstar = [[LEOStarView alloc]initWithFrame:CGRectMake(0, -5, 120*MYWIDTH, 21*MYWIDTH)];
    }
    LEDstar.markType = EMarkTypeDecimal;
    LEDstar.currentPercent =  [model.scores floatValue]/5;
    LEDstar.starBackgroundColor = [UIColor lightGrayColor];
    LEDstar.starCount = 5;
    
    LEDstar.userInteractionEnabled = NO;
    [cell.scoreView addSubview:LEDstar];
    cell.scroe.text = [NSString stringWithFormat:@"%@",model.scores];
    cell.name.text = [NSString stringWithFormat:@"%@",model.custname];
    if ([model.folder isEqualToString:@""]||[model.autoname isEqualToString:@""]) {
        cell.headImg.image = [UIImage imageNamed:@"noHeadImg"];
        
    }else{
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@",HTImgUrl,model.folder,model.autoname]];
        [cell.headImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"noHeadImg"]];
    }
    cell.contentLabel.text = [NSString stringWithFormat:@"%@",model.comments];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)dataRequest{
    [_dataCommentArray removeAllObjects];
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"proid\":\"%@\",\"type\":\"%@\"}",self.proid,self.type]};
    [HTNetWorking postWithUrl:@"evaulteManage?action=searchEvaluteNew" refreshCache:YES  params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"评价%@",str);
        if (!IsEmptyValue(array)) {
            for (NSDictionary* dict in array) {
                MYYDetailProCommentModel* model = [[MYYDetailProCommentModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_dataCommentArray addObject:model];
            }
            [_tbView reloadData];
        }
        
    } fail:^(NSError *error) {
        
    }];
    
}
@end
