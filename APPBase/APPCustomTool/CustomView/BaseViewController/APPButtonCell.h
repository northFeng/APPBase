//
//  APPButtonCell.h
//  APPBase
//
//  Created by 峰 on 2020/9/1.
//  Copyright © 2020 ishansong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

///CellModel
@interface APPButtonCellModel : NSObject

///index
@property (nonatomic,assign) NSInteger index;

@property (nonatomic,copy) NSString *leftImgName;

@property (nonatomic,copy) NSString *leftLabText;

@property (nonatomic,copy) NSString *rightImgName;

@property (nonatomic,copy) NSString *rightLabText;

///获取一个model
+ (APPButtonCellModel *)getCellModelWithLeftImg:(NSString *)leftImg leftText:(NSString *)leftText rightImg:(NSString *)rightImg rightText:(NSString *)rightText index:(NSInteger)index;


@end


@interface APPButtonCell : UIButton

///左边image
@property (nonatomic,strong) UIImageView *leftImgview;

///左边文字
@property (nonatomic,strong) UILabel *leftLabel;

///右边image
@property (nonatomic,strong) UIImageView *rightImgview;

///右边文字
@property (nonatomic,strong) UILabel *rightLabel;

///model
@property (nonatomic,strong) APPButtonCellModel *model;


- (void)setCellModel:(APPButtonCellModel *)model;


+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
