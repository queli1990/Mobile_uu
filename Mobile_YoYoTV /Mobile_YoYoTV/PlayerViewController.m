//
//  PlayerViewController.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/3.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "PlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Masonry/Masonry.h>
#import "ZFPlayer.h"
#import "PlayerRequest.h"
#import "PlayVCContentView.h"
#import "StorageHelper.h"
#import "HomeCollectionViewCell.h"
#import "PlayerCollectionReusableView.h"
#import "HomeFootCollectionReusableView.h"
#import "Mobile_YoYoTV-Swift.h"


@interface PlayerViewController ()<ZFPlayerDelegate,selectedIndexDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
/** 播放器View的父视图*/
@property (strong, nonatomic) UIView *playerFatherView;
@property (strong, nonatomic) ZFPlayerView *playerView;
/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) ZFPlayerModel *playerModel;
@property (nonatomic, strong) UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (nonatomic,strong) NSArray *vimeoResponseArray;
@property (nonatomic,strong) NSDictionary *vimeoResponseDic;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic,strong) PlayVCContentView *videoInfoView;
@property (nonatomic,strong) NSArray *storageArray;
@property (nonatomic,strong) UIView *relatedView;
@property (nonatomic,strong) UICollectionView *collectionView;
/*用来做中间变量，给collectionView的headerView中影片信息部分传值*/
@property (nonatomic,strong) PlayerRequest *VimeoRequest;
@property (nonatomic) CGFloat sectionOneHeight;
@end

@implementation PlayerViewController

- (void)dealloc {
    NSLog(@"%@释放了",self.class);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // pop回来时候是否自动播放
    if (self.navigationController.viewControllers.count == 2 && self.playerView && self.isPlaying) {
        self.isPlaying = NO;
    }
}

- (void) requestData {
    [SVProgressHUD showWithStatus:@"loading"];
    PlayerRequest *request = [PlayerRequest new];
    request.genre_id = self.model.genre_id;
    request.ID = self.model.ID;
    request.vimeo_id = self.model.vimeo_id;
    request.vimeo_token = self.model.vimeo_token;
    request.regexName = self.model.name;
    [request requestVimeoPlayurl:^(PlayerRequest *responseData) {
        PlayerRequest *vimeoRequest = responseData;
        
        PlayerRequest *relatedRequest = [[PlayerRequest alloc] init];
        relatedRequest.ID = self.model.ID;
        [relatedRequest requestRelatedData:nil andBlock:^(PlayerRequest *responseData) {
            if (responseData.responseData.count > 0) {
                self.storageArray = responseData.responseData;
            }
            
            self.VimeoRequest = vimeoRequest;
            PlayerCollectionReusableView *headView = [PlayerCollectionReusableView new];
            headView.model = self.model;
            headView.selectedIndex = _currentIndex;
            [headView dealResponseData:self.VimeoRequest];
            self.sectionOneHeight = headView.headerInfoHeight;
            self.vimeoResponseDic = headView.vimeoResponseDic;
            self.vimeoResponseArray = headView.vimeoResponseArray;
            
            BOOL isHaveInitCollectionView = false;
            for ( UIView *view in self.view.subviews ) {
                NSString *className = NSStringFromClass([view class]);
                if ([className isEqualToString:@"UICollectionView"]) {
                    isHaveInitCollectionView = true;
                    break;
                }
            }
            isHaveInitCollectionView ? [_collectionView reloadData] : [self initCollectionView];
        
            [self setNewModel];
            [SVProgressHUD dismiss];
        } andFailureBlock:^(PlayerRequest *responseData) {
            
        }];
    } andFailureBlock:^(PlayerRequest *responseData) {
        [SVProgressHUD showWithStatus:@"请检查网络"];
    }];
}

/**设置播放的model**/
/**当前只考虑默认进入页面，即index=0时，如果user选集的话另做考虑**/
- (void) setNewModel {
    if (self.vimeoResponseDic) {
        //将当前剧集的所有url从大到小排列
        NSMutableArray *arr = [self dealUrlWidthWithFiles:self.vimeoResponseDic[@"files"] andDownload:self.vimeoResponseDic[@"download"]];
        self.playerModel.title            = _vimeoResponseDic[@"name"];
        self.playerModel.videoURL         = [NSURL URLWithString:arr.lastObject[@"link"]];
        [self.playerView resetToPlayNewVideo:self.playerModel];
    }
    if (self.vimeoResponseArray) {
        NSDictionary *currendDic = self.vimeoResponseArray[(int)_currentIndex];
        //将当前剧集的所有url从大到小排列
        NSMutableArray *arr = [self dealUrlWidthWithFiles:currendDic[@"files"] andDownload:currendDic[@"download"]];
        self.playerModel.title            = currendDic[@"name"];
        self.playerModel.videoURL         = [NSURL URLWithString:[arr lastObject][@"link"]];
        [self.playerView resetToPlayNewVideo:self.playerModel];
    }
}

- (NSMutableArray *) dealUrlWidthWithFiles:(NSArray *)filesArray andDownload:(NSArray *)downloadsArray {
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i<filesArray.count; i++) {
        PlayerModel *model = filesArray[i];
        [tempArray addObject:model];
    }
    for (int i = 0; i<downloadsArray.count; i++) {
        PlayerModel *model = downloadsArray[i];
        [tempArray addObject:model];
    }
    [tempArray sortUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2)
    {
        //此处的规则含义为：若前一元素比后一元素小，则返回降序（即后一元素在前，为从大到小排列）
        if ([obj1[@"size"] integerValue] < [obj2[@"size"] integerValue]){
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    return tempArray;
}

/**当点中某一集的时候的代理方法**/
- (void)selectedButton:(UIButton *)btn {
    NSInteger index = btn.tag - 1000;
    if (index == _currentIndex) return;
    btn.selected = YES;
    _currentIndex = index;
    [self setNewModel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.currentIndex = 0;
    [self requestData];
    [self setupPlayer];
    
    StorageHelper *instance = [StorageHelper sharedSingleClass];
    self.storageArray = instance.storageArray;
}

- (void) setupPlayer {
    self.playerFatherView = [[UIView alloc] init];
    [self.view addSubview:self.playerFatherView];
    [self.playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.leading.trailing.mas_equalTo(0);
        // 这里宽高比16：9,可自定义宽高比
        make.height.mas_equalTo(self.playerFatherView.mas_width).multipliedBy(9.0f/16.0f);
    }];
    // 自动播放，默认不自动播放
    //[self.playerView autoPlayTheVideo];
}

// 返回值要必须为NO
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    // 这里设置横竖屏不同颜色的statusbar
    // if (ZFPlayerShared.isLandscape) {
    //    return UIStatusBarStyleDefault;
    // }
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
//    return ZFPlayerShared.isStatusBarHidden;
    return NO;
}

#pragma mark - ZFPlayerDelegate

- (void)zf_playerBackAction {
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)zf_playerDownload:(NSString *)url {
//    // 此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
//    NSString *name = [url lastPathComponent];
//    [[ZFDownloadManager sharedDownloadManager] downFileUrl:url filename:name fileimage:nil];
//    // 设置最多同时下载个数（默认是3）
//    [ZFDownloadManager sharedDownloadManager].maxCount = 4;
//}

- (void)zf_playerControlViewWillShow:(UIView *)controlView isFullscreen:(BOOL)fullscreen {
    //    self.backBtn.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.backBtn.alpha = 0;
    }];
}

- (void)zf_playerControlViewWillHidden:(UIView *)controlView isFullscreen:(BOOL)fullscreen {
    //    self.backBtn.hidden = fullscreen;
    [UIView animateWithDuration:0.25 animations:^{
        self.backBtn.alpha = !fullscreen;
    }];
}

#pragma mark - Getter

- (ZFPlayerModel *)playerModel {
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];
        _playerModel.title            = @"";
        _playerModel.videoURL         = [NSURL URLWithString:@""];
        _playerModel.placeholderImage = [UIImage imageNamed:@"loading_bgView1"];
        _playerModel.fatherView       = self.playerFatherView;
        //        _playerModel.resolutionDic = @{@"高清" : self.videoURL.absoluteString,
        //                                       @"标清" : self.videoURL.absoluteString};
    }
    return _playerModel;
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[ZFPlayerView alloc] init];
        
        /*****************************************************************************************
         *   // 指定控制层(可自定义)
         *   // ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
         *   // 设置控制层和播放模型
         *   // 控制层传nil，默认使用ZFPlayerControlView(如自定义可传自定义的控制层)
         *   // 等效于 [_playerView playerModel:self.playerModel];
         ******************************************************************************************/
        [_playerView playerControlView:nil playerModel:self.playerModel];
        
        // 设置代理
        _playerView.delegate = self;
        
        //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResize;
        
        // 打开下载功能（默认没有这个功能）
//        _playerView.hasDownload    = YES;
        
        // 打开预览图
        self.playerView.hasPreviewView = YES;
        
    }
    return _playerView;
}

#pragma mark - Action

- (IBAction)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)playNewVideo:(UIButton *)sender {
    self.playerModel.title            = @"这是新播放的视频";
    self.playerModel.videoURL         = [NSURL URLWithString:@"http://baobab.wdjcdn.com/1456665467509qingshu.mp4"];
    // 设置网络封面图
    self.playerModel.placeholderImageURLString = @"http://img.wdjimg.com/image/video/447f973848167ee5e44b67c8d4df9839_0_0.jpeg";
    // 从xx秒开始播放视频
    // self.playerModel.seekTime         = 15;
    [self.playerView resetToPlayNewVideo:self.playerModel];
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
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20+ScreenWidth*9/16 + 10, ScreenWidth, ScreenHeight-20-ScreenWidth*9/16 - 10) collectionViewLayout:layout];
    [_collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
    [_collectionView registerClass:[PlayerCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PlayerCollectionReusableView"];
    [_collectionView registerClass:[HomeFootCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HomeFootCollectionReusableView"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_relatedView addSubview:_collectionView];
    [self.view addSubview:_collectionView];
}

#pragma mark UIColltionViewDelegate
//有多少个分区
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//每个分区下有多少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.storageArray.count;
}

//每个cell是什么
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];
    cell.model = self.storageArray[indexPath.row];
    return cell;
}

//头视图和尾视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        PlayerCollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PlayerCollectionReusableView" forIndexPath:indexPath];
        headView.model = self.model;
        headView.selectedIndex = _currentIndex;
        [headView dealResponseData:self.VimeoRequest];
        self.sectionOneHeight = headView.headerInfoHeight;
        self.vimeoResponseDic = headView.vimeoResponseDic;
        self.vimeoResponseArray = headView.vimeoResponseArray;
        headView.delegate = self;
        return headView;
    } else {
        HomeFootCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HomeFootCollectionReusableView" forIndexPath:indexPath];
        return footerView;
    }
}

//collectionView头视图的高度
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGFloat gap = 10;
    return CGSizeMake(0, _sectionOneHeight + gap);
}

//点中cell的相应事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeModel *model = self.storageArray[indexPath.row];
    
    id isPayKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"com.uu.VIP"];
    BOOL isPay = [isPayKey boolValue];
    if (!isPay && model.pay) {
        PurchaseViewController *vc = [PurchaseViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        [_playerView pause];
        return;
    }
    
    self.model = model;
    [_relatedView removeFromSuperview];
    [_videoInfoView removeFromSuperview];
    _vimeoResponseDic = nil;
    _vimeoResponseArray = nil;
    self.currentIndex = 0;
    [self requestData];
}

- (NSArray *)storageArray {
    if (_storageArray == nil) {
        _storageArray = [NSArray array];
    }
    return _storageArray;
}



@end
