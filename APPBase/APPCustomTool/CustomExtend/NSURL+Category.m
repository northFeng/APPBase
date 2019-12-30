//
//  NSURL+Category.m
//  APPBase
//
//  Created by 峰 on 2019/12/25.
//  Copyright © 2019 ishansong. All rights reserved.
//

#import "NSURL+Category.h"


@implementation NSURL (Category)

+ (NSURL *)gf_URLWithString:(NSString *)url {
    
    url = url.length ? url : @"";
    
    return [NSURL URLWithString:url];
}


@end
