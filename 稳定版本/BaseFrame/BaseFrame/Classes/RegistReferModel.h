//
//  RegistReferModel.h
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/9.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface RegistReferModel : BaseModel
@property (nonatomic,strong)NSString* custname;
@property (nonatomic,strong)NSString* phone;
@property (nonatomic,strong)NSString* name;
@property (nonatomic,strong)NSString* password;
@property (nonatomic,strong)NSString* picname;
@property (nonatomic,strong)NSString* folder;
@property (nonatomic,strong)NSString* isvalid;
@property (nonatomic,strong)NSString* note;
@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* recommenderid;
@property (nonatomic,strong)NSString* chargerid;
@property (nonatomic,strong)NSString* score;
@property (nonatomic,strong)NSString* balance;
@property (nonatomic,strong)NSString* recommendername;
@property (nonatomic,strong)NSString* chargername;
@property (nonatomic,strong)NSString* autoname;
@property (nonatomic,strong)NSString* uuid;
@property (nonatomic,strong)NSString* accountname;
/*
[{"custname":"15753032591","phone":"15753032591","name":"15753032591","password":"song@2499","picname":"","folder":"","createtime":"2017-05-08 09:09:57","isvalid":1,"note":"","id":34,"recommenderid":0,"chargerid":0,"score":0,"balance":0,"recommendername":"","chargername":"","autoname":"","uuid":"213a4784-16a1-43fe-b0c3-de303ced6bc3","accountname":"15753032591"}]
 */
@end
