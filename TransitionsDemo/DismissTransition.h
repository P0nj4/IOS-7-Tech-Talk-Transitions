//
//  DismissTransition.h
//  TransitionsDemo
//
//  Created by Germán Pereyra on 27/12/13.
//  Copyright (c) 2013 Ponja. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DismissTransition;

@protocol DismissTransitionDeleage <NSObject>
- (void)dragToDismissTransitionDidBeginDraggin:(DismissTransition *)transition;

@end


@interface DismissTransition : NSObject <UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning, UIViewControllerTransitioningDelegate>
@property (strong) id<DismissTransitionDeleage> delegate;

- (instancetype)initWithSourceView:(UIView *)vSource;
@end
