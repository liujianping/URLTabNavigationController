# URLTabNavigationController

[![CI Status](http://img.shields.io/travis/liujianping/URLTabNavigationController.svg?style=flat)](https://travis-ci.org/liujianping/URLTabNavigationController)
[![Version](https://img.shields.io/cocoapods/v/URLTabNavigationController.svg?style=flat)](http://cocoapods.org/pods/URLTabNavigationController)
[![License](https://img.shields.io/cocoapods/l/URLTabNavigationController.svg?style=flat)](http://cocoapods.org/pods/URLTabNavigationController)
[![Platform](https://img.shields.io/cocoapods/p/URLTabNavigationController.svg?style=flat)](http://cocoapods.org/pods/URLTabNavigationController)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

URLTabNavigationController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "URLTabNavigationController"
```

## Quick Start

### TabBar Navigation

````
#import "URLTabNavigationController.h"

//! singleton instance
URLTabNavigationController* tabNavigation = [URLTabNavigationController defaultTabNavigationController];

//! tab navigate url to class name
[tabNavigation navigate:@"/red" title:@"red" image:nil selectedImage:nil className:@"RedViewController"];
[tabNavigation navigate:@"/blue" title:@"blue" image:nil selectedImage:nil className:@"BlueViewController"];
[tabNavigation navigate:@"/yellow" title:@"yellow" image:nil selectedImage:nil className:@"YellowViewController"];

//! tab bar controller initialization
[tabNavigation initialization];
````

### URL Router

````
#import "URLRouter.h"

//! singleton instance
URLRouter* router = [URLRouter defaultRouter];

//! router map path to class name
[router map:@"/home/:user" withControllerClassName: @"HomeViewController"];
[router map:@"/message" withControllerClassName: @"MessageViewController"];
[router map:@"/mine" withControllerClassName:@"MineViewController"];

//! router map path pattern example
[router map:@"/:name/:age/:hobby" withCompletion: ^(NSURL* url){
    NSLog(@"block exeucte (name: %@) (age: %@) (hobby: %@)", url.queryDictionary[@"name"], url.queryDictionary[@"age"], url.queryDictionary[@"hobby"]);
}];

//! router map path pattern for View Controller
UIViewController* vc = [router viewControllerForPath:@"/home/liujianping"];

//! router map path pattern for excute URL
[router executeURL:[[NSURL alloc] initWithString: @"/liujianping/36/movie"]];

````

## Author

liujianping, liujianping.itech@qq.com

## License

URLTabNavigationController is available under the MIT license. See the LICENSE file for more info.
