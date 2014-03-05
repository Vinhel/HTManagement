//
//  AppDelegate.m
//  HTManagement
//
//  Created by lyn on 13-12-17.
//  Copyright (c) 2013年 SFI-china. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"

#import "BPush.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"lauchoptions %@",launchOptions);
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.window.backgroundColor = [UIColor whiteColor];
    LoginViewController *loginVC = [[LoginViewController alloc]init];


    UINavigationController *nav1 =[[UINavigationController alloc]initWithRootViewController:loginVC];
    //   FirstViewController *viewVC = [FirstViewController new];
    // UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewVC];
    //UITabBarController *tab = [[UITabBarController alloc]init];
   // tab.viewControllers = [NSArray arrayWithObjects:nav,loginVC, nil];
    
    nav1.tabBarItem.title = @"hello";
    self.window.rootViewController = loginVC;
    [BPush setupChannel:launchOptions];
    [BPush setDelegate:self];
    
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeAlert| UIRemoteNotificationTypeBadge| UIRemoteNotificationTypeSound];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
     NSLog(@"test:%@",deviceToken);
    [BPush registerDeviceToken: deviceToken];
    [BPush bindChannel];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
   // NSLog(@"Receive Notify: %@", [userInfo JSONString]);
    NSLog(@"userinfo %@",userInfo);
    NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    if (application.applicationState == UIApplicationStateActive) {
        // Nothing to do if applicationState is Inactive, the iOS already displayed an alert view.
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"收到新的通知"
                                                            message:[NSString stringWithFormat:@"%@", alert]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    [application setApplicationIconBadgeNumber:0];
    
    [BPush handleNotification:userInfo];
    
  
}

- (void) onMethod:(NSString*)method response:(NSDictionary*)data {
    NSLog(@"On method:%@", method);
    NSLog(@"data:%@", [data description]);
    NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
    if ([BPushRequestMethod_Bind isEqualToString:method]) {
        NSString *appid = [res valueForKey:BPushRequestAppIdKey];
        NSString *userid = [res valueForKey:BPushRequestUserIdKey];
        NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
        NSLog(@"appid %@",appid);
        NSLog(@"channelid %@",channelid);
        NSLog(@"userid %@",userid);
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    //[[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"ff"]];
    //UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
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

@end
