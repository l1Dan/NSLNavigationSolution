//
//  NSLBaseViewController.h
//  NSLNavigationSolution
//
//  Created by Dennis on 19/03/2017.
//  Copyright © 2017 Dennis Lee. All rights reserved.
//

@import NSLNavigationSolution;
#import <UIKit/UIKit.h>
//#import <UINavigationController+NSLNavigationSolution.h>

@interface NSLBaseViewController : UIViewController
@property (nonatomic, copy) NSString *note;

- (void)clickNextButton:(UIButton *)button;

@end
