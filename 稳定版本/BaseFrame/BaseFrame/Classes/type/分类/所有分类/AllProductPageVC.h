//
//  AllProductPageVC.h
//  BaseFrame
//
//  Created by 钱龙 on 2018/3/13.
//  Copyright © 2018年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface AllProductPageVC : BaseViewController
@property (weak, nonatomic) IBOutlet UICollectionView *allProCollectionView;
@property (nonatomic,copy)NSString * title;
@property (nonatomic,copy)NSString * typeId;
@end
