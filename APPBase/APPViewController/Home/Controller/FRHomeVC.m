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
{
    UIButton *_btnTwo;
    UIButton *_btn3;
}

- (void)dealloc{
    
    NSLog(@"---->FRHome死亡了");
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    

    if (@available(iOS 13.0, *)) {
    
        
    } else {
        // Fallback on earlier versions
    }
   // _btnTwo.layer.borderColor = DynamicColor([UIColor redColor], [UIColor greenColor]).CGColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = DynamicColor(COLOR(@"333333"), COLOR(@"FFFFFF"));
    [button setTitle:@"hello" forState:UIControlStateNormal];
    [button setTitleColor:DynamicColor(COLOR(@"FFFFFF"), COLOR(@"333333")) forState:UIControlStateNormal];
    button.frame = CGRectMake(100, 100, 100, 50);
    [self.view addSubview:button];
    [button addTarget:self action:@selector(onClickBtn) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *btnTwo = [UIButton buttonWithType:UIButtonTypeCustom];
    btnTwo.backgroundColor = COLOR(@"#333333");
    btnTwo.layer.borderWidth = 2;
    LayerBorderCGColor(btnTwo, btnTwo.layer, DynamicColor([UIColor redColor], [UIColor greenColor]));
    [btnTwo setTitle:@"show" forState:UIControlStateNormal];
    btnTwo.frame = CGRectMake(100, 200, 100, 50);
    [self.view addSubview:btnTwo];
    [btnTwo addTarget:self action:@selector(onClickBtnTwo) forControlEvents:UIControlEventTouchUpInside];
    _btnTwo = btnTwo;
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.backgroundColor = COLOR(@"#333333");
    [btn3 setTitle:@"hide" forState:UIControlStateNormal];
    btn3.layer.borderWidth = 2;
    LayerBorderCGColor(btn3, btn3.layer, DynamicColor([UIColor redColor], [UIColor greenColor]));
    btn3.frame = CGRectMake(100, 300, 100, 50);
    [self.view addSubview:btn3];
    [btn3 addTarget:self action:@selector(onClickBtnThr) forControlEvents:UIControlEventTouchUpInside];
    _btn3 = btn3;
    
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:kRect(100, 400, 200, 30)];
    labelTitle.textAlignment = NSTextAlignmentLeft;
    labelTitle.font = kFontOfCustom(kMediumFont, 20);
    labelTitle.textColor = COLOR(@"333333");
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:DynamicColor([UIColor blackColor], [UIColor redColor])};
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"富文本文案" attributes:dic];
    labelTitle.attributedText = str;
    [self.view addSubview:labelTitle];
    
    
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
    
    [self pushViewControllerWithClassString:@"FROrderCellVC" pageTitle:@"第二页面"];
}

///
- (void)onClickBtnThr {
    

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
