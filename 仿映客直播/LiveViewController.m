//
//  LiveViewController.m
//  仿映客直播
//
//  Created by xxxxx on 16/11/5.
//  Copyright © 2016年 hst. All rights reserved.
//

#import "LiveViewController.h"
#import "HttpRequest.h"
#import "LiveModel.h"
#import "LiveCell.h"
#import "LivingViewController.h"
#import "MJRefresh.h"

#define LiveURL @"http://live.9158.com/Fans/GetHotLive?page=%ld"

@interface LiveViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger _pageNum;
}
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** 数据源 */
@property (nonatomic, strong) NSMutableArray *liveArray;

/** 上一行 */
@property (nonatomic, assign) NSInteger lastIndexRow;

@end

@implementation LiveViewController
#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        UITableView *tb = [[UITableView alloc] init];
        
        tb.delegate = self;
        tb.dataSource = self;
        tb.rowHeight = 370;

        NSMutableArray *images = [NSMutableArray array];
        
        for (int i = 1; i < 30; i++)
        {
            NSString *numString = [NSString stringWithFormat:@"%04d",i];
            NSString *imageName = [NSString stringWithFormat:@"refresh_fly_%@",numString];
            UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [images addObject:image];
        }
        
        // 下拉刷新
    
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            _pageNum = 1;
            [self requestData];
        }];
        [header setImages:images forState:MJRefreshStateIdle];
        [header setImages:images duration:0.9 forState:MJRefreshStatePulling];
        [header setImages:images duration:0.9 forState:MJRefreshStateRefreshing];

        tb.mj_header = header;
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        
        tb.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _pageNum++;
            [self requestData];
        }];
        
        [tb registerClass:[LiveCell class] forCellReuseIdentifier:@"liveCell"];
        
        [self.view addSubview:tb];
        _tableView = tb;
    }
    return _tableView;
}

- (NSMutableArray *)liveArray
{
    if (!_liveArray)
    {
        _liveArray = [NSMutableArray array];
    }
    return _liveArray;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pageNum = 1;
    
    self.navigationController.title = @"直播列表";
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.barTintColor = [UIColor whiteColor];
    // 1.请求数据
    [self requestData];
}

#pragma mark - 请求数据
- (void)requestData
{
    NSString *url = [NSString stringWithFormat:LiveURL,_pageNum];
    
    NSLog(@"%@",url);
    
    [HttpRequest GET:url paramaters:nil success:^(id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (_pageNum == 1)
        {
            [self.liveArray removeAllObjects];
        }
        
        // 封装数据模型
        [self handleDataModelWithDict:dict];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);

    }];
}

#pragma mark - 封装数据模型
- (void)handleDataModelWithDict:(NSDictionary *)dictionary
{
    NSArray *array = dictionary[@"data"][@"list"];
        
    for (NSDictionary *dict in array)
    {
        LiveModel *model = [LiveModel liveModelWithDict:dict];
        [self.liveArray addObject:model];
    }
    
    //刷新数据源
    [self.tableView reloadData];
}

#pragma mark - UITabelViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.liveArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"liveCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    LiveModel *model = self.liveArray[indexPath.row];
    
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LivingViewController *ctrl = [[LivingViewController alloc] init];
    
    ctrl.model = self.liveArray[indexPath.row];
    
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.lastIndexRow < indexPath.row)
    {
        NSLog(@"向下");
        CATransform3D transform = CATransform3DIdentity;
        transform = CATransform3DRotate(transform, 0, 0, 0, 1); //角度
        transform = CATransform3DScale(transform, 1.2, 1.5, 0); //放大的状态
        cell.layer.transform = transform;
        cell.layer.opacity = 0; //渐变
        
        [UIView animateWithDuration:0.3 animations:^{
            cell.layer.transform = CATransform3DIdentity;
            cell.layer.opacity = 1; //不透明
        }];
    }
    
    self.lastIndexRow = indexPath.row;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
