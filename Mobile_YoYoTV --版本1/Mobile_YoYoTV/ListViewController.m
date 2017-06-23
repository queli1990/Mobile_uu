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
@property (nonatomic,strong) NSArray *contentArray;
@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupNav];
    [self requestData];
}

- (void) requestData {
    [SVProgressHUD showWithStatus:@"loading"];
    ListRequest *request = [ListRequest new];
    request.ID = self.ID;
    [request requestData:nil andBlock:^(ListRequest *responseData) {
        //NSLog(@"%@success",NSStringFromClass([self class]));
        self.contentArray = responseData.responseData;
        if (_contentArray.count > 0) {
            [self initCollectionView];
        } else {
            NoResultView *noResultView = [[NoResultView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
            [self.view addSubview:noResultView];
        }
        [SVProgressHUD dismiss];
    } andFailureBlock:^(ListRequest *responseData) {
        //NSLog(@"%@fail",NSStringFromClass([self class]));
        [SVProgressHUD showWithStatus:@"请检查网络"];
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
    [self.view addSubview:_collectionView];
}

#pragma mark UIColltionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.contentArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeModel *model = self.contentArray[indexPath.row];
    id isPayKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"com.uu.VIP"];
    BOOL isPay = [isPayKey boolValue];
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
    if (!cell.model.pay) {
        cell.vipImgView.hidden = YES;
    }
    return cell;
}

- (void) setupNav {
    NavView *nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    nav.titleLabel.text = self.titleName;
    [nav.backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:nav];
}

- (void) backBtnClick:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}








@end
