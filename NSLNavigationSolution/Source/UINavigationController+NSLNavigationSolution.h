//
//  UINavigationController+CS.h
//  NSLNavigationSolution
//
//  Created by Leo Lee on 17/03/2017.
//  Copyright © 2017 Leo Lee. All rights reserved.
//

#import "NSLNavigationSolutionProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (NSLNavigationSolution)

/**
 提供方法：
 *  是否禁用手势返回
 *  导航栏是否透明
 */
@property (nonatomic, strong, readonly) id<NSLViewControllerProtocol> solution;

@end

@interface UINavigationController (NSLNavigationSolution)

/**
 提供方法：
 *  跳转控制器
 *  点击系统返回操作
 */
@property (nonatomic, strong, readonly) id<NSLNavigationControllerProtocol> solution;

@end

NS_ASSUME_NONNULL_END
