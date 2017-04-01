//
//  NSLGlobalSwitchView.h
//  NSLNavigationSolution
//
//  Created by Dennis on 19/03/2017.
//  Copyright © 2017 Dennis Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NSLGlobalSwitchView;
@protocol NSLGlobalSwitchViewDelegate <NSObject>
- (void)globalSwitchView:(NSLGlobalSwitchView *)view didClickSwitch:(UISwitch *)aSwitch;
@end

@interface NSLGlobalSwitchView : UIView
@property (nonatomic, weak) id<NSLGlobalSwitchViewDelegate> delegate;

+ (instancetype)globalSwitchView;

- (void)changeSwitchStatus:(BOOL)status;
@end
