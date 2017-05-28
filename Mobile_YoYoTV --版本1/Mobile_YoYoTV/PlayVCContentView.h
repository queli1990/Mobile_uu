//
//  PlayVCContentView.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/26.
//  Copyright © 2017年 li que. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerModel.h"

@protocol selectedEpisodeDelegate <NSObject>

- (void) selectedEpisode:(UIButton *)selectedBtn;

@end

@interface PlayVCContentView : UIView

@property (nonatomic,weak) id<selectedEpisodeDelegate> delegate;

/**根据genre_id判断类型**/
@property (nonatomic,strong) NSNumber *genre_id;
/**播放的url数组**/
@property (nonatomic,strong) NSMutableArray *playUrlArray;



@property (nonatomic,strong) UIView *view1;
/**影片名称**/
@property (nonatomic,strong) UILabel *videoNameLabel;
/**收藏按钮**/
@property (nonatomic,strong) UIButton *collectionBtn;


@property (nonatomic,strong) UIView *view2;
/**共多少集**/
@property (nonatomic,strong) UILabel *totalEpisodeLabel;
@property (nonatomic,strong) UIScrollView *scrollView;


@property (nonatomic,strong) UIView *view3;
/**导演**/
@property (nonatomic,strong) UILabel *directorLabel;
/**演员**/
@property (nonatomic,strong) UILabel *actorLabel;
/**简介**/
@property (nonatomic,strong) UILabel *descriptionLabel;


/**推荐视图**/
@property (nonatomic,strong) UICollectionView *collectionView;


- (void) addContentView ;

@end
