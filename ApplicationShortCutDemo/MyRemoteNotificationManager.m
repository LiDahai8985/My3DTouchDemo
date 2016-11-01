//
//  MyRemoteNotificationManager.m
//  My3DTouchDemo
//
//  Created by LiDaHai on 16/11/1.
//  Copyright © 2016年 Andy. All rights reserved.
//

#import "MyRemoteNotificationManager.h"
#import <UserNotifications/UserNotifications.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface MyRemoteNotificationManager ()<UNUserNotificationCenterDelegate>

@end

@implementation MyRemoteNotificationManager

// 单例
+ (_Nonnull instancetype)shared
{
    __strong static id sharedObj = nil;
    
    static dispatch_once_t p = 0;
    dispatch_once(&p, ^{
        sharedObj = [[self alloc] init];
    });
    
    return sharedObj;
}

// 添加一个本地通知（本地通知可以不注册远程通知，即，可不注册token）
- (void)setLocalNotification
{
    NSString *requestIdentifier = @"requestIdentifier";
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题"; // 只能显示一行
    content.subtitle = @"副副副副副副副副副副副副副副副副副副副副副副副副副副副副副副副副副副副副副副标题";// 只能显示一行
    content.body = @"内容内容内容内容内内容内容内容内容内容内容内容内容内容内容容内容内容内容内容内容";// 顶部时最多两行，点开时全部显示
    content.badge = [NSNumber numberWithInt:1];
    content.sound = [UNNotificationSound defaultSound];
    content.launchImageName = @"search";
    
    // 添加附件
    NSString *attachmentPath = [[NSBundle mainBundle] pathForResource:@"aa" ofType:@".png"];
    NSError *attachmentError = nil;
    NSDictionary *attachmentOptions = @{UNNotificationAttachmentOptionsTypeHintKey:(__bridge id _Nullable)kUTTypeImage,
                                        UNNotificationAttachmentOptionsThumbnailHiddenKey:[NSNumber numberWithBool:NO],
                                         UNNotificationAttachmentOptionsThumbnailClippingRectKey:(__bridge id _Nullable)CGRectCreateDictionaryRepresentation(CGRectMake(0, 0, 0.25, 0.25))};
    UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"attachment1"
                                                                                          URL:[NSURL fileURLWithPath:attachmentPath]
                                                                                      options:attachmentOptions
                                                                                        error:&attachmentError];
    
    NSString *attachmentPath2 = [[NSBundle mainBundle] pathForResource:@"test_1" ofType:@"mp4"];
    NSError *attachmentError2 = nil;
    NSDictionary *attachmentOptions2 = @{UNNotificationAttachmentOptionsTypeHintKey:(__bridge id _Nullable)kUTTypeMPEG4,
                                         UNNotificationAttachmentOptionsThumbnailHiddenKey:[NSNumber numberWithBool:NO],
                                         UNNotificationAttachmentOptionsThumbnailClippingRectKey:(__bridge id _Nullable)CGRectCreateDictionaryRepresentation(CGRectMake(0.75, 0.75, 0.25, 0.25)),
                                         UNNotificationAttachmentOptionsThumbnailTimeKey:[NSNumber numberWithInt:5]};
    UNNotificationAttachment *attachment2 = [UNNotificationAttachment attachmentWithIdentifier:@"attachment2"
                                                                                          URL:[NSURL fileURLWithPath:attachmentPath2]
                                                                                      options:attachmentOptions2
                                                                                        error:&attachmentError2];
    
    // 附件的options可不传，其中的每个key值都有不同的含义
    // 使用kUTTypeImage 或 kUTTypeMPEG4这些字段时，要导入头文件<MobileCoreServices/MobileCoreServices.h>
    
    
    // 设置附件(多个时只显示第一个附件内容，附件支持三种类型，图片音视频，附件必须是本地已有的文件且有大小限制，图片10M,音频5M,视频50M)
    content.attachments = @[attachment2,attachment];
    
    // 触发模式设置
    UNNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
    
    // 创建request
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier
                                                                          content:content
                                                                          trigger:trigger];
    
    // 发出通知
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request
                                                           withCompletionHandler:^(NSError * _Nullable error) {
                                                               if (error) {
                                                                   NSLog(@"-----本地通知-----\n%@",error);
                                                               }
                                                           }];
}

// 打开推送
- (void)registerRemoteNotification
{
    // iOS10以后版本推送权限获取
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_9_x_Max) {
        UNUserNotificationCenter *notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
        notificationCenter.delegate = self;
        [notificationCenter requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound |UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
            NSLog(@"-----iOS10请求推送相关权限-----%d",granted);
            if (granted) {
                [notificationCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    NSLog(@"-----iOS10推送相关权限-----%@",settings);
                }];
            }
        }];
    } else {
        // iOS10 以前的推送类型设置
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil]];
    }
    
    // 注册token
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}


// 返回deviceToken
- (void)didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken
{
    NSString *deviceTokenString = [NSString stringWithFormat:@"%@",deviceToken];
    if (deviceTokenString && deviceTokenString.length > 1) {
        NSLog(@"-------token--------\n%@",[deviceTokenString substringWithRange:NSMakeRange(1, deviceTokenString.length - 2)]);
    }
}

// 注册deviceToken失败
- (void)didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error
{
    NSLog(@"-------注册token失败--------\n%@",error.localizedDescription);
}

// iOS10之前推送消息处理
- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"-------iOS10之前推送消息处理--------\n%@",userInfo);
}

// iOS10之后，应用前台收到推送消息（应用在打开时收到消息通知）
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    NSLog(@"-------iOS10之后，应用前台收到推送消息--------");
    [self remoteNotificationHandler:notification];
    
    // 执行这个方法，客户端在前台时是否提醒用户，有Badge、Sound、Alert三种类型可以设置，如果设置了，应用在打开时也能像后台收到推送时一样在顶部弹出消息框
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}


// iOS10之后，应用后台收到推送消息
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
{
    NSLog(@"-------iOS10之后，应用后台收到推送消息--------");
    [self remoteNotificationHandler:response.notification];
    completionHandler();
}

// 对推送消息处理
- (void)remoteNotificationHandler:(UNNotification *)notification
{
    // 推送具体消息内容
    NSDictionary *userInfo = notification.request.content.userInfo;
    
    // 推送消息标题
    NSString *title = notification.request.content.title;
    
    // 推送消息副标题
    NSString *subtitle = notification.request.content.subtitle;
    
    // 推送消息体
    NSString *body = notification.request.content.body;
    
    // 推送消息角标
    NSNumber *badgeNum = notification.request.content.badge;
    
    // 推送提醒声音
    UNNotificationSound *sound = notification.request.content.sound;
    
    NSLog(@"---->推送消息：\nuserInfo:%@\nbadgeNum:%@\nbody:%@\nsound:%@\ntitle:%@\nsubtitle:%@",userInfo,badgeNum,body,sound,title,subtitle);
    
    // 根据不同推送类型进行处理
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"--------远程推送消息处理-------");
    } else if ([notification.request.trigger isKindOfClass:[UNTimeIntervalNotificationTrigger class]]) {
        NSLog(@"--------本地: 一定时间之后，重复或者不重复推送通知。我们可以设置timeInterval（重复的时间间隔）和repeats（是否重复）-------");
    } else if ([notification.request.trigger isKindOfClass:[UNCalendarNotificationTrigger class]]) {
        NSLog(@"--------本地: 一定日期之后，重复或者不重复推送通知 例如，你每天8点推送一个通知，只要dateComponents为8，如果你想每天8点都推送这个通知，只要repeats为YES就可以了");
    } else if ([notification.request.trigger isKindOfClass:[UNLocationNotificationTrigger class]]) {
        NSLog(@"--------本地: 地理位置的一种通知，当用户进入或离开一个地理区域来通知。在CLRegion标识符必须是唯一的。因为如果相同的标识符来标识不同区域的UNNotificationRequests，会导致不确定的行为");
    }
}

@end
