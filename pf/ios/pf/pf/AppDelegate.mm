#import "AppDelegate.h"
#import "ViewController.h"
#import "conchRuntime.h"
#import <AppsFlyerLib/AppsFlyerTracker.h>

@implementation AppDelegate

/*
 帮助文档
 iOS中的程序的五种状态 https://www.cnblogs.com/pangbin/p/5412784.html
 
 */





/**
 (1）回调方法：application:didFinishLaunchingWithOptions:
 本地通知：UIApplicationDidFinishLaunchingNotification
 触发时机：程序启动并进行初始化的时候后。
 适宜操作：这个阶段应该进行根视图的创建。
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
    ViewController* pViewController  = [[ViewController alloc] init];
    _window.rootViewController = pViewController;
    [_window makeKeyAndVisible];
    
    _launchView = [[LaunchView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_window.rootViewController.view addSubview:_launchView.view];
    
    
    // ZF 隐藏状态栏
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    // AppsFlayer SDK 初始化
    [self initAppsFlyer:application];
    
    

    return YES;
    
}


/*
 （3）回调方法：applicationWillResignActive:
 本地通知：UIApplicationWillResignActiveNotification
 触发时机：从活动状态进入非活动状态。
 适宜操作：这个阶段应该保存UI状态（例如游戏状态）。
 */
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

/**
 (4）回调方法：applicationDidEnterBackground:
 本地通知：UIApplicationDidEnterBackgroundNotification
 触发时机：程序进入后台时调用。
 适宜操作：这个阶段应该保存用户数据，释放一些资源（例如释放数据库资源）。
 */
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    m_kBackgroundTask = [application beginBackgroundTaskWithExpirationHandler:^{
        if(m_kBackgroundTask != UIBackgroundTaskInvalid )
        {
            NSLog(@">>>>>backgroundTask end");
            [application endBackgroundTask:m_kBackgroundTask];
            m_kBackgroundTask = UIBackgroundTaskInvalid;
        }
    }];
}

/**
 （5）回调方法：applicationWillEnterForeground：
 本地通知：UIApplicationWillEnterForegroundNotification
 触发时机：程序进入前台，但是还没有处于活动状态时调用。
 适宜操作：这个阶段应该恢复用户数据。
 */
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

/**
 （2）回调方法：applicationDidBecomeActive：
 本地通知：UIApplicationDidBecomeActiveNotification
 触发时机：程序进入前台并处于活动状态时调用。
 适宜操作：这个阶段应该恢复UI状态（例如游戏状态）。
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
    // AppsFlayer SDK 程序进入前台并处于活动状态时调用。
    [self setAppsFlyerDidBecomeActive:application];
}

/**
 （6）回调方法：applicationWillTerminate:
 本地通知：UIApplicationWillTerminateNotification
 触发时机：程序被杀死时调用。
 适宜操作：这个阶段应该进行释放一些资源和保存用户数据。
 */
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


//===============================================
// AppsFlyerTrackerDelegate 实现方法 开始
// https://support.appsflyer.com/hc/zh-cn/articles/207032066-AppsFlyer-SDK-对接-iOS
//-----------------------------------------------


// AppsFlayer SDK 初始化
- (void)initAppsFlyer:(UIApplication *)application
{
    [AppsFlyerTracker sharedTracker].appsFlyerDevKey = @"Tm6NpyjCqyyJUHXKMDvewJ";
    [AppsFlyerTracker sharedTracker].appleAppID = @"1434375733";
    [AppsFlyerTracker sharedTracker].delegate = self;
#ifdef DEBUG
    [AppsFlyerTracker sharedTracker].isDebug = true;
#endif
}



// AppsFlayer SDK 程序进入前台并处于活动状态时调用。
- (void) setAppsFlyerDidBecomeActive:(UIApplication *)application
{
    // Track Installs, updates & sessions(app opens) (You must include this API to enable tracking)
    [[AppsFlyerTracker sharedTracker] trackAppLaunch];
}

- (void) onConversionDataReceived:(NSDictionary*) installData
{
    
}
- (void) onConversionDataRequestFailure:(NSError *)error
{
    
}
- (void) onAppOpenAttribution:(NSDictionary*) attributionData
{
    
}
- (void) onAppOpenAttributionFailure:(NSError *)error
{
    
}


//-----------------------------------------------
// AppsFlyerTrackerDelegate 实现方法 结束
//===============================================

//===============================================
// AppsFlyerTrackerDelegate 追踪应用内事件 开始
//-----------------------------------------------

// 注册完成
- (void) onAppsFlyerRegistation:(NSDictionary*) installData
{
    [[AppsFlyerTracker sharedTracker] trackEvent:AFEventCompleteRegistration
                                      withValues: @{
                                                    AFEventParamRegistrationMethod: @"Facebook"
                                                    }];
    //[[AppsFlyerTracker sharedTracker] trackEvent: AFEventPurchase withValues:@{
    //                                                                           AFEventParamRevenue: @"0", AFEventParamCurrency: @"Registation"
    //                                                                           }];
}

// 登陆游戏
- (void) onAppsFlyerLogin:(NSDictionary*) installData
{
    [[AppsFlyerTracker sharedTracker] trackEvent:AFEventLogin withValues: nil];
    //[[AppsFlyerTracker sharedTracker] trackEvent: AFEventPurchase withValues:@{
    //                                                                           AFEventParamRevenue: @"0", AFEventParamCurrency: @"Login"
    //                                                                           }];
}

// 完成新手引导
- (void) onAppsFlyerTutorial:(NSDictionary*) installData
{
    [[AppsFlyerTracker sharedTracker] trackEvent:AFEventTutorial_completion
                                      withValues: @{
                                                    AFEventParamSuccess: @TRUE,
                                                    AFEventParamTutorialId: @"3",
                                                    AFEventParamContent: @"Getting Started"
                                                    }];
    //[[AppsFlyerTracker sharedTracker] trackEvent: AFEventPurchase withValues:@{
    //                                                                           AFEventParamRevenue: @"0", AFEventParamCurrency: @"Tutorial"
    //                                                                           }];
}

// 玩家等级提升
- (void) onAppsFlyerLevelAchieved:(NSDictionary*) installData
{
    [[AppsFlyerTracker sharedTracker] trackEvent: AFEventLevelAchieved withValues:@{
                                                                                    AFEventParamLevel: installData,
                                                                                    AFEventParamScore : @100
                                                                                    }];
}

// 玩家充值
- (void) onAppsFlyerPurchase:(NSDictionary*)appContentID :(NSDictionary*) costVal
{
    [[AppsFlyerTracker sharedTracker] trackEvent: AFEventPurchase withValues:@{
                                                                               AFEventParamContentId:appContentID,
                                                                               AFEventParamContentType : @"category_a",
                                                                               AFEventParamRevenue: costVal,
                                                                               AFEventParamCurrency:@"USD"
                                                                               }];
}
// 其他事件通用
// eventName 事件名称
// values af值（json）
/**
 示例：
 {
 "af_revenue":"50.87",
 "af_currency":"USD",
 "af_receipt_id":"57601333",
 "product":[
 {
 "af_content_id":"1164_8186",
 "af_price":"8.97",
 "af_quantity":"1"
 },
 {
 "af_content_id":"1164_8186",
 "af_price":"8.97",
 "af_quantity":"1"
 },
 {
 "af_content_id":"1164_8186",
 "af_price":"8.97",
 "af_quantity":"1"
 },
 {
 "af_content_id":"1177_8185",
 "af_price":"8.97",
 "af_quantity":"1"
 },
 {
 "af_content_id":"0153_9077",
 "af_price":"14.99",
 "af_quantity":"1"
 }
 ]
 }

 */
- (void) trackEvent:(NSString *)eventName withValues:(NSDictionary*)values
{
    
}


/*
- (void) onAppsFlyerTracker:(NSDictionary*) installData
{
    // 达到级别的应用内事件
    [[AppsFlyerTracker sharedTracker] trackEvent: AFEventLevelAchieved withValues:@{
                                                                                    AFEventParamLevel: @9,
                                                                                    AFEventParamScore : @100
                                                                                    }];
    
    [[AppsFlyerTracker sharedTracker] trackEvent: AFEventPurchase withValues: @{
                                                                                AFEventParamRevenue: @"1200", AFEventParamCurrency: @"JPY"
                                                                                }];
    // 追踪收入
    [[AppsFlyerTracker sharedTracker] trackEvent: AFEventPurchase withValues:@{
                                                                               AFEventParamContentId:@"1234567",
                                                                               AFEventParamContentType : @"category_a",
                                                                               AFEventParamRevenue: @1.99,
                                                                               AFEventParamCurrency:@"USD"
                                                                               }];
    // 获取 AppsFlyer Device ID
    // NSString *appsflyerId = [AppsFlyerTracker sharedTracker].getAppsFlyerUID;
    // Set Customer User ID
    // [AppsFlyerTracker sharedTracker].customerUserID= @"my user id";
    // 收集用户电子邮件地址
    // [[AppsFlyerTracker sharedTracker] setUserEmails:@[@"email1@domain.com",@"email2@domain.com"] withCryptType:EmailCryptTypeSHA1];
    // 设置货币代码
    // [AppsFlyerTracker sharedTracker].currencyCode= @"USD";
    // 在某些极端情况下，您可能出于法律和隐私合规方面的考虑，希望关闭所有 SDK 追踪。使用 isStopTracking API 可实现此功能。一旦调用该 API，SDK 将停止运行，不再与服务器通信。
    // [AppsFlyerTracker sharedTracker].isStopTracking= true;
    // AppsFlyer SDK 允许您收集设备名称以作内部分析之用。此项功能默认是关闭的。使用以下 API 开启此项功能：
    // [AppsFlyerTracker sharedTracker].shouldCollectDeviceName= NO;
}
 */

//追踪深度链接
/*
// Reports app open from a Universal Link for iOS 9 or above
- (BOOL) application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *_Nullable))restorationHandler {
    [[AppsFlyerTracker sharedTracker] continueUserActivity:userActivity restorationHandler:restorationHandler];
    return YES;
}

// Reports app open from deep link from apps which do not support Universal Links (Twitter) and for iOS8 and below
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation {
    [[AppsFlyerTracker sharedTracker] handleOpenURL:url sourceApplication:sourceApplication withAnnotation:annotation];
    return YES;
}
// Reports app open from deep link for iOS 10
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
            options:(NSDictionary *) options {
    [[AppsFlyerTracker sharedTracker] handleOpenUrl:url options:options];
    return YES;
}
*/
// 要启用通过推送通知追踪应用启动，需要在 App Delegate 中添加下列代码
/*
-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[AppsFlyerTracker sharedTracker] handlePushNotification:userInfo];
}
*/
// af 参数
/*{
    "aps": {
        "alert": "Push text",
        "sound": "default",
        "category": "REMINDER_CATEGORY"
    },
    "_p": 123456,
    "payloadKey": "payloadValue"
    "af": {
        "pid": "swrve_int",
        "is_retargeting": true,
        "c": "test_campaign"
    }
}
 */

// 应用内购买的服务器验证
// 该函数支持 iOS7 和更高版本。
/*
- (void) validateAndTrackInAppPurchase:(NSString *) productIdentifier
                                 price:(NSString *) price
                              currency:(NSString *) currency
                         transactionId:(NSString *) tranactionId
                  additionalParameters:(NSDictionary *) params
                               success:(void (^)(NSDictionary *response)) successBlock
                               failure:(void (^)(NSError *error, id reponse)) failedBlock;
*/
 
 
 // 示例
/*
 
 [[AppsFlyerTracker sharedTracker] validateAndTrackInAppPurchase:product.productIdentifierprice:product.price.stringValue
 currency:@"USD"
 transactionId:trans.transactionIdentifier
 additionalParameters:@{@"test": @"val" , @"test1" : @"val 1"}
 success:^(NSDictionary *result){
 NSLog(@"Purchase succeeded And verified!!! response: %@", result[@"receipt"]);
 } failure:^(NSError *error, id response) {
 NSLog(@"response = %@", response);
 }];
 */


//-----------------------------------------------
// AppsFlyerTrackerDelegate 追踪应用内事件 结束
//===============================================

@end




