//
//  BaseNavigationController.m
//  
//
//  Created by Ease on 15/2/5.
//  Copyright (c) 2015年 Coding. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(IOS7)
    {
        self.navigationBar.translucent = NO;
    }
}


/////////

/*
-(instancetype)initWithRootViewController:(UIViewController *)rootViewController{


    if (self = [super initWithRootViewController:rootViewController]) {
        self.delegate = self;
        self.animation = [[NavigationTransitionAnimation alloc] init];
        
        self.interactionController = [[UIPercentDrivenInteractiveTransition alloc] init];
        
//        [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
    }
    return self;

}
*/


/*
-(void)handleGesture:(UIPanGestureRecognizer *)gesture {
    UIView* view = self.view;
    CGPoint location = [gesture locationInView:gesture.view];
    CGPoint translation = [gesture translationInView:gesture.view];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            _interActiving = YES;
//            if (location.x < CGRectGetMidX(view.bounds) && self.navigationController.viewControllers.count > 1) {
//                [self.navigationController popViewControllerAnimated:YES];
//            }
            if (location.x < CGRectGetMidX(view.bounds) ) {
                [self popViewControllerAnimated:YES];
            }
            if (location.y < CGRectGetMidY(view.bounds) ) {
                
                
                    UIViewController *vc = [[UIViewController alloc]init];
                    vc.view.backgroundColor = [UIColor redColor];
                    [self pushViewController:vc animated:YES];
                
            }
            
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGFloat fraction = fabs(translation.y / view.bounds.size.height);
            [_interactionController updateInteractiveTransition:fraction];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            _interActiving = NO;
            CGFloat fraction = fabs(translation.y / view.bounds.size.height);
            if (fraction < 0.2 || [gesture velocityInView:view].y < 0 || gesture.state == UIGestureRecognizerStateCancelled) {
                [_interactionController cancelInteractiveTransition];
            } else {
                [_interactionController finishInteractiveTransition];
            }
            
            break;
        }
        default:
            break;
    }
}

 */
 

/*
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {

    if (operation == UINavigationControllerOperationPush) {
        //当前控制器是根控制器就做动画

        if ([fromVC isKindOfClass:[HomeViewController class]]) {
            return _animation;
        }
        
    }
    
    return nil;
}
*/

/*
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self.interActiving ? self.interactionController : nil;
//    return self.interactionController;

}

 */
//////////////


- (BOOL)shouldAutorotate{
    return [self.visibleViewController shouldAutorotate];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.visibleViewController preferredInterfaceOrientationForPresentation];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.visibleViewController supportedInterfaceOrientations];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 判断当前导航控制器是否是子控制器
    if (self.childViewControllers.count > 0) {
        // 隐藏底部工具条
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end
