//
//  LiveCell.h
//  仿映客直播
//
//  Created by xxxxx on 16/11/5.
//  Copyright © 2016年 hst. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LiveModel;
@interface LiveCell : UITableViewCell

/** 数据 */
@property (nonatomic, strong) LiveModel *model;

@end
