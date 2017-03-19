//
//  LDBrownViewController.m
//  LDNavigationSolution
//
//  Created by Dennis on 19/03/2017.
//  Copyright © 2017 Dennis Lee. All rights reserved.
//

#import "LDBrownViewController.h"
#import "UINavigationController+LDNavigationSolution.h"

@interface LDBrownViewController ()

@end

@implementation LDBrownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *customBackItem = [[UIBarButtonItem alloc] initWithTitle:@"Custom Back Item" style:UIBarButtonItemStylePlain target:self action:@selector(clickCustomBackItem:)];
    self.navigationItem.leftBarButtonItem = customBackItem;
}

/// 自定义返回按钮点击返回
- (void)clickCustomBackItem:(UIBarButtonItem *)item {
    [self.navigationController ld_clickBackBarButtonItem];
}

@end
