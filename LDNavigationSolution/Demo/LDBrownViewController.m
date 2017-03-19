//
//  LDBrownViewController.m
//  LDNavigationSolution
//
//  Created by Dennis on 19/03/2017.
//  Copyright © 2017 Dennis Lee. All rights reserved.
//

#import "LDBrownViewController.h"
#import "UIBarButtonItem+Convenience.h"

@implementation LDBrownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor brownColor];
    self.navigationItem.title = @"第 2 页";
    
    UIBarButtonItem *customBackItem = [UIBarButtonItem itemWithTitle:@"点我返回" target:self action:@selector(clickBackItem:)];
    self.navigationItem.leftBarButtonItem = customBackItem;
}

/// 自定义返回按钮点击返回
- (void)clickBackItem:(UIBarButtonItem *)item {
    [self.navigationController ld_clickBackBarButtonItem];
}

@end
