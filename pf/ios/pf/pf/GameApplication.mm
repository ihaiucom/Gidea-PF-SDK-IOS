//
//  NSObject+GameApplication.m
//  pf
//
//  Created by gidea on 2018/9/27.
//  Copyright © 2018 pf. All rights reserved.
//
#import <AdSupport/ASIdentifierManager.h>
#import <conchRuntime.h>
#import <Foundation/NSString.h>
#import "GameApplication.h"

@implementation GameApplication

static GameApplication* _instance = nil;

+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
    }) ;
    
    return _instance ;
}

+(id) allocWithZone:(struct _NSZone *)zone
{
    return [GameApplication shareInstance] ;
}

-(id) copyWithZone:(struct _NSZone *)zone
{
    return [GameApplication shareInstance] ;
}




/////////////////////////////////////
// 通知 js事件
/////////////////////////////////////

/*
 （3）回调方法：applicationWillResignActive:
 本地通知：UIApplicationWillResignActiveNotification
 触发时机：从活动状态进入非活动状态。
 适宜操作：这个阶段应该保存UI状态（例如游戏状态）。
 */
- (void)applicationWillResignActive:(UIApplication *)application
{
    [[conchRuntime GetIOSConchRuntime] runJS:@"if(window['gameApplication'] && window['gameApplication'].applicationWillResignActive)gameApplication.applicationWillResignActive()"];
}


/**
 (4）回调方法：applicationDidEnterBackground:
 本地通知：UIApplicationDidEnterBackgroundNotification
 触发时机：程序进入后台时调用。
 适宜操作：这个阶段应该保存用户数据，释放一些资源（例如释放数据库资源）。
 */
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    [[conchRuntime GetIOSConchRuntime] runJS:@"if(window['gameApplication'] && window['gameApplication'].applicationDidEnterBackground)gameApplication.applicationDidEnterBackground()"];
}


/**
 （5）回调方法：applicationWillEnterForeground：
 本地通知：UIApplicationWillEnterForegroundNotification
 触发时机：程序进入前台，但是还没有处于活动状态时调用。
 适宜操作：这个阶段应该恢复用户数据。
 */
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    [[conchRuntime GetIOSConchRuntime] runJS:@"if(window['gameApplication'] && window['gameApplication'].applicationWillEnterForeground)gameApplication.applicationWillEnterForeground()"];
}

/**
 （2）回调方法：applicationDidBecomeActive：
 本地通知：UIApplicationDidBecomeActiveNotification
 触发时机：程序进入前台并处于活动状态时调用。
 适宜操作：这个阶段应该恢复UI状态（例如游戏状态）。
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    [[conchRuntime GetIOSConchRuntime] runJS:@"if(window['gameApplication'] && window['gameApplication'].applicationDidBecomeActive)gameApplication.applicationDidBecomeActive()"];
}

/**
 （6）回调方法：applicationWillTerminate:
 本地通知：UIApplicationWillTerminateNotification
 触发时机：程序被杀死时调用。
 适宜操作：这个阶段应该进行释放一些资源和保存用户数据。
 */
- (void)applicationWillTerminate:(UIApplication *)application
{
    
    [[conchRuntime GetIOSConchRuntime] runJS:@"if(window['gameApplication'] && window['gameApplication'].applicationWillTerminate)gameApplication.applicationWillTerminate()"];
}






/////////////////////////////////////
// js 获取
/////////////////////////////////////



/*
 IDFA
 
 简介：广告标示符，适用于对外：例如广告推广，换量等跨应用的用户追踪等。但如果用户完全重置系统（(设置程序 -> 通用 -> 还原 -> 还原位置与隐私) ，这个广告标示符会重新生成。另外如果用户明确的还原广告(设置程序-> 通用 -> 关于本机 -> 广告 -> 还原广告标示符) ，那么广告标示符也会重新生成。注意：如果程序在后台运行，此时用户“还原广告标示符”，然后再回到程序中，此时获取广 告标示符并不会立即获得还原后的标示符。必须要终止程序，然后再重新启动程序，才能获得还原后的广告标示符。在同一个设备上的所有App都会取到相同的值，是苹果专门给各广告提供商用来追踪用户而设的，用户可以在 设置 -> 隐私 -> 广告追踪 里重置此id的值，或限制此id的使用。
 
 获取：[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
 
 ---------------------
 
 本文来自 Que_Li 的CSDN 博客 ，全文地址请点击：https://blog.csdn.net/que_li/article/details/76607319?utm_source=copy
*/
- (void) getIDFA
{
    NSString* uuid =[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    NSLog(@">>>>> GameApplication getIDFA: %@", uuid);
    [[conchRuntime GetIOSConchRuntime] callbackToJSWithObject:self methodName:@"getIDFA" ret:uuid];
}


/*
 IDFV
 
 简介：iOS 6.0系统新增用于替换uniqueIdentifier的接口。是给Vendor标识用户用的，每个设备在所属同一个Vender的应用里，都有相同的值。其中的Vender是指应用提供商，但准确点说，是通过BundleID的DNS反转的前两部分进行匹配，如果相同就是同一个Vender，例如对于com.somecompany.appone,com.somecompany.apptwo这两个BundleID来说，就属于同一个Vender，共享同一个idfv的值。和idfa不同的是，idfv的值是一定能取到的，所以非常适合于作为内部用户行为分析的主id，来标识用户，替代OpenUDID。如果用户将属于此Vender的所有App卸载，则idfv的值会被重置，即再重装此Vender的App，idfv的值和之前不同。
 
 获取：[[[UIDevice currentDevice] identifierForVendor] UUIDString]
 
 ---------------------
 
 本文来自 Que_Li 的CSDN 博客 ，全文地址请点击：https://blog.csdn.net/que_li/article/details/76607319?utm_source=copy
 */
- (void) getIDFV
{
    NSString* uuid =[[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSLog(@">>>>> GameApplication getIDFV: %@", uuid);
    [[conchRuntime GetIOSConchRuntime] callbackToJSWithObject:self methodName:@"getIDFV" ret:uuid];
}

- (void) getBundleIdentifier
{
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    NSLog(@">>>>> GameApplication getBundleIdentifier: %@", identifier);
    [[conchRuntime GetIOSConchRuntime] callbackToJSWithObject:self methodName:@"getBundleIdentifier" ret:identifier];
}



// 打开网页
- (void) openURL: (NSString *) url
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];

}

@end
