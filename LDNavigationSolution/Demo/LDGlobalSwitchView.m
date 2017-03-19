//
//  LDGlobalSwitchView.m
//  LDNavigationSolution
//
//  Created by Dennis on 19/03/2017.
//  Copyright © 2017 Dennis Lee. All rights reserved.
//

#import "LDGlobalSwitchView.h"

@implementation LDGlobalSwitchView
+ (instancetype)globalSwitchView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}
@end
