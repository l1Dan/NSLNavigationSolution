//
//  NSLBrownViewController.m
//  NSLNavigationSolution
//
//  Created by Leo Lee on 19/03/2017.
//  Copyright © 2017 Leo Lee. All rights reserved.
//

#import "NSLBrownViewController.h"
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
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否返回到上个页面？" preferredStyle:UIAlertControllerStyleAlert];
        
        [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }]];

        [self.navigationController presentViewController:controller animated:YES completion:NULL];
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - Public method
- (void)clickNextButton:(UIButton *)button {
    [self.navigationController pushViewController:[[NSLGrayViewController alloc] init] animated:YES];
}

@end
