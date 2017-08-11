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
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 135, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor blackColor];
        
        self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-15-8, (30-16)/2, 8, 16)];
        _arrowImageView.image = [UIImage imageNamed:@"ArrowRight"];
        _arrowImageView.userInteractionEnabled = YES;
        
        self.lineImageView = [[UIImageView alloc] init];
        _lineImageView.frame = CGRectMake(CGRectGetMaxX(_titleLabel.frame)+10, 18, ScreenWidth-CGRectGetMaxX(_titleLabel.frame)-15-20-10, 2);
        _lineImageView.backgroundColor = [UIColor grayColor];
        _lineImageView.userInteractionEnabled = YES;
        
        self.categoryBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _categoryBtn.frame = frame;
        
        [_categoryBtn addSubview:_titleLabel];
        [_categoryBtn addSubview:_arrowImageView];
        [_categoryBtn addSubview:_lineImageView];
        
        [self addSubview:_categoryBtn];
    }
    return  self;
}
@end
