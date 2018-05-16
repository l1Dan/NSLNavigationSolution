//
//  NSLNavigationSolutionProtocol.h
//  NSLNavigationSolution
//
//  Created by Leo Lee on 2018/5/16.
//  Copyright © 2018年 Dennis. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 UINavigationControllerCustomizable
 */
@protocol UINavigationControllerCustomizable <NSObject>

/**
 当手势滑动或点击返回按钮时调用
 
 @param navigationController 当前导航控制器
 @param usingGesture 是否使用手势滑动：区分是手势滑动还是点击返回按钮
 @return 是否继续完成手势滑动或点击按钮操作
 */
- (BOOL)navigationController:(UINavigationController *)navigationController shouldJumpToViewControllerUsingGesture:(BOOL)usingGesture;

@end

/**
 NSLViewControllerProtocol
 */
@protocol NSLViewControllerProtocol <NSObject>

/// 是否禁用手势返回
@property (nonatomic, assign) BOOL interactivePopDisabled;

/// 是否设置导航栏透明
@property (nonatomic, assign) BOOL navigationBarTranslucent;

@end

/**
 NSLNavigationControllerProtocol
 */
@protocol NSLNavigationControllerProtocol <NSObject>

/// 设置需要跳转的控制器
- (void)jumpViewControllerClass:(Class)cls usingBlock:(UIViewController * (^)(void))block;

/// 点击返回按钮
- (void)clickBackBarButtonItem;

@end
NS_ASSUME_NONNULL_END

