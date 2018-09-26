//
//  OcNativeClass.m
//  pf
//
//  Created by gidea on 2018/9/25.
//  Copyright © 2018年 pf. All rights reserved.
//

#import <Foundation/NSObject.h>
@interface OcNativeClass: NSObject
@property (nonatomic) NSString* op;
-(void) operatorWith:(NSNumber*)x and:(NSNumber*)y;
-(void) onAppsFlyerRegistation:(NSNumber*) installData;
-(void) onAppsFlyerLogin:(NSNumber*) installData;
-(void) onAppsFlyerTutorial:(NSNumber*) installData;
-(void) onAppsFlyerLevelAchieved:(NSNumber*) installData;
-(void) onAppsFlyerPurchase:(NSNumber*)appContentID and:(NSNumber*)costVal;
@end
