//
//  UIBarButtonItem+Convenience.m
//  NSLNavigationSolution
//
//  Created by Leo Lee on 19/03/2017.
//  Copyright © 2017 Leo Lee. All rights reserved.
//

#import "UIBarButtonItem+Convenience.h"

@implementation UIBarButtonItem (Convenience)

+ (instancetype)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    return [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
}

@end
