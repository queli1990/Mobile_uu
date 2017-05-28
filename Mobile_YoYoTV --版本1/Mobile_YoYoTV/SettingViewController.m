//
//  SettingViewController.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/27.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "SettingViewController.h"
#import "NavView.h"
#import "SettingTableViewCell.h"

@interface SettingViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSArray *titlesArray;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *heaerView;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNav];
    [self setupHeader];
    [self setupTableView];
}

- (void) setupNav {
    NavView *nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    [nav.backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    nav.titleLabel.text = @"系统设置";
    [self.view addSubview:nav];
}

- (void) setupHeader {
    CGFloat height = ScreenWidth * 9/16;
    self.heaerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, height)];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-79)/2, (height-84)/2, 79, 84)];
    img.image = [UIImage imageNamed:@"settingHeaderImg"];
    [_heaerView addSubview:img];
}

- (void) setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[SettingTableViewCell class] forCellReuseIdentifier:@"SettingTableViewCell"];
    _tableView.tableHeaderView = _heaerView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingTableViewCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-30-15, (44-20)/2, 30, 20)];
        newLabel.text = @"最新";
        newLabel.backgroundColor = UIColorFromRGB(0x7ED321, 1.0);
        newLabel.font = [UIFont systemFontOfSize:13];
        newLabel.textAlignment = NSTextAlignmentRight;
        newLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:newLabel];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = _titlesArray[indexPath.row][@"title"];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [ShowToast showToastWithString:@"已是最新版本" withBackgroundColor:[UIColor orangeColor] withTextFont:18];
    } else if (indexPath.row == 1) {
        NSString * url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",@"1214672760"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titlesArray.count;
}

- (void) goBack:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSArray *)titlesArray {
    if (_titlesArray == nil) {
        NSDictionary *dic1 = @{@"title":@"版本更新"};
        NSDictionary *dic2 = @{@"title":@"我来打分"};
        _titlesArray = @[dic1,dic2];
    }
    return _titlesArray;
}


@end
