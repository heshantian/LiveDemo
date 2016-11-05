//
//  BaseTabbarViewController.m
//  仿映客直播
//
//  Created by xxxxx on 16/11/5.
//  Copyright © 2016年 hst. All rights reserved.
//

#import "BaseTabbarViewController.h"

@interface BaseTabbarViewController ()

@end

@implementation BaseTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initChildrenController];
    
}

- (void)initChildrenController
{
    
    //控制器名字
    NSArray *controllerNames    = @[@"LiveViewController",
                                    @"AnchorViewController"];
    
    //未选中
    NSArray *normalImageNames   = @[@"tab_live",@"tab_me"];
    
    //选中
    NSArray *selectedImageNames = @[@"tab_live_p",@"tab_me_p"];
    
    //self.tabBar.translucent     = NO;
    
    [controllerNames enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIViewController *controller = [[NSClassFromString(name) alloc] init];
        
        controller.tabBarItem.image = [[UIImage imageNamed:normalImageNames[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageNames[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        //tabbarItem图片居中显示
        controller.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        
        [self addChildViewController:nav];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
