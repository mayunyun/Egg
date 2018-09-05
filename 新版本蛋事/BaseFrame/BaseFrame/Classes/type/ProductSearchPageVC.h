//
//  ProductSearchPageVC.h
//  BaseFrame
//
//  Created by 钱龙 on 2018/3/17.
//  Copyright © 2018年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface ProductSearchPageVC : BaseViewController
@property (weak, nonatomic) IBOutlet UICollectionView *allProCollectionView;
@property (nonatomic,strong)NSString* biaoshi;
@property (nonatomic,strong)NSString* specialid;
@property (nonatomic,strong)NSString* pronameLIKE;
@property (nonatomic,strong)NSString* controller;
@end
