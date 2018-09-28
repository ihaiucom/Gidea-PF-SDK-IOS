#import "AppDelegate.h"
#import "ViewController.h"
#import "conchRuntime.h"
#import "GameApplication.h"
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

    
    [[GameApplication shareInstance] applicationWillResignActive:application];
}

/**
 (4）回调方法：applicationDidEnterBackground:
 本地通知：UIApplicationDidEnterBackgroundNotification
 触发时机：程序进入后台时调用。
 适宜操作：这个阶段应该保存用户数据，释放一些资源（例如释放数据库资源）。
 */
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[GameApplication shareInstance] applicationDidEnterBackground:application];
    
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

    [[GameApplication shareInstance] applicationWillEnterForeground:application];
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
    
    [[GameApplication shareInstance] applicationDidBecomeActive:application];
}

/**
 （6）回调方法：applicationWillTerminate:
 本地通知：UIApplicationWillTerminateNotification
 触发时机：程序被杀死时调用。
 适宜操作：这个阶段应该进行释放一些资源和保存用户数据。
 */
- (void)applicationWillTerminate:(UIApplication *)application
{
    [[GameApplication shareInstance] applicationWillTerminate:application];
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

// 追踪深度链接
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


//-----------------------------------------------
// AppsFlyerTrackerDelegate 实现方法 结束
//===============================================


@end




