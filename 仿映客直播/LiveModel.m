//
//  LiveModel.m
//  仿映客直播
//
//  Created by xxxxx on 16/11/5.
//  Copyright © 2016年 hst. All rights reserved.
//

#import "LiveModel.h"

@implementation LiveModel

+ (instancetype)liveModelWithDict:(NSDictionary *)dict
{
    LiveModel *model = [[LiveModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

@end
