//
//  NSLNavigationSolutionProtocol.h
//  NSLNavigationSolution
//
//  Created by Leo Lee on 2018/5/16.
//  Copyright © 2018年 Dennis. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol NSLViewControllerProtocol <NSObject>

/// 是否禁用手势返回
@property (nonatomic, assign) BOOL interactivePopDisabled;

/// 是否设置导航栏透明
@property (nonatomic, assign) BOOL navigationBarTranslucent;

@end

@protocol NSLNavigationControllerProtocol <NSObject>

/// 设置需要跳转的控制器
- (void)jumpViewControllerClass:(Class)cls usingBlock:(UIViewController * (^)(void))block;

/// 点击返回按钮
- (void)clickBackBarButtonItem;

@end
NS_ASSUME_NONNULL_END

