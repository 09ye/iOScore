//
//  SHAppDelegate.m
//  siemens.bussiness.partner.CRM.tool
//
//  Created by WSheely on 14-3-6.
//  Copyright (c) 2014年 MobilityChina. All rights reserved.
//

#import "SHAppDelegate.h"
#import "ViewController.h"

@implementation SHAppDelegate

@synthesize viewController;

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    //NSLog(@"%@", [url absoluteString]);
    NSArray * args = [[url query] componentsSeparatedByString:@"&"];
    SHIntent * intent = [[SHIntent alloc]init];
    intent.target = [url host];
    for (NSString* arg  in args) {
        NSArray* a =[arg componentsSeparatedByString:@"="];
        if(a.count > 1) {
            [intent.args setValue:[a objectAtIndex:1] forKey:[a objectAtIndex:0]];
        }
    }
    [[UIApplication sharedApplication]open:intent];
    return YES;
}
@end
