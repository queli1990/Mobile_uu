//
//  NavView.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/3.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "NavView.h"

@implementation NavView

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(15, 20+(44-44)/2, 50, 44);
        [_backBtn setImage:[UIImage imageNamed:@"ArrowLeft"] forState:UIControlStateNormal];
        CGFloat width = 22*0.5;
        CGFloat height = 36*0.5;
        _backBtn.imageEdgeInsets = UIEdgeInsetsMake((44-height)/2, 0, (44-height)/2, 50-width);
        [self addSubview:_backBtn];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-200)/2, (44-20)/2, 200, 20)];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:18.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-1, ScreenWidth, 1)];
        lineView.backgroundColor = [UIColor blackColor];
        [self addSubview:lineView];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
