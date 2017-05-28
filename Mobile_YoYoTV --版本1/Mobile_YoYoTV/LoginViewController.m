//
//  LoginViewController.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/18.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginNav.h"
#import "NSString+encrypto.h"
#import "PostBaseHttpRequest.h"
#import "RegistViewController.h"
#import "HomeViewController.h"

@interface LoginViewController () <UITextFieldDelegate>
@property (nonatomic,strong) LoginNav *navView;
@property (nonatomic,strong) UITextField *nickNameTextField;
@property (nonatomic,strong) UITextField *passWordTextField;
@end

@implementation LoginViewController

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_nickNameTextField becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNav];
    
    [self initTextField];
}

- (void) initTextField{
    
    UIView *inputView1 = [[UIView alloc] initWithFrame:CGRectMake(30, 64+50, ScreenWidth-60, 40)];
    //    inputView1.layer.masksToBounds = YES;
    //    inputView1.layer.borderWidth = 1.0;
    //    inputView1.layer.borderColor = [UIColor grayColor].CGColor;
    //    inputView1.layer.cornerRadius = 14.0;
    inputView1.backgroundColor = [UIColor clearColor];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 49, ScreenWidth-60, 1)];
    lineView1.backgroundColor = UIColorFromRGB(0xF0F0F0, 1.0);
    [inputView1 addSubview:lineView1];
    
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (40-20)/2, 20, 20)];
    headImageView.image = [UIImage imageNamed:@"login_personal"];
    [inputView1 addSubview:headImageView];
    
    self.nickNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame)+15, 5, ScreenWidth-60-headImageView.frame.size.width-30-10-5-20, 30)];
    _nickNameTextField.placeholder = @"请输入邮箱地址";
    _nickNameTextField.backgroundColor = [UIColor clearColor];
    //设置placeholder的颜色
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = UIColorFromRGB(0x4A4A4A, 1.0);
    NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:_nickNameTextField.placeholder attributes:dict];
    [_nickNameTextField setAttributedPlaceholder:attribute];
    _nickNameTextField.textColor = [UIColor blackColor];
    _nickNameTextField.font = [UIFont systemFontOfSize:16.0];
    _nickNameTextField.clearButtonMode = UITextFieldViewModeAlways;
    
    
    //    _nickNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    _nickNameTextField.delegate = self;
    [inputView1 addSubview:_nickNameTextField];
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame = CGRectMake(CGRectGetMaxX(_nickNameTextField.frame)+5, 10, 20, 20);
    [clearBtn setImage:[UIImage imageNamed:@"personal_clearBtnNormal"] forState:UIControlStateNormal];
    [clearBtn setImage:[UIImage imageNamed:@"personal_clearBtnHeighted"] forState:UIControlStateHighlighted];
    [clearBtn addTarget:self action:@selector(clearInput:) forControlEvents:UIControlEventTouchUpInside];
    [inputView1 addSubview:clearBtn];
    
    [self.view addSubview:inputView1];
    
    
    UIView *inputView2 = [[UIView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(inputView1.frame)+30, ScreenWidth-60, 40)];
    //    inputView2.layer.masksToBounds = YES;
    //    inputView2.layer.borderWidth = 1.0;
    //    inputView2.layer.borderColor = [UIColor grayColor].CGColor;
    //    inputView2.layer.cornerRadius = 14.0;
    inputView2.backgroundColor = [UIColor clearColor];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 39, ScreenWidth-60, 1)];
    lineView2.backgroundColor = UIColorFromRGB(0xF0F0F0, 1.0);
    [inputView2 addSubview:lineView2];
    
    UIImageView *passwordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (40-20)/2, 20, 20)];
    passwordImageView.image = [UIImage imageNamed:@"personal_lock"];
    [inputView2 addSubview:passwordImageView];
    
    self.passWordTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(passwordImageView.frame)+15, 5, _nickNameTextField.frame.size.width, 30)];
    _passWordTextField.textColor = [UIColor blackColor];
    _passWordTextField.placeholder = @"请输入6位数以上密码";
    _passWordTextField.secureTextEntry = YES;
    //设置placeholder的颜色
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    dict2[NSForegroundColorAttributeName] = UIColorFromRGB(0x4A4A4A, 1.0);
    NSAttributedString *attribute2 = [[NSAttributedString alloc] initWithString:_passWordTextField.placeholder attributes:dict2];
    [_passWordTextField setAttributedPlaceholder:attribute2];
    _passWordTextField.font = [UIFont systemFontOfSize:16.0];
    //    _passWordTextField.borderStyle = UITextBorderStyleRoundedRect;
    _passWordTextField.delegate = self;
    [inputView2 addSubview:_passWordTextField];
    
    [self.view addSubview:inputView2];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat scal = (ScreenWidth-20-20)/630;
    loginBtn.frame = CGRectMake(20, CGRectGetMaxY(inputView2.frame)+40, ScreenWidth-20-20, 104*scal);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.backgroundColor = [UIColor orangeColor];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registBtn.frame = CGRectMake(20, CGRectGetMaxY(loginBtn.frame)+20, ScreenWidth-20-20, 40);
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [registBtn addTarget:self action:@selector(regist:) forControlEvents:UIControlEventTouchUpInside];
    [registBtn setBackgroundImage:[UIImage imageNamed:@"personalBgNormal"] forState:UIControlStateNormal];
    [registBtn setBackgroundImage:[UIImage imageNamed:@"personalBgHeighted"] forState:UIControlStateHighlighted];
    
    //    [self.view addSubview:registBtn];
    
}

- (void) clearInput:(UIButton *)btn{
    _nickNameTextField.text = nil;
}

- (void) regist:(UIButton *)btn{
    RegistViewController *vc = [[RegistViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void) login:(UIButton *)btn{
    if (![self validateEmail:_nickNameTextField.text]) {
        [ShowToast showToastWithString:@"请输入合法的邮箱地址" withBackgroundColor:[UIColor orangeColor] withTextFont:18];
        [_nickNameTextField resignFirstResponder];
        return;
    }
    if (_passWordTextField.text.length<6) {
        [ShowToast showToastWithString:@"您输入的密码名不符合" withBackgroundColor:[UIColor orangeColor] withTextFont:18];
        [_passWordTextField resignFirstResponder];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *userName = _nickNameTextField.text;
    NSString *password = _passWordTextField.text;
    NSString *platform = @"mobile";
    NSString *combineStr = [NSString stringWithFormat:@"%@&%@&%@",userName,password,platform];
    NSString *md5Str = [combineStr md5];
    [params setObject:userName forKey:@"userName"];
    [params setObject:password forKey:@"password"];
    [params setObject:platform forKey:@"platform"];
    [params setObject:md5Str forKey:@"sign"];
    
    [[PostBaseHttpRequest alloc] basePostDataRequest:params andTransactionSuffix:@"app/member/doLogin.do" andBlock:^(PostBaseHttpRequest *responseData) {
        NSDictionary *userDic = [NSJSONSerialization JSONObjectWithData:responseData._data options:NSJSONReadingMutableContainers error:nil];
        NSString *statusString = userDic[@"status"];
        if ([statusString isEqualToString:@"1"]) {
            [ShowToast showToastWithString:@"登录成功" withBackgroundColor:[UIColor orangeColor] withTextFont:18];
            [[NSUserDefaults standardUserDefaults] setObject:userDic forKey:@"userInfo"];
//            [self.navigationController.viewControllers[i] removeFromParentViewController];
            [self.navigationController popViewControllerAnimated:YES];
        } else if ([statusString isEqualToString:@"0"]){
            [ShowToast showToastWithString:@"服务端异常,请稍后重试" withBackgroundColor:[UIColor orangeColor] withTextFont:18];
        } else {
            [ShowToast showToastWithString:@"用户名或密码错误" withBackgroundColor:[UIColor orangeColor] withTextFont:18];
        }
        /*
         {
         dueTime = "";
         isVip = 0;
         status = 1;
         token = a21362784feae48e5955e94fae328c3a;
         userName = "zhangsan@hotmail.com";
         }
         */
    } andFailure:^(PostBaseHttpRequest *responseData) {
        [ShowToast showToastWithString:@"登录失败请查看网络" withBackgroundColor:[UIColor orangeColor] withTextFont:18];
    }];
}

//判断是否为邮箱
- (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_passWordTextField resignFirstResponder];
    [_nickNameTextField resignFirstResponder];
}

- (void) textFieldDidEndEditing:(UITextField *)textField{
    
}

- (void) textFieldDidBeginEditing:(UITextField *)textField{
    //    [UIView animateWithDuration:0.2 animations:^{
    //        if (ScreenWidth == 320) {
    //            _fullView.frame = CGRectMake(0, (ScreenHeight-64-120-40-80-80)/2-253-10, ScreenWidth, ScreenHeight-64);
    //        }else if (ScreenWidth == 375){
    //            _fullView.frame = CGRectMake(0, (ScreenHeight-64-120-40-80-80)/2-200-10, ScreenWidth, ScreenHeight-64);
    //        }else{
    //            _fullView.frame = CGRectMake(0, (ScreenHeight-64-120-40-80-80)/2-271-10, ScreenWidth, ScreenHeight-64);
    //        }
    //    }];
}


- (void) setNav{
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    bgImageView.image = [[UIImage imageNamed:@"HomeBackground"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //[self.view addSubview:bgImageView];
    self.navView = [[LoginNav alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    _navView.backgroundColor = [UIColor clearColor];
    [_navView addRightBtn];
    [_navView.rightBtn setTitle:@"注册" forState:UIControlStateNormal];
    _navView.titleLabel.hidden = YES;
    _navView.rightBtn.frame = CGRectMake(ScreenWidth-15-40, 20+(44-49.0*0.5)/2, 40, 49.0*0.5);
    [_navView.rightBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [_navView.rightBtn addTarget:self action:@selector(regist:) forControlEvents:UIControlEventTouchUpInside];
    [_navView.backBtn addTarget:self action:@selector(backToLastPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_navView];
}

- (void) backToLastPage {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
