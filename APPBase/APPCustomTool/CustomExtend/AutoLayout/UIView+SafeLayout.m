//
//  UIView+SafeLayout.m
//  APPBase
//
//  Created by v_gaoyafeng on 2020/11/5.
//  Copyright © 2020 ishansong. All rights reserved.
//

#import "UIView+SafeLayout.h"

@implementation UIView (SafeLayout)

- (MASViewAttribute *)mas_safeAreaLayoutGuide {
    if (@available(iOS 11.0, *)) {
        return [[MASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
    } else {
        return [[MASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBottom];
    }
    
}
- (MASViewAttribute *)mas_safeAreaLayoutGuideTop {
    if (@available(iOS 11.0, *)) {
        return [[MASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeTop];
    } else {
        return [[MASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTop];
    }
}

- (MASViewAttribute *)mas_safeAreaLayoutGuideBottom {
    if (@available(iOS 11.0, *)) {
        return [[MASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
    } else {
        return [[MASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBottom];
    }
}

- (MASViewAttribute *)mas_safeAreaLayoutGuideLeft {
    if (@available(iOS 11.0, *)) {
        return [[MASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeLeft];
    } else {
        return [[MASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeft];
    }
}
- (MASViewAttribute *)mas_safeAreaLayoutGuideRight {
    if (@available(iOS 11.0, *)) {
        return [[MASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeRight];
    } else {
        return [[MASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeRight];
    }
}

@end
