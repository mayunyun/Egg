//
//  ChildrenProductTwoCell.h
//  BaseFrame
//
//  Created by 钱龙 on 2018/3/14.
//  Copyright © 2018年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYYDetailProCommentModel.h"
@interface ChildrenProductTwoCell : UITableViewCell
@property (nonatomic,strong)void(^seeMoreBlock)();
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (nonatomic,strong)MYYDetailProCommentModel * model;

@end
