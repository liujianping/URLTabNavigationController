//
//  UIViewController+URLRouter.m
//  iLeft
//
//  Created by 刘建平 on 16/4/13.
//  Copyright © 2016年 JamesLiu. All rights reserved.
//

#import "UIViewController+URLRouter.h"
#import <objc/runtime.h>

@implementation UIViewController (URLRouter)

static char kAssociatedObjectKey;

-(void) setURL: (NSURL*) url {
    NSLog(@"UIViewController setURL => %@", url);
    objc_setAssociatedObject(self, &kAssociatedObjectKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSURL*) URL {
    NSLog(@"UIViewController get URL");
    return objc_getAssociatedObject(self, &kAssociatedObjectKey);
}

@end
