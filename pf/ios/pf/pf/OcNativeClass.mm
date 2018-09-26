//
//  OcNativeClass.m
//  pf
//
//  Created by gidea on 2018/9/25.
//  Copyright © 2018年 pf. All rights reserved.
//

#import "OcNativeClass.h"
#import <conchRuntime.h>
#import <Foundation/NSString.h>
#import <AppsFlyerLib/AppsFlyerTracker.h>
@implementation OcNativeClass
-(void) operatorWith:(NSNumber*)x and:(NSNumber*)y
{// 测试
    int result = 0;
    if ([self.op isEqualToString:@"+"]){
        result = x.intValue + y.intValue;
    }
    else if ([self.op isEqualToString:@"-"]){
        result = x.intValue - y.intValue;
    }
    [[conchRuntime GetIOSConchRuntime] callbackToJSWithObject:self methodName:@"operatorWith:and:" ret:[NSNumber numberWithInt:result]];
}


// 注册完成
- (void) onAppsFlyerRegistation:(NSNumber*) installData
{
    [[AppsFlyerTracker sharedTracker] trackEvent:AFEventCompleteRegistration
                                      withValues: @{
                                                    AFEventParamRegistrationMethod: @"Facebook"
                                                    }];
    NSLog(@">>>>>objc ios注册完成 onAppsFlyerRegistation");
}

// 登陆游戏
- (void) onAppsFlyerLogin:(NSNumber*) installData
{
    [[AppsFlyerTracker sharedTracker] trackEvent:AFEventLogin withValues: nil];
    NSLog(@">>>>>objc ios登陆游戏 onAppsFlyerLogin %@",installData);
}

// 完成新手引导
- (void) onAppsFlyerTutorial:(NSNumber*) installData
{
    [[AppsFlyerTracker sharedTracker] trackEvent:AFEventTutorial_completion
                                      withValues: @{
                                                    AFEventParamSuccess: @TRUE,
                                                    AFEventParamTutorialId: @"3",
                                                    AFEventParamContent: @"Getting Started"
                                                    }];
    NSLog(@">>>>>objc ios完成新手引导 onAppsFlyerTutorial");
}

// 玩家等级提升
- (void) onAppsFlyerLevelAchieved:(NSNumber*) installData
{
    [[AppsFlyerTracker sharedTracker] trackEvent: AFEventLevelAchieved withValues:@{
                                                                                    AFEventParamLevel: installData,
                                                                                    AFEventParamScore : @100
                                                                                    }];
    NSLog(@">>>>>objc ios玩家等级提升 onAppsFlyerLevelAchieved:%@",installData);
}

// 玩家充值
- (void) onAppsFlyerPurchase:(NSNumber*)appContentID and:(NSNumber*)costVal
{
    [[AppsFlyerTracker sharedTracker] trackEvent: AFEventPurchase withValues:@{
                                                                               AFEventParamContentId:appContentID,
                                                                               AFEventParamContentType : @"category_a",
                                                                               AFEventParamRevenue: costVal,
                                                                               AFEventParamCurrency:@"USD"
                                                                               }];
    NSLog(@">>>>>objc ios玩家充值 onAppsFlyerPurchase:%@,%@",appContentID,costVal);
}

@end
