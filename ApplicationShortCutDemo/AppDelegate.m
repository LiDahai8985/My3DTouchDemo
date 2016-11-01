//
//  AppDelegate.m
//  ApplicationShortCutDemo
//
//  Created by 张好志 on 15/10/22.
//  Copyright © 2015年 Andy. All rights reserved.
//

#import "AppDelegate.h"
#import "MyNavigationController.h"
#import "MyForceTouchManager.h"
#import "MyRemoteNotificationManager.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<UIAlertViewDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UITraitCollection *traitCollection;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 3DTouch 处理
    [[MyForceTouchManager shared] forceTouchHandler];
    
    // 打开推送
    [[MyRemoteNotificationManager shared] registerRemoteNotification];
    
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // 桌面应用图标icon 数字清除
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // 添加本地推送
    [[MyRemoteNotificationManager shared] setLocalNotification];
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

#pragma mark- *******************推送相关*******************
// 返回deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken
{
    [[MyRemoteNotificationManager shared] didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error
{
    [[MyRemoteNotificationManager shared] didFailToRegisterForRemoteNotificationsWithError:error];
}

// iOS7之前收到推送消息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo
{
    NSLog(@"-------iOS7之前推送消息处理--------\n%@",userInfo);
    [[MyRemoteNotificationManager shared] didReceiveRemoteNotification:userInfo];
}

// iOS7~10推送消息处理（此方法声明之后不会再调用application:didReceiveRemoteNotification：方法）
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    NSLog(@"-------iOS7~10推送消息处理--------\n%@",userInfo);
    [[MyRemoteNotificationManager shared] didReceiveRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark- *******************3DTouch 相关*******************

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler{
    
    // 3DTouch item点击事件处理
    [[MyForceTouchManager shared] performActionForShortcutItem:shortcutItem completionHandler:completionHandler];
}

@end
