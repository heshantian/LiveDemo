//
//  LiveModel.h
//  仿映客直播
//
//  Created by xxxxx on 16/11/5.
//  Copyright © 2016年 hst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveModel : NSObject

/** 人数 */
@property(nonatomic, assign) NSInteger allnum;

/** 大图 */
@property(nonatomic, copy) NSString *bigpic;

/** 头像 */
@property (nonatomic, copy) NSString *smallpic;

/** 主播名字 */
@property (nonatomic, copy) NSString *myname;

/** 拉流的地址 */
@property (nonatomic, copy) NSString *flv;

+ (instancetype)liveModelWithDict:(NSDictionary *)dict;
@end
