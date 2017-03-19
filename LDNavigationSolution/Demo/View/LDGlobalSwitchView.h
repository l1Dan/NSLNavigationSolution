//
//  LDGlobalSwitchView.h
//  LDNavigationSolution
//
//  Created by Dennis on 19/03/2017.
//  Copyright © 2017 Dennis Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LDGlobalSwitchView;
@protocol LDGlobalSwitchViewDelegate <NSObject>
- (void)globalSwitchView:(LDGlobalSwitchView *)view didClickSwitch:(UISwitch *)aSwitch;
@end

@interface LDGlobalSwitchView : UIView
@property (nonatomic, weak) id<LDGlobalSwitchViewDelegate> delegate;

+ (instancetype)globalSwitchView;

- (void)changeSwitchStatus:(BOOL)status;
@end
