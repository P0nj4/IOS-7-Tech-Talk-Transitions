//
//  SecondViewController.m
//  TransitionsDemo
//
//  Created by Germán Pereyra on 27/12/13.
//  Copyright (c) 2013 Ponja. All rights reserved.
//

#import "SecondViewController.h"
#import "DismissTransition.h"

@interface SecondViewController () <DismissTransitionDeleage, UIViewControllerTransitioningDelegate>
@property (strong) DismissTransition *myDismissTransition;
@end

@implementation SecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.myDismissTransition = [[DismissTransition alloc] initWithSourceView:self.view];
    self.myDismissTransition.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dragToDismissTransitionDidBeginDraggin:(DismissTransition *)transition{
    self.transitioningDelegate = self;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id<UIViewControllerTransitioningDelegate>)animationControllerForDismissedController:(UIViewController *)controller{
    return self.myDismissTransition;
}

- (id<UIViewControllerTransitioningDelegate>)interactionControllerForDismissal:(id<UIViewControllerInteractiveTransitioning>)animator{
    return self.myDismissTransition;
}
@end
