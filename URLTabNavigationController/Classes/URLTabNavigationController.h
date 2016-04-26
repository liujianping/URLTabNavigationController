//
//  UITabNavigationViewController.h
//  iLeft
//
//  Created by 刘建平 on 16/4/15.
//  Copyright © 2016年 JamesLiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "URLRouter.h"

@interface NavigationModel : NSObject
@property (strong, nonatomic) NSString* route;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* image;
@property (strong, nonatomic) NSString* selectedImage;
@property (strong, nonatomic) NSString* className;
@property (weak, nonatomic)   UINavigationController* navigationController;
@end

@interface UITabNavigationViewController : UITabBarController
@property (strong, nonatomic) NSMutableArray* navigations;
@property (weak, nonatomic) URLRouter* router;
@property (readonly, strong, nonatomic) UIButton* centerButton;

//! class method : get default instance
+ (instancetype) defaultTabNavigationController;

- (BOOL) initialization;
- (void) navigation: (NavigationModel*) nav;
- (void) navigate: (NSString*) route
            title: (NSString*) title
            image: (NSString*) image
    selectedImage: (NSString*) selectedImage
        className: (NSString*) className;

- (void) buttonImage: (UIImage*)buttonImage highlightImage:(UIImage*)highlightImage;

//! push view controller
- (UIViewController*) pushURL: (NSURL*) url animated: (BOOL) flag completion:(void (^)(void))completion;

//! present view controller
- (UIViewController*) presentURL: (NSURL*) url animated: (BOOL) flag completion:(void (^)(void))completion;


@end
