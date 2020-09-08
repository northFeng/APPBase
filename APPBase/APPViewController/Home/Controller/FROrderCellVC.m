//
//  FROrderCellVC.m
//  FlashRider
//
//  Created by gaoyafeng on 2018/11/22.
//  Copyright © 2018 ishansong. All rights reserved.
//

#import "FROrderCellVC.h"

@interface FROrderCellVC ()

@end

@implementation FROrderCellVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = DynamicColor([UIColor whiteColor], [UIColor greenColor]);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = DynamicColor(COLOR(@"333333"), COLOR(@"FFFFFF"));
    [button setTitle:@"hello" forState:UIControlStateNormal];
    button.frame = CGRectMake(100, 100, 100, 50);
    [self.view addSubview:button];
    [button addTarget:self action:@selector(onClickBtn) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btnTwo = [UIButton buttonWithType:UIButtonTypeCustom];
    btnTwo.backgroundColor = COLOR(@"#333333");
    [btnTwo setTitle:@"show" forState:UIControlStateNormal];
    btnTwo.frame = CGRectMake(100, 200, 100, 50);
    [self.view addSubview:btnTwo];
    [btnTwo addTarget:self action:@selector(onClickBtnTwo) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.backgroundColor = COLOR(@"#333333");
    [btn3 setTitle:@"hide" forState:UIControlStateNormal];
    btn3.frame = CGRectMake(100, 300, 100, 50);
    [self.view addSubview:btn3];
    [btn3 addTarget:self action:@selector(onClickBtnThr) forControlEvents:UIControlEventTouchUpInside];
}

///
- (void)onClickBtn {
    
    [APPAlertTool showMessage:@"弹出来了"];
    
    [self pushViewControllerWithClassString:@"FRHomeVC" pageTitle:@"第二页面"];
}

///
- (void)onClickBtnTwo {
    
    [APPAlertTool showCustomLoading];
}

///
- (void)onClickBtnThr {
    
    [APPAlertTool hideCustomLoading];
    [self dismissViewControllerAnimated:YES completion:nil];
}


//--------------------------------------- 3DTouch功能 ---------------------------------------
- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    // setup a list of preview actions
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"关注" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"关注");
    }];
    
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"收藏" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"收藏");
    }];
    
    UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:@"分享" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"分享");
    }];
    
    NSArray *actions = @[action1,action2,action3];
    
       return actions;
}

//--------------------------------------------------------------------------------------------


@end
