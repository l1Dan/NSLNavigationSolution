//
//  UIBarButtonItem+Convenience.h
//  NSLNavigationSolution
//
//  Created by Leo Lee on 19/03/2017.
//  Copyright © 2017 Leo Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface UIBarButtonItem (Convenience)
+ (instancetype)itemWithTitle:(nullable NSString *)title target:(nullable id)target action:(nullable SEL)action;
@end
NS_ASSUME_NONNULL_END
