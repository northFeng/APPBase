//
//  UIViewController+SafeLayout.h
//  APPBase
//
//  Created by v_gaoyafeng on 2020/11/5.
//  Copyright © 2020 ishansong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (SafeLayout)

- (MASViewAttribute *)mas_safeAreaLayoutGuide;

- (MASViewAttribute *)mas_safeAreaLayoutGuideTop;

- (MASViewAttribute *)mas_safeAreaLayoutGuideBottom;

- (MASViewAttribute *)mas_safeAreaLayoutGuideLeft;

- (MASViewAttribute *)mas_safeAreaLayoutGuideRight;


@end

NS_ASSUME_NONNULL_END
