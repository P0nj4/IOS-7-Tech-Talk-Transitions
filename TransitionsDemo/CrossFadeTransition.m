//
//  CrossFadeTransition.m
//  TransitionsDemo
//
//  Created by Germán Pereyra on 27/12/13.
//  Copyright (c) 2013 Ponja. All rights reserved.
//

#import "CrossFadeTransition.h"

@interface CrossFadeTransition () 

@end

@implementation CrossFadeTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 2.0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    fromVC.view.frame = [transitionContext initialFrameForViewController:fromVC];
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    
    [transitionContext.containerView addSubview:fromVC.view];
    [transitionContext.containerView addSubview:toVC.view];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    toVC.view.alpha = 0.;
    
    [UIView animateWithDuration:duration animations:^{
        toVC.view.alpha = 1.;
        fromVC.view.alpha = 0.;
    }completion:^(BOOL finished) {
        fromVC.view.alpha = 1.;
        [transitionContext completeTransition:YES];
    }];
}
@end
