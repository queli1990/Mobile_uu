//
//  LeftViewController.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/4.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "LeftViewController.h"
#import "UIViewController+NavPushHelper.h"
#import "LeftVCTableViewCell.h"
#import "LoginViewController.h"
#import "RegistViewController.h"
#import "SettingViewController.h"
#import "FeedBackViewController.h"

#import "UIViewController+LGSideMenuController.h"

@interface LeftViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *titleConfigsArray;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIButton *headImageBtn;
@property (nonatomic,strong) UILabel *headNameLabel;
@property (nonatomic,strong) UIView *footView;
@property (nonatomic,strong) UIButton *loginBtn;
@property (nonatomic,strong) UIButton *quitBtn;
@property (nonatomic,copy) NSString *isLoginString;
@end

@implementation LeftViewController

- (void)willShowLeftView:(UIView *)leftView sideMenuController:(LGSideMenuController *)sideMenuController{
    
    NSLog(@"willShow");
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    if (userInfo) {
        _isLoginString = userInfo[@"userName"];
        _headNameLabel.text = _isLoginString;
        [_headImageBtn setImage:[UIImage imageNamed:@"leftPersonal"] forState:UIControlStateNormal];
        [_loginBtn setTitle:@"退出" forState:UIControlStateNormal];
    } else {
        _isLoginString = @"未登录";
        _headNameLabel.text = _isLoginString;
        [_headImageBtn setImage:[UIImage imageNamed:@"leftPersonal"] forState:UIControlStateNormal];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    }
}

- (void) setupData {
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    if (userInfo) {
        _isLoginString = userInfo[@"userName"];
        _headNameLabel.text = _isLoginString;
        [_headImageBtn setImage:[UIImage imageNamed:@"leftPersonal"] forState:UIControlStateNormal];
        [_loginBtn setTitle:@"退出" forState:UIControlStateNormal];
    } else {
        _isLoginString = @"未登录";
        _headNameLabel.text = _isLoginString;
        [_headImageBtn setImage:[UIImage imageNamed:@"leftPersonal"] forState:UIControlStateNormal];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupTabView];
    [self setUpFootView];
    
    //MainViewController *mainViewController = (MainViewController *)self.sideMenuController;
    self.sideMenuController.delegate = self;
}

- (void) setupTabView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth*3/4, ScreenHeight-44*2) style:UITableViewStylePlain];
//    _tableView.contentInset = UIEdgeInsetsMake(44.0, 0.0, 44.0, 0.0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[LeftVCTableViewCell class] forCellReuseIdentifier:@"LeftVCTableViewCell"];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = self.headView;
    [self.view addSubview:_tableView];
}

- (void) setUpFootView {
    if (_footView == nil) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-80, ScreenWidth*3/4, 40)];
        _footView.backgroundColor = [UIColor whiteColor];
        
        self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.frame = CGRectMake(50, (40-36)/2, 80, 36);
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.backgroundColor = UIColorFromRGB(0xFF7F00, 1.0);
        [_loginBtn addTarget:self action:@selector(pushLoginView:) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:_loginBtn];
        [self setupData];
        [self.view addSubview:_footView];
    }
}

#pragma mark --示例--[self mainVCPush:viewController]  push出新界面
- (void) pushLoginView:(UIButton *)btn {
    if ([btn.titleLabel.text isEqualToString:@"退出"]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
        [self setupData];
    }else {
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self mainVCPush:vc];
    }
}

- (UIView *)headView {
    if (_headView == nil) {
        CGFloat width = ScreenWidth*3/4;
        CGFloat height = width*(170.0/300.0);
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height+20)];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        imgView.image = [UIImage imageNamed:@"leftPoster"];
        [_headView addSubview:imgView];
        
        self.headImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _headImageBtn.frame = CGRectMake(22, height-32-16, 32, 32);
        _headImageBtn.layer.cornerRadius = _headImageBtn.frame.size.width/2;
        [imgView addSubview:_headImageBtn];
        
        
        _headNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImageBtn.frame)+12, _headImageBtn.frame.origin.y+(32-24)/2, 120, 24)];
        _headNameLabel.textAlignment = NSTextAlignmentLeft;
        _headNameLabel.text = _isLoginString;
        _headNameLabel.font = [UIFont systemFontOfSize:14.0];
        _headNameLabel.textColor = UIColorFromRGB(0xFFFFFF, 1.0);
        [imgView addSubview:_headNameLabel];
        [self setupData];
    }
    return _headView;
}

#pragma mark --TableViewDatalegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleConfigsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LeftVCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftVCTableViewCell" forIndexPath:indexPath];
    cell.titleLabel.text = _titleConfigsArray[indexPath.row][@"title"];
    cell.iconImageView.image = [UIImage imageNamed:_titleConfigsArray[indexPath.row][@"iconName"]];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {//意见反馈
        FeedBackViewController *vc = [FeedBackViewController new];
        [self mainVCPush:vc];
    } else if (indexPath.row == 1) {//系统设置
        SettingViewController *vc = [[SettingViewController alloc] init];
        [self mainVCPush:vc];
    } else if(indexPath.row == 2) {
        
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

- (NSArray *) titleConfigsArray {
    if (!_titleConfigsArray) {
        //NSDictionary *dic1 = @{@"title":@"播放历史",@"iconName":@"playHistory"};
        //NSDictionary *dic2 = @{@"title":@"我的收藏",@"iconName":@"collection"};
        NSDictionary *dic3 = @{@"title":@"意见反馈",@"iconName":@"feedBack"};
        NSDictionary *dic4 = @{@"title":@"系统设置",@"iconName":@"setting"};
        _titleConfigsArray = @[dic3,dic4];
    }
    return _titleConfigsArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
