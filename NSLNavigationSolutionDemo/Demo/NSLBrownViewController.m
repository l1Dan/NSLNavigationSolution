//
//  NSLBrownViewController.m
//  NSLNavigationSolution
//
//  Created by Dennis on 19/03/2017.
//  Copyright © 2017 Dennis Lee. All rights reserved.
//

#import "NSLBrownViewController.h"
@import NSLNavigationSolution;
#import "UIBarButtonItem+Convenience.h"
#import "NSLGrayViewController.h"

@interface NSLBrownViewController() <UINavigationControllerCustomizable, UIAlertViewDelegate>

@end

@implementation NSLBrownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor brownColor];
    self.navigationItem.title = @"第 2 页";
    
    UIBarButtonItem *customBackItem = [UIBarButtonItem itemWithTitle:@"点我返回" target:self action:@selector(clickBackItem:)];
    self.navigationItem.leftBarButtonItem = customBackItem;
    
    self.note = @"监听系统返回按钮 监听手势滑动返回";
}

/// 自定义返回按钮点击返回
- (void)clickBackItem:(UIBarButtonItem *)item {
    [self.navigationController nsl_clickBackBarButtonItem];
}

#pragma makr - UINavigationControllerCustomizable
- (BOOL)navigationController:(UINavigationController *)navigationController shouldJumpToViewControllerUsingGesture:(BOOL)usingGesture {
    if (usingGesture) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否返回到上个页面？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Public method
- (void)clickNextButton:(UIButton *)button {
    [self.navigationController pushViewController:[[NSLGrayViewController alloc] init] animated:YES];
}

@end
