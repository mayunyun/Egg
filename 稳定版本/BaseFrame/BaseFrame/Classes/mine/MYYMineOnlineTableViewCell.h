//
//  MYYMineOnlineTableViewCell.h
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/10.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYYMineOnlineTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *selectBtn1;
- (IBAction)selectBtnClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *selectBtn2;
- (IBAction)selectBtn2Click:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *selectBtn3;
- (IBAction)selectBtn3Click:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *selectBtn4;
- (IBAction)selectBtn4Click:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *moneyField;

@end
