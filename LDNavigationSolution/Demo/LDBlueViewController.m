//
//  LDBlueViewController.m
//  LDNavigationSolution
//
//  Created by Dennis on 19/03/2017.
//  Copyright © 2017 Dennis Lee. All rights reserved.
//

#import "LDBlueViewController.h"
#import "LDOrangeViewController.h"
#import "LDGrayViewController.h"
#import "LDBrownViewController.h"

@implementation LDBlueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blueColor];
    self.navigationItem.title = @"第 1 页";
}

#pragma mark - Public method
- (void)clickNextButton:(UIButton *)button {
    [self.navigationController pushViewController:[[LDBrownViewController alloc] init] animated:YES];
}

@end
