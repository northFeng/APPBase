//
//  APPAudioPlayerVM.m
//  CleverBaby
//
//  Created by 峰 on 2020/3/4.
//  Copyright © 2020 小神童. All rights reserved.
//

#import "APPAudioPlayerVM.h"

@implementation APPAudioPlayerVM

- (RACSubject *)timerAction {
    if (!_timerAction) {
        _timerAction = [RACSubject subject];
    }
    return _timerAction;
}

#pragma mark - ************************* 定时器 *************************
///销毁定时器
- (void)deallocTimer {
    
    ///销毁定时器
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:0.02 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        [_timer setFireDate:[NSDate distantFuture]];
    }
    return _timer;
}
         
///定时器事件
- (void)timerEvent {
    
    [self.timerAction sendNext:@0];
}
         
///开启定时器
- (void)timerStart {
    [self.timer setFireDate:[NSDate distantPast]];
}

///暂停定时器
- (void)timerPause {
    [self.timer setFireDate:[NSDate distantFuture]];
}


#pragma mark - ************************* 按钮点击事件 *************************
///分享事件
+ (void)shareActionWithThemeTitle:(NSString *)themeTitle {
    
    if ([APPAudioPlayer shareInstance].playItem) {
        
        
    }else{
        AlertMessage(@"分享错误");
    }
}

///分享
+ (void)gotoShareWithUrl:(NSString *)shareUrl themeTitle:(NSString *)themeTitle {
    
    
}

///进行儿歌收藏
+ (void)collectionSongWithAcgtionBtn:(UIButton *)collectBtn {
    
    NSMutableDictionary *dicJson = [NSMutableDictionary dictionary];
    [dicJson gf_setObject:[APPAudioPlayer shareInstance].playItem.audioId withKey:@"songId"];
    
    if (collectBtn.selected) {
        //已收藏 ——>取消收藏
        [dicJson gf_setObject:@"0" withKey:@"isCollect"];
    }else{
        //未收藏 ——>收藏
        [dicJson gf_setObject:@"1" withKey:@"isCollect"];
    }
    
    AlertLoadingEnable(NO);
    [APPHttpTool getRequestNetDicDataUrl:@"v2/front/freeSongCollect/addFreeSongCollect" params:dicJson WithBlock:^(BOOL result, id  _Nonnull idObject, NSInteger code) {
        AlertHideLoading;
        if (result) {
            collectBtn.selected = !collectBtn.selected;
            
            if (collectBtn.selected) {
                AlertMessage(@"已收藏");
            }else{
                AlertMessage(@"已取消收藏");
            }
        }else{
            AlertMessage((NSString *)idObject);
        }
    }];
}

///查询改儿歌收藏状态
+ (void)getSongCollectionStateWithButton:(UIButton *)collectBtn {
    
    collectBtn.selected = NO;
    
    NSMutableDictionary *dicJson = [NSMutableDictionary dictionary];
    [dicJson gf_setObject:[APPAudioPlayer shareInstance].playItem.audioId withKey:@"songId"];
    
    [APPHttpTool getRequestNetDicDataUrl:@"v2/front/freeSongCollect/findFreeSongConditionById" params:dicJson WithBlock:^(BOOL result, id  _Nonnull idObject, NSInteger code) {
        if (result) {
            NSString *dataStr = (NSString *)idObject;
            if (dataStr.intValue) {
                collectBtn.selected = YES;
            }
        }
    }];
}

@end
