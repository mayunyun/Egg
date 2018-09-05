//
//  AllCateItemHeaderView.m
//  categories
//
//  Created by 贺心元 on 2017/7/4.
//  Copyright © 2017年 ichina. All rights reserved.
//

#import "AllCateItemHeaderView.h"

@interface AllCateItemHeaderView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *moreBtn;
@end

@implementation AllCateItemHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
                
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, frame.size.width - 100, 20)];
        _titleLabel.textColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1.0];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreBtn.frame = CGRectMake(frame.size.width-80, 15, 70, 20);
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_moreBtn setTitle:@"查看全部" forState:UIControlStateNormal];
        [_moreBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreBtnCliked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_moreBtn];
        [self addSubview:_titleLabel];
    }
    return self;
}
-(void)moreBtnCliked{
    if (_moreBtnBlck) {
        self.moreBtnBlck();
    }
}
- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = _title;
}


@end
