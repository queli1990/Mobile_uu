//
//  HomeScrollViewController.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/17.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "HomeScrollViewController.h"
#import "ZJScrollPageView.h"
#import "HomeViewController.h"
#import "SearchViewController.h"
#import "HomeRequest.h"
#import "TYTabPagerBar.h"
#import "TYPagerController.h"
#import "ChannelsView.h"
#import "UIButton+BottomLineButton.h"

@interface HomeScrollViewController () <TYTabPagerBarDataSource,TYTabPagerBarDelegate,TYPagerControllerDataSource,TYPagerControllerDelegate,didShowNavDelegate,selectNavIndexDelegate>
@property(strong, nonatomic)NSArray<NSString *> *titles;
@property(strong, nonatomic)NSArray *genreModels;
@property (strong, nonatomic) ZJScrollPageView *scrollPageView;

@property (nonatomic, strong) TYTabPagerBar *tabBar;
@property (nonatomic, strong) HomeViewController *pagerController;
@property (nonatomic,strong) UIView *animatedView;
@property (nonatomic,strong) UIView *underNavScrollView;
@property (nonatomic) BOOL isNavHidden;
@property (nonatomic,strong) UIView *allChannelsView;
@property (nonatomic,strong) ChannelsView *channelsView;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) NSInteger lastIndex;
@end

@implementation HomeScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    [self liveness];
}

- (void) liveness {
    NSString *url = @"http://pv.sohu.com/cityjson?ie=utf-8";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSRange range = [str rangeOfString:@"=" options:NSRegularExpressionSearch];
        NSString *xx = [str substringFromIndex:range.location+1];
        NSString *xxx = [xx substringToIndex:xx.length-1];
        NSData *data = [xxx dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSString *IP = dic[@"cip"];
        NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
        NSString *platform = @"mobile-ios";
        NSString *UUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        //获取当前时间
        NSDate *now = [NSDate date];
        //创建日期格式
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; //设定时间的格式
        NSString *visitingTime = [dateFormatter stringFromDate:now];
        NSDictionary *params = @{@"deviceId" : UUID, @"version":version, @"platform":platform, @"ip":IP, @"visitingTime":visitingTime};
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];;
        
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];//请求格式
        
        [manager POST:@"http://api.100uu.tv/app/member/doActiveMembers.do" parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if ([dic[@"status"]  isEqual: @"2"]) {
                NSLog(@"发送活跃用户成功");
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"发送用户活跃数据失败----%@",error);
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求IP失败----%@",error);
    }];
}

- (void) requestData {
    [SVProgressHUD showWithStatus:@"loading"];
    [[[HomeRequest alloc] init] requestData:nil andBlock:^(HomeRequest *responseData) {
        self.genreModels = [[NSArray alloc] initWithArray:responseData.genresArray];
        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i<_genreModels.count; i++) {
            GenresModel *model = _genreModels[i];
            [tempArray addObject:model.name];
        }
        self.titles = (NSArray *)tempArray;
        [self setupView];
        [SVProgressHUD dismiss];
    } andFailureBlock:^(HomeRequest *responseData) {
        [SVProgressHUD showWithStatus:@"请检查网络"];
    }];
}

- (void) setupView {
    [[[CAGradientLayer alloc] init] addLayerWithY:20+50 andHeight:70 withAddedView:self.view];
    
    TYTabPagerBar *tabBar = [[TYTabPagerBar alloc]init];
    tabBar.layout.barStyle = TYPagerBarStyleProgressElasticView;
    tabBar.dataSource = self;
    tabBar.delegate = self;
    [tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    
    self.underNavScrollView = [[UIView alloc] init];
    //增加右边的按钮
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(ScreenWidth-50, 0, 50, 44);
    button1.backgroundColor = [UIColor greenColor];
    [button1 setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(showAllChannel:) forControlEvents:UIControlEventTouchUpInside];
    [_underNavScrollView addSubview:button1];
    [_underNavScrollView addSubview:tabBar];
    [self.view addSubview:_underNavScrollView];
    _tabBar = tabBar;
    
    HomeViewController *pagerController = [[HomeViewController alloc]init];
    pagerController.layout.prefetchItemCount = 0;
    //pagerController.layout.autoMemoryCache = NO;
    // 只有当scroll滚动动画停止时才加载pagerview，用于优化滚动时性能
    pagerController.layout.addVisibleItemOnlyWhenScrollAnimatedEnd = YES;
    pagerController.dataSource = self;
    pagerController.delegate = self;
    [self addChildViewController:pagerController];
    [self.view addSubview:pagerController.view];
    _pagerController = pagerController;
    [self reloadData];
    
    [self setupNav];
}


- (void) setupNav {
    [[[CAGradientLayer alloc] init] addLayerWithY:0 andHeight:70 withAddedView:self.view];
    
    self.animatedView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 50)];
    UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    leftImg.backgroundColor = [UIColor blackColor];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(ScreenWidth-15-20-15-20, (50-20)/2, 20, 20);
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    
    UIButton *historyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    historyBtn.frame = CGRectMake(ScreenWidth-15-20, (50-20)/2, 20, 20);
    [historyBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    
    [_animatedView addSubview:leftImg];
    [_animatedView addSubview:searchBtn];
    [_animatedView addSubview:historyBtn];
    [self.view addSubview:_animatedView];
}

- (void) showAllChannel:(UIButton *)btn {
    if (_channelsView == nil) {
        self.channelsView = [[[ChannelsView alloc] init] addChannelsWithTitles:self.titles withIndex:_currentIndex];
        _channelsView.delegate = self;
        _channelsView.frame = CGRectMake(0, _underNavScrollView.frame.origin.y, ScreenWidth, _channelsView.frame.size.height);
        
        UIButton *hiddenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        hiddenBtn.frame = CGRectMake(ScreenWidth-50, 0, 50, 44);
        hiddenBtn.backgroundColor = [UIColor greenColor];
        [hiddenBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
        [hiddenBtn addTarget:self action:@selector(hideNav) forControlEvents:UIControlEventTouchUpInside];
        [_channelsView addSubview:hiddenBtn];
        
        UIView *shadowView = _channelsView.subviews[1];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideNav)];
        [shadowView addGestureRecognizer:tap];
    }
    //获取所有的button，然后对当前的button添加下划线
    UIButton *lastBtn = [_channelsView.subviews[0] subviews][_lastIndex];
    lastBtn.line.hidden = YES;
    UIButton *selectedBtn = [_channelsView.subviews[0] subviews][_currentIndex];
    selectedBtn.line.hidden = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view addSubview:_channelsView];
    } completion:^(BOOL finished) {
        
    }];
}

- (void) selectedIndex:(NSInteger)index {
//    [_tabBar scrollToItemFromIndex:2 toIndex:5 animate:YES];
    [UIView animateWithDuration:0.25 animations:^{
        [_channelsView removeFromSuperview];
    } completion:^(BOOL finished) {
        [_pagerController scrollToControllerAtIndex:index-1000 animate:YES];
    }];
}

- (void) hideNav {
    [UIView animateWithDuration:0.25 animations:^{
        [_channelsView removeFromSuperview];
    }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _underNavScrollView.frame = CGRectMake(0, 70, ScreenWidth, 44);
    _tabBar.frame = CGRectMake(0, (44-44)/2, CGRectGetWidth(self.view.frame)-50, 44);
    _pagerController.view.frame = CGRectMake(0, CGRectGetMaxY(_underNavScrollView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)- CGRectGetMaxY(_underNavScrollView.frame));
    if (self.isNavHidden) {
        self.view.frame = CGRectMake(0, -50, ScreenWidth, 618+50);
        _animatedView.hidden = YES;
    }
}

 - (void) goSearch:(UIButton *)btn {
    SearchViewController *vc = [SearchViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TYTabPagerBarDataSource
- (NSInteger)numberOfItemsInPagerTabBar {
    return self.titles.count;
}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    cell.titleLabel.text = [self.genreModels[index] name];
    return cell;
}

#pragma mark - TYTabPagerBarDelegate
- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    NSString *title = [self.genreModels[index] name];
    return [pagerTabBar cellWidthForTitle:title];
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [_pagerController scrollToControllerAtIndex:index animate:YES];
}

#pragma mark - TYPagerControllerDataSource
- (NSInteger)numberOfControllersInPagerController {
    return self.titles.count;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    HomeViewController *vc = [[HomeViewController alloc] init];
    GenresModel *model = self.genreModels[index];
    vc.currentIndex = model.ID;
    vc.showNavDelegate = self;
    return vc;
}

- (void) didShowNav:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 0) {//向上滑动，隐藏
        if (self.view.frame.origin.y == -50) return ;
        [UIView animateWithDuration:0.25 animations:^{
            self.view.frame = CGRectMake(0, -50, ScreenWidth, 618+50);
            _animatedView.hidden = YES;
            _isNavHidden = YES;
        }];
    } else { //下滑，显示
        if (self.view.frame.origin.y == 0) return ;
        [UIView animateWithDuration:0.25 animations:^{
            self.view.frame = CGRectMake(0, 0, ScreenWidth, 618);
            _animatedView.hidden = NO;
            _isNavHidden = NO;
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark - TYPagerControllerDelegate
- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    self.currentIndex = toIndex;
    self.lastIndex = fromIndex;
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}

- (void)reloadData {
    [_tabBar reloadData];
    [_pagerController reloadData];
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}



@end
