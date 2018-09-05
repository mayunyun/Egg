//
//  ChildrenProductOneCell.h
//  BaseFrame
//
//  Created by 钱龙 on 2018/3/14.
//  Copyright © 2018年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYYDetailsWebModel.h"
@interface ChildrenProductOneCell : UITableViewCell
@property(nonatomic,strong)void (^upBlock)(NSInteger);
@property(nonatomic,strong)void (^downBlock)(NSInteger);

@property (weak, nonatomic) IBOutlet UILabel *proname;
@property (weak, nonatomic) IBOutlet UILabel *proprice;
@property (weak, nonatomic) IBOutlet UILabel *guige;
@property (weak, nonatomic) IBOutlet UIButton *down;
@property (weak, nonatomic) IBOutlet UIButton *up;
@property (weak, nonatomic) IBOutlet UITextField *count;
@property (nonatomic,strong)MYYDetailsWebModel * model;
@end
