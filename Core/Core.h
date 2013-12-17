//
//  Core.h
//  Core
//
//  Created by zywang on 13-8-17.
//  Copyright (c) 2013年 zywang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NVSkin.h"
#import "SHPostTaskM.h"
#import "Entironment.h"
#import "SHTask.h"
#import "SHIIOSVersion.h"
#import "Base64.h"
#import "SHVersion.h"
#import "SHCrashManager.h"
#import "SHConfigManager.h"
#import "SHVersion.h"
#import "SHFuck.h"
#import "NSData+AES.h"
#import "NSString+MD5.h"
#import "SHUser.h"
#import "SHTools.h"
#import "IPAddress.h"
#import "SHFlowManager.h"
#import "SHLogger.h"
#import "SHCacheManager.h"
#import "wax.h"

//日志记录
#define CORE_NOTIFICATION_LOG_RECORD LOG_RECORD
//流量表更新
#define CORE_NOTIFICATION_FLOW_UPDATE SHFLOW_PUSH_UPDATE

//配置表更新
#define CORE_NOTIFICATION_CONFIG_STATUS_CHANGED @"core_notification_config_status_changed"
//触发重新登录
#define CORE_NOTIFICATION_LOGIN_RELOGIN @"core_notification_login_relogin"

//重新登录超时时间
#define CODE_RELOGIN -5

//#define SHLog(a) [NSString stringWithFormat:a]
#define SHLog(a,b) [SHLogger Log:[NSString stringWithFormat:a,b]]

//日志
//void SHLogger(NSString *format, ...);
//void SHLogger(NSString *log);
