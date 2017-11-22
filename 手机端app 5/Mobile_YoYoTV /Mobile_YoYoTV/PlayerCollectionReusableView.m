//
//  PlayerCollectionReusableView.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/8/10.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "PlayerCollectionReusableView.h"

@interface PlayerCollectionReusableView()

@end

@implementation PlayerCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
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
    self.videoInfoView = [[PlayVCContentView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, height)];
    _videoInfoView.delegate = self;
    _videoInfoView.genre_id = self.model.genre_id;
    _videoInfoView.selectedIndex = self.selectedIndex;
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
    self.videoInfoView.descriptionLabel.text = self.model.Description;
    _videoInfoView.delegate = self;
    
    self.headerInfoHeight = _videoInfoView.totalHeight;
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[PlayVCContentView class]]) {
            [view removeFromSuperview];
        }
    }
    [self addSubview:_videoInfoView];
}

- (void) selectedEpisode:(UIButton *)selectedBtn{
    if ([self.delegate respondsToSelector:@selector(selectedButton:)]) {
        for (UIView *subView in _videoInfoView.scrollView.subviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                ((UIButton *)subView).selected = NO;
            }
        }
        [self.delegate selectedButton:selectedBtn];
    }
}


@end
