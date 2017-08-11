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
#import "PlayerViewController.h"

@interface LeftViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *titleConfigsArray;
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self setupTabView];
}

- (void) setupTabView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, 250, ScreenHeight-44*2) style:UITableViewStylePlain];
    _tableView.contentInset = UIEdgeInsetsMake(44.0, 0.0, 44.0, 0.0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[LeftVCTableViewCell class] forCellReuseIdentifier:@"LeftVCTableViewCell"];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}

#pragma mark --示例--[self mainVCPush:viewController]  push出新界面
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIViewController *viewController = [UIViewController new];
    viewController.view.backgroundColor = [UIColor whiteColor];
    viewController.title = @"xxxxxxx";
    
    [self mainVCPush:viewController];
}

#pragma mark --TableViewDatalegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleConfigsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LeftVCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftVCTableViewCell" forIndexPath:indexPath];
    cell.titleLabel.text = _titleConfigsArray[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        _titleConfigsArray = @[@"HomePage",
                               @"Search",
                               @"Setting"];
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
