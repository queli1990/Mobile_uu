//
//  AppDelegate.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/2.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "AppDelegate.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "RDVTabBar.h"
#import "HomeViewController.h"
#import "HomeScrollViewController.h"
#import "MainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
//    [self setupViewControllers];  //设置TabBar
//    [self.window setRootViewController:self.viewController];
    
    HomeScrollViewController *homeVC = [HomeScrollViewController new];
    homeVC.view.backgroundColor = [UIColor whiteColor];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeVC];
    MainViewController *mainViewController = [MainViewController new];
    mainViewController.rootViewController = navigationController;
    [mainViewController setupWithType:1];
    UIWindow *window = UIApplication.sharedApplication.delegate.window;
    window.rootViewController = mainViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}


#pragma mark - Methods - tabBar
- (void)setupViewControllers {
    //第1个控制器
    UIViewController *firstViewController = [[HomeViewController alloc] init];
    UINavigationController *firstNavigationController = [[UINavigationController alloc]
                                                         initWithRootViewController:firstViewController];
    [firstNavigationController.navigationBar setHidden:YES];
    //第2个控制器
    UINavigationController *secondNavigationController;
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    if (userId.length) {
        UIViewController *secondViewController = [[UIViewController alloc] init];
        secondNavigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
    }else{
        UIViewController *secondViewController = [[UIViewController alloc] init];
        secondNavigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
    }
    //第3个控制器
    UIViewController *thirdViewController = [[UIViewController alloc] init];
    UINavigationController *thirdNavigationController = [[UINavigationController alloc]
                                                         initWithRootViewController:thirdViewController];
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
    [tabBarController setViewControllers:@[firstNavigationController, secondNavigationController,
                                           thirdNavigationController]];
//        RDVTabBar *tabBar = tabBarController.tabBar;
//        tabBar.backgroundView.backgroundColor = [UIColor redColor];//tabBar的整体背景颜色
    self.viewController = tabBarController;
    [self customizeTabBarForController:tabBarController];
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
//    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];//改变选中后的item的背景色或者图片
//    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    NSArray *tabBarItemImages = @[@"first", @"second", @"third"];
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        if (index == 0) item.title = @"first";
        if (index == 1) item.title = @"second";
        if (index == 2) item.title = @"third";
//        [item setBackgroundSelectedImage:nil withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        index++;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
