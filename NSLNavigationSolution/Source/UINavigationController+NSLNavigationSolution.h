//
//  UINavigationController+CS.h
//  NSLNavigationSolution
//
//  Created by Leo Lee on 17/03/2017.
//  Copyright © 2017 Leo Lee. All rights reserved.
//

#import "NSLNavigationSolutionProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UINavigationControllerCustomizable <NSObject>

/**
 当手势滑动或点击返回按钮时调用

 @param navigationController 当前导航控制器
 @param usingGesture 是否使用手势滑动：区分是手势滑动还是点击返回按钮
 @return 是否继续完成手势滑动或点击按钮操作
 */
- (BOOL)navigationController:(UINavigationController *)navigationController shouldJumpToViewControllerUsingGesture:(BOOL)usingGesture;

@end

@interface UIViewController (NSLNavigationSolution)

@property (nonatomic, strong, readonly) id<NSLViewControllerProtocol> solution;

@end

@interface UINavigationController (NSLNavigationSolution)

@property (nonatomic, strong, readonly) id<NSLNavigationControllerProtocol> solution;

@end

NS_ASSUME_NONNULL_END
