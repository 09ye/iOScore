//
//  SHLocationManager.m
//  Core
//
//  Created by WSheely on 14-10-8.
//  Copyright (c) 2014年 zywang. All rights reserved.
//

#import "SHLocationManager.h"

static SHLocationManager * __instance;

@implementation SHLocationManager

@synthesize userlocation;

- (SHLocationManager*)init
{
    if(self = [super init]){
        if(iOS8){
            
            CLLocationManager * locationManager =[[CLLocationManager alloc] init];
            //    [locationManager requestAlwaysAuthorization];//用这个方法，plist中需要NSLocationAlwaysUsageDescription
            [locationManager requestWhenInUseAuthorization];//用这个方法，plist里要加字段NSLocationWhenInUseUsageDescription
        }

        _bmkservice = [[BMKLocationService alloc]init];
        _bmkservice.delegate = self;
        
    }
    return self;
}

- (void)startUserLocationService
{
    [_bmkservice startUserLocationService];
}

- (void)stopUserLocationService
{
    [_bmkservice stopUserLocationService];
}


+ (SHLocationManager*)instance
{
    if(__instance ==nil){
        
        __instance = [[SHLocationManager alloc]init];
    }
    return __instance;
}
/**
 *在将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser
{
    
}

/**
 *在停止定位后，会调用此函数
 */
- (void)didStopLocatingUser
{
    
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    SHUserLocation * location = [[SHUserLocation alloc]init];
    location.location = userLocation.location;
    location.heading = userLocation.heading;
    location.source = userLocation;
    self.userlocation = location;
    [[NSNotificationCenter defaultCenter]postNotificationName:CORE_NOTIFICATION_LOCATION_UPDATE_USERLOCATION object:self.userlocation];
    
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    SHUserLocation * location = [[SHUserLocation alloc]init];
    location.location = userLocation.location;
    location.heading = userLocation.heading;
    location.source = userLocation;
    self.userlocation = location;
    [[NSNotificationCenter defaultCenter]postNotificationName:CORE_NOTIFICATION_LOCATION_UPDATE_USERHEAD object:self.userlocation];

}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    
}

@end
