//
//  NSObject+GameApplication.h
//  pf
//
//  Created by gidea on 2018/9/27.
//  Copyright © 2018 pf. All rights reserved.
//

#import <Foundation/NSObject.h>
@interface GameApplication: NSObject
+(instancetype) shareInstance ;


/////////////////////////////////////
// 通知 js事件
/////////////////////////////////////
- (void)applicationWillResignActive:(UIApplication *)application;
- (void)applicationDidEnterBackground:(UIApplication *)application;
- (void)applicationWillEnterForeground:(UIApplication *)application;
- (void)applicationDidBecomeActive:(UIApplication *)application;
- (void)applicationWillTerminate:(UIApplication *)application;


/////////////////////////////////////
// js 获取
/////////////////////////////////////

- (void) getIDFA;
- (void) getIDFV;
- (void) getBundleIdentifier;


- (void) openURL: (NSString *) url;
- (void) exitAppp;
- (void) checkNetwork;



@end
