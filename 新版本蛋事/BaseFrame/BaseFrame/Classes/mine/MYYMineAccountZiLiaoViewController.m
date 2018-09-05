//
//  MYYMineAccountZiLiaoViewController.m
//  BaseFrame
//
//  Created by LONG on 2018/4/2.
//  Copyright © 2018年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYMineAccountZiLiaoViewController.h"
#import "ProvinceModel.h"

@interface MYYMineAccountZiLiaoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _tbView;
    UIButton* _nextBtn;
    UIView* _popView;
    UIButton* _hide_keHuPopViewBut;
    NSMutableArray* _provinceDataArray;
    NSMutableArray* _cityDataArray;
    NSMutableArray* _countryDataArray;
    NSMutableArray* _viliageDataArray;
    NSMutableArray* _nameDataArray;
    NSArray* _DataArray;

    NSString* _provinceid;
    NSString* _cityid;
    NSString* _countryid;
    NSString* _xiaoquid;
    NSString* _nameid;
    NSString* _name;
    NSString *_recomphone;
}
@property (nonatomic,strong)UITableView* proTableView;

@end

@implementation MYYMineAccountZiLiaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"更多资料";
    // Do any additional setup after loading the view.
    _provinceDataArray = [[NSMutableArray alloc]init];
    _cityDataArray = [[NSMutableArray alloc]init];
    _countryDataArray = [[NSMutableArray alloc]init];
    _viliageDataArray = [[NSMutableArray alloc]init];
    _nameDataArray = [[NSMutableArray alloc]init];
    _DataArray = [[NSArray alloc]init];

    [self creatUI];
    [self getPersonalInfoAddNEW];
    [self getPersonalInfo];
}
- (void)creatUI{
    UIScrollView* bgView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    bgView.contentSize = CGSizeMake(kScreen_Width, 714);
    bgView.showsVerticalScrollIndicator = NO;
    bgView.showsHorizontalScrollIndicator = NO;
    bgView.bounces = NO;
    bgView.backgroundColor = BackGorundColor;
    [self.view addSubview:bgView];
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 45*8) style:UITableViewStylePlain];
    _tbView.showsVerticalScrollIndicator = NO;
    _tbView.showsHorizontalScrollIndicator = NO;
    _tbView.backgroundColor = BackGorundColor;
    _tbView.separatorStyle = UITableViewCellEditingStyleNone;
    _tbView.delegate = self;
    _tbView.dataSource = self;
    [bgView addSubview:_tbView];
    
    
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _nextBtn.frame = CGRectMake(15, _tbView.bottom+100, kScreen_Width-30, 45);
    [_nextBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _nextBtn.backgroundColor = NavBarItemColor;
    _nextBtn.layer.masksToBounds = YES;
    _nextBtn.layer.cornerRadius = 5;
    [bgView addSubview:_nextBtn];
    [_nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)nextBtnClick{
    if ([_provinceid isEqualToString:@""]) {
        [Command customAlert:@"请选择省"];
        return;
    }else if ([_cityid isEqualToString:@""]) {
        [Command customAlert:@"请选择市"];
        return;
    }else if ([_countryid isEqualToString:@""]) {
        [Command customAlert:@"请选择区/县"];
        return;
    }else if ([_xiaoquid isEqualToString:@""]) {
        [Command customAlert:@"请选择小区"];
        return;
    }
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\",\"villageid\":\"%@\",\"address\":\"\",\"isdefault\":\"3\",\"chargerid\":\"%@\",\"chargername\":\"%@\"}",_provinceid,_cityid,_countryid,_xiaoquid,_nameid,_name]};
    NSString *url;
    if (_DataArray.count) {//修改
        url = @"personal?action=updateCustAddressPerNEW";
    }else{//新增
        url = @"personal?action=addCustAddressPerNEW";
    }
    [HTNetWorking postWithUrl:url refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"地址提交%@",str);
        if ([str rangeOfString:@"false"].location!=NSNotFound) {
            [Command customAlert:@"地址保存错误"];
        }else if ([str rangeOfString:@"nologin"].location!=NSNotFound){
            [Command customAlert:@"登录失效，请重新登录"];
        }else{
            [Command customAlert:@"地址保存成功"];
        }
    } fail:^(NSError *error) {
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _tbView) {
        return 2;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _tbView) {
        if (section==0) {
            return 0;
        }else{
            return 10;
        }
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _tbView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 10)];
        view.backgroundColor = BackGorundColor;
        return view;
    }
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tbView) {
        if (section==0) {
            return 1;
        }
        return 5;
    }else if (tableView == self.proTableView){
        switch (tableView.tag) {
            case 101:{
                return _provinceDataArray.count;
            }break;
            case 102:{
                return _cityDataArray.count;
            }break;
            case 103:{
                return _countryDataArray.count;
            }break;
            case 104:{
                return _viliageDataArray.count;
            }break;
            case 105:{
                return _nameDataArray.count;
            }break;
            default:
                break;
        }
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 定义cell标识  每个cell对应一个自己的标识
    //    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    static NSString* CellIdentifier = @"CellIdentifier";
    // 通过不同标识创建cell实例
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell .accessoryType  = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    
    if (tableView == _tbView) {
        NSArray* titleArray = @[@"所在省",@"所在市",@"所在区",@"所在小区",@"负责人"];
        cell.textLabel.text = titleArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:14];

        if (indexPath.section==0) {
            cell.textLabel.text = @"推荐人手机号";
            
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width - 30 - 200, 0, 200, 44)];
            label.text = _recomphone;
            label.textAlignment = NSTextAlignmentRight;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = GrayTitleColor;
            [cell.contentView addSubview:label];
            return cell;
        }
        CGFloat cellHeight = 44;
        NSArray* placeholderArray;
        placeholderArray = @[@"请选择",@"请选择",@"请选择",@"请选择",@"请选择"];
        NSArray* fomalArray;
        if (_DataArray.count) {
            fomalArray =
            @[[NSString stringWithFormat:@"%@",[_DataArray[0] objectForKey:@"pname"]],
              [NSString stringWithFormat:@"%@",[_DataArray[0] objectForKey:@"cname"]],
              [NSString stringWithFormat:@"%@",[_DataArray[0] objectForKey:@"aname"]],
              [NSString stringWithFormat:@"%@",[_DataArray[0] objectForKey:@"vname"]],
              [NSString stringWithFormat:@"%@",_name]];
        }
        
        UIButton* btn =(UIButton*)[self.view viewWithTag:101+indexPath.row];
        if (btn==nil) {
            btn = [UIButton buttonWithType:UIButtonTypeSystem];
        }
        btn.frame = CGRectMake(120, 0, kScreen_Width - 120 - 30, cellHeight);
        if (_DataArray.count) {
            [btn setTitle:fomalArray[indexPath.row] forState:UIControlStateNormal];
        }else{
            [btn setTitle:placeholderArray[indexPath.row] forState:UIControlStateNormal];
        }
        [btn setTitleColor:GrayTitleColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = 101+indexPath.row;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [cell.contentView addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        UILabel* line = [[UILabel alloc]initWithFrame:CGRectMake(0, 43, kScreen_Width, 1)];
        line.backgroundColor = LineColor;
        [cell.contentView addSubview:line];
        
    }else if (tableView == self.proTableView){
        
        switch (tableView.tag) {
            case 101:{
                if (!IsEmptyValue(_provinceDataArray)) {
                    ProvinceModel* model = _provinceDataArray[indexPath.row];
                    cell.textLabel.text = [NSString stringWithFormat:@"%@",model.areaname];
                }
            }break;
            case 102:{
                if (!IsEmptyValue(_cityDataArray)) {
                    CityModel* model = _cityDataArray[indexPath.row];
                    cell.textLabel.text = [NSString stringWithFormat:@"%@",model.areaname];
                }
            }break;
            case 103:{
                if (!IsEmptyValue(_countryDataArray)) {
                    ContryModel* model = _countryDataArray[indexPath.row];
                    cell.textLabel.text = [NSString stringWithFormat:@"%@",model.areaname];
                }
            }break;
            case 104:{
                if (!IsEmptyValue(_viliageDataArray)) {
                    ViligeModel* model = _viliageDataArray[indexPath.row];
                    cell.textLabel.text = [NSString stringWithFormat:@"%@",model.areaname];
                }
            }break;
            case 105:{
                if (!IsEmptyValue(_nameDataArray)) {
                    ChargeModel* model = _nameDataArray[indexPath.row];
                    cell.textLabel.text = [NSString stringWithFormat:@"%@",model.accountname];
                }
            }break;
            default:break;
        }
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.proTableView) {
        switch (tableView.tag) {
            case 101:{
                if (!IsEmptyValue(_provinceDataArray)) {
                    ProvinceModel* model = _provinceDataArray[indexPath.row];
                    _provinceid = [NSString stringWithFormat:@"%@",model.areaid];
                    
                    UIButton* btn =(UIButton*)[self.view viewWithTag:101];
                    [btn setTitle:[NSString stringWithFormat:@"%@",model.areaname] forState:UIControlStateNormal];
                    [_popView removeFromSuperview];
                    [_cityDataArray removeAllObjects];
                    _cityid = @"";
                    [_countryDataArray removeAllObjects];
                    _countryid = @"";
                    [_viliageDataArray removeAllObjects];
                    _xiaoquid = @"";
                    [_nameDataArray removeAllObjects];
                    _nameid = @"";
                    for (int i = 102 ; i < 107 ;i++) {
                        UIButton* btn = [self.view viewWithTag:i];
                        [btn setTitle:@"请选择" forState:UIControlStateNormal];
                    }
                }
            }break;
            case 102:{
                if (!IsEmptyValue(_cityDataArray)) {
                    CityModel* model = _cityDataArray[indexPath.row];
                    _cityid = [NSString stringWithFormat:@"%@",model.areaid];
                    UIButton* btn = [self.view viewWithTag:102];
                    [btn setTitle:[NSString stringWithFormat:@"%@",model.areaname] forState:UIControlStateNormal];
                    [_popView removeFromSuperview];
                    [_countryDataArray removeAllObjects];
                    _countryid = @"";
                    [_viliageDataArray removeAllObjects];
                    _xiaoquid = @"";
                    [_nameDataArray removeAllObjects];
                    _nameid = @"";
                    for (int i = 103 ; i < 107 ;i++) {
                        UIButton* btn = [self.view viewWithTag:i];
                        [btn setTitle:@"请选择" forState:UIControlStateNormal];
                    }
                }
            }break;
            case 103:{
                if (!IsEmptyValue(_countryDataArray)) {
                    ContryModel* model = _countryDataArray[indexPath.row];
                    _countryid = [NSString stringWithFormat:@"%@",model.areaid];
                    UIButton* btn = [self.view viewWithTag:103];
                    [btn setTitle:[NSString stringWithFormat:@"%@",model.areaname] forState:UIControlStateNormal];
                    [_popView removeFromSuperview];
                    [_viliageDataArray removeAllObjects];
                    _xiaoquid = @"";
                    [_nameDataArray removeAllObjects];
                    _nameid = @"";
                    for (int i = 104; i < 107 ;i++) {
                        UIButton* btn = [self.view viewWithTag:i];
                        [btn setTitle:@"请选择" forState:UIControlStateNormal];
                    }
                }
            }break;
            case 104:{
                if (!IsEmptyValue(_viliageDataArray)) {
                    ViligeModel* model = _viliageDataArray[indexPath.row];
                    _xiaoquid = [NSString stringWithFormat:@"%@",model.areaid];
                    UIButton* btn = [self.view viewWithTag:104];
                    [btn setTitle:[NSString stringWithFormat:@"%@",model.areaname] forState:UIControlStateNormal];
                    [_popView removeFromSuperview];
                    [_nameDataArray removeAllObjects];
                    _nameid = @"";
                    for (int i = 105; i < 107 ;i++) {
                        UIButton* btn = [self.view viewWithTag:i];
                        [btn setTitle:@"请选择" forState:UIControlStateNormal];
                    }
                }
            }break;
            case 105:{
                if (!IsEmptyValue(_nameDataArray)) {
                    ChargeModel* model = _nameDataArray[indexPath.row];
                    _nameid = [NSString stringWithFormat:@"%@",model.accountid];
                    _name = [NSString stringWithFormat:@"%@",model.accountname];
                    UIButton* btn = (UIButton*)[self.view viewWithTag:105];
                    [btn setTitle:[NSString stringWithFormat:@"%@",model.accountname] forState:UIControlStateNormal];
                    [_popView removeFromSuperview];
                }
            }break;
            default:break;
        }
        
    }
}

- (void)btnClick:(UIButton*)sender{
    switch (sender.tag) {
        case 101:{
            [self popViewUI:101];
            [self provinceDataRequest];
            
        }break;
        case 102:{
            [self popViewUI:102];
            [self cityDataRequest];
            
        }break;
        case 103:{
            [self popViewUI:103];
            [self countyDataRequest];
        }break;
        case 104:{
            [self popViewUI:104];
            [self loadXiaoqu];
        }break;
        case 105:{
            [self popViewUI:105];
            [self loadChargeid];
        }break;
        default:
            break;
    }
}
- (void)popViewUI:(NSInteger)tag{
    _popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kScreen_Width, kScreen_Height)];
    //        self.m_keHuPopView.backgroundColor = [UIColor grayColor];
    _popView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [_popView addSubview:_hide_keHuPopViewBut];
    
    if (self.proTableView == nil) {
        self.proTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 80,kScreen_Width-20, kScreen_Height-174) style:UITableViewStylePlain];
        self.proTableView.backgroundColor = [UIColor whiteColor];
    }
    self.proTableView.dataSource = self;
    self.proTableView.delegate = self;
    self.proTableView.tag = tag;
    self.proTableView.rowHeight = 80;
    [_popView addSubview:self.proTableView];
    //        [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:_popView];
    
    
}


- (void)closePop{
    [_popView removeFromSuperview];
    
}



- (void)provinceDataRequest{
    [_provinceDataArray removeAllObjects];
    [HTNetWorking postWithUrl:@"register?action=loadProvince" refreshCache:YES params:nil success:^(id response) {
        //        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        //        NSLog(@"县数据%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (!IsEmptyValue(array)) {
            for (NSDictionary* dict in array) {
                ProvinceModel* model = [[ProvinceModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_provinceDataArray addObject:model];
            }
            [self.proTableView reloadData];
        }
    } fail:^(NSError *error) {
        
    }];
}

- (void)cityDataRequest{
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"provinceid\":\"%@\"}",_provinceid]};
    [_cityDataArray removeAllObjects];
    [HTNetWorking postWithUrl:@"register?action=loadCity" refreshCache:YES params:params success:^(id response) {
        //        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        //        NSLog(@"市数据%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (!IsEmptyValue(array)) {
            for (NSDictionary* dict in array) {
                CityModel* model = [[CityModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_cityDataArray addObject:model];
            }
            [self.proTableView reloadData];
        }
        
    } fail:^(NSError *error) {
        
    }];
}

- (void)countyDataRequest{
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"cityid\":\"%@\"}",_cityid]};
    [_countryDataArray removeAllObjects];
    [HTNetWorking postWithUrl:@"register?action=loadCountry" refreshCache:YES params:params success:^(id response) {
        //        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        //        NSLog(@"县数据%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (!IsEmptyValue(array)) {
            for (NSDictionary* dict in array) {
                ContryModel* model = [[ContryModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_countryDataArray addObject:model];
            }
            [self.proTableView reloadData];
        }
    } fail:^(NSError *error) {
        
    }];
}
- (void)loadXiaoqu{
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"countryid\":\"%@\"}",_countryid]};
    [_viliageDataArray removeAllObjects];
    [HTNetWorking postWithUrl:@"register?action=loadXiaoqu" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"小区数据%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (!IsEmptyValue(array)) {
            for (NSDictionary* dict in array) {
                ViligeModel* model = [[ViligeModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_viliageDataArray addObject:model];
            }
            [self.proTableView reloadData];
        }
    } fail:^(NSError *error) {
        
    }];
}
- (void)loadChargeid{
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"xiaoquid\":\"%@\"}",_xiaoquid]};
    [_nameDataArray removeAllObjects];
    [HTNetWorking postWithUrl:@"register?action=loadChargeid" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"查询负责人接口数据%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (!IsEmptyValue(array)) {
            for (NSDictionary* dict in array) {
                ChargeModel* model = [[ChargeModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_nameDataArray addObject:model];
            }
            [self.proTableView reloadData];
        }
    } fail:^(NSError *error) {
        
    }];
}
- (void)getPersonalInfoAddNEW{
    
    [HTNetWorking postWithUrl:@"personal?action=getPersonalInfoAddNEW" refreshCache:YES params:nil success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"查询用户地址信息数据%@",str);
        _DataArray = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (_DataArray.count) {
            _provinceid = [NSString stringWithFormat:@"%@",[_DataArray[0] objectForKey:@"provinceid"]];
            _cityid = [NSString stringWithFormat:@"%@",[_DataArray[0] objectForKey:@"cityid"]];
            _countryid = [NSString stringWithFormat:@"%@",[_DataArray[0] objectForKey:@"areaid"]];
            _xiaoquid = [NSString stringWithFormat:@"%@",[_DataArray[0] objectForKey:@"villageid"]];
        }
        [_tbView reloadData];
    } fail:^(NSError *error) {
        
    }];
}
- (void)getPersonalInfo{
    
    [HTNetWorking postWithUrl:@"personal?action=getPersonalInfo" refreshCache:YES params:nil success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"查询用户推荐人手机号信息%@",str);
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (arr.count) {
            _recomphone = [NSString stringWithFormat:@"%@",[arr[0] objectForKey:@"recomphone"]];
            _name = [NSString stringWithFormat:@"%@",[arr[0] objectForKey:@"chargername"]];
            _nameid = [NSString stringWithFormat:@"%@",[arr[0] objectForKey:@"chargerid"]];
        }
        [_tbView reloadData];
    } fail:^(NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
