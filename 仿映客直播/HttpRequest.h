//
//  HttpRequest.h
//  仿映客直播
//
//  Created by xxxxx on 16/11/5.
//  Copyright © 2016年 hst. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HttpRequestDidRequestSuccessCallback)(id responseObject);

typedef void(^HttpRequestDidRequestFailureCallback)(NSError *error);

@interface HttpRequest : NSObject

+ (void)GET:(NSString *)urlString paramaters:(NSDictionary *)paramaters success:(HttpRequestDidRequestSuccessCallback)success failure:(HttpRequestDidRequestFailureCallback)failure;

@end
