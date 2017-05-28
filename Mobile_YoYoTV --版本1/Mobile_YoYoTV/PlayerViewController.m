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


@interface PlayerViewController ()<ZFPlayerDelegate,selectedEpisodeDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
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
@property (nonatomic) NSInteger *currentIndex;
@property (nonatomic,strong) PlayVCContentView *videoInfoView;
@property (nonatomic,strong) NSArray *storageArray;
@property (nonatomic,strong) UIView *relatedView;
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
            [self dealResponseData:vimeoRequest];
            [self setNewModel];
            [self initCollectionView];
            [SVProgressHUD dismiss];
        } andFailureBlock:^(PlayerRequest *responseData) {
            
        }];
    } andFailureBlock:^(PlayerRequest *responseData) {
        //NSLog(@"vimeo请求失败");
        [SVProgressHUD showWithStatus:@"请检查网络"];
    }];
}

- (void) dealResponseData:(PlayerRequest *)responseData {
    CGFloat height = 0.0 ;
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
    if (self.model.genre_id.integerValue == 3) {//电影
        //NSLog(@"%@",responseData.vimeo_responseDataDic);
        height = 13+22+112;
        [tempArray addObject:responseData.vimeo_responseDataDic];
        self.vimeoResponseDic = responseData.vimeo_responseDataDic;
    } else if (self.model.genre_id.integerValue == 4) {//综艺
        //NSLog(@"%@",responseData.vimeo_responseDataArray);
        [tempArray addObjectsFromArray:responseData.vimeo_responseDataArray];
        self.vimeoResponseArray = responseData.vimeo_responseDataArray;
        height = 13+22+14+22+8+66;
    } else {//电视剧或者动漫及其他
        //NSLog(@"%@",responseData.vimeo_responseDataArray);
        [tempArray addObjectsFromArray:responseData.vimeo_responseDataArray];
        self.vimeoResponseArray = responseData.vimeo_responseDataArray;
        if (responseData.vimeo_responseDataArray.count > 1) {
            height = 13+22+14+22+8+40;
        }else {
            height = 13+22+112;
        }
    }
    self.videoInfoView = [[PlayVCContentView alloc] initWithFrame:CGRectMake(0, ScreenWidth*9/16+10, ScreenWidth, height)];
    _videoInfoView.delegate = self;
    _videoInfoView.genre_id = self.model.genre_id;
    _videoInfoView.playUrlArray = tempArray;
    [_videoInfoView addContentView];
    _videoInfoView.videoNameLabel.text = self.model.name;
    _videoInfoView.totalEpisodeLabel.text = [NSString stringWithFormat:@"共%ld集",responseData.vimeo_responseDataArray.count];
    _videoInfoView.directorLabel.text = [NSString stringWithFormat:@"导演：%@",self.model.director];
    if (self.model.cast4.length > 0) {
        _videoInfoView.actorLabel.text = [NSString stringWithFormat:@"演员：%@,%@,%@,%@",self.model.cast1,self.model.cast2,self.model.cast3,self.model.cast4];
    } else if(self.model.cast3.length > 0){
        _videoInfoView.actorLabel.text = [NSString stringWithFormat:@"演员：%@,%@,%@",self.model.cast1,self.model.cast2,self.model.cast3];
    } else if(self.model.cast2.length > 0){
        _videoInfoView.actorLabel.text = [NSString stringWithFormat:@"演员：%@,%@",self.model.cast1,self.model.cast2];
    } else if(self.model.cast1.length > 0){
        _videoInfoView.actorLabel.text = [NSString stringWithFormat:@"演员：%@",self.model.cast1];
    } else {
        _videoInfoView.actorLabel.text = [NSString stringWithFormat:@"演员："];
    }
    _videoInfoView.descriptionLabel.text = self.model.Description;
    [self.view addSubview:_videoInfoView];
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
- (void)selectedEpisode:(UIButton *)btn {
    NSInteger *index = (NSInteger *)(btn.tag - 1000);
    if (index == _currentIndex) return;
    for (UIView *subView in _videoInfoView.scrollView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            ((UIButton *)subView).selected = NO;
        }
    }
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
    
    CGFloat height = ScreenWidth*9/16 + _videoInfoView.view1.frame.size.height + _videoInfoView.view2.frame.size.height + _videoInfoView.view3.frame.size.height + 20;
    self.relatedView = [[UIView alloc] initWithFrame:CGRectMake(0, height, ScreenWidth, ScreenHeight-height)];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 8)];
    bgView.backgroundColor = UIColorFromRGB(0xF3F3F3, 1.0);
    [_relatedView addSubview:bgView];
    UILabel *moreRelatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, ScreenWidth-40, 15)];
    moreRelatedLabel.text = @"更多影片推荐";
    moreRelatedLabel.font = [UIFont systemFontOfSize:16];
    moreRelatedLabel.textColor = UIColorFromRGB(0x666666, 1.0);
    moreRelatedLabel.textAlignment = NSTextAlignmentLeft;
    [_relatedView addSubview:moreRelatedLabel];
    
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 45, ScreenWidth, _relatedView.frame.size.height-60) collectionViewLayout:layout];
    [collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [_relatedView addSubview:collectionView];
    [self.view addSubview:_relatedView];
}

#pragma mark UIColltionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.storageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];
    cell.model = self.storageArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeModel *model = self.storageArray[indexPath.row];
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
