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
#import "APPDataBase.h"//数据库

///Apple 登录框架
#import <AuthenticationServices/AuthenticationServices.h>

#import "APPLoginApi.h"

@interface FRHomeVC ()

///
@property (nonatomic,strong) APPDataBase *dataBase;



@end

@implementation FRHomeVC
{
    UIButton *_btnTwo;
    UIButton *_btn3;
}

- (void)dealloc{
    
    NSLog(@"---->FRHome死亡了");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"SwiftOne" forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 200, 50, 30);
    [btn addTarget:self action:@selector(onClickBtnStore) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn2 setTitle:@"全部" forState:UIControlStateNormal];
    btn2.frame = CGRectMake(200, 200, 50, 30);
    [btn2 addTarget:self action:@selector(onClickBtnTake) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn3 setTitle:@"分页" forState:UIControlStateNormal];
    btn3.frame = CGRectMake(300, 200, 50, 30);
    [btn3 addTarget:self action:@selector(onClickBtnTakePage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    
    _dataBase = [[APPDataBase alloc] init];
    
    [_dataBase createDataBase];
    
    
    ASAuthorizationAppleIDButton * appleIDBtn = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeDefault style:ASAuthorizationAppleIDButtonStyleWhite];
    appleIDBtn.frame = CGRectMake(30, 80, 60, 64);
    [appleIDBtn addTarget:self action:@selector(didAppleIDBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:appleIDBtn];
}

///
- (void)didAppleIDBtnClicked {
    
    NSLog(@"点击苹果登录按钮");
    
    [APPLoginApi.shareInstance appleLogin];
}

///存储
- (void)onClickBtnStore {
    
    NSLog(@"---->%@",[APPLoacalInfo getDeviceIDInKeychain]);
    //4780A8E1-8F2D-4324-B5FF-92228139AB53
    
    OneSwiftController *swiftVC = [[OneSwiftController alloc] init];
    swiftVC.infoStr = @"OC传的消息";
    [self.navigationController pushViewController:swiftVC animated:YES];

}

///读取
- (void)onClickBtnTake {
   
    [_dataBase getData];
    
}

///
- (void)onClickBtnTakePage {
    static int i = 0;
    [_dataBase getDataPage:i limit:5];
    i ++;
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
