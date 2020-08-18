//
//  APPVideoDownView.m
//  CleverBaby
//
//  Created by 峰 on 2020/8/15.
//  Copyright © 2020 小神童. All rights reserved.
//

#import "APPVideoDownView.h"

#import "MCDownloadManager.h"

@implementation APPVideoDownView

{
    UILabel *_label;//显示进度
    
    UIButton *_cancleBtn;//取消按钮
    
    NSString *_currentUrl;
}

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.72];
        [self createView];
    }
    return self;
}



///创建View
- (void)createView {
    
    _label = [APPViewTool view_createLabelWithText:@"" font:kFontOfSystem(FitIpad(15)) textColor:UIColor.blackColor textAlignment:(NSTextAlignmentCenter)];
    _label.backgroundColor = UIColor.whiteColor;
    _label.layer.cornerRadius = FitIpad(5);
    _label.layer.masksToBounds = YES;
    [self addSubview:_label];
    
    
    _cancleBtn = [APPViewTool view_createButtonTitle:@"取消缓存" textColor:UIColor.redColor textFont:kFontOfSystem(FitIpad(15)) bgColor:UIColor.whiteColor];
    _cancleBtn.layer.cornerRadius = FitIpad(15);
    [self addSubview:_cancleBtn];
    
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-FitIpad(30));
        make.width.mas_equalTo(FitIpad(70));
        make.height.mas_equalTo(FitIpad(35));
    }];
    
    [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self->_label);
        make.centerY.equalTo(self).offset(FitIpad(30));
        make.width.mas_equalTo(FitIpad(120));
        make.height.mas_equalTo(FitIpad(35));
    }];
    
    [_cancleBtn addTarget:self action:@selector(onClickBtnCancle) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickBtnBack)];
    tap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tap];
}

- (void)onClickBtnBack {
}


///点击取消
- (void)onClickBtnCancle {
    
    [MCDownloadManager.defaultInstance removeWithURL:_currentUrl];
    self.hidden = YES;
    AlertMessage(@"您已取消缓存了哦~");
}

///下载
- (void)downVideo:(NSString *)videoUrl blockComplete:(APPBackBlock)blockEnd {
    
    _currentUrl = videoUrl;
    _label.text = @"0.0%";
    
    //先删除最旧的视频
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        NSString *videoCache = [kAPP_File_CachePath stringByAppendingPathComponent:@"MCDownloadCache"];
        
        NSError *error;
        NSArray *pathArray = [NSFileManager.defaultManager contentsOfDirectoryAtPath:videoCache error:&error];
        
        if (pathArray.count >= 10) {
            //删除第一条视频
            
            NSString *fileName = @"";
            NSString *removeName = @"";
            NSDate *removeDate = nil;
            for (NSInteger i = 0; i < pathArray.count ; i++) {
                //倒着取
                fileName = pathArray[i];
                if ([fileName hasSuffix:@"mp4"]) {
                    //是mp4文件
                    NSString *filePath = [videoCache stringByAppendingPathComponent:fileName];
                    NSDictionary<NSString *, id> *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
                    NSDate *createDate = [attrs fileCreationDate];//创建日期
                    if (i == 0) {
                        removeDate = createDate;
                        removeName = fileName;
                    }else{
                        if (createDate.timeIntervalSince1970 < removeDate.timeIntervalSince1970) {
                            removeDate = createDate;
                            removeName = fileName;
                        }
                    }
                }
            }
            
            if (removeName.length) {
                NSString *filePath = [videoCache stringByAppendingPathComponent:removeName];
                [NSFileManager.defaultManager removeItemAtPath:filePath error:nil];
            }
        }
    });
    
    [MCDownloadManager.defaultInstance downloadFileWithURL:videoUrl progress:^(NSProgress * _Nonnull downloadProgress, MCDownloadReceipt * _Nonnull receipt) {
        if ([receipt.url isEqualToString:self->_currentUrl]) {
            self->_label.text = [NSString stringWithFormat:@"%.1f%@",downloadProgress.fractionCompleted * 100,@"%"];
        }
    } destination:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSURL * _Nonnull filePath) {
        //下载完
        self.hidden = YES;
        NSString *videoPath = [self loacalVideoFilePath:videoUrl];
        if (videoPath.length) {
            blockEnd(YES,videoPath);
        }else{
            self.hidden = YES;
            AlertMessage(@"缓存出错了哦~请重新缓存");
        }
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        //下载失败
        self.hidden = YES;
        AlertMessage(@"缓存出错了哦~请重新缓存");
    }];
}


///移除
- (void)removeDown {
    
    [MCDownloadManager.defaultInstance removeWithURL:_currentUrl];
}

///获取本地的视频路径
- (NSString *)loacalVideoFilePath:(NSString *)videoUrl {
    
    NSString *filePath = @"";
    
    MCDownloadReceipt *receipt = [MCDownloadManager.defaultInstance getReceiptForURL:videoUrl];
    
    if (receipt) {
        
        if (receipt.state == MCDownloadStateCompleted) {
            if (receipt.filePath.length) {
                
                if ([NSFileManager.defaultManager fileExistsAtPath:receipt.filePath]) {
                    filePath = receipt.filePath;
                }else{
                    //不存在路径，被删除了
                    [MCDownloadManager.defaultInstance removeWithDownloadReceipt:receipt];
                }
            }
        }
    }
    
    return filePath;
}



@end
