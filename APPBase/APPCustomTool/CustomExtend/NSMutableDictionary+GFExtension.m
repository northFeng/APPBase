//
//  NSMutableDictionary+GFExtension.m
//  GFAPP
//
//  Created by gaoyafeng on 2018/9/15.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "NSMutableDictionary+GFExtension.h"

@implementation NSMutableDictionary (GFExtension)

- (BOOL)gf_setObject:(id)itemObject withKey:(NSString *)key {
    
    if (![itemObject isKindOfClass:[NSNull class]] && itemObject != nil && key.length > 0) {
        
        [self setObject:itemObject forKey:key];
        
        return YES;
    }else{
        
        return NO;
    }
}

@end


@implementation NSDictionary (GFExtension)


- (id)gf_objectForKey:(NSString *)key {

    id object = nil;
    if (([self isKindOfClass:[NSDictionary class]] || [self isKindOfClass:[NSMutableDictionary class]]) && key.length > 0) {
        object = [self objectForKey:key];
    }
    
    return object;
}


@end
