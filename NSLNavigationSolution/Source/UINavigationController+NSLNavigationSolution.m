//
//  UINavigationController+CS.m
//  NSLNavigationSolution
//
//  Created by Leo Lee on 17/03/2017.
//  Copyright © 2017 Leo Lee. All rights reserved.
//

#import "UINavigationController+NSLNavigationSolution.h"
#import <objc/runtime.h>

static const char * INTERACTIVE_DELEGATE = "INTERACTIVE_DELEGATE";
static const char * INTERACTIVE_POP_TARGET = "INTERACTIVE_POP_TARGET";
static const char * INTERACTIVE_POP_RUN = "INTERACTIVE_POP_RUN"; // 正在手势交互

@implementation UIViewController (NSLNavigationSolution)
- (void)ex_viewWillAppear:(BOOL)animated {
    [self ex_viewWillAppear:animated];
    // 解决导航栏闪烁问题
    [UIView animateWithDuration:0.1 animations:^{
        self.navigationController.navigationBar.alpha = [self navigationBarTranslucent] ? 0.0 : 1.0;
    }];
    
    if (![self navigationBarTranslucent]) { [self setNavigationBarTranslucent:NO]; }
}

#pragma mark - solution
- (id<NSLViewControllerProtocol>)solution {
    id <NSLViewControllerProtocol> protocol = objc_getAssociatedObject(self, _cmd);
    if (!protocol) {
        protocol = (id<NSLViewControllerProtocol>)self;
        [self setSolution:protocol];
    }
    return protocol;
}

- (void)setSolution:(id<NSLViewControllerProtocol> _Nonnull)solution {
    objc_setAssociatedObject(self, @selector(solution), solution, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - NSLViewControllerProtocol
- (BOOL)interactivePopDisabled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setInteractivePopDisabled:(BOOL)interactivePopDisabled {
    objc_setAssociatedObject(self, @selector(interactivePopDisabled), @(interactivePopDisabled), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)navigationBarTranslucent {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setNavigationBarTranslucent:(BOOL)navigationBarTranslucent {
    objc_setAssociatedObject(self, @selector(navigationBarTranslucent), @(navigationBarTranslucent), OBJC_ASSOCIATION_ASSIGN);
    self.navigationController.navigationBar.alpha = navigationBarTranslucent ? 0.0 : 1.0;
}

@end

#pragma mark - UINavigationController Category
@implementation UINavigationController (NSLNavigationSolution)
- (void)ex_viewDidLoad {
    [self ex_viewDidLoad];
	
    objc_setAssociatedObject(self, INTERACTIVE_POP_RUN, @(NO), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, INTERACTIVE_DELEGATE, self.interactivePopGestureRecognizer.delegate, OBJC_ASSOCIATION_ASSIGN);
    
    self.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    UIGestureRecognizer *gesture = [self interactivePopGestureRecognizer];
    gesture.enabled = NO;
    UIView *gestureView = [gesture view];
    
    NSMutableArray *_targets = [gesture valueForKey:@"_targets"];
    id gesterRecognizerTarget = [_targets firstObject];
    id navigationInteractiveTransion = [gesterRecognizerTarget valueForKey:@"_target"];
    objc_setAssociatedObject(self, INTERACTIVE_POP_TARGET, navigationInteractiveTransion, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UIScreenEdgePanGestureRecognizer *popGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
    popGestureRecognizer.edges = UIRectEdgeLeft;
    popGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [gestureView addGestureRecognizer:popGestureRecognizer];
    
    // 防止系统中途修改导航栏
//    [self.navigationBar addObserver:self forKeyPath:@"alpha" options:NSKeyValueObservingOptionNew context:NULL];
}

#pragma mark - observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"alpha"] && [object isKindOfClass:[UINavigationBar class]]) {
        BOOL isRun = [objc_getAssociatedObject(self, INTERACTIVE_POP_RUN) boolValue];
        if (!isRun) { // 没有手势交互可以监听
            UINavigationBar *bar = (UINavigationBar *)object;
            // 本来是要隐藏的，但是现在却是现实的
            if ([self.topViewController navigationBarTranslucent] && bar.alpha == 1.0) {  bar.alpha = 0.0; }
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - 导航栏渐变
- (void)handleGestureRecognizer:(UIScreenEdgePanGestureRecognizer *)gesture {
    id target = objc_getAssociatedObject(self, INTERACTIVE_POP_TARGET);
    SEL selector = NSSelectorFromString(@"handleNavigationTransition:");
    
    IMP imp = [target methodForSelector: selector];
    void (*transitionHandle)(id, SEL, UIGestureRecognizer *) = (void *)imp;
    transitionHandle(target, selector, gesture);
    
    id<UIViewControllerTransitionCoordinator> tc = self.transitionCoordinator;
    UIViewController *fromVC = [tc viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [tc viewControllerForKey:UITransitionContextToViewControllerKey];
    
    /*  导航栏处理的四种情况：
     1）从 有 --≥ 有，不需要处理
     2）从 无 --≥ 无，不需要处理
     3）从 无 --≥ 有，alpha 变为 1.0
     4）从 有 --≥ 无，alpha 变为 0.0
     */
    if ([fromVC navigationBarTranslucent] && [toVC navigationBarTranslucent]) { return; }
    if (![fromVC navigationBarTranslucent] && ![toVC navigationBarTranslucent]) { return; }
    
    UIView *barBackgroundView = self.navigationBar;
    BOOL reverse = [fromVC navigationBarTranslucent];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged: {
            CGFloat progress = tc.percentComplete;
            barBackgroundView.alpha = reverse ? progress : 1 - progress;
            objc_setAssociatedObject(self, INTERACTIVE_POP_RUN, @(YES), OBJC_ASSOCIATION_ASSIGN);
            
            break;
        }
        default: {
            if ([tc isCancelled]) {
                barBackgroundView.alpha = reverse ? 0.0 : 1.0;
            } else {
                barBackgroundView.alpha = reverse ? 1.0 : 0.0;
            }
            objc_setAssociatedObject(self, INTERACTIVE_POP_RUN, @(NO), OBJC_ASSOCIATION_ASSIGN);
            
            break;
        }
    }
}

#pragma mark - UINavigationBarDelegate
- (BOOL)ex_navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    UIViewController *topViewController = [self topViewController];
    if (item != topViewController.navigationItem) {
        return [self ex_navigationBar:navigationBar shouldPopItem:item];
    }
    
    if ([topViewController conformsToProtocol:@protocol(UINavigationControllerCustomizable)]) {
        if (![(id<UINavigationControllerCustomizable>)topViewController navigationController:self shouldJumpToViewControllerUsingGesture:NO]) {
            for (UIView *v in [navigationBar subviews]) {
                // 当 `navigationControllerShouldJumpToViewController:` 返回 `NO` 时，返回按钮需要变回正常颜色
                if ([v isKindOfClass:NSClassFromString(@"_UINavigationBarBackIndicatorView")]) { v.alpha = 1.0; }
            }
            return NO;
        }
    }
    return [self ex_navigationBar:navigationBar shouldPopItem:item];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count <= 1) { return NO; }
    
    UIViewController *topViewController = [self topViewController];
    if ([topViewController interactivePopDisabled]) { return NO; }
    
    if ([topViewController conformsToProtocol:@protocol(UINavigationControllerCustomizable)]) {
        return [(id<UINavigationControllerCustomizable>)topViewController navigationController:self shouldJumpToViewControllerUsingGesture:YES];
    }
    
    id<UIGestureRecognizerDelegate> delegate = objc_getAssociatedObject(self, INTERACTIVE_DELEGATE);
    return [delegate gestureRecognizerShouldBegin:gestureRecognizer];
}

- (NSArray<UIViewController *> *)findViewControllerClass:(Class)cls
                                     fromViewControllers:(NSArray<UIViewController *> *)viewControllers
                                              usingBlock:(UIViewController * (^)(void))block {
    
    /*  导航栏查找规则：
     1）如果传入 viewController 存在于 viewControllers 中，则使用 viewControllers 中的以及存在的。
     2）如果传入 viewController 不存在 viewControllers 中，则使用传入的 viewController。
     */
    NSMutableArray<UIViewController *> *elements = [NSMutableArray array];
    for (UIViewController *vc in viewControllers) {
        if ([vc isKindOfClass:cls]) {
            if (elements.count == viewControllers.count - 1) {
                [elements addObject:vc];
                [elements addObject:vc];
            } else {
                [elements addObject:vc];
                [elements addObject:[viewControllers lastObject]];
            }
            break;
        } else {
            if (elements.count == viewControllers.count - 1) {
                if (block) {
                    UIViewController *vc = block();
                    [elements addObject:vc];
                }
            }
            [elements addObject:vc];
        }
    }
    return elements;
}

#pragma mark - solution
- (id<NSLViewControllerProtocol>)solution {
    id<NSLViewControllerProtocol> protocol = objc_getAssociatedObject(self, _cmd);
    if (!protocol) {
        protocol = (id<NSLViewControllerProtocol>)self;
        [self setSolution:protocol];
    }
    return protocol;
}

- (void)setSolution:(id<NSLViewControllerProtocol> _Nonnull)solution {
    objc_setAssociatedObject(self, @selector(solution), solution, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - NSLNavigationControllerProtocol
- (void)jumpViewControllerClass:(Class)cls usingBlock:(UIViewController * _Nonnull (^)(void))block {
    self.viewControllers = [self findViewControllerClass:cls fromViewControllers:self.viewControllers usingBlock:block];
}

- (void)clickBackBarButtonItem {
    [(id<UINavigationBarDelegate>)self navigationBar:self.topViewController.navigationController.navigationBar shouldPopItem:self.topViewController.navigationItem];
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.visibleViewController;
}

//- (void)dealloc {
//    [self.navigationBar removeObserver:self forKeyPath:@"alpha" context:NULL];
//}
@end

#pragma mark - exchange method
static void NSLExchangeMethods(Class cls, SEL s1, SEL s2) {
    Method m1 = class_getInstanceMethod(cls, s1);
    Method m2 = class_getInstanceMethod(cls, s2);
    
    BOOL success = class_addMethod(cls, s1, method_getImplementation(m2), method_getTypeEncoding(m2));
    if (success) {
        class_replaceMethod(cls, s2, method_getImplementation(m1), method_getTypeEncoding(m1));
    } else {
        method_exchangeImplementations(m1, m2);
    }
}

static void __attribute__((constructor)) initialize(void) {
    NSLExchangeMethods([UIViewController class], @selector(viewWillAppear:), @selector(ex_viewWillAppear:));
    NSLExchangeMethods([UINavigationController class], @selector(viewDidLoad), @selector(ex_viewDidLoad));
    NSLExchangeMethods([UINavigationController class], @selector(navigationBar:shouldPopItem:), @selector(ex_navigationBar:shouldPopItem:));
}
