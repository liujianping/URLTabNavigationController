//
//  UITabNavigationViewController.m
//  iLeft
//
//  Created by 刘建平 on 16/4/15.
//  Copyright © 2016年 JamesLiu. All rights reserved.
//

#import "URLTabNavigationController.h"


@implementation NavigationModel
@end

@interface URLTabNavigationController ()

@end

@implementation URLTabNavigationController

+ (instancetype) defaultTabNavigationController{
    static URLTabNavigationController *tabNavigationController = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (!tabNavigationController) {
            tabNavigationController = [[self alloc] init];
        }
    });
    return tabNavigationController;
}

- (id) init{
    if (self = [super init]) {
        _navigations = [[NSMutableArray alloc] init];
        _router = [URLRouter defaultRouter];
    }
    return self;
}


- (BOOL)initialization {
    NSMutableArray* navs = [[NSMutableArray alloc] init];
    for (NavigationModel *nav in self.navigations) {
        UIViewController* viewController = [self.router viewControllerForPath:nav.route];
        if (viewController) {
            UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:viewController];
            [navController.navigationBar setBarStyle:UIBarStyleBlack];
            viewController.title = nav.title;
            [navController.tabBarItem setTitle:nav.title];
            [navController.tabBarItem setImage:[UIImage imageNamed:nav.image]];
            [navController.tabBarItem setSelectedImage:[UIImage imageNamed:nav.selectedImage]];
            [navs addObject:navController];
            nav.navigationController = navController;
        }
    }
    [self setViewControllers: navs];
    return YES;
}

- (void) navigation: (NavigationModel*) nav{
    [self.router map:nav.route withControllerClassName:nav.className];
    [self.navigations addObject:nav];
}

- (void) navigate: (NSString*) route
            title: (NSString*) title
            image: (NSString*) image
    selectedImage: (NSString*) selectedImage
        className: (NSString*) className{
    NavigationModel* nav = [[NavigationModel alloc] init];
    nav.route = route;
    nav.title = title;
    nav.image = image;
    nav.selectedImage = selectedImage;
    nav.className = className;
    [self navigation: nav];
}

//! push URL view controller
- (UIViewController*) pushURL: (NSURL*) url animated: (BOOL) flag completion:(void (^)(void))completion {
    for (NavigationModel* nav in self.navigations) {
        if ([url.path hasPrefix:nav.route]) {
            UIViewController* viewController = [self.router viewControllerForURL:url];
            if (viewController != nil) {
                viewController.hidesBottomBarWhenPushed = YES;
                self.selectedViewController = nav.navigationController;
                [nav.navigationController pushViewController:viewController animated:flag];
                if (completion) {
                    completion();
                }
                return viewController;
            }
        }
    }
    return nil;
}

//! present URL view controller
- (UIViewController*) presentURL: (NSURL*) url animated: (BOOL) flag completion:(void (^)(void))completion {
    for (NavigationModel* nav in self.navigations) {
        if ([url.path hasPrefix:nav.route]) {
            UIViewController* viewController = [self.router viewControllerForURL:url];
            if (viewController != nil) {
                self.selectedViewController = nav.navigationController;
                [nav.navigationController.visibleViewController presentViewController:viewController animated:flag completion:completion];
                return viewController;
            }
        }
    }
    return nil;
}

- (void) buttonImage: (UIImage*)buttonImage highlightImage:(UIImage*)highlightImage {
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0)
        button.center = self.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        button.center = center;
    }
    _centerButton = button;
    
    [self.view addSubview:button];
}

@end
