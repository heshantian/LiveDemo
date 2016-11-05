//
//  LiveCell.m
//  仿映客直播
//
//  Created by xxxxx on 16/11/5.
//  Copyright © 2016年 hst. All rights reserved.
//

#import "LiveCell.h"
#import "LiveModel.h"
#import "Masonry.h"
#import "YYWebImage.h"

@interface LiveCell ()

/** 大图 */
@property (nonatomic, weak) UIImageView *bigImageView;

/** 头像 */
@property (nonatomic, weak) UIImageView *headImageView;

/** 名字 */
@property (nonatomic, weak) UILabel *anchorNameLabel;

/** 人数 */
@property (nonatomic, weak) UILabel *allnumLabel;

/** "在看" */
@property (nonatomic, weak) UILabel *watchingLabel;

@end

@implementation LiveCell
#pragma mark - 懒加载
// 大图
- (UIImageView *)bigImageView
{
    if (!_bigImageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        //imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imageView];
        _bigImageView = imageView;
    }
    return _bigImageView;
}

// 头像
- (UIImageView *)headImageView
{
    if (!_headImageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        _headImageView = imageView;
    }
    return _headImageView;
}

// 主播名字
- (UILabel *)anchorNameLabel
{
    if (!_anchorNameLabel) {
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        _anchorNameLabel = label;
    }
    return _anchorNameLabel;
}

// 观看人数
- (UILabel *)allnumLabel
{
    if (!_allnumLabel) {
        UILabel *label = [[UILabel alloc] init];
        // 属性设置
        label.textColor = [UIColor orangeColor];
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:label];
        _allnumLabel = label;
    }
    return _allnumLabel;
}

// 在看
- (UILabel *)watchingLabel
{
    if (!_watchingLabel) {
        UILabel *label = [[UILabel alloc] init];
        // 属性设置
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentRight;
        [self addSubview:label];
        _watchingLabel = label;
    }
    return _watchingLabel;
}

#pragma mark - 赋值
- (void)setModel:(LiveModel *)model
{
    [self.bigImageView yy_setImageWithURL:[NSURL URLWithString:model.bigpic] placeholder:[UIImage imageNamed:@"live_empty_bg"]];
    
    [self.headImageView yy_setImageWithURL:[NSURL URLWithString:model.smallpic] placeholder:[UIImage imageNamed:@"default_head"]];
    
    self.anchorNameLabel.text = model.myname;
    
    self.allnumLabel.text = [NSString stringWithFormat:@"%ld",model.allnum];
    
    self.watchingLabel.text = @"在看";
}

- (void)layoutSubviews
{
    // 头像
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(50);
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(10);
    }];
    
    // 人数
    [self.allnumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(10);
    }];
    
    // 在看
    [self.watchingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.allnumLabel.mas_bottom).offset(8);
        make.right.equalTo(self.allnumLabel);
        make.width.mas_equalTo(50);
    }];
    
    // 主播名字
    [self.anchorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(10);
        make.top.equalTo(self.headImageView);
        make.right.equalTo(self.allnumLabel.mas_left);
    }];
    
    // 大图
    [self.bigImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self.headImageView.mas_bottom).offset(15);
    }];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
