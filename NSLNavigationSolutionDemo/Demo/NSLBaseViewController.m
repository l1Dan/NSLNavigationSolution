//
//  NSLBaseViewController.m
//  NSLNavigationSolution
//
//  Created by Leo Lee on 19/03/2017.
//  Copyright © 2017 Leo Lee. All rights reserved.
//

#import "NSLBaseViewController.h"
#import "AppDelegate.h"

@interface NSLBaseViewController()
@property (nonatomic, strong) UILabel *noteLabel;
@end

@implementation NSLBaseViewController
+ (void)initialize {
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nsl_navigationBarTranslucent = NO;
    self.navigationItem.backBarButtonItem = [self backBarButtonItem];
    
    if ([self.navigationController.viewControllers count] < 4) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(100, 100, 100, 44);
        button.backgroundColor = [UIColor blackColor];
        [button setTitle:@"下一页" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickNextButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    self.noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, 0, 0)];
    self.noteLabel.backgroundColor = [UIColor blackColor];
    self.noteLabel.textColor = [UIColor whiteColor];
    self.noteLabel.numberOfLines = 0;
    [self.view addSubview:self.noteLabel];
}

- (UIBarButtonItem *)backBarButtonItem {
    return [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.globalView changeSwitchStatus:self.nsl_navigationBarTranslucent];
}

#pragma mark - Public Method
- (void)setNote:(NSString *)note {
    if ([note length] == 0) {
        return;
    }
    
    self.noteLabel.text = note;
    [self.noteLabel sizeToFit];
}

- (void)clickNextButton:(UIButton *)button { }

@end
