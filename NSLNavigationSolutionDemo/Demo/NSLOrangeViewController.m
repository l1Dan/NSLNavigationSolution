//
//  NSLOrangeViewController.m
//  NSLNavigationSolution
//
//  Created by Leo Lee on 19/03/2017.
//  Copyright © 2017 Leo Lee. All rights reserved.
//

#import "NSLOrangeViewController.h"
#import "NSLGrayViewController.h"
#import "NSLBlueViewController.h"

@interface NSLOrangeViewController () <UINavigationControllerCustomizable>

@end

@implementation NSLOrangeViewController

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
        navigationController.nsl_jumpViewController = [[NSLBlueViewController alloc] init];
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
        self.navigationController.nsl_jumpViewController = [[NSLGrayViewController alloc] init];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
