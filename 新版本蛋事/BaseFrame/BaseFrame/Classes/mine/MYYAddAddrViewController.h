//
//  MYYAddAddrViewController.h
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/9.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

//ui隐藏
typedef enum {
    typeEditAddress = 0,
    typeAddAddress = 1,
}	typeAddress;

#import "BaseViewController.h"
#import "MYYMinesearchAddressModel.h"

@interface MYYAddAddrViewController : BaseViewController
@property (nonatomic,assign)typeAddress typeAddr;
@property (nonatomic,strong)MYYMinesearchAddressModel * addrModel;
@end
