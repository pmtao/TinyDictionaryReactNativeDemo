//
//  NavigationAnimator.m
//  TinyDictionary
//
//  Created by Meler Paine on 2019/4/3.
//  Copyright © 2019 Sinking Soul. All rights reserved.
//

#import "NavigationAnimator.h"

static const NSTimeInterval transitionDuration = 0.25;

@implementation NavigationAnimator {
    UINavigationControllerOperation navigationType;
}

- (instancetype)initWith:(UINavigationControllerOperation)type {
    self = [super init];
    if (self) {
        navigationType = type;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return transitionDuration;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = transitionContext.containerView;
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = fromVC.view;
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    [containerView addSubview:toView];
    
    if (navigationType == UINavigationControllerOperationPush) {
        [self pushAnimationIn:containerView
                         from:fromView
                           to:toView
                      context:transitionContext];
    } else {
        [self popAnimationIn:containerView
                        from:fromView
                          to:toView
                     context:transitionContext];
    }
}

- (void)pushAnimationIn:(UIView *)containerView
                   from:(UIView *)fromView
                     to:(UIView *)toView
                context:(nonnull id<UIViewControllerContextTransitioning>)transitionContext
{
    CGFloat translation = containerView.frame.size.width;
    CGAffineTransform toViewTransform = CGAffineTransformIdentity;
    CGAffineTransform fromViewTransform = CGAffineTransformIdentity;
    
    fromViewTransform = CGAffineTransformMakeTranslation(-translation * 0.3, 0);
    toViewTransform = CGAffineTransformMakeTranslation(translation, 0);
    toView.transform = toViewTransform;
    
    UIView *shadow = [[UIView alloc] initWithFrame:fromView.bounds];
    shadow.backgroundColor = UIColor.whiteColor;
    shadow.layer.shadowOpacity = 0.5;
    shadow.layer.shadowOffset = CGSizeMake(0, 0);
    shadow.layer.shadowRadius = 8;
    [toView addSubview:shadow];
    [toView sendSubviewToBack:shadow];
    shadow.alpha = 1;
    
    [UIView animateWithDuration:transitionDuration
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         fromView.transform = fromViewTransform;
                         toView.transform = CGAffineTransformIdentity;
                         shadow.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         fromView.transform = CGAffineTransformIdentity;
                         toView.transform = CGAffineTransformIdentity;
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         [shadow removeFromSuperview];
                     }];
}

- (void)popAnimationIn:(UIView *)containerView
                  from:(UIView *)fromView
                    to:(UIView *)toView
               context:(nonnull id<UIViewControllerContextTransitioning>)transitionContext
{
    CGFloat translation = containerView.frame.size.width;
    CGAffineTransform toViewTransform = CGAffineTransformIdentity;
    CGAffineTransform fromViewTransform = CGAffineTransformIdentity;
    
    fromViewTransform = CGAffineTransformMakeTranslation(translation, 0);
    toViewTransform = CGAffineTransformMakeTranslation(-translation * 0.3, 0);
    toView.transform = toViewTransform;
    [containerView sendSubviewToBack:toView];
    
    UIView *shadow = [[UIView alloc] initWithFrame:fromView.bounds];
    shadow.backgroundColor = UIColor.whiteColor;
    shadow.layer.shadowOpacity = 0.5;
    shadow.layer.shadowOffset = CGSizeMake(0, 0);
    shadow.layer.shadowRadius = 8;
    [fromView addSubview:shadow];
    [fromView sendSubviewToBack:shadow];
    shadow.alpha = 1;
    
    [UIView animateWithDuration:transitionDuration
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         fromView.transform = fromViewTransform;
                         toView.transform = CGAffineTransformIdentity;
                         shadow.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         fromView.transform = CGAffineTransformIdentity;
                         toView.transform = CGAffineTransformIdentity;
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         [shadow removeFromSuperview];
                     }];
}

@end
