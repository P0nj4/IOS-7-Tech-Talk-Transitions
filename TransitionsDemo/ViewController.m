//
//  ViewController.m
//  TransitionsDemo
//
//  Created by Germán Pereyra on 27/12/13.
//  Copyright (c) 2013 Ponja. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "CrossFadeTransition.h"

@interface ViewController () <UIViewControllerTransitioningDelegate>
- (IBAction)presentSecondViewController:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)presentSecondViewController:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SecondViewController *sec = [storyboard instantiateViewControllerWithIdentifier:@"SecondViewController"];
    sec.modalPresentationStyle = UIModalPresentationFullScreen;
    sec.transitioningDelegate = self;
    [self presentViewController:sec animated:YES completion:nil];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [[CrossFadeTransition alloc] init];
}
@end
