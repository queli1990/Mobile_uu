//
//  FeedBackViewController.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/28.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "FeedBackViewController.h"
#import "NavView.h"

@interface FeedBackViewController () <UITextViewDelegate>
@property (nonatomic,strong) UITextView *feedbackTextView;
@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNav];
    [self setupView];
}

- (void) setNav {
    NavView *nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    [nav.backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    nav.titleLabel.text = @"意见反馈";
    [self.view addSubview:nav];
}

- (void) setupView {
    self.feedbackTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 64+20, ScreenWidth-30, (ScreenWidth-30)*(259.0/341.0))];
    _feedbackTextView.layer.borderColor = [UIColorFromRGB(0xE6E6E6, 1.0) CGColor];
    _feedbackTextView.layer.borderWidth = 1.0;
    _feedbackTextView.layer.cornerRadius = 2.0;
    _feedbackTextView.delegate = self;
    [self.view addSubview:_feedbackTextView];
    
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(15, CGRectGetMaxY(_feedbackTextView.frame)+20, ScreenWidth-30, 45);
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = submitBtn.frame;
    //颜色分配:四个一组代表一种颜色(r,g,b,a)
    layer.colors = @[(__bridge id) [UIColor colorWithRed:247/255.0 green:136/255.0 blue:26/255.0 alpha:1.0].CGColor,
                     (__bridge id) [UIColor colorWithRed:247/255.0 green:175/255.0 blue:36/255.0 alpha:1.0].CGColor];
    //起始点
    layer.startPoint = CGPointMake(0.15, 0.5);
    //结束点
    layer.endPoint = CGPointMake(0.85, 0.5);
    [submitBtn.layer addSublayer:layer];
    
    submitBtn.backgroundColor = [UIColor orangeColor];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:submitBtn];
}

- (void) submitBtnClick {
    if (_feedbackTextView.text.length <2 ) {
        [ShowToast showToastWithString:@"您输入的内容过短" withBackgroundColor:[UIColor orangeColor] withTextFont:18];
        return;
    }
    
    NSDictionary *dic = @{@"id":@3,@"platform":@"ios",@"msg":_feedbackTextView.text,@"version_number":@"1.0",@"version_code":@"1.0"};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:@"http://www.100uu.tv:8000/feedbacks" parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [ShowToast showToastWithString:@"已提交成功" withBackgroundColor:[UIColor orangeColor] withTextFont:18];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:error options:NSJSONReadingMutableContainers error:nil];
        [ShowToast showToastWithString:@"请检查您的网络设置" withBackgroundColor:[UIColor orangeColor] withTextFont:18];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_feedbackTextView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (void) goBack:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
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
