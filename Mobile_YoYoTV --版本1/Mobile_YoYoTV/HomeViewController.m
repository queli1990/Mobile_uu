//
//  HomeViewController.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/3.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "HomeViewController.h"

#import "HomeHeadCollectionReusableView.h"
#import "HomeHead_title_CollectionReusableView.h"
#import "HomeFootCollectionReusableView.h"
#import "HomeCollectionViewCell.h"
#import "ListViewController.h"
#import "HomeRequest.h"
#import "PlayerViewController.h"
#import "StorageHelper.h"
#import "Mobile_YoYoTV-Swift.h"


@interface HomeViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HomeCirculationScrollViewDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) NSArray *headArray;
@property (nonatomic,strong) NSMutableArray *contentArray;
@property (nonatomic,strong) NSMutableArray *titleArray;
@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation HomeViewController

/*
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewWillAppear");
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)subView;
            if (scrollView.contentOffset.y > 210) {
                [self.scrollPageView setupContentFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
                [self.scrollPageView setUpSegmentFrame:CGRectMake(0, 20, ScreenWidth, 44)];
                self.scrollPageView.segmentView.scrollView.zj_height = 44;
                NSArray *titleLabels = self.scrollPageView.segmentView.titleViews;
                for (ZJTitleView *titleView in titleLabels) {
                    titleView.frame = CGRectMake(titleView.frame.origin.x, 0, titleView.frame.size.width, 44);
                }
                _collectionView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
            } else {
                [self.scrollPageView setupContentFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                _collectionView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            }
        }
    }
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SearchHistory"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self requestDataWithDictionary:nil];
}

- (void) requestDataWithDictionary:(NSDictionary *)dic {
    [SVProgressHUD showWithStatus:@"loading"];
    HomeRequest *requet = [[HomeRequest alloc] init];
    requet.currentIndex = self.currentIndex;
    [requet requestData:dic andBlock:^(HomeRequest *responseData) {
        self.headArray = responseData.responseHeadArray;
        self.contentArray = responseData.responseDataArray;
        self.titleArray = responseData.titleArray;
        [self addStorageHelper];
        if (self.contentArray.count > 0) {
            [self initCollectionView];
        } else {
            NoResultView *noResultView = [[NoResultView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
            [self.view addSubview:noResultView];
        }
        [SVProgressHUD dismiss];
    } andFailureBlock:^(HomeRequest *responseData) {
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
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-38) collectionViewLayout:layout];
    [_collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
    [_collectionView registerClass:[HomeHeadCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeHeadCollectionReusableView"];
    [_collectionView registerClass:[HomeHead_title_CollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeHead_title_CollectionReusableView"];
    [_collectionView registerClass:[HomeFootCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HomeFootCollectionReusableView"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
}

#pragma mark - collectionView代理方法
//多少个分区
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.contentArray.count;
}

//每个分区有多少cell
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([_contentArray[section] count] > 6) {
        return 6;
    } else {
        return [_contentArray[section] count];
    }
}

//每个cell是什么
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeModel *model = _contentArray[indexPath.section][indexPath.row];
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];
    cell.model = model;
    if (!model.pay) {
        cell.vipImgView.hidden = YES;
    }
    return cell;
}

//头尾视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            HomeHeadCollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeHeadCollectionReusableView" forIndexPath:indexPath];
            [headView detailArray:self.headArray];
            headView.delegate = self;
            headView.titleLabel.text = _titleArray[indexPath.section][@"name"];
            UIFont *font = [UIFont fontWithName:@"Arial" size:18.0];
            headView.titleLabel.font = font;
            CGSize labelSize = [headView.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
            headView.titleLabel.frame = CGRectMake(10, 5+5, labelSize.width, 20);
            headView.moreLabel.frame = CGRectMake(ScreenWidth-15-8-5-40, 5+5, 40, 20);
            headView.categoryBtn.tag = indexPath.section;
            [headView.categoryBtn addTarget:self action:@selector(pushCategoryVC:) forControlEvents:UIControlEventTouchUpInside];
            return headView;
        }
        HomeHead_title_CollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeHead_title_CollectionReusableView" forIndexPath:indexPath];
        headView.titleLabel.text = _titleArray[indexPath.section][@"name"];
        UIFont *font = [UIFont fontWithName:@"Arial" size:18.0];
        headView.titleLabel.font = font;
        CGSize labelSize = [headView.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
        headView.titleLabel.frame = CGRectMake(10, 5+5, labelSize.width, 20);
        headView.moreLabel.frame = CGRectMake(ScreenWidth-15-8-5-40, 5+5, 40, 20);
        headView.categoryBtn.tag = indexPath.section;
        [headView.categoryBtn addTarget:self action:@selector(pushCategoryVC:) forControlEvents:UIControlEventTouchUpInside];
        return headView;
    }else {
        HomeFootCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HomeFootCollectionReusableView" forIndexPath:indexPath];
        return footerView;
    }
}

- (void) pushCategoryVC:(UIButton *)btn {
    NSNumber *currentID = _titleArray[btn.tag][@"id"];
    NSNumber *currentGenreID = _titleArray[btn.tag][@"genre_id"];
    NSLog(@"点中的分类的id------%@---geneid:%@",currentID,currentGenreID);
    ListViewController *vc = [[ListViewController alloc] init];
    vc.ID = currentID;
    vc.titleName = [btn.subviews[0] text];
    [self.navigationController pushViewController:vc animated:YES];
}

//collectionView头视图的高度
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(0, ScreenWidth*210/375+30+5);
    } else {
        return CGSizeMake(0, 35);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    HomeModel *model = _contentArray[indexPath.section][indexPath.row];
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
    
    //PolicyViewController *vc = [PolicyViewController new];
    //[self.navigationController pushViewController:vc animated:YES];
}

//滚动视图的代理方法
- (void) didSecectedHomeCirculationScrollViewAnIndex:(NSInteger)currentpage{
    id isPayKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"com.uu.VIP"];
    BOOL isPay = [isPayKey boolValue];
    HomeModel *model = _headArray[currentpage];
    if (!isPay && model.pay) {
        PlayerViewController *vc = [[PlayerViewController alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        PurchaseViewController *vc = [PurchaseViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void) addStorageHelper {
    StorageHelper *sharedInstance = [StorageHelper sharedSingleClass];
    sharedInstance.storageArray = self.headArray;
}

//scrollview代理方法，判断是否滑动到一定距离
/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 210) {
        [self.scrollPageView setupContentFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
        [self.scrollPageView setUpSegmentFrame:CGRectMake(0, 20, ScreenWidth, 44)];
        self.scrollPageView.segmentView.scrollView.zj_height = 44;
        NSArray *titleLabels = self.scrollPageView.segmentView.titleViews;
        for (ZJTitleView *titleView in titleLabels) {
            titleView.frame = CGRectMake(titleView.frame.origin.x, 0, titleView.frame.size.width, 44);
        }
        _collectionView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
    } else {
        [self.scrollPageView setupContentFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _collectionView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }
}
*/


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
