//
//  DismissTransition.m
//  TransitionsDemo
//
//  Created by Germán Pereyra on 27/12/13.
//  Copyright (c) 2013 Ponja. All rights reserved.
//

#import "DismissTransition.h"

@interface DismissTransition () 
@property (strong) id<UIViewControllerContextTransitioning> context;
@property (strong) UIPanGestureRecognizer *pan;
@property UIOffset touchOffsetFromCenter;

@property (strong) UIView *transitionContainer;
@property (strong) UIView *viewBeingDismissed;
@end

@implementation DismissTransition

- (instancetype)initWithSourceView:(UIView *)vSource{
    self = [super init];
    if (self) {
        self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
        [vSource addGestureRecognizer:self.pan];
        [vSource viewWithTag:11].backgroundColor  = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.];
    }
    return self;
}

- (void)dealloc{
    [self.pan.view removeGestureRecognizer:self.pan];
}


#pragma mark - Animated Transitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{

}

#pragma mark - Interactive Transitioning

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    self.context = transitionContext;
    self.transitionContainer = [transitionContext containerView];
 
    UIViewController *fromView = [self.context viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toView = [self.context viewControllerForKey:UITransitionContextToViewControllerKey];
    
    fromView.view.frame = [self.context initialFrameForViewController:fromView];
    toView.view.frame = [self.context finalFrameForViewController:toView];
    
    [self.transitionContainer addSubview:toView.view];
    [self.transitionContainer addSubview:fromView.view];

    self.viewBeingDismissed = fromView.view;
    
    CGPoint fingerPoint = [self.pan locationInView:fromView.view];
    CGPoint viewCenter = fromView.view.center;
    self.touchOffsetFromCenter = UIOffsetMake(fingerPoint.x - viewCenter.x, fingerPoint.y - viewCenter.y);
}

- (void)finishInteraction{
    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.context.containerView];
    UIViewController *fromvc = [self.context viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[fromvc.view]];
    gravity.gravityDirection = CGVectorMake(0, 4.0);
    
    __weak typeof(self) weakSelf = self;
    gravity.action = ^{
        typeof (self) strongSelf = weakSelf;
        if ([self percentOfView] > 1.0) {
            [animator removeAllBehaviors];
            [strongSelf completeTransition];
        }
    };
    
    [animator addBehavior:gravity];
    [self.context finishInteractiveTransition];
}

- (void)cancelIntraction{
    
    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.context.containerView];
    UIViewController *fromVC = [self.context viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGRect initialFrame = CGRectMake(0, 0, [self.context initialFrameForViewController:fromVC].size.width,  [self.context initialFrameForViewController:fromVC].size.height);
    CGPoint snapPoint = CGPointMake(CGRectGetMidX(initialFrame), CGRectGetMidY(initialFrame));
    
    UIDynamicItemBehavior *behavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.viewBeingDismissed]];
    behavior.allowsRotation = NO;
    [animator addBehavior:behavior];
    
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.viewBeingDismissed snapToPoint:snapPoint];
    snap.damping = 0.1;
    
    __weak typeof(self) weakSelf = self;
    [self.viewBeingDismissed viewWithTag:11].backgroundColor  = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.];
    snap.action = ^{
        typeof (self) strongSelf = weakSelf;
        UIView *view = strongSelf.viewBeingDismissed;
        if (ABS(view.frame.origin.y) < 1) {
            view.frame = initialFrame;
            [animator removeAllBehaviors];
            [strongSelf completeTransition];
        }
    };
    
    [animator addBehavior:snap];
    
    [self.context cancelInteractiveTransition];
}

- (void) completeTransition{
    BOOL finish = !self.context.transitionWasCancelled;
    [self.context completeTransition:finish];
    self.context = nil;
    self.touchOffsetFromCenter = UIOffsetZero;
    self.transitionContainer = nil;
    self.viewBeingDismissed = nil;
}

#pragma mark - Gesture Recognized

- (float)percentOfView{
    UIView *contView = self.context.containerView;
    return CGRectGetMinY(self.viewBeingDismissed.frame) / CGRectGetHeight(contView.frame);
}

- (void)panned:(UIGestureRecognizer *)gesture{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self.delegate dragToDismissTransitionDidBeginDraggin:self];
            break;
        case UIGestureRecognizerStateChanged:{
            CGPoint touchLocation = [self.pan locationInView:self.transitionContainer];
            CGPoint center = self.transitionContainer.center;
            center.y = touchLocation.y - self.touchOffsetFromCenter.vertical;
            self.viewBeingDismissed.center = center;
            [self.viewBeingDismissed viewWithTag:11 ].backgroundColor = [UIColor colorWithRed:1-[self percentOfView] green:[self percentOfView] blue:[self percentOfView] alpha:[self percentOfView]];
            [self.context updateInteractiveTransition:[self percentOfView]];
        }
            break;
        case UIGestureRecognizerStateEnded:{
            if ([self percentOfView] >= 0.33) {
                [self finishInteraction];
            }else{
                [self cancelIntraction];
            }
        }
            break;
        default:
            [self cancelIntraction];
            break;
    }
}
@end
