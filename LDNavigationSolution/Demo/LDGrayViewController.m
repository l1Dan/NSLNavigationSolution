//
//  LDGrayViewController.m
//  LDNavigationSolution
//
//  Created by Dennis on 19/03/2017.
//  Copyright © 2017 Dennis Lee. All rights reserved.
//

#import "LDGrayViewController.h"
#import "LDOrangeViewController.h"

@implementation LDGrayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    self.navigationItem.title = @"第 3 页";
}

#pragma mark - Public method
- (void)clickNextButton:(UIButton *)button {
    [self.navigationController pushViewController:[[LDOrangeViewController alloc] init] animated:YES];
}

@end
