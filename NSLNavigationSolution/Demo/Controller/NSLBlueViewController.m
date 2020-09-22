//
//  NSLBlueViewController.m
//  NSLNavigationSolution
//
//  Created by Leo Lee on 19/03/2017.
//  Copyright © 2017 Leo Lee. All rights reserved.
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
