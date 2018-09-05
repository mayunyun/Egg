//
//  MYYTypeDetailsCemmentTableViewCell.m
//  BaseFrame
//
//  Created by apple on 17/5/4.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MYYTypeDetailsCemmentTableViewCell.h"

@interface MYYTypeDetailsCemmentTableViewCell ()
{
    BOOL _isClick;
}
@end

@implementation MYYTypeDetailsCemmentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)totalBtnClick:(id)sender {
    _isClick = !_isClick;
    if (_transVaule) {
        _transVaule(_isClick);
    }
}
@end
