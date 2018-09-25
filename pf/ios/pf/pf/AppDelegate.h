#import <UIKit/UIKit.h>
#import "LaunchView.h"
#import <AppsFlyerLib/AppsFlyerTracker.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate, AppsFlyerTrackerDelegate>
{
@public
    UIBackgroundTaskIdentifier m_kBackgroundTask;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LaunchView *launchView;
@end
