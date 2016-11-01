//
//  MyRemoteNotificationManager.h
//  My3DTouchDemo
//
//  Created by LiDaHai on 16/11/1.
//  Copyright © 2016年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyRemoteNotificationManager : NSObject

+ (_Nonnull instancetype)shared;

// 添加一个本地通知
- (void)setLocalNotification;

// 注册token
- (void)registerRemoteNotification;

// 返回deviceToken
- (void)didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken;

// 注册deviceToken失败
- (void)didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error;

// iOS10之前收到推送消息
- (void)didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo;

@end
