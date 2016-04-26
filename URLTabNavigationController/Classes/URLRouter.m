//
//  URLRouter.m
//  iLeft
//
//  Created by 刘建平 on 16/4/7.
//  Copyright © 2016年 JamesLiu. All rights reserved.
//

#import "URLRouter.h"
#import "NSURL+QueryDictionary.h"
#import <objc/runtime.h>

#import "UIViewController+URLRouter.h"

@interface URLRouter ()
//! object property router routes map
@property (strong, nonatomic) NSMutableDictionary *routes;
@end


@implementation URLRouter

//! class method : get default url router instance
+ (instancetype) defaultRouter {
    static URLRouter *router = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (!router) {
            router = [[self alloc] init];
        }
    });
    return router;
}

- (NSMutableDictionary*) routes{
    if (_routes == nil) {
        _routes = [NSMutableDictionary dictionary];
    }
    return _routes;
}

//! map url, writable
- (NSMutableDictionary *) mapRoute: (NSURL*) url {
    NSMutableDictionary *route = self.routes;
    for (NSString* path in url.pathComponents) {
        if ([path isEqualToString:@"/"]) {
            continue;
        }
        
        if (![route objectForKey:path]) {
            route[path] = [[NSMutableDictionary alloc] init];
        }
        
        route = route[path];
    }
    return route;
}

//! match route, readonly
- (NSMutableDictionary *) matchRoute:(NSURL*) url {
    NSMutableDictionary *next = self.routes;
    for (NSString* path in url.pathComponents) {
        if ([path isEqualToString:@"/"]) {
            continue;
        }
        
        NSArray *keys = next.allKeys;
        //! path in keys
        if ([keys containsObject:path]) {
            next = next[path];
            continue;
        }
        
        //! path match keys pattern
        for (NSString* key in keys) {
            if ([key hasPrefix:@":"]) {
                next = next[key];
                break;
            }
        }
    }
    return next;
}

//! match url
- (NSURL *) matchURL:(NSURL*) url {
    NSURL *aURL = url;
    NSMutableDictionary *next = self.routes;
    for (NSString* path in url.pathComponents) {
        if ([path isEqualToString:@"/"]) {
            continue;
        }
        
        NSArray *keys = next.allKeys;
        //! path in keys
        if ([keys containsObject:path]) {
            next = next[path];
            continue;
        }
        
        //! path match keys pattern
        for (NSString* key in keys) {
            if ([key hasPrefix:@":"]) {
                aURL = [aURL URLByAppendingQueryDictionary:[NSDictionary dictionaryWithObject:path forKey:[key substringFromIndex:1]]];
                next = next[key];
                break;
            }
        }
    }
    
    Class class = next[@"_"];
    if (class_isMetaClass(object_getClass(class))){
        if ([class isSubclassOfClass:[UIViewController class]]) {
            aURL = [aURL URLByAppendingQueryDictionary:[NSDictionary dictionaryWithObject:NSStringFromClass(class) forKey:@"_controller_class"]];
        }
    }
    return aURL;
}

//! map route path pattern
- (BOOL) map: (NSString*) pattern withControllerClassName: (NSString*) className {
    Class class = NSClassFromString(className);
    if ([class isSubclassOfClass:[UIViewController class]]) {
        NSURL* url = [[NSURL alloc] initWithString:pattern];
        NSMutableDictionary *route = [self mapRoute:url];
        route[@"_"] = class;
        return YES;
    }
    return FALSE;
}

- (BOOL) map: (NSString*) pattern withCompletion: (URLRouterCompletion) block {
    NSURL* url = [[NSURL alloc] initWithString:pattern];
    NSMutableDictionary *route = [self mapRoute:url];
    route[@"_"] = [block copy];
    return YES;
}

//! view controller
- (UIViewController*) viewControllerForPath: (NSString*) path {
    NSURL *url = [[NSURL alloc] initWithString:path];
    return [self viewControllerForURL:url];
}

//! get view controller for URL
- (UIViewController*) viewControllerForURL: (NSURL*) url{
    NSURL *aURL = [self matchURL:url];
    
    Class controllerClass = NSClassFromString([aURL.queryDictionary objectForKey:@"_controller_class"]);
    UIViewController *viewController = [[controllerClass alloc] init];
    if ([viewController respondsToSelector:@selector(setURL:)]) {
        [viewController performSelector:@selector(setURL:)
                             withObject:aURL];
    }
    return viewController;
}

//! url block execute
-(void) executeURL: (NSURL*) url {
    NSMutableDictionary* route = [self matchRoute:url];
    if (!class_isMetaClass(object_getClass(route[@"_"]))){
        URLRouterCompletion completion = [route[@"_"] copy];
        NSURL* aURL = [self matchURL:url];
        completion(aURL);
    }
}
@end

