//
//  NavigationDelegate.m
//  TinyDictionary
//
//  Created by Meler Paine on 2019/4/3.
//  Copyright © 2019 Sinking Soul. All rights reserved.
//

#import "NavigationDelegate.h"
#import "NavigationAnimator.h"

@interface NavigationDelegate ()<UIGestureRecognizerDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactiveController;

@end

@implementation NavigationDelegate

- (instancetype)init:(UINavigationController *)navigationController {
    self = [super init];
    if (self) {
        self.interactable = NO;
        self.interactiveController = [UIPercentDrivenInteractiveTransition new];
        self.navigationController = navigationController;
        self.navigationController.delegate = self;
        [self setupGesture];
    }
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    return [[NavigationAnimator alloc] initWith:operation];
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return _interactable ? _interactiveController : nil;
}

- (void)setupGesture {
    // 添加导航栏滑动转场手势
    UIScreenEdgePanGestureRecognizer *edgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    edgePanGestureRecognizer.delegate = self;
    edgePanGestureRecognizer.edges = UIRectEdgeLeft;
    [_navigationController.view addGestureRecognizer:edgePanGestureRecognizer];
}

- (void)pan:(UIScreenEdgePanGestureRecognizer*)recognizer {
    UIView* view = _navigationController.view;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (_navigationController.viewControllers.count > 1) {
            self.interactable = YES;
            [_navigationController popViewControllerAnimated:YES];
        }
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:recognizer.view];
        CGFloat d = fabs(translation.x / CGRectGetWidth(view.bounds));
        [self.interactiveController updateInteractiveTransition:d];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint translation = [recognizer translationInView:recognizer.view];
        CGFloat d = fabs(translation.x / CGRectGetWidth(view.bounds));
        // 先判断加速度大于 1200 时，直接结束转场
        CGPoint velocity = [recognizer velocityInView:recognizer.view];
        if (velocity.x > 1200) {
            [self.interactiveController finishInteractiveTransition];
        }
        // 再判断手势移动距离，松开时超过视图宽度 40% 则结束。
        else if (d > 0.4) {
            [self.interactiveController finishInteractiveTransition];
        } else {
            [self.interactiveController cancelInteractiveTransition];
        }
        self.interactable = NO;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
