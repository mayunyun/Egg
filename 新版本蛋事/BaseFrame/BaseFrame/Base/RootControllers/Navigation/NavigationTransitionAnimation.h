//
//  NavigationTransitionAnimation.h
//  ViewControllerSwitchDemo
//
//  Created by 向用钧 on 15-7-24.
//  Copyright (c) 2014年 向用钧. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NavigationTransitionAnimation : NSObject<UIViewControllerAnimatedTransitioning>

@end

@interface BottomToTopAnimation : NavigationTransitionAnimation

@end


@interface RightToLeftAnimation : NavigationTransitionAnimation

@end

@interface TopToBottomAnimation : NavigationTransitionAnimation

@end

@interface LeftToRightAnimation : NavigationTransitionAnimation

@end