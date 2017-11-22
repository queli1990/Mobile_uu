//
//  NoResultView.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/27.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "NoResultView.h"

@implementation NoResultView

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-178)/2, (ScreenHeight-130)/2, 178, 130)];
        imgView.image = [UIImage imageNamed:@"noResult"];
        [self addSubview:imgView];
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
