//
//  LDOrangeViewController.m
//  LDNavigationSolution
//
//  Created by Dennis on 19/03/2017.
//  Copyright © 2017 Dennis Lee. All rights reserved.
//

#import "LDOrangeViewController.h"
#import "LDGrayViewController.h"
#import "UINavigationController+LDNavigationSolution.h"

@interface LDOrangeViewController () <UINavigationControllerCustomizable>

@end

@implementation LDOrangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
}

#pragma mark - UINavigationControllerCustomizable
- (BOOL)navigationController:(UINavigationController *)navigationController shouldJumpToViewControllerUsingGesture:(BOOL)usingGesture {
    navigationController.ld_jumpToViewController = [[LDGrayViewController alloc] init];
    // or
    //    for (UIViewController *vc in [navigationController viewControllers]) {
    //        if ([vc isKindOfClass:[LDGrayViewController class]]) {
    //            navigationController.ld_jumpToViewController = vc;
    //            break;
    //        }
    //    }
    
    return YES;
}

@end
