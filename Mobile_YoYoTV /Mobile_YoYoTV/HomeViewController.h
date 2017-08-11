//
//  HomeViewController.h
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/3.
//  Copyright © 2017年 li que. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJScrollPageViewDelegate.h"
#import "ZJScrollPageView.h"

@interface HomeViewController : UIViewController <ZJScrollPageViewChildVcDelegate>
@property (nonatomic,strong) ZJScrollPageView *scrollPageView;
@property (nonatomic,strong) UIView *customView;
@property (nonatomic,strong) NSNumber *currentIndex;
@end
