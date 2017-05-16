//
//  HomeHeadCollectionReusableView.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/9.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "HomeHeadCollectionReusableView.h"

@implementation HomeHeadCollectionReusableView 

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void) setModel:(HomeModel *)model {
    _model = model;
}

- (void) addCirculationScrollView:(NSArray *)imageArray andTitleArray:(NSArray *)titleArray{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray* urlsArray = @[
                               @"http://img.pconline.com.cn/images/upload/upc/tx/wallpaper/1602/26/c0/18646722_1456498424671_800x600.jpg",
                               @"http://img.pconline.com.cn/images/upload/upc/tx/wallpaper/1602/26/c0/18646649_1456498410838_800x600.jpg",
                               @"http://img.pconline.com.cn/images/upload/upc/tx/wallpaper/1602/26/c0/18646706_1456498430419_800x600.jpg",
                               @"http://img.pconline.com.cn/images/upload/upc/tx/wallpaper/1602/26/c0/18646723_1456498427059_800x600.jpg",
                               @"http://img.pconline.com.cn/images/upload/upc/tx/wallpaper/1602/26/c0/18646705_1456498422529_800x600.jpg"
                               ];
        NSArray* titlesArray = @[@"欢迎使用BHInfiniteScrollView无限轮播图",
                                 @"如果你在使用过程中遇到什么疑问",
                                 @"可以添加QQ群：206177395",
                                 @"我会及时修复bug",
                                 @"为你解答问题",
                                 ];
        CGFloat viewHeight = [UIScreen mainScreen].bounds.size.height/4;
        
        BHInfiniteScrollView* infinitePageView1 = [BHInfiniteScrollView
                                                   infiniteScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, viewHeight) Delegate:self ImagesArray:urlsArray];
        infinitePageView1.titlesArray = titlesArray;
        infinitePageView1.dotSize = 8;
        infinitePageView1.pageControlAlignmentOffset = CGSizeMake(0, 10);
        infinitePageView1.dotSpacing = 6;
        infinitePageView1.titleView.textColor = [UIColor whiteColor];
        infinitePageView1.titleView.margin = 30;
        infinitePageView1.titleView.hidden = YES;
        infinitePageView1.scrollTimeInterval = 2;
        infinitePageView1.autoScrollToNextPage = YES;
        infinitePageView1.delegate = self;
        infinitePageView1.backgroundColor = [UIColor redColor];
        [self addSubview:infinitePageView1];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 135, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor blackColor];
        
        self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-15-8, (40-16)/2, 8, 16)];
        _arrowImageView.image = [UIImage imageNamed:@"ArrowRight"];
        _arrowImageView.userInteractionEnabled = YES;
        
        self.lineImageView = [[UIImageView alloc] init];
        _lineImageView.frame = CGRectMake(CGRectGetMaxX(_titleLabel.frame)+10, 18, ScreenWidth-CGRectGetMaxX(_titleLabel.frame)-15-20-10, 2);
        _lineImageView.backgroundColor = [UIColor grayColor];
        _lineImageView.userInteractionEnabled = YES;
        
        self.categoryBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _categoryBtn.frame = CGRectMake(0, ScreenWidth/2, ScreenWidth, 40);
        
        [_categoryBtn addSubview:_titleLabel];
        [_categoryBtn addSubview:_arrowImageView];
        [_categoryBtn addSubview:_lineImageView];
        
        [self addSubview:_categoryBtn];
    });
}

- (void)infiniteScrollView:(BHInfiniteScrollView *)infiniteScrollView didScrollToIndex:(NSInteger)index {
    
}

- (void)infiniteScrollView:(BHInfiniteScrollView *)infiniteScrollView didSelectItemAtIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(didSecectedHomeCirculationScrollViewAnIndex:)]) {
        [self.delegate didSecectedHomeCirculationScrollViewAnIndex:index];
    }
}

@end
