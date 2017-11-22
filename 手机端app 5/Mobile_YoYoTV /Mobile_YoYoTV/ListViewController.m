//
//  ListViewController.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/22.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "ListViewController.h"
#import "ListRequest.h"
#import "NavView.h"
#import "HomeCollectionViewCell.h"
#import "PlayerViewController.h"
#import "Mobile_YoYoTV-Swift.h"

@interface ListViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSMutableArray *contentArray;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic) int requestPage;
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _requestPage = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupNav];
    [self initCollectionView];
    [self requestData:_requestPage];
}

- (void) requestData:(int) page {
    [SVProgressHUD showWithStatus:@"loading"];
    
    ListRequest *request = [ListRequest new];
    request.ID = self.ID;
    request.currentPage = page;
    [request requestData:nil andBlock:^(ListRequest *responseData) {
        //NSLog(@"%@success",NSStringFromClass([self class]));
        
        if (responseData.responseData.count > 0) {
            [self.contentArray addObjectsFromArray:responseData.responseData];
            [self.collectionView reloadData];
            [self.collectionView.mj_footer endRefreshing];
            [self.collectionView.mj_header endRefreshing];
            if (responseData.totalCount == self.contentArray.count ) {
                self.collectionView.mj_footer.hidden = YES;
            } else {
                self.collectionView.mj_footer.hidden = NO;
            }
        } else {
            NoResultView *noResultView = [[NoResultView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
            [self.view addSubview:noResultView];
        }
        [SVProgressHUD dismiss];
    } andFailureBlock:^(ListRequest *responseData) {
        //NSLog(@"%@fail",NSStringFromClass([self class]));
        [SVProgressHUD showWithStatus:@"请检查网络"];
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_header endRefreshing];
    }];
}

- (void) initCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat padding = 5;
    CGFloat itemWidth = (ScreenWidth-4*padding)/3.0;
    CGFloat itemHeight = itemWidth * (152.0/107.0);
    layout.itemSize    = CGSizeMake(itemWidth, itemHeight); // 设置cell的宽高
    layout.minimumLineSpacing = 5.0;
    layout.minimumInteritemSpacing = 5.0;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64) collectionViewLayout:layout];
    [_collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    //下拉刷新
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.contentArray removeAllObjects];
        _requestPage = 1;
        [self requestData:_requestPage];
    }];
    //加载更多
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _requestPage += 1;
        [self requestData:_requestPage];
    }];
    
    [self.view addSubview:_collectionView];
}

#pragma mark UIColltionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.contentArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeModel *model = self.contentArray[indexPath.row];
    BOOL isPay = ([[[NSUserDefaults standardUserDefaults] objectForKey:@"com.uu.VIP199"] boolValue] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"com.uu.VIP199"] boolValue] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"com.uu.VIP199"] boolValue]);
    if (!isPay && model.pay) {
        PurchaseViewController *vc = [PurchaseViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        PlayerViewController *vc = [[PlayerViewController alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];
    cell.model = self.contentArray[indexPath.row];
    return cell;
}

- (void) setupNav {
    NavView *nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    nav.titleLabel.text = self.titleName;
    [nav.backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:nav];
}

- (void) backBtnClick:(UIButton *)btn {
//    [self.navigationController popViewControllerAnimated:YES];
    [[PushHelper new] popController:self WithNavigationController:self.navigationController andSetTabBarHidden:NO];
}

- (NSMutableArray *)contentArray {
    if (_contentArray == nil) {
        _contentArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _contentArray;
}






@end
