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
#import "LoginViewController.h"

@interface HomeScrollViewController () <ZJScrollPageViewDelegate,isLeftViewDelegate>
@property(strong, nonatomic)NSArray<NSString *> *titles;
@property(strong, nonatomic)NSArray *genreModels;
@property (strong, nonatomic) ZJScrollPageView *scrollPageView;
@end

@implementation HomeScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];
}

- (void) setupView {
    self.title = @"效果示例";
    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    // 缩放标题
    style.scaleTitle = YES;
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    style.segmentViewBounces = NO;
    style.segmentHeight = 38;
    style.normalTitleColor = UIColorFromRGB(0xFFFFFF, 1.0);
    style.selectedTitleColor = UIColorFromRGB(0xFFFFFF, 1.0);
    // 设置附加按钮的背景图片
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = CGRectMake(0, 0, ScreenWidth, 20+38);
    //颜色分配:四个一组代表一种颜色(r,g,b,a)
    layer.colors = @[(__bridge id) [UIColor colorWithRed:247/255.0 green:136/255.0 blue:26/255.0 alpha:1.0].CGColor,
                     (__bridge id) [UIColor colorWithRed:247/255.0 green:175/255.0 blue:36/255.0 alpha:1.0].CGColor];
    //起始点
    layer.startPoint = CGPointMake(0.15, 0.5);
    //结束点
    layer.endPoint = CGPointMake(0.85, 0.5);
    [self.view.layer addSublayer:layer];
    
    // 初始化
    self.scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    _scrollPageView.backgroundColor = [UIColor clearColor];
    _scrollPageView.segmentView.backgroundColor = [UIColor clearColor];
    [_scrollPageView setUpSegmentFrame:CGRectMake(15+20, 0, ScreenWidth-15-40-15, 38)];
    
    UIButton *personalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    personalBtn.frame = CGRectMake(15, 20+(38-20)/2, 20, 20);
    [personalBtn setImage:[UIImage imageNamed:@"Personal"] forState:UIControlStateNormal];
    [personalBtn addTarget:self action:@selector(goSettingPage:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(ScreenWidth-15-20, 20+(38-20)/2, 20, 20);
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(goSearch:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //    _scrollPageView.contentView.leftScrollDelegate = self;//当滑动到index=0时，再向左侧滑动，滑出left菜单
    // 这里可以设置头部视图的属性(背景色, 圆角, 背景图片...)
    //    scrollPageView.segmentView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_scrollPageView];
    [self.view addSubview:personalBtn];
    [self.view addSubview:searchBtn];
}

- (void) goSettingPage:(UIButton *)btn {
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]) {
//        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
//    }else {
        [self showLeftViewController];
//    }
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

- (void) goSearch:(UIButton *)btn {
    SearchViewController *vc = [SearchViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) isContentViewScrollToLeftView {
    [self showLeftViewController];
}

#pragma ZJScrollPageViewDelegate 代理方法
- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    
    HomeViewController<ZJScrollPageViewChildVcDelegate> *childVc = (HomeViewController *)reuseViewController;
    
    if (!childVc) {
        childVc = [[HomeViewController alloc] init];
        GenresModel *model = self.genreModels[index];
        childVc.currentIndex = model.ID;
        childVc.scrollPageView = self.scrollPageView;
        childVc.title = self.titles[index];
    }
    return childVc;
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllWillAppear:(UIViewController *)childViewController forIndex:(NSInteger)index {
//    NSLog(@"%ld ---将要出现",index);
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidAppear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllWillDisappear:(UIViewController *)childViewController forIndex:(NSInteger)index {
//    NSLog(@"%ld ---将要消失",index);
}


- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidDisappear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    
}



@end
