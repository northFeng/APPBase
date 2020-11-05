//
//  GFMineController.m
//  APPBase
//
//  Created by 峰 on 2019/10/11.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import "GFMineController.h"

#import <YYText/YYText.h>//yytext 框架

@interface GFMineController ()

///
@property (nonatomic,strong) UIView *backView;

@end

@implementation GFMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    YYLabel *label = [[YYLabel alloc] initWithFrame:CGRectMake(50, 100, 150, 100)];
    
    [self.view addSubview:label];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"我们的网站:http:www.baidu.com"];
    attrString.yy_font = [UIFont systemFontOfSize:15];
    [attrString yy_setColor:[UIColor blueColor] range:NSMakeRange(6, 18)];
    [attrString yy_setUnderlineStyle:NSUnderlineStyleSingle range:NSMakeRange(6, 18)];
    [attrString yy_setUnderlineColor:UIColor.blueColor range:NSMakeRange(6, 18)];
    
    [attrString yy_setTextHighlightRange:NSMakeRange(6, 18) color:UIColor.blueColor backgroundColor:UIColor.grayColor tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSLog(@"点击了链接");
    }];
    
    label.numberOfLines = 0;
    label.attributedText = attrString;
    
    if ([label isKindOfClass:[UIView class]]) {
        NSLog(@"属于UIview");
    }
    
    if ([label isMemberOfClass:[YYLabel class]]) {
        NSLog(@"属于YYlabel子类");
    }
    
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = UIColor.redColor;
    [self.view addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(10, 0, 50, 0));
    }];
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UIEdgeInsets edge1 = self.view.safeAreaInsets;
    UIEdgeInsets edge2 = _backView.safeAreaInsets;
    
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
