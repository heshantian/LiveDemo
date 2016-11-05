//
//  HttpRequest.m
//  仿映客直播
//
//  Created by xxxxx on 16/11/5.
//  Copyright © 2016年 hst. All rights reserved.
//

#import "HttpRequest.h"
#import "AFNetworking.h"

@implementation HttpRequest

+ (void)GET:(NSString *)urlString paramaters:(NSDictionary *)paramaters success:(HttpRequestDidRequestSuccessCallback)success failure:(HttpRequestDidRequestFailureCallback)failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success)
        {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure)
        {
            failure(error);
        }
    }];
}

@end
