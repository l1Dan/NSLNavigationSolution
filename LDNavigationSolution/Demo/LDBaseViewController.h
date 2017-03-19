//
//  LDBaseViewController.h
//  LDNavigationSolution
//
//  Created by Dennis on 19/03/2017.
//  Copyright © 2017 Dennis Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationController+LDNavigationSolution.h"

@interface LDBaseViewController : UIViewController
@property (nonatomic, copy) NSString *note;

- (void)clickNextButton:(UIButton *)button;

@end
