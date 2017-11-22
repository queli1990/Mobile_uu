//
//  HomeHead_title_CollectionReusableView.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/9.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "HomeHead_title_CollectionReusableView.h"


@implementation HomeHead_title_CollectionReusableView

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) { //总共高30
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 5)];
        bgView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
        [self addSubview:bgView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 135, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor blackColor];
        
        
        self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-15-8, 5+(30-16)/2, 8, 16)];
        _arrowImageView.image = [UIImage imageNamed:@"ArrowRight"];
        
        self.moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-15-8-5-40, 5, 40, 20)];
        _moreLabel.textAlignment = NSTextAlignmentRight;
        _moreLabel.font = [UIFont systemFontOfSize:14];
        _moreLabel.textColor = [UIColor grayColor];
//        _moreLabel.text = @"更多";
        
        self.categoryBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _categoryBtn.frame = CGRectMake(0, 0, ScreenWidth, 30);
        
        [_categoryBtn addSubview:_titleLabel];
        [_categoryBtn addSubview:_arrowImageView];
        [_categoryBtn addSubview:_moreLabel];
        
        [self addSubview:_categoryBtn];
    }
    return  self;
}
@end
