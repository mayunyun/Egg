//
//  HXSearchBar.m
//  黄轩博客 blog.libuqing.com
//  https://github.com/huangxuan518/HXSearchBar
//  Created by 黄轩 on 2017/1/18.
//  Copyright © 2017年 黄轩 IT小子. All rights reserved.
//

#import "HXSearchBar.h"

@implementation HXSearchBar

#pragma mark - Initializers
// ------------------------------------------------------------------------------------------
- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.hasCentredPlaceholder = NO;
    }
    
    return self;
}


// ------------------------------------------------------------------------------------------
#pragma mark - Methods
// ------------------------------------------------------------------------------------------
- (void)setHasCentredPlaceholder:(BOOL)hasCentredPlaceholder
{
    _hasCentredPlaceholder = hasCentredPlaceholder;
    
    SEL centerSelector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", @"setCenter", @"Placeholder:"]);
    if ([self respondsToSelector:centerSelector])
    {
        NSMethodSignature *signature = [[UISearchBar class] instanceMethodSignatureForSelector:centerSelector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:centerSelector];
        [invocation setArgument:&_hasCentredPlaceholder atIndex:2];
        [invocation invoke];
    }
    
}
//设置输入框光标颜色
- (void)setCursorColor:(UIColor *)cursorColor
{
    if (cursorColor) {
        _cursorColor = cursorColor;
        //获取输入框
        UITextField *searchField = self.searchBarTextField;
        if (searchField) {
            //光标颜色
            [searchField setTintColor:cursorColor];
        }
    }
}

//获取输入框
- (UITextField *)searchBarTextField
{
    //获取输入框
    _searchBarTextField.layer.borderColor = LineColor.CGColor;
    _searchBarTextField.layer.borderWidth = 1;
    _searchBarTextField.layer.masksToBounds = YES;
    _searchBarTextField.layer.cornerRadius = 5;
    _searchBarTextField = [self valueForKey:@"searchField"];
    return _searchBarTextField;
}

//设置清除按钮图标
- (void)setClearButtonImage:(UIImage *)clearButtonImage
{
    if (clearButtonImage) {
        _clearButtonImage = clearButtonImage;
        //获取输入框
        UITextField *searchField = self.searchBarTextField;
        if (searchField) {
            //设置清除按钮图片
            UIButton *button = [searchField valueForKey:@"_clearButton"];
            [button setImage:clearButtonImage forState:UIControlStateNormal];
            searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
        }
    }
}

- (void)setHideSearchBarBackgroundImage:(BOOL)hideSearchBarBackgroundImage {
    if (hideSearchBarBackgroundImage) {
        _hideSearchBarBackgroundImage = hideSearchBarBackgroundImage;
        self.backgroundImage = [[UIImage alloc] init];
    }
}

//获取取消按钮
- (UIButton *)cancleButton
{
    self.showsCancelButton = YES;
    for (UIView *view in [[self.subviews lastObject] subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            _cancleButton = (UIButton *)view;
        }
    }
    return _cancleButton;
}



@end
