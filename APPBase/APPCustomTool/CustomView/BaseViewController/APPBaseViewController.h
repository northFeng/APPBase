//
//  APPBaseViewController.h
//  FlashSend
//  APP内的根视图
//  Created by gaoyafeng on 2018/8/24.
//  Copyright © 2018年 ishansong. All rights reserved.
//

#import <UIKit/UIKit.h>

//导航条
#import "GFNavigationBarView.h"

#import "GFButton.h"//自定义按钮

#import "APPLoadWaitView.h"//加载等待视图

//提示图
#import "FSPromptView.h"

NS_ASSUME_NONNULL_BEGIN

//刷新视图
typedef void (^Block) (void);

@interface APPBaseViewController : UIViewController <GFNavigationBarViewDelegate,UITableViewDelegate,UITableViewDataSource>

///tableView
@property (nonatomic,strong,nullable) UITableView *tableView;

///tableView的头部view
@property (nonatomic,strong,nullable) UIView *headView;

///标题label
@property (nonatomic,strong,nullable) UILabel *headLabelTitle;

///数据列表数组
@property (nonatomic,strong,nullable) NSMutableArray *arrayDataList;

///加载更多——页数
@property (nonatomic,assign) NSInteger page;

///导航条
@property (nonatomic, strong,nullable) GFNavigationBarView *naviBar;

///页面标题
@property (nonatomic, copy,nullable) NSString *naviBarTitle;

///无网提示图
@property (nonatomic,strong,nullable) FSPromptView *promptNonetView;

///空空视图
@property (nonatomic,strong,nullable) FSPromptView *promptEmptyView;

///系统等待视图
@property (nonatomic,strong,nullable) APPLoadWaitView *waitingView;



#pragma mark - 创建tableView

/**
 *  @brief 创建tableView
 *
 *
 */
- (void)createTableView;

///创建tableView无HeadView
- (void)createTableViewNoHeadView;

///处理占位图显示 && 刷新cell
- (void)refreshTableViewHandlePromptView;


#pragma mark - tableView的 滚动 && 获取 && 刷新 cell
/**
 *  @brief 滚动指定tableView的位置
 *
 *  @param section 组
 *  @param row 行
 *  @param position 上 中 下
 */
- (void)scrollTableViewToSection:(NSInteger)section row:(NSInteger)row position:(UITableViewScrollPosition)position;

/**
 *  @brief 获取指定的cell
 *
 *  @param section 组
 *  @param row 行
 */
- (UITableViewCell *)getOneCellWithSection:(NSInteger)section row:(NSInteger)row;

///刷新指定cell
- (void)reloadOneCellForSection:(NSInteger)section row:(NSInteger)row;


/**
 *  @brief 添加上拉刷新，下拉加载功能
 *
 *
 */
- (void)addTableViewRefreshView;


///添加标题视图(在没有tableview没有tableHeadView的情况使用！！！)
- (void)addHeadTitleView;

///单独添加网络请求等待视图(最后添加！！！)
- (void)addWaitingView;

///独立添加提示图
- (void)addPromptView;


#pragma mark - 简版网络请求
///请求网络数据(分页请求)
- (void)requestTableViewNetPageData:(NSString *)url params:(NSDictionary *)params;

///tableView请求一个字典
- (void)requestTableViewNetDicDataUrl:(NSString *)url params:(NSDictionary *)params;

///请求一个字典
- (void)requestNetDicDataUrl:(NSString *)url params:(NSDictionary *)params;

///get请求一个字典
- (void)requestGetNetDicDataUrl:(NSString *)url params:(NSDictionary *)params;

///请求一个字典 && 不带等待视图
- (void)requestNetDicDataNoWatingViewUrl:(NSString *)url params:(NSDictionary *)params;


#pragma mark - 提示框&警告框
/**
 *  @brief 开启等待视图
 *
 */
- (void)startWaitingAnimating;

/**
 *  @brief 关闭等待视图
 *
 */
- (void)stopWaitingAnimating;

/**
 *  @brief 开启等待视图 && 显示文字
 *
 *  @param title 显示标题
 */
- (void)startWaitingAnimatingWithTitle:(NSString *)title;

/**
 *  @brief 关闭等待视图 && 显示文字
 *
 *  @param title 显示标题
 */
- (void)stopWaitingAnimatingWithTitle:(NSString *)title;

/**
 *  @brief 关闭等待视图 && 显示文字 ——>执行block
 *
 *  @param title 显示标题
 *  @param block 隐藏弹框后执行事件
 */
- (void)stopWaitingAnimatingWithTitle:(NSString *)title block:(APPBackBlock)block;


/**
 *  @brief 自定义消息框 && 确定按钮执行事件
 *
 *  @param message 消息
 *  @param block 执行按钮事件block
 */
- (void)showAlertCustomMessage:(NSString *)message okBlock:(APPBackBlock)block;

/**
 *  @brief 自定义弹框——>自定义标题
 *
 *  @param title 标题
 *  @param message 消息
 *  @param block 执行按钮事件block
 */
- (void)showAlertCustomTitle:(NSString *)title message:(NSString *)message okBlock:(APPBackBlock)block;

/**
 *  @brief 自定义弹框——>自定义标题——>自定义按钮文字
 *
 *  @param title 标题
 *  @param message 消息
 *  @param cancleTitle 取消按钮标题
 *  @param okTitle 确定按钮标题
 *  @param block 执行按钮事件block
 */
- (void)showAlertCustomTitle:(NSString *)title message:(NSString *)message cancleBtnTitle:(NSString *)cancleTitle okBtnTitle:(NSString *)okTitle okBlock:(APPBackBlock)block;

/**
 *  @brief 自定义弹框——>自定义标题——>自定义按钮文字 ——>左右按钮事件
 *
 *  @param title 标题
 *  @param message 消息
 *  @param cancleTitle 取消按钮标题
 *  @param okTitle 确定按钮标题
 *  @param blockLeft 执行左按钮事件block
 *  @param blockRight 执行右按钮事件block
 */
- (void)showAlertCustomTitle:(NSString *)title message:(NSString *)message cancleBtnTitle:(NSString *)cancleTitle okBtnTitle:(NSString *)okTitle leftBlock:(APPBackBlock)blockLeft rightBlock:(APPBackBlock)blockRight;

/**
 *  @brief 消息提示框
 *
 *  @param message 消息默认显示在Window视图上，全APP内显示位置一样（多个控制提示可能会重叠）
 *
 */
- (void)showMessage:(NSString *)message;

/**
 *  @brief 消息提示弹框 && 执行block
 *
 *  @param message 消息默认显示在Window视图上，全APP内显示位置一样（多个控制提示可能会重叠）
 *  @param block 消息弹框消失后执行block
 */
- (void)showMessage:(NSString *)message block:(APPBackBlock  )block;

/**
 *  @brief 消息提示框（显示在本控制器上，多个提示框不会重叠）
 *
 *  @param message 消息默认显示在self.view上
 *
 */
- (void)showMessage:(NSString *)message onView:(UIView *)subView;

/**
 *  @brief 消息确认框
 *
 *  @param message 消息
 *  @param title 消息框标题
 *
 */
- (void)showAlertMessage:(NSString *)message title:(NSString *)title;

/**
 *  @brief 消息提示框 && 带一个按钮执行事件
 *
 *  @param message 消息
 *  @param title 消息框标题
 *  @param btnTitle 按钮标题
 *  @param block 执行按钮事件block
 */
- (void)showAlertMessage:(NSString *)message title:(NSString *)title btnTitle:(NSString *)btnTitle block:(Block)block;

/**
 *  @brief 消息提示框 && 带两个按钮执行事件
 *
 *  @param message 消息
 *  @param title 消息框标题
 *  @param leftTitle 左边按钮标题
 *  @param leftBlock 执行左边按钮事件block
 *  @param rightTitle 右边按钮标题
 *  @param rightBlock 执行右边按钮事件block
 */
- (void)showAlertMessage:(NSString *)message title:(NSString *)title btnLeftTitle:(NSString *)leftTitle leftBlock:(Block)leftBlock btnRightTitle:(NSString *)rightTitle rightBlock:(Block  )rightBlock;

/**
 *  @brief 无网提示图
 *
 */
- (void)showPromptNonetView;

/**
 *  @brief 无内容提示图
 *
 */
- (void)showPromptEmptyView;

/**
 *  @brief 隐藏无网&&无内容提示图
 *
 */
- (void)hidePromptView;


#pragma mark - 状态栏设置
/**
 *  @brief 设置状态栏是否隐藏
 *
 */
- (void)setStatusBarIsHide:(BOOL)isHide;

/**
 *  @brief 设置状态栏样式为默认
 *
 */
- (void)setStatusBarStyleDefault;

/**
 *  @brief 设置状态栏样式为白色
 *
 */
- (void)setStatusBarStyleLight;



#pragma mark - 右滑返回手势的 开启  && 禁止
///禁止返回手势
- (void)removeBackGesture;

/**
 * 恢复返回手势
 */
- (void)resumeBackGesture;



#pragma mark - 视图推进封装

/**
 *  @brief 推进视图 && Xib
 *
 *  @param classString VC类的字符串
 *  @param title VC页面标题
 */
- (void)pushViewControllerWithNibClassString:(NSString *)classString pageTitle:(NSString *)title;

/**
 *  @brief 推进视图 && 无Xib
 *
 *  @param classString VC类的字符串
 *  @param title VC页面标题
 */
- (void)pushViewControllerWithClassString:(NSString *)classString pageTitle:(NSString *)title;

#pragma mark - 弹出模态视图

///弹出模态视图
- (void)presentViewController:(APPBaseViewController *)presentVC;

/**
 *  @brief 弹出模态视图
 *
 *  @param presentVC VC视图
 *  @param presentStyle 弹出动画风格
 *  @param completion 动画执行完毕回调
 */
- (void)presentViewController:(APPBaseViewController *)presentVC presentStyle:(UIModalTransitionStyle)presentStyle completionBlock:(void (^)(void))completion;


#pragma mark - 系统方法自动添加

///给按钮添加事件
- (void)btnAddEventControlWithBtn:(UIButton *)button action:(SEL)action;

///给按钮添加显示(默认状态)
- (void)btnAddTitleWithBtn:(UIButton *)button title:(NSString *)title font:(UIFont *)font textColor:(UIColor *)color;

///给按钮添加显示——设置状态
- (void)btnAddTitleWithBtn:(UIButton *)button title:(NSString *)title font:(UIFont *)font textColor:(UIColor *)color state:(UIControlState)state;


#pragma mark - 延时器执行方法

/**
 *  @brief 延时几秒执行事件
 *
 *  @param timeOut 执行事件延时时间
 *  @param block 执行事件
 */
- (void)performDelayerEventWithTimeOut:(NSInteger)timeOut block:(APPBackBlock)block;

/**
 *  @brief 延时几秒执行事件 + 传参对象
 *
 *  @param timeOut 执行事件延时时间
 *  @param block 执行事件
 *  @param object 执行事件传的参数对象
 */
- (void)performDelayerEventWithTimeOut:(NSInteger)timeOut block:(APPBackBlock)block withObject:(nullable id)object;



@end

NS_ASSUME_NONNULL_END
