//
//  LDOrangeViewController.m
//  LDNavigationSolution
//
//  Created by Dennis on 19/03/2017.
//  Copyright © 2017 Dennis Lee. All rights reserved.
//

#import "LDOrangeViewController.h"
#import "UINavigationController+LDNavigationSolution.h"
#import "LDGrayViewController.h"
#import "LDBlueViewController.h"

@interface LDOrangeViewController () <UINavigationControllerCustomizable>

@end

@implementation LDOrangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    self.navigationItem.title = @"第 4 页";
    
    self.note = @"点击 “返回” 按钮 “提示” \n 返回到上个页面(Gray), \n 手势滑动到根控制器 (Blue)";
}

#pragma mark - UINavigationControllerCustomizable
// 监听点击返回和手势返回
- (BOOL)navigationController:(UINavigationController *)navigationController shouldJumpToViewControllerUsingGesture:(BOOL)usingGesture {
    if (usingGesture) {
        navigationController.ld_jumpToViewController = [[LDBlueViewController alloc] init];
        return YES;
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否返回到上个页面？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        
        return NO;
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 0) {
        self.navigationController.ld_jumpToViewController = [[LDGrayViewController alloc] init];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
