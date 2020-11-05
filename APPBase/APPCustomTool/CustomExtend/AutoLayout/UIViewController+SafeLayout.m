//
//  UIViewController+SafeLayout.m
//  APPBase
//
//  Created by v_gaoyafeng on 2020/11/5.
//  Copyright © 2020 ishansong. All rights reserved.
//

#import "UIViewController+SafeLayout.h"

@implementation UIViewController (SafeLayout)

- (MASViewAttribute *)mas_safeAreaLayoutGuide {
    if (@available(iOS 11.0, *)) {
        return [[MASViewAttribute alloc] initWithView:self.view item:self.view.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
    } else {
        return [[MASViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
    }
}

- (MASViewAttribute *)mas_safeAreaLayoutGuideTop {
    if (@available(iOS 11.0, *)) {
        return [[MASViewAttribute alloc] initWithView:self.view item:self.view.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeTop];
    } else {
        return [[MASViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
    }
}

- (MASViewAttribute *)mas_safeAreaLayoutGuideBottom {
    if (@available(iOS 11.0, *)) {
        return [[MASViewAttribute alloc] initWithView:self.view item:self.view.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
    } else {
        return [[MASViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeTop];
    }
}

- (MASViewAttribute *)mas_safeAreaLayoutGuideLeft {
    if (@available(iOS 11.0, *)) {
        return [[MASViewAttribute alloc] initWithView:self.view item:self.view.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeLeft];
    } else {
        return [[MASViewAttribute alloc] initWithView:self.view layoutAttribute:NSLayoutAttributeLeft];
    }
}
- (MASViewAttribute *)mas_safeAreaLayoutGuideRight {
    if (@available(iOS 11.0, *)) {
        return [[MASViewAttribute alloc] initWithView:self.view item:self.view.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeRight];
    } else {
        return [[MASViewAttribute alloc] initWithView:self.view layoutAttribute:NSLayoutAttributeRight];
    }
}

@end
