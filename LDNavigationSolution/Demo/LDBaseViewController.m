//
//  LDBaseViewController.m
//  LDNavigationSolution
//
//  Created by Dennis on 19/03/2017.
//  Copyright © 2017 Dennis Lee. All rights reserved.
//

#import "LDBaseViewController.h"
#import "AppDelegate.h"

@implementation LDBaseViewController
+ (void)initialize {
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ld_navigationBarTranslucent = NO;
    self.navigationItem.backBarButtonItem = [self backBarButtonItem];
}

- (UIBarButtonItem *)backBarButtonItem {
    return [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.globalView changeSwitchStatus:self.ld_navigationBarTranslucent];
}

@end
