//
//  MYYAddManageTableViewCell.h
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/11.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

@class MYYMinesearchAddressModel;
@protocol MYYAddManageTableViewCellDelegate <NSObject>

- (void)defaultBtnClick:(id)sender Id:(NSString*)Id;
- (void)editBtnClick:(id)sender model:(MYYMinesearchAddressModel*)model;
- (void)deleteBtnClick:(id)sender model:(MYYMinesearchAddressModel*)model;

@end


#import <UIKit/UIKit.h>
#import "MYYMinesearchAddressModel.h"
@interface MYYAddManageTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UIButton *defaultBtn;
- (IBAction)defaultBtnClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *editBtn;
- (IBAction)editBtnClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
- (IBAction)deleteBtnClick:(id)sender;
@property (nonatomic,strong)MYYMinesearchAddressModel* model;
//block声明
@property (weak,nonatomic)id<MYYAddManageTableViewCellDelegate> delegate;
@end
