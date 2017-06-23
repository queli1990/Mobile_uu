//
//  PlayVCContentView.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/26.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "PlayVCContentView.h"

@implementation PlayVCContentView


- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void) addContentView {
    CGFloat gap1 = 13;
    self.view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, gap1+22)];
    
    self.videoNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, gap1, 180, 22)];
    self.videoNameLabel = [self dealLabel:_videoNameLabel Font:[UIFont systemFontOfSize:16] color:UIColorFromRGB(0x4A4A4A, 1.0) textAlignment:NSTextAlignmentLeft];
    
    self.collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectionBtn.frame = CGRectMake(ScreenWidth-15-20, gap1, 20, 20);
    [_collectionBtn setImage:[UIImage imageNamed:@"userCollection"] forState:UIControlStateNormal];
    
    [_view1 addSubview:_videoNameLabel];
    //[_view1 addSubview:_collectionBtn];
    [self isHaveScrollView];
}

//添加view2
- (void) isHaveScrollView {
    CGFloat height;
    if (self.genre_id.integerValue == 3 || self.playUrlArray.count == 1) {//电影
        height = 25;
    }else if(self.genre_id.integerValue == 4){//综艺
        CGFloat gap2 = 14;
        self.view2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_view1.frame), ScreenWidth, gap2+22+8+66)];
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, gap2, 80, 22)];
        label1 = [self dealLabel:label1 Font:[UIFont systemFontOfSize:13] color:UIColorFromRGB(0x4A4A4A, 1.0) textAlignment:NSTextAlignmentLeft];
        label1.text = @"选集";
        
        self.totalEpisodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-15-180, label1.frame.origin.y, 180, 22)];
        _totalEpisodeLabel = [self dealLabel:_totalEpisodeLabel Font:[UIFont systemFontOfSize:13] color:UIColorFromRGB(0x000000, 1.0) textAlignment:NSTextAlignmentRight];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_totalEpisodeLabel.frame)+8, ScreenWidth, 66)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        CGFloat itemwidth = 166;
        CGFloat itemheight = 66;
        for (int i = 0; i<self.playUrlArray.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(15+(15+itemwidth)*i, 0, itemwidth, itemheight);
            [btn setTitle:_playUrlArray[i][@"name"] forState:UIControlStateNormal];
            [btn setTitleColor:UIColorFromRGB(0x666666, 1.0) forState:UIControlStateNormal];
            [btn setTitleColor:UIColorFromRGB(0xFF7F00, 1.0) forState:UIControlStateSelected];
            btn.backgroundColor = UIColorFromRGB(0xF0F0F0, 1.0);
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            btn.titleLabel.numberOfLines = 0;
            [btn addTarget:self action:@selector(selectedClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 1000 + i;
            if (i == 0) {
                btn.selected = YES;
            }
            [_scrollView addSubview:btn];
        }
        _scrollView.contentSize = CGSizeMake(15+_playUrlArray.count*(15+itemwidth), 66);
        [_view2 addSubview:label1];
        [_view2 addSubview:self.totalEpisodeLabel];
        [_view2 addSubview:_scrollView];
        height = 25+gap2+22+8+66;
    }else {//电视剧
        CGFloat gap2 = 14;
        self.view2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_view1.frame), ScreenWidth, gap2+22+8+40)];
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, gap2, 80, 22)];
        label1 = [self dealLabel:label1 Font:[UIFont systemFontOfSize:13] color:UIColorFromRGB(0x4A4A4A, 1.0) textAlignment:NSTextAlignmentLeft];
        label1.text = @"选集";
        
        self.totalEpisodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-15-180, label1.frame.origin.y, 180, 22)];
        _totalEpisodeLabel = [self dealLabel:_totalEpisodeLabel Font:[UIFont systemFontOfSize:13] color:UIColorFromRGB(0x000000, 1.0) textAlignment:NSTextAlignmentRight];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_totalEpisodeLabel.frame)+8, ScreenWidth, 40)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        CGFloat itemwidth = 40;
        CGFloat itemheight = 40;
        for (int i = 0; i<self.playUrlArray.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(15+(15+itemwidth)*i, 0, itemwidth, itemheight);
            [btn setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
            [btn setTitleColor:UIColorFromRGB(0x666666, 1.0) forState:UIControlStateNormal];
            [btn setTitleColor:UIColorFromRGB(0xFF7F00, 1.0) forState:UIControlStateSelected];
            btn.backgroundColor = UIColorFromRGB(0xF0F0F0, 1.0);
            [btn addTarget:self action:@selector(selectedClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 1000 + i;
            if (i == 0) {
                btn.selected = YES;
            }
            [_scrollView addSubview:btn];
        }
        _scrollView.contentSize = CGSizeMake(15+_playUrlArray.count*(15+itemwidth), 40);
        [_view2 addSubview:label1];
        [_view2 addSubview:self.totalEpisodeLabel];
        [_view2 addSubview:_scrollView];
        height = 25+gap2+22+8+40;
    }
    [self addDescriptionView:height];
}

//添加view3
- (void) addDescriptionView:(CGFloat)height {
    CGFloat gap3 = 20;
    self.view3 = [[UIView alloc] initWithFrame:CGRectMake(0, gap3+height, ScreenWidth, 112)];
    
    self.directorLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, gap3, ScreenWidth-30, 22)];
    //self.directorLabel.text = @"导演：我是导演。。。。。";
    _directorLabel = [self dealLabel:_directorLabel Font:[UIFont systemFontOfSize:13] color:UIColorFromRGB(0x000000, 1.0) textAlignment:NSTextAlignmentLeft];
    
    self.actorLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_directorLabel.frame), ScreenWidth-30, 22)];
    //_actorLabel.text = @"我是演员";
    _actorLabel = [self dealLabel:_actorLabel Font:[UIFont systemFontOfSize:13] color:UIColorFromRGB(0x000000, 1.0) textAlignment:NSTextAlignmentLeft];
    
    self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_actorLabel.frame), ScreenWidth-30, 112-CGRectGetMaxY(_actorLabel.frame))];
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel = [self dealLabel:_descriptionLabel Font:[UIFont systemFontOfSize:13] color:UIColorFromRGB(0x000000, 1.0) textAlignment:NSTextAlignmentLeft];
    
    
    [_view3 addSubview:_directorLabel];
    [_view3 addSubview:_actorLabel];
    [_view3 addSubview:_descriptionLabel];
    
    [self addSubview:_view1];
    [self addSubview:_view2];
    [self addSubview:_view3];
}

- (void) selectedClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(selectedEpisode:)]) {
        [self.delegate selectedEpisode:btn];
    }
}

- (UILabel *) dealLabel:(UILabel *)label Font:(UIFont *)font color:(UIColor *)color textAlignment:(NSTextAlignment)Alignment {
    label.font = font;
    label.textColor = color;
    label.textAlignment = Alignment;
    return label;
}


- (NSMutableArray *)playUrlArray {
    if (_playUrlArray == nil) {
        _playUrlArray = [NSMutableArray array];
    }
    return _playUrlArray;
}



@end
