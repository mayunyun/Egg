//
//  ChildrenProductTwoCell.m
//  BaseFrame
//
//  Created by 钱龙 on 2018/3/14.
//  Copyright © 2018年 济南联祥技术有限公司. All rights reserved.
//

#import "ChildrenProductTwoCell.h"

@implementation ChildrenProductTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)moreBtnClicked:(UIButton *)sender {
}
-(void)setModel:(MYYDetailProCommentModel *)model{
    _model = model;
//    [NSString stringWithFormat:@"%@%@%@",serverAddress,model.folder,model.]
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",HTImgUrl,model.folder,model.autoname]];
    [self.headImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"noHeadImg"]];
    self.name.text = model.custname;
    self.content.text = model.comments;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
