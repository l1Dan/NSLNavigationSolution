//
//  NSLGrayViewController.m
//  NSLNavigationSolution
//
//  Created by Dennis on 19/03/2017.
//  Copyright © 2017 Dennis Lee. All rights reserved.
//

#import "NSLGrayViewController.h"
#import "NSLOrangeViewController.h"

@implementation NSLGrayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    self.navigationItem.title = @"第 3 页";
}

#pragma mark - Public method
- (void)clickNextButton:(UIButton *)button {
    [self.navigationController pushViewController:[[NSLOrangeViewController alloc] init] animated:YES];
}

@end
