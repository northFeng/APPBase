//
//  FRHomeVC.m
//  FlashRider
//
//  Created by gaoyafeng on 2018/11/21.
//  Copyright © 2018 ishansong. All rights reserved.
//

#import "FRHomeVC.h"
#import "FROrderCellVC.h"
#import "GFNavigationController.h"

@interface FRHomeVC ()

@end

@implementation FRHomeVC

- (void)dealloc{
    
    NSLog(@"---->FRHome死亡了");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = COLOR(@"#333333");
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
    
    
    NSString *urlStr = [[NSURL URLWithString:@"v1/goin/list" relativeToURL:[NSURL URLWithString:@"https://www.baidu.com/"]] absoluteString];
    
    NSLog(@"--->%@",urlStr);
}

///
- (void)onClickBtn {
    
    [APPAlertTool showAlertMessage:@"弹出来了"];
    
    [self pushViewControllerWithClassString:@"FRHomeVC" pageTitle:@"第二页面"];
}

///
- (void)onClickBtnTwo {
    
    [APPAlertTool showCustomLoading];
}

///
- (void)onClickBtnThr {
    
    [APPAlertTool hideCustomLoading];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    FROrderCellVC *vc = [[FROrderCellVC alloc] init];
    
    GFNavigationController *navi = [[GFNavigationController alloc] initWithRootViewController:vc];
    navi.navigationBarHidden = YES;//隐藏系统导航条
    
    [self presentViewController:navi animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
