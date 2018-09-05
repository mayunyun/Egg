//
//  HomeLineCollectionViewCell.m
//  BaseFrame
//
//  Created by 邱 德政 on 17/5/3.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "HomeLineCollectionViewCell.h"

@interface HomeLineCollectionViewCell()
{
    BOOL _isClick;
}
@end

@implementation HomeLineCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imgView.layer.masksToBounds = YES;
    self.imgView.layer.cornerRadius = 5;
}

- (IBAction)shopCarBtnClick:(id)sender {
    _isClick = !_isClick;
    if (_transVaule) {
        _transVaule(_isClick);
    }
}
@end
