//
//  URLRouter.h
//  iLeft
//
//  Created by 刘建平 on 16/4/7.
//  Copyright © 2016年 JamesLiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//! type def URLRouterBlock
typedef void (^URLRouterCompletion)(NSURL* url);

//! class URLRouter
@interface URLRouter : NSObject

//! class method : get default url router instance
+ (instancetype) defaultRouter;

//! object property router schema
@property(nonatomic, strong) NSString* schema;

//! map route path pattern
- (BOOL) map: (NSString*) pattern withControllerClassName: (NSString*) className;
- (BOOL) map: (NSString*) pattern withCompletion: (URLRouterCompletion) block;

//! match view controller
- (UIViewController*) viewControllerForPath: (NSString*) pattern;
- (UIViewController*) viewControllerForURL: (NSURL*) url;

//! execute block
-(void) executeURL: (NSURL*) url;
@end




