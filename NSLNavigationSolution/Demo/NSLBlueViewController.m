//
//  NSLBlueViewController.m
//  NSLNavigationSolution
//
//  Created by Dennis on 19/03/2017.
//  Copyright © 2017 Dennis Lee. All rights reserved.
//

#import "NSLBlueViewController.h"
#import "NSLOrangeViewController.h"
#import "NSLGrayViewController.h"
#import "NSLBrownViewController.h"

@implementation NSLBlueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blueColor];
    self.navigationItem.title = @"第 1 页";
}

#pragma mark - Public method
- (void)clickNextButton:(UIButton *)button {
    [self.navigationController pushViewController:[[NSLBrownViewController alloc] init] animated:YES];
}

@end
