//
//  UINavigationController+CS.m
//  LDNavigationSolution
//
//  Created by Dennis Lee on 17/03/2017.
//  Copyright © 2017 Dennis Lee. All rights reserved.
//

#import "UINavigationController+LDNavigationSolution.h"
#import <objc/runtime.h>

void ld_method_exchangeImplementations(Class cls, SEL oringinal, SEL swizzled) {
    Method originalMethod = class_getInstanceMethod(cls, oringinal);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzled);
    
    BOOL didAddMethod = class_addMethod(cls, oringinal, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(cls, swizzled, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@implementation UIViewController (LDNavigationSolution)
+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ld_method_exchangeImplementations([self class],  @selector(viewWillAppear:), @selector(ld_viewWillAppear:));
    });
}

- (void)ld_viewWillAppear:(BOOL)animated {
    [self ld_viewWillAppear:animated];

    // 解决导航栏闪烁问题
    [UIView animateWithDuration:0.1 animations:^{
        self.navigationController.navigationBar.alpha = self.ld_navigationBarTranslucent ? 0.0 : 1.0;
    }];
    
    if (!self.ld_navigationBarTranslucent) { self.ld_navigationBarTranslucent = NO; }
}

#pragma mark - ld_interactivePopDisabled
- (BOOL)ld_interactivePopDisabled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setLd_interactivePopDisabled:(BOOL)ld_interactivePopDisabled {
    objc_setAssociatedObject(self, @selector(ld_interactivePopDisabled), @(ld_interactivePopDisabled), OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - ld_navigationBarTranslucent
- (BOOL)ld_navigationBarTranslucent {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setLd_navigationBarTranslucent:(BOOL)ld_navigationBarTranslucent {
    objc_setAssociatedObject(self, @selector(ld_navigationBarTranslucent), @(ld_navigationBarTranslucent), OBJC_ASSOCIATION_ASSIGN);
    self.navigationController.navigationBar.alpha = ld_navigationBarTranslucent ? 0.0 : 1.0;
}

@end

#pragma mark - UINavigationController extension
static const char * INTERACTIVE_DELEGATE = "INTERACTIVE_DELEGATE";

@interface UINavigationController (LDNavigationSolutionPrivate)
@property (nonatomic, strong) id _popTarget;
@property (nonatomic, assign, getter=_isInteractive) BOOL _interactive; // 正在手势交互
@end

@implementation UINavigationController (LDNavigationSolutionPrivate)
#pragma mark - _popTarget
- (id)_popTarget {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)set_popTarget:(id)_popTarget {
    objc_setAssociatedObject(self, @selector(_popTarget), _popTarget, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - _interactive
- (BOOL)_isInteractive {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)set_interactive:(BOOL)_interactive {
    objc_setAssociatedObject(self, @selector(_isInteractive), @(_interactive), OBJC_ASSOCIATION_ASSIGN);
}
@end

@implementation UINavigationController (LDNavigationSolution)
+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ld_method_exchangeImplementations([self class], @selector(navigationBar:shouldPopItem:), @selector(ld_navigationBar:shouldPopItem:));
        ld_method_exchangeImplementations([self class], @selector(viewDidLoad), @selector(ld_viewDidLoad));
    });
}

#pragma mark -
- (void)ld_viewDidLoad {
    [self ld_viewDidLoad];
	
    self._interactive = NO;
	
    objc_setAssociatedObject(self, INTERACTIVE_DELEGATE, self.interactivePopGestureRecognizer.delegate, OBJC_ASSOCIATION_ASSIGN);
    self.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    UIGestureRecognizer *gesture = [self interactivePopGestureRecognizer];
    gesture.enabled = NO;
    UIView *gestureView = [gesture view];
    
    NSMutableArray *_targets = [gesture valueForKey:@"_targets"];
    id gesterRecognizerTarget = [_targets firstObject];
    id navigationInteractiveTransion = [gesterRecognizerTarget valueForKey:@"_target"];
    self._popTarget = navigationInteractiveTransion;
    
    UIScreenEdgePanGestureRecognizer *popGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(ld_handleNavigationTransition:)];
    popGestureRecognizer.edges = UIRectEdgeLeft;
    popGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [gestureView addGestureRecognizer:popGestureRecognizer];
    
    // 防止系统中途修改导航栏
    [self.navigationBar addObserver:self forKeyPath:@"alpha" options:NSKeyValueObservingOptionNew context:NULL];
}

#pragma mark - observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"alpha"] && [object isKindOfClass:[UINavigationBar class]]) {
        if (!self._isInteractive) { // 没有手势交互可以监听
            UINavigationBar *bar = (UINavigationBar *)object;
            // 本来是要隐藏的，但是现在却是现实的
            if (self.topViewController.ld_navigationBarTranslucent && bar.alpha == 1.0) {  bar.alpha = 0.0; }
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - 导航栏渐变
- (void)ld_handleNavigationTransition:(UIScreenEdgePanGestureRecognizer *)gesture {
    SEL selector = NSSelectorFromString(@"handleNavigationTransition:");
    IMP imp = [self._popTarget methodForSelector: selector];
    void (*transitionHandle)(id, SEL, UIGestureRecognizer *) = (void *)imp;
    transitionHandle(self._popTarget, selector, gesture);
    
    id<UIViewControllerTransitionCoordinator> tc = self.transitionCoordinator;
    UIViewController *fromVC = [tc viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [tc viewControllerForKey:UITransitionContextToViewControllerKey];
    
    /*  导航栏处理的四种情况：
        1）从 有 --≥ 有，不需要处理
        2）从 无 --≥ 无，不需要处理
        3）从 无 --≥ 有，alpha 变为 1.0
        4）从 有 --≥ 无，alpha 变为 0.0
     */
    if (fromVC.ld_navigationBarTranslucent && toVC.ld_navigationBarTranslucent) { return; }
    if (!fromVC.ld_navigationBarTranslucent && !toVC.ld_navigationBarTranslucent) { return; }
    
    UIView *barBackgroundView = self.navigationBar;
    BOOL reverse = fromVC.ld_navigationBarTranslucent;
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged: {
            CGFloat progress = tc.percentComplete;
            barBackgroundView.alpha = reverse ? progress : 1 - progress;
            self._interactive = YES;
            
            break;
        }
        default: {
            if ([tc isCancelled]) {
                barBackgroundView.alpha = reverse ? 0.0 : 1.0;
            } else {
                barBackgroundView.alpha = reverse ? 1.0 : 0.0;
            }
            self._interactive = NO;
            
            break;
        }
    }
}

#pragma mark - UINavigationBarDelegate
- (BOOL)ld_navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    UIViewController *topViewController = [self topViewController];
    if (item != topViewController.navigationItem) {
        return [self ld_navigationBar:navigationBar shouldPopItem:item];
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
    return [self ld_navigationBar:navigationBar shouldPopItem:item];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count <= 1) { return NO; }
    
    UIViewController *topViewController = [self topViewController];
    if (topViewController.ld_interactivePopDisabled) { return NO; }
    
    if ([topViewController conformsToProtocol:@protocol(UINavigationControllerCustomizable)]) {
        return [(id<UINavigationControllerCustomizable>)topViewController navigationController:self shouldJumpToViewControllerUsingGesture:YES];
    }
    
    id<UIGestureRecognizerDelegate> delegate = objc_getAssociatedObject(self, INTERACTIVE_DELEGATE);
    return [delegate gestureRecognizerShouldBegin:gestureRecognizer];
}

- (NSArray<UIViewController *> *)findViewControllers:(NSArray<UIViewController *> *)viewControllers whereViewController:(UIViewController *)viewController {
    /*  导航栏查找规则：
     1）如果传入 viewController 存在于 viewControllers 中，则使用 viewControllers 中的以及存在的。
     2）如果传入 viewController 不存在 viewControllers 中，则使用传入的 viewController。
     */
    NSMutableArray<UIViewController *> *elements = [NSMutableArray array];
    for (UIViewController *vc in viewControllers) {
        if ([vc isKindOfClass:[viewController class]]) {
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
                [elements addObject:viewController];
            }
            [elements addObject:vc];
        }
    }
    return elements;
}

#pragma mark - ld_jumpToViewController
- (UIViewController *)ld_jumpToViewController {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLd_jumpToViewController:(UIViewController *)ld_jumpToViewController {
    objc_setAssociatedObject(self, @selector(ld_jumpToViewController), ld_jumpToViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.viewControllers = [self findViewControllers:[self viewControllers] whereViewController:ld_jumpToViewController];
}

#pragma mark - Public method
- (void)ld_clickBackBarButtonItem {
    [(id<UINavigationBarDelegate>)self navigationBar:self.topViewController.navigationController.navigationBar shouldPopItem:self.topViewController.navigationItem];
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.visibleViewController;
}

- (void)dealloc {
    [self.navigationBar removeObserver:self forKeyPath:@"alpha" context:NULL];
}
@end
