//
//  NSLBaseViewController.h
//  NSLNavigationSolution
//
//  Created by Leo Lee on 19/03/2017.
//  Copyright © 2017 Leo Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NSLNavigationSolution/NSLNavigationSolution.h>

@interface NSLBaseViewController : UIViewController
@property (nonatomic, copy) NSString *note;

- (void)clickNextButton:(UIButton *)button;

@end
