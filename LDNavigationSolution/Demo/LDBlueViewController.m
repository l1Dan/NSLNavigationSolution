//
//  LDBlueViewController.m
//  LDNavigationSolution
//
//  Created by Dennis on 19/03/2017.
//  Copyright © 2017 Dennis Lee. All rights reserved.
//

#import "LDBlueViewController.h"
#import "UINavigationController+LDNavigationSolution.h"
#import "LDOrangeViewController.h"
#import "LDGrayViewController.h"

@interface LDBlueViewController ()<UINavigationControllerCustomizable, UIAlertViewDelegate>

@end

@implementation LDBlueViewController

#pragma mark - UINavigationControllerCustomizable
// 监听点击返回和手势返回
- (BOOL)navigationController:(UINavigationController *)navigationController shouldJumpToViewControllerUsingGesture:(BOOL)usingGesture {
    if (usingGesture) {
        navigationController.ld_jumpToViewController = [[LDOrangeViewController alloc] init];
        return YES;
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否返回到上个页面？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        
        return NO;
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    self.navigationController.ld_jumpToViewController = [[LDGrayViewController alloc] init];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
