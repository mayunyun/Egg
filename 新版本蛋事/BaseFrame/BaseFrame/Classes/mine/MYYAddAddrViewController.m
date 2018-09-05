//
//  MYYAddAddrViewController.m
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/9.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYAddAddrViewController.h"
#import "ProvinceModel.h"

@interface MYYAddAddrViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView* _tbView;
    UISwitch* _switch;
    UIButton* _nextBtn;
    UIView* _popView;
    UIButton* _hide_keHuPopViewBut;
    NSMutableArray* _provinceDataArray;
    NSMutableArray* _cityDataArray;
    NSMutableArray* _countryDataArray;
    NSMutableArray* _viliageDataArray;
    NSString* _provinceid;
    NSString* _cityid;
    NSString* _countryid;
    NSString* _xiaoquid;
    
}
@property (nonatomic,strong)UITableView* proTableView;
@end

@implementation MYYAddAddrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _provinceDataArray = [[NSMutableArray alloc]init];
    _cityDataArray = [[NSMutableArray alloc]init];
    _countryDataArray = [[NSMutableArray alloc]init];
    _viliageDataArray = [[NSMutableArray alloc]init];
    if (self.typeAddr == typeEditAddress) {
        self.title = @"编辑地址";
        _provinceid = [NSString stringWithFormat:@"%@",self.addrModel.provinceid];
        _cityid = [NSString stringWithFormat:@"%@",self.addrModel.cityid];
        _countryid = [NSString stringWithFormat:@"%@",self.addrModel.areaid];
        _xiaoquid = [NSString stringWithFormat:@"%@",self.addrModel.villageid];

    }else{
        self.title = @"添加地址";
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(backToLastViewController:)];
    [self.navigationItem.leftBarButtonItem setTintColor:UIColorFromRGB(0xffffff)];
    
    [self creatUI];
}
- (void)backToLastViewController:(UIButton *)button
{
    //[Public hideLoadingView];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置状态栏颜色
    [self setStatusBarBackgroundColor:UIColorFromRGB(0xFFA500)];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
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
    _tbView.delegate = self;
    _tbView.dataSource = self;
    [bgView addSubview:_tbView];
    
    
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _nextBtn.frame = CGRectMake(15, _tbView.bottom+30, kScreen_Width - 30, 45);
    if (self.typeAddr == typeEditAddress) {
        [_nextBtn setTitle:@"编辑保存" forState:UIControlStateNormal];
    }else{
        [_nextBtn setTitle:@"保存" forState:UIControlStateNormal];
    }
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _nextBtn.backgroundColor = NavBarItemColor;
    _nextBtn.layer.masksToBounds = YES;
    _nextBtn.layer.cornerRadius = 5;
    [bgView addSubview:_nextBtn];
    [_nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tbView) {
        return 8;
    }else if (tableView == self.proTableView){
        switch (tableView.tag) {
            case 102:{
                return _provinceDataArray.count;
            }break;
            case 103:{
                return _cityDataArray.count;
            }break;
            case 104:{
                return _countryDataArray.count;
            }break;
            case 105:{
                return _viliageDataArray.count;
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
    if (tableView == _tbView) {
        NSArray* titleArray = @[@"收货人",@"联系手机",@"省",@"市",@"区/县",@"小区",@"详细地址",@"设为常用地址"];
        cell.textLabel.text = titleArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        CGFloat cellHeight = 44;
        NSArray* placeholderArray;
        if (IsEmptyValue(self.addrModel.custname)) {
            placeholderArray = @[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:ACCOUNTNAME]],[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:USERPHONE]],@"省",@"市",@"县",@"小区名称",@"请输入详细地址",@"0"];
        }else{
            placeholderArray = @[[NSString stringWithFormat:@"%@",self.addrModel.custname],[NSString stringWithFormat:@"%@",self.addrModel.phone],@"省",@"市",@"县",@"小区名称",@"请输入详细地址",@"0"];
        }
        
        NSArray* fomalArray =
      @[[NSString stringWithFormat:@"%@",self.addrModel.custname],
        [NSString stringWithFormat:@"%@",self.addrModel.phone],
        [NSString stringWithFormat:@"%@",self.addrModel.province],
        [NSString stringWithFormat:@"%@",self.addrModel.city],
        [NSString stringWithFormat:@"%@",self.addrModel.area],
        [NSString stringWithFormat:@"%@",self.addrModel.village],
        [NSString stringWithFormat:@"%@",self.addrModel.address],
        [NSString stringWithFormat:@"%@",self.addrModel.isdefault]];
        if (indexPath.row == 0||indexPath.row == 1||indexPath.row == 6) {
            UITextField* textField = [[UITextField alloc]initWithFrame:CGRectMake(120, 0, kScreen_Width - 120 - 10, cellHeight)];
            if (self.typeAddr == typeEditAddress) {
                if (indexPath.row == 6) {
                    textField.placeholder = fomalArray[indexPath.row];
                }else{
                    textField.text = fomalArray[indexPath.row];
                }
            }else{
                if (indexPath.row == 6) {
                    textField.placeholder = placeholderArray[indexPath.row];
                }else{
                    textField.text = placeholderArray[indexPath.row];
                }
            }
            textField.textColor = GrayTitleColor;
            textField.textAlignment = NSTextAlignmentRight;
            textField.delegate = self;
            textField.font = [UIFont systemFontOfSize:14];
            textField.tag = 100+indexPath.row;
            [cell.contentView addSubview:textField];
            UILabel* line = [[UILabel alloc]initWithFrame:CGRectMake(0, 43, kScreen_Width, 2)];
            line.backgroundColor = LineColor;
            [cell.contentView addSubview:line];
//            if (indexPath.row == 1||indexPath.row == 0) {
//                textField.userInteractionEnabled = NO;
//            }
        }else if (indexPath.row == 2||indexPath.row == 3||indexPath.row == 4||indexPath.row == 5){
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.frame = CGRectMake(120, 0, kScreen_Width - 120 - 10, cellHeight);
            if (self.typeAddr == typeEditAddress) {
                [btn setTitle:fomalArray[indexPath.row] forState:UIControlStateNormal];
            }else{
                [btn setTitle:placeholderArray[indexPath.row] forState:UIControlStateNormal];
            }
            [btn setTitleColor:GrayTitleColor forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn.tag = 100+indexPath.row;
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [cell.contentView addSubview:btn];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            UILabel* line = [[UILabel alloc]initWithFrame:CGRectMake(0, 43, kScreen_Width, 2)];
            line.backgroundColor = LineColor;
            [cell.contentView addSubview:line];
        }else if (indexPath.row == 7){
            _switch = [[UISwitch alloc]initWithFrame:CGRectMake(kScreen_Width - 90, 5, 80, 35)];
            if (self.typeAddr == typeEditAddress) {
                if ([fomalArray[indexPath.row] integerValue] == 1) {
                    [_switch setOn:YES];
                }else{
                    [_switch setOn:NO];
                }
            }else{
                [_switch setOn:YES];
                _switch.userInteractionEnabled = NO;
            }
            [cell.contentView addSubview:_switch];
            [_switch addTarget:self action:@selector(swChange:) forControlEvents:UIControlEventValueChanged];
        }
    }else if (tableView == self.proTableView){
        
        switch (tableView.tag) {
            case 102:{
                if (!IsEmptyValue(_provinceDataArray)) {
                    ProvinceModel* model = _provinceDataArray[indexPath.row];
                    cell.textLabel.text = [NSString stringWithFormat:@"%@",model.areaname];
                }
            }break;
            case 103:{
                if (!IsEmptyValue(_cityDataArray)) {
                    CityModel* model = _cityDataArray[indexPath.row];
                    cell.textLabel.text = [NSString stringWithFormat:@"%@",model.areaname];
                }
            }break;
            case 104:{
                if (!IsEmptyValue(_countryDataArray)) {
                    ContryModel* model = _countryDataArray[indexPath.row];
                    cell.textLabel.text = [NSString stringWithFormat:@"%@",model.areaname];
                }
            }break;
            case 105:{
                if (!IsEmptyValue(_viliageDataArray)) {
                    ViligeModel* model = _viliageDataArray[indexPath.row];
                    cell.textLabel.text = [NSString stringWithFormat:@"%@",model.areaname];
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
            case 102:{
                if (!IsEmptyValue(_provinceDataArray)) {
                    ProvinceModel* model = _provinceDataArray[indexPath.row];
                    _provinceid = [NSString stringWithFormat:@"%@",model.areaid];
                    
                    UIButton* btn =(UIButton*)[self.view viewWithTag:102];
                    [btn setTitle:[NSString stringWithFormat:@"%@",model.areaname] forState:UIControlStateNormal];
                    [_popView removeFromSuperview];
                    [_cityDataArray removeAllObjects];
                    _cityid = @"";
                    [_countryDataArray removeAllObjects];
                    _countryid = @"";
                    [_viliageDataArray removeAllObjects];
                    _xiaoquid = @"";
                    for (int i = 103 ; i < 106 ;i++) {
                        UIButton* btn = [self.view viewWithTag:i];
                        [btn setTitle:@" " forState:UIControlStateNormal];
                    }
                }
            }break;
            case 103:{
                if (!IsEmptyValue(_cityDataArray)) {
                    CityModel* model = _cityDataArray[indexPath.row];
                    _cityid = [NSString stringWithFormat:@"%@",model.areaid];
                    UIButton* btn = [self.view viewWithTag:103];
                    [btn setTitle:[NSString stringWithFormat:@"%@",model.areaname] forState:UIControlStateNormal];
                    [_popView removeFromSuperview];
                    [_countryDataArray removeAllObjects];
                    _countryid = @"";
                    [_viliageDataArray removeAllObjects];
                    _xiaoquid = @"";
                    for (int i = 104 ; i < 106 ;i++) {
                        UIButton* btn = [self.view viewWithTag:i];
                        [btn setTitle:@" " forState:UIControlStateNormal];
                    }
                }
            }break;
            case 104:{
                if (!IsEmptyValue(_countryDataArray)) {
                    ContryModel* model = _countryDataArray[indexPath.row];
                    _countryid = [NSString stringWithFormat:@"%@",model.areaid];
                    UIButton* btn = [self.view viewWithTag:104];
                    [btn setTitle:[NSString stringWithFormat:@"%@",model.areaname] forState:UIControlStateNormal];
                    [_popView removeFromSuperview];
                    [_viliageDataArray removeAllObjects];
                    _xiaoquid = @"";
                    for (int i = 105 ; i < 106 ;i++) {
                        UIButton* btn = [self.view viewWithTag:i];
                        [btn setTitle:@" " forState:UIControlStateNormal];
                    }
                }
            }break;
            case 105:{
                if (!IsEmptyValue(_viliageDataArray)) {
                    ViligeModel* model = _viliageDataArray[indexPath.row];
                    _xiaoquid = [NSString stringWithFormat:@"%@",model.areaid];
                    UIButton* btn = (UIButton*)[self.view viewWithTag:105];
                    [btn setTitle:[NSString stringWithFormat:@"%@",model.areaname] forState:UIControlStateNormal];
                    [_popView removeFromSuperview];
                }
            }break;
            default:break;
        }

    }
}

- (void)btnClick:(UIButton*)sender{
    switch (sender.tag) {
        case 102:{
            [self popViewUI:102];
                [self provinceDataRequest];
            
        }break;
        case 103:{
            [self popViewUI:103];
            [self cityDataRequest];
            
        }break;
        case 104:{
            [self popViewUI:104];
            [self countyDataRequest];
        }break;
        case 105:{
            [self popViewUI:105];
            [self villageDataRequest];
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
    
    UITextField* textField = (UITextField*)[self.view viewWithTag:106];
    [textField resignFirstResponder];
}


- (void)closePop{
    [_popView removeFromSuperview];
    
}

- (void)swChange:(UISwitch*)sender{

}

- (void)nextBtnClick:(UIButton*)sender{
    UITextField* textField1 = (UITextField*)[_tbView viewWithTag:100];
    UITextField* textField2 = (UITextField*)[_tbView viewWithTag:101];
    UITextField* textField = (UITextField*)[_tbView viewWithTag:106];
    if ([textField1.text isEqualToString:@""]) {
        [self customAlert:@"请填写收货人"];
        return;
    }
    if ([textField2.text isEqualToString:@""]) {
        [self customAlert:@"请填写联系电话"];
        return;
    }
    if (IsEmptyValue(_provinceid)||IsEmptyValue(_cityid)||IsEmptyValue(_countryid)||IsEmptyValue(_xiaoquid)) {
        [self customAlert:@"地址信息填写不完整"];
        return;
    }
    if (self.typeAddr == typeEditAddress) {
        //编辑
        [self editAddrRequest];
    }else{
        //保存
        [self newAddrRequest];
        
    }
   
}

- (void)editAddrRequest{
/*
 mallAddressManage?action=updateCustAddress  修改地址
 */
    UITextField* textField = (UITextField*)[_tbView viewWithTag:106];
    UITextField* textField1 = (UITextField*)[_tbView viewWithTag:100];
    UITextField* textField2 = (UITextField*)[_tbView viewWithTag:101];
    NSString* defaultStr;
    if (_switch.on) {
        defaultStr = @"1";
    }else{
        defaultStr = @"0";
    }
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"id\":\"%@\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\",\"villageid\":\"%@\",\"address\":\"%@\",\"isdefault\":\"%@\",\"name\":\"%@\",\"phone\":\"%@\"}",self.addrModel.Id,_provinceid,_cityid,_countryid,_xiaoquid,textField.text,defaultStr,textField1.text,textField2.text]};
    //NSLog(@"%@",params);
    
    [HTNetWorking postWithUrl:@"mallAddressManage?action=updateCustAddress" refreshCache:YES showHUD:@"加载中" params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
//            [Command customAlert:@"编辑地址成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
       // NSLog(@"编辑地址  %@",str);
    } fail:^(NSError *error) {
        
    }];
    
}

- (void)newAddrRequest{
    UITextField* textField = (UITextField*)[_tbView viewWithTag:106];
    UITextField* textField1 = (UITextField*)[_tbView viewWithTag:100];
    UITextField* textField2 = (UITextField*)[_tbView viewWithTag:101];
/*
 mallAddressManage?action=addCustAddress
 provinceid，cityid，areaid,villageid,address,isdefault
 */
//    NSString* defaultStr;
//    if (_switch.on) {
//        defaultStr = @"1";
//    }else{
//        defaultStr = @"0";
//    }
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\",\"villageid\":\"%@\",\"address\":\"%@\",\"isdefault\":\"1\",\"name\":\"%@\",\"phone\":\"%@\"}",_provinceid,_cityid,_countryid,_xiaoquid,textField.text,textField1.text,textField2.text]};
    [HTNetWorking postWithUrl:@"mallAddressManage?action=addCustAddress" refreshCache:YES showHUD:@"加载中" params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } fail:^(NSError *error) {
        
    }];
}

- (void)provinceDataRequest{
    [HTNetWorking postWithUrl:@"register?action=loadProvince" refreshCache:YES params:nil success:^(id response) {
        //        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        //        NSLog(@"县数据%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (!IsEmptyValue(array)) {
            [_provinceDataArray removeAllObjects];
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
    [HTNetWorking postWithUrl:@"register?action=loadCity" refreshCache:YES params:params success:^(id response) {
        //        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        //        NSLog(@"市数据%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (!IsEmptyValue(array)) {
            [_cityDataArray removeAllObjects];
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
    [HTNetWorking postWithUrl:@"register?action=loadCountry" refreshCache:YES params:params success:^(id response) {
        //        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        //        NSLog(@"县数据%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (!IsEmptyValue(array)) {
            [_countryDataArray removeAllObjects];
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
- (void)villageDataRequest{
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"countryid\":\"%@\"}",_countryid]};
    [HTNetWorking postWithUrl:@"register?action=loadXiaoqu" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"小区数据%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (!IsEmptyValue(array)) {
            [_viliageDataArray removeAllObjects];
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


@end
