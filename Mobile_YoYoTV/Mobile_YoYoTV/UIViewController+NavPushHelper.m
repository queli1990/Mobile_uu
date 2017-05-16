//
//  UIViewController+NavPushHelper.m
//  Mobile_YoYoTV
//
//  Created by li que on 2017/5/5.
//  Copyright © 2017年 li que. All rights reserved.
//

#import "UIViewController+NavPushHelper.h"
#import "MainViewController.h"
#import <objc/runtime.h>
#import "UIViewController+LGSideMenuController.h"

@implementation UIViewController (NavPushHelper)

- (void) mainVCPush:(UIViewController *)pushedVC {
    MainViewController *mainViewController = (MainViewController *)self.sideMenuController;
    
    UINavigationController *navigationController = (UINavigationController *)mainViewController.rootViewController;
    [navigationController pushViewController:pushedVC animated:YES];
    
    [mainViewController hideLeftViewAnimated:YES completionHandler:nil];
}

- (nullable LGSideMenuController *)sideMenuController {
    if ([self isKindOfClass:[LGSideMenuController class]]) {
        return (LGSideMenuController *)self;
    }
    
    LGSideMenuController *result;
    
    result = objc_getAssociatedObject(self, @"sideMenuController");
    if (result) return result;
    
    result = self.parentViewController.sideMenuController;
    if (result) return result;
    
    result = self.navigationController.sideMenuController;
    if (result) return result;
    
    result = self.presentingViewController.sideMenuController;
    if (result) return result;
    
    result = self.splitViewController.sideMenuController;
    if (result) return result;
    
    return nil;
}

@end
