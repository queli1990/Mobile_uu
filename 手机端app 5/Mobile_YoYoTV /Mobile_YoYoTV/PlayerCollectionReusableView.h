//
//  PlayerCollectionReusableView.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/8/10.
//  Copyright © 2017年 li que. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerRequest.h"
#import "HomeModel.h"
#import "PlayVCContentView.h"

@protocol selectedIndexDelegate <NSObject>

- (void) selectedButton:(UIButton *)btn;

@end

@interface PlayerCollectionReusableView : UICollectionReusableView<selectedEpisodeDelegate>

@property (nonatomic,weak) id<selectedIndexDelegate>delegate;
/*需要外部传入的*/
@property (nonatomic,strong) HomeModel *model;
/*传出去的*/
@property (nonatomic) CGFloat headerInfoHeight;
@property (nonatomic,strong) NSArray *vimeoResponseArray;
@property (nonatomic,strong) NSDictionary *vimeoResponseDic;
@property (nonatomic,strong) PlayVCContentView *videoInfoView;

/*选中的集数*/
@property (nonatomic) NSInteger selectedIndex;


- (void) dealResponseData:(PlayerRequest *)responseData;

@end
