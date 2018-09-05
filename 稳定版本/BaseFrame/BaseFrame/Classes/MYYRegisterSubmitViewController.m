//
//  MYYRegisterSubmitViewController.m
//  BaseFrame
//
//  Created by apple on 17/5/5.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYRegisterSubmitViewController.h"
#import "RegistReferModel.h"
#import "ProvinceModel.h"

@interface MYYRegisterSubmitViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITextField* _pwdField;
    UITextField* _againPwdField;
    UITextField* _phoneField;
    NSMutableArray* _downBtnArray;
    UIView* _popView;
    UIButton* _hide_keHuPopViewBut;
    NSString* _provinceid;
    NSMutableArray* _provinceDataArray;
    NSString* _cityid;
    NSMutableArray* _cityDataArray;
    NSString* _countryid;
    NSMutableArray* _countryDataArray;
    NSString* _xiaoquid;
    NSMutableArray* _viliageDataArray;
    NSString* _chargerid;
    NSString* _chargername;
    NSMutableArray* _chargeDataArray;
    NSString* _recommenderid;
    NSString* _recommendername;
    
    
}
@property (nonatomic,strong)UITableView* proTableView;
@end

@implementation MYYRegisterSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _downBtnArray = [NSMutableArray arrayWithCapacity:5];
    _provinceDataArray = [[NSMutableArray alloc]init];
    _cityDataArray = [[NSMutableArray alloc]init];
    _countryDataArray = [[NSMutableArray alloc]init];
    _viliageDataArray = [[NSMutableArray alloc]init];
    _chargeDataArray = [[NSMutableArray alloc]init];
    self.title = @"注册";
    
    [self creatUI];
}

- (void)creatUI
{
    UIScrollView* bgSView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    bgSView.contentSize = CGSizeMake(kScreen_Width, 714);
    bgSView.showsVerticalScrollIndicator = NO;
    bgSView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:bgSView];
    _pwdField = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, kScreen_Width - 40, 54)];
    _pwdField.delegate = self;
    _pwdField.secureTextEntry = YES;
    _pwdField.placeholder = @"请输入登录密码";
    _pwdField.font = [UIFont systemFontOfSize:14];
    _pwdField.keyboardType = UIKeyboardTypeASCIICapable;//数字英文键盘
    _pwdField.enablesReturnKeyAutomatically = YES; //这里设置为无文字就灰色不可点
    [bgSView addSubview:_pwdField];
    UIView* line1 = [[UIView alloc]initWithFrame:CGRectMake(_pwdField.left, _pwdField.bottom, _pwdField.width, 1)];
    line1.backgroundColor = LineColor;
    [bgSView addSubview:line1];
    
    _againPwdField = [[UITextField alloc]initWithFrame:CGRectMake(_pwdField.left, line1.bottom, _pwdField.width, 54)];
    _againPwdField.delegate = self;
    _againPwdField.secureTextEntry = YES;
    _againPwdField.placeholder = @"请输入确认密码";
    _againPwdField.font = [UIFont systemFontOfSize:14];
    _againPwdField.keyboardType = UIKeyboardTypeASCIICapable;
    _againPwdField.enablesReturnKeyAutomatically = YES;
    [bgSView addSubview:_againPwdField];
    UIView* line1_1 = [[UIView alloc]initWithFrame:CGRectMake(_againPwdField.left, _againPwdField.bottom, _againPwdField.width, 1)];
    line1_1.backgroundColor = LineColor;
    [bgSView addSubview:line1_1];
    
    _phoneField = [[UITextField alloc]initWithFrame:CGRectMake(_pwdField.left, line1_1.bottom, _pwdField.width, _pwdField.height)];
    _phoneField.delegate = self;
    _phoneField.placeholder = @"请输入推荐人手机号（可选）";
    _phoneField.font = [UIFont systemFontOfSize:14];
    _phoneField.keyboardType = UIKeyboardTypeASCIICapable;
    [bgSView addSubview:_phoneField];
    UIView* line2 = [[UIView alloc]initWithFrame:CGRectMake(_phoneField.left, _phoneField.bottom, _phoneField.width, 1)];
    line2.backgroundColor = LineColor;
    [bgSView addSubview:line2];
    NSArray* placeholderArray  = @[@"",@"",@"",@"",@""];
    NSArray* leftLabelArray= @[@"请选择所在省(可选)",@"请选择所在市(可选)",@"请选择所在县(可选)",@"请选择所在小区(可选)",@"请选择负责人(可选)"];
    for (int i = 0; i < leftLabelArray.count; i++) {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(20, line2.bottom+i*55, 145, _phoneField.height)];
        label.text = leftLabelArray[i];
        label.font = [UIFont systemFontOfSize:14];
        [bgSView addSubview:label];
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:placeholderArray[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:GrayTitleColor forState:UIControlStateNormal];
        btn.frame = CGRectMake(label.right, label.top, _phoneField.width - 30 - label.width, _phoneField.height);
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn addTarget:self action:@selector(downBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgSView addSubview:btn];
        [_downBtnArray addObject:btn];
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(_phoneField.left, _phoneField.bottom+55*i+54, _phoneField.width, 1)];
        line.backgroundColor = LineColor;
        [bgSView addSubview:line];
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(_phoneField.right - 30, _phoneField.bottom+(_phoneField.height - 5)*0.5+55*i, 10, 5)];
        imageView.image = [UIImage imageNamed:@"downBtn"];
        [bgSView addSubview:imageView];
    }

    UIButton* registBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    registBtn.frame = CGRectMake(_phoneField.left,_phoneField.bottom+55*leftLabelArray.count+40 , _phoneField.width, 45);
    registBtn.backgroundColor = NavBarItemColor;
    [registBtn setTitle:@"提交注册" forState:UIControlStateNormal];
    [registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registBtn.layer.masksToBounds = YES;
    registBtn.layer.cornerRadius = 5;
    [bgSView addSubview:registBtn];
    [registBtn addTarget:self action:@selector(registBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)downBtnClick:(UIButton*)sender{
    if (sender == _downBtnArray[0]) {
        [self popViewUI:0];
        [_provinceDataArray removeAllObjects];
        _provinceid = @"";
        [_cityDataArray removeAllObjects];
        _cityid = @"";
        [_countryDataArray removeAllObjects];
        _countryid = @"";
        [_viliageDataArray removeAllObjects];
        _xiaoquid = @"";
        [_chargeDataArray removeAllObjects];
        _chargerid = @"";
        for (int i = 0 ; i < _downBtnArray.count ;i++) {
            UIButton* btn = _downBtnArray[i];
            [btn setTitle:@" " forState:UIControlStateNormal];
        }
        [self provinceDataRequest];
    }else if (sender == _downBtnArray[1]){
        [self popViewUI:1];
        [_cityDataArray removeAllObjects];
        _cityid = @"";
        [_countryDataArray removeAllObjects];
        _countryid = @"";
        [_viliageDataArray removeAllObjects];
        _xiaoquid = @"";
        [_chargeDataArray removeAllObjects];
        _chargerid = @"";
        for (int i = 1 ; i < _downBtnArray.count ;i++) {
            UIButton* btn = _downBtnArray[i];
            [btn setTitle:@" " forState:UIControlStateNormal];
        }
        [self cityDataRequest];
    }else if (sender == _downBtnArray[2]){
        [self popViewUI:2];
        [_countryDataArray removeAllObjects];
        _countryid = @"";
        [_viliageDataArray removeAllObjects];
        _xiaoquid = @"";
        [_chargeDataArray removeAllObjects];
        _chargerid = @"";
        for (int i = 2 ; i < _downBtnArray.count ;i++) {
            UIButton* btn = _downBtnArray[i];
            [btn setTitle:@" " forState:UIControlStateNormal];
        }
        [self countyDataRequest];
    }else if (sender == _downBtnArray[3]){
        [self popViewUI:3];
        [_viliageDataArray removeAllObjects];
        _xiaoquid = @"";
        [_chargeDataArray removeAllObjects];
        _chargerid = @"";
        for (int i = 3 ; i < _downBtnArray.count ;i++) {
            UIButton* btn = _downBtnArray[i];
            [btn setTitle:@" " forState:UIControlStateNormal];
        }
        [self villageDataRequest];
    }else if (sender == _downBtnArray[4]){
        [self popViewUI:4];
        [_chargeDataArray removeAllObjects];
        _chargerid = @"";
        for (int i = 4 ; i < _downBtnArray.count ;i++) {
            UIButton* btn = _downBtnArray[i];
            [btn setTitle:@" " forState:UIControlStateNormal];
        }
        [self personInChargeRequest];
    }
}

- (void)registBtnClick:(UIButton*)sender{
    //self.phone,self.phone,self.phone,self.phone,_pwdField.text必填
    if (!IsEmptyValue(_pwdField.text)) {
        if ([_pwdField.text isEqualToString:_againPwdField.text]) {
            if ([Command isPassword:_pwdField.text]&&[Command isPassword:_againPwdField.text]) {
                if (!IsEmptyValue(self.phone)) {
                    if (!IsEmptyValue(_phoneField.text)) {
                        
                        NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"phone\":\"%@\"}",_phoneField.text]};
                        [HTNetWorking postWithUrl:@"register?action=isExitsPhone" refreshCache:YES params:params success:^(id response) {
                            NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
                            NSLog(@"推荐人%@",str);
                            if ([str rangeOfString:@"true"].location!=NSNotFound) {
                                [Command customAlert:@"推荐人不存在"];
                            }else{
                                [self registDataRequest];
                            }
                            
                        } fail:^(NSError *error) {
                            
                        }];

                        
//                        if (!IsEmptyValue(_recommenderid)&&!IsEmptyValue(_recommendername)) {
//                            [self registDataRequest];
//                        }else{
//                            [self customAlert:@"推荐人不存在"];
//                        }
                        
                    }else{
                        [self registDataRequest];
                    }
                }
            }else{
                [self customAlert:@"密码大于6位"];
            }
        }else{
            [self customAlert:@"两次密码输入不一致"];
        }
    }else{
        [self customAlert:@"密码为空"];
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
    self.proTableView.tag = 100+tag;
    self.proTableView.rowHeight = 80;
    [_popView addSubview:self.proTableView];
    //        [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:_popView];

}


- (void)closePop{
    [_popView removeFromSuperview];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 100:{
            return _provinceDataArray.count;
        }break;
        case 101:{
            return _cityDataArray.count;
        }break;
        case 102:{
            return _countryDataArray.count;
        }break;
        case 103:{
            return _viliageDataArray.count;
        }break;
        case 104:{
            return _chargeDataArray.count;
        }break;
        default:return 0;
            break;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"cellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    switch (tableView.tag) {
        case 100:{
            if (!IsEmptyValue(_provinceDataArray)) {
                ProvinceModel* model = _provinceDataArray[indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat:@"%@",model.areaname];
            }
        }break;
        case 101:{
            if (!IsEmptyValue(_cityDataArray)) {
                CityModel* model = _cityDataArray[indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat:@"%@",model.areaname];
            }
        }break;
        case 102:{
            if (!IsEmptyValue(_countryDataArray)) {
                ContryModel* model = _countryDataArray[indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat:@"%@",model.areaname];
            }
        }break;
        case 103:{
            if (!IsEmptyValue(_viliageDataArray)) {
                ViligeModel* model = _viliageDataArray[indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat:@"%@",model.areaname];
            }
        }break;
        case 104:{
            if (!IsEmptyValue(_chargeDataArray)) {
                ChargeModel* model = _chargeDataArray[indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat:@"%@",model.accountname];
            }
        }break;
        default:break;
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case 100:{
            if (!IsEmptyValue(_provinceDataArray)) {
                ProvinceModel* model = _provinceDataArray[indexPath.row];
                _provinceid = [NSString stringWithFormat:@"%@",model.areaid];
                UIButton* btn = _downBtnArray[tableView.tag-100];
                [btn setTitle:[NSString stringWithFormat:@"%@",model.areaname] forState:UIControlStateNormal];
                [_popView removeFromSuperview];
            }
        }break;
        case 101:{
            if (!IsEmptyValue(_cityDataArray)) {
                CityModel* model = _cityDataArray[indexPath.row];
                _cityid = [NSString stringWithFormat:@"%@",model.areaid];
                UIButton* btn = _downBtnArray[tableView.tag-100];
                [btn setTitle:[NSString stringWithFormat:@"%@",model.areaname] forState:UIControlStateNormal];
                [_popView removeFromSuperview];
            }
        }break;
        case 102:{
            if (!IsEmptyValue(_countryDataArray)) {
                ContryModel* model = _countryDataArray[indexPath.row];
                _countryid = [NSString stringWithFormat:@"%@",model.areaid];
                UIButton* btn = _downBtnArray[tableView.tag-100];
                [btn setTitle:[NSString stringWithFormat:@"%@",model.areaname] forState:UIControlStateNormal];
                [_popView removeFromSuperview];
            }
        }break;
        case 103:{
            if (!IsEmptyValue(_viliageDataArray)) {
                ViligeModel* model = _viliageDataArray[indexPath.row];
                _xiaoquid = [NSString stringWithFormat:@"%@",model.areaid];
                UIButton* btn = _downBtnArray[tableView.tag-100];
                [btn setTitle:[NSString stringWithFormat:@"%@",model.areaname] forState:UIControlStateNormal];
                [_popView removeFromSuperview];
            }
        }break;
        case 104:{
            if (!IsEmptyValue(_chargeDataArray)) {
                ChargeModel* model = _chargeDataArray[indexPath.row];
                _chargerid = [NSString stringWithFormat:@"%@",model.accountid];
                _chargername = [NSString stringWithFormat:@"%@",model.accountname];
                UIButton* btn = _downBtnArray[tableView.tag-100];
                [btn setTitle:[NSString stringWithFormat:@"%@",model.accountname] forState:UIControlStateNormal];
                [_popView removeFromSuperview];
            }
        }break;
        default:break;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _pwdField) {
        if (![Command isPassword:_pwdField.text]) {
            [Command customAlert:@"密码长度6-20位"];
        }
    }else if (textField == _againPwdField){
//        if (![Command isPassword:_againPwdField.text]) {
//            [Command customAlert:@"密码长度6-20位"];
//        }
        if (![_pwdField.text isEqualToString:_againPwdField.text]) {
            [Command customAlert:@"两次输入密码不一致"];
        }
    }else if (textField == _phoneField){
        if (!IsEmptyValue(_phoneField.text)) {
            [self referrerDataRequest];
        }
    }
}

- (void)referrerDataRequest{
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"phone\":\"%@\"}",_phoneField.text]};
    [HTNetWorking postWithUrl:@"register?action=isExitsPhone" refreshCache:YES  params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"推荐人%@",str);
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            [Command customAlert:@"推荐人不存在"];
        }else{
            NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            if (!IsEmptyValue(array)) {
                NSDictionary* dict = array[0];
                RegistReferModel* model = [[RegistReferModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                _recommenderid = [NSString stringWithFormat:@"%@",model.Id];
                _recommendername = [NSString stringWithFormat:@"%@",model.name];
            }
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

- (void)personInChargeRequest{
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"xiaoquid\":\"%@\"}",_xiaoquid]};
    [HTNetWorking postWithUrl:@"register?action=loadChargeid" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"负责人数据%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if (!IsEmptyValue(array)) {
            [_chargeDataArray removeAllObjects];
            for (NSDictionary* dict in array) {
                ChargeModel* model = [[ChargeModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_chargeDataArray addObject:model];
            }
            [self.proTableView reloadData];
        }
    } fail:^(NSError *error) {
        
    }];
}

- (void)registDataRequest{
    /*
     （custname，phone，name，accountname）此值都为电话号码，password（必填），isvalid="1"，score="0"，balance="0"，provinceid，cityid，areaid
     ，villageid，chargerid（负责人id）chargername（负责人名称），recommenderid（推荐人id），recommendername（推荐人名称）
     */
    _provinceid = [Command convertNull:_provinceid];
    _cityid = [Command convertNull:_cityid];
    _countryid = [Command convertNull:_countryid];
    _xiaoquid = [Command convertNull:_xiaoquid];
    _chargerid = [Command convertNull:_chargerid];
    _chargername = [Command convertNull:_chargername];
    _recommenderid = [Command convertNull:_recommenderid];
    _recommendername = [Command convertNull:_recommendername];
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"custname\":\"%@\",\"phone\":\"%@\",\"name\":\"%@\",\"accountname\":\"%@\",\"password\":\"%@\",\"isvalid\":\"1\",\"score\":\"0\",\"balance\":\"0\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\",\"villageid\":\"%@\",\"chargerid\":\"%@\",\"chargername\":\"%@\",\"recommenderid\":\"%@\",\"recommendername\":\"%@\"}",self.phone,self.phone,self.phone,self.phone,_pwdField.text,_provinceid,_cityid,_countryid,_xiaoquid,_chargerid,_chargername,_recommenderid,_recommendername]};
    NSLog(@"注册参数%@",params);
    [HTNetWorking postWithUrl:@"register?action=addCoustomer" refreshCache:YES showHUD:@"" params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            NSArray* array = self.navigationController.viewControllers;
            UIViewController *viewCtl = self.navigationController.viewControllers[array.count - 1 - 2];
            [self.navigationController popToViewController:viewCtl animated:YES];
        }else{
            [self customAlert:@"注册失败"];
        }
    } fail:^(NSError *error) {
        
    }];
}



@end
