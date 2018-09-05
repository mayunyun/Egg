//
//  NavigationTransitionAnimation.m
//  ViewControllerSwitchDemo
//
//  Created by 向用钧 on 15-7-24.
//  Copyright (c) 2014年 向用钧. All rights reserved.
//

#import "NavigationTransitionAnimation.h"
//#import "POP+MCAnimate.h"

@implementation NavigationTransitionAnimation

/*
//动画持续时间0.7秒
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 1.5;
}


- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    //通过键值UITransitionContextToViewControllerKey获得需要呈现的试图控制器
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //通过键值UITransitionContextFromViewControllerKey获得需要退出的试图控制器
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [[transitionContext containerView] addSubview:toVC.view];
    
    [fromVC.view setAlpha:1];
    //设置需要呈现的试图控制器透明
    [toVC.view setAlpha:1];
    //设置需要呈现的试图控制器位于左侧屏幕外，且大小为0.1倍，这样才有从左侧推入屏幕，且逐渐变大的动画效果
    
    
    toVC.view.transform = CGAffineTransformMakeTranslation(0, kScreen_Height);
    
    toVC.navigationController.navigationBarHidden = YES;
    
    /////
   
    /////
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        //将需要退出的试图控制器移出右侧屏幕外，且大小为原来的0.1倍
//        fromVC.view.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0), 0.1, 0.1);
        fromVC.view.alpha = 0.3;
        toVC.view.transform = CGAffineTransformIdentity;
        toVC.view.alpha = 1;
        toVC.navigationController.navigationBarHidden = YES;
        
        ////
//        POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
//        CGPoint point = toVC.view.center;
//        if (point.y == 240) {
//            springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(point.x, -230)];
//        }
//        else{
//            springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(point.x, 240)];
//        }
//        springAnimation.springBounciness = 100.0;
//        [toVC.view pop_addAnimation:springAnimation forKey:@"changeposition"];
        /////
 
    } completion:^(BOOL finished) {
        //动画结束后属性设为初始值
        fromVC.view.transform = CGAffineTransformIdentity;
        fromVC.view.alpha = 1;
        
        toVC.view.transform = CGAffineTransformIdentity;
        toVC.view.alpha = 1;
        toVC.navigationController.navigationBarHidden = NO;
        
       
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
        
        
    }];
    
    
}
 */
@end

@implementation BottomToTopAnimation
//动画持续时间0.7秒
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 1.5;
}


- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    //通过键值UITransitionContextToViewControllerKey获得需要呈现的试图控制器
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //通过键值UITransitionContextFromViewControllerKey获得需要退出的试图控制器
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [[transitionContext containerView] addSubview:toVC.view];
    
    [fromVC.view setAlpha:1];
    //设置需要呈现的试图控制器透明
    [toVC.view setAlpha:1];
    //设置需要呈现的试图控制器位于左侧屏幕外，且大小为0.1倍，这样才有从左侧推入屏幕，且逐渐变大的动画效果
    
    
    toVC.view.transform = CGAffineTransformMakeTranslation(0, kScreen_Height);
    
    toVC.navigationController.navigationBarHidden = YES;
    
    /////
    
    /////
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        //将需要退出的试图控制器移出右侧屏幕外，且大小为原来的0.1倍
        //        fromVC.view.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0), 0.1, 0.1);
        fromVC.view.alpha = 0.3;
        toVC.view.transform = CGAffineTransformIdentity;
        toVC.view.alpha = 1;
        toVC.navigationController.navigationBarHidden = YES;
        
        ////
        //        POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
        //        CGPoint point = toVC.view.center;
        //        if (point.y == 240) {
        //            springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(point.x, -230)];
        //        }
        //        else{
        //            springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(point.x, 240)];
        //        }
        //        springAnimation.springBounciness = 100.0;
        //        [toVC.view pop_addAnimation:springAnimation forKey:@"changeposition"];
        /////
        
    } completion:^(BOOL finished) {
        //动画结束后属性设为初始值
        fromVC.view.transform = CGAffineTransformIdentity;
        fromVC.view.alpha = 1;
        
        toVC.view.transform = CGAffineTransformIdentity;
        toVC.view.alpha = 1;
        toVC.navigationController.navigationBarHidden = NO;
        
        
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
        
        
    }];
    
    
}


@end


@implementation TopToBottomAnimation
//动画持续时间0.7秒
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 1.5;
}


- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    //通过键值UITransitionContextToViewControllerKey获得需要呈现的试图控制器
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //通过键值UITransitionContextFromViewControllerKey获得需要退出的试图控制器
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [[transitionContext containerView] addSubview:toVC.view];
    
    [fromVC.view setAlpha:1];
    //设置需要呈现的试图控制器透明
    [toVC.view setAlpha:1];
    //设置需要呈现的试图控制器位于左侧屏幕外，且大小为0.1倍，这样才有从左侧推入屏幕，且逐渐变大的动画效果
    
    
    toVC.view.transform = CGAffineTransformMakeTranslation(0, -kScreen_Height);
    
    toVC.navigationController.navigationBarHidden = YES;
    
    /////
    
    /////
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        //将需要退出的试图控制器移出右侧屏幕外，且大小为原来的0.1倍
        //        fromVC.view.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0), 0.1, 0.1);
        fromVC.view.alpha = 0.3;
        toVC.view.transform = CGAffineTransformIdentity;
        toVC.view.alpha = 1;
        toVC.navigationController.navigationBarHidden = YES;
        
        ////
        //        POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
        //        CGPoint point = toVC.view.center;
        //        if (point.y == 240) {
        //            springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(point.x, -230)];
        //        }
        //        else{
        //            springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(point.x, 240)];
        //        }
        //        springAnimation.springBounciness = 100.0;
        //        [toVC.view pop_addAnimation:springAnimation forKey:@"changeposition"];
        /////
        
    } completion:^(BOOL finished) {
        //动画结束后属性设为初始值
        fromVC.view.transform = CGAffineTransformIdentity;
        fromVC.view.alpha = 1;
        
        toVC.view.transform = CGAffineTransformIdentity;
        toVC.view.alpha = 1;
        toVC.navigationController.navigationBarHidden = NO;
        
        
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
        
        
    }];
    
    
}


@end


@implementation LeftToRightAnimation

//动画持续时间0.7秒
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 1.5;
}


- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    //通过键值UITransitionContextToViewControllerKey获得需要呈现的试图控制器
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //通过键值UITransitionContextFromViewControllerKey获得需要退出的试图控制器
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [[transitionContext containerView] addSubview:toVC.view];
    
    [fromVC.view setAlpha:1];
    //设置需要呈现的试图控制器透明
    [toVC.view setAlpha:1];
    //设置需要呈现的试图控制器位于左侧屏幕外，且大小为0.1倍，这样才有从左侧推入屏幕，且逐渐变大的动画效果
    
    
    toVC.view.transform = CGAffineTransformMakeTranslation(-kScreen_Width, 0);
    
    toVC.navigationController.navigationBarHidden = YES;
    
    /////
    
    /////
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        //将需要退出的试图控制器移出右侧屏幕外，且大小为原来的0.1倍
        //        fromVC.view.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0), 0.1, 0.1);
        fromVC.view.alpha = 0.3;
        toVC.view.transform = CGAffineTransformIdentity;
        toVC.view.alpha = 1;
        toVC.navigationController.navigationBarHidden = YES;
        
        ////
        //        POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
        //        CGPoint point = toVC.view.center;
        //        if (point.y == 240) {
        //            springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(point.x, -230)];
        //        }
        //        else{
        //            springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(point.x, 240)];
        //        }
        //        springAnimation.springBounciness = 100.0;
        //        [toVC.view pop_addAnimation:springAnimation forKey:@"changeposition"];
        /////
        
    } completion:^(BOOL finished) {
        //动画结束后属性设为初始值
        fromVC.view.transform = CGAffineTransformIdentity;
        fromVC.view.alpha = 1;
        
        toVC.view.transform = CGAffineTransformIdentity;
        toVC.view.alpha = 1;
        toVC.navigationController.navigationBarHidden = NO;
        
        
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
        
        
    }];
    
    
}

@end

@implementation RightToLeftAnimation

//动画持续时间0.7秒
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 1.5;
}


- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    //通过键值UITransitionContextToViewControllerKey获得需要呈现的试图控制器
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //通过键值UITransitionContextFromViewControllerKey获得需要退出的试图控制器
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [[transitionContext containerView] addSubview:toVC.view];
    
    [fromVC.view setAlpha:1];
    //设置需要呈现的试图控制器透明
    [toVC.view setAlpha:1];
    //设置需要呈现的试图控制器位于左侧屏幕外，且大小为0.1倍，这样才有从左侧推入屏幕，且逐渐变大的动画效果
    
    
    toVC.view.transform = CGAffineTransformMakeTranslation(kScreen_Width, 0);
    
    toVC.navigationController.navigationBarHidden = YES;
    
    /////
    
    /////
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        //将需要退出的试图控制器移出右侧屏幕外，且大小为原来的0.1倍
        //        fromVC.view.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0), 0.1, 0.1);
        fromVC.view.alpha = 0.3;
        toVC.view.transform = CGAffineTransformIdentity;
        toVC.view.alpha = 1;
        toVC.navigationController.navigationBarHidden = YES;
        
        ////
        //        POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
        //        CGPoint point = toVC.view.center;
        //        if (point.y == 240) {
        //            springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(point.x, -230)];
        //        }
        //        else{
        //            springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(point.x, 240)];
        //        }
        //        springAnimation.springBounciness = 100.0;
        //        [toVC.view pop_addAnimation:springAnimation forKey:@"changeposition"];
        /////
        
    } completion:^(BOOL finished) {
        //动画结束后属性设为初始值
        fromVC.view.transform = CGAffineTransformIdentity;
        fromVC.view.alpha = 1;
        
        toVC.view.transform = CGAffineTransformIdentity;
        toVC.view.alpha = 1;
        toVC.navigationController.navigationBarHidden = NO;
        
        
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
        
        
    }];
    
    
}

@end
