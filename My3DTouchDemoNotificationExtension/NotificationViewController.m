//
//  NotificationViewController.m
//  My3DTouchDemoNotificationExtension
//
//  Created by LiDaHai on 16/11/1.
//  Copyright © 2016年 Andy. All rights reserved.
//
//
//
//  注：1、联机调试此功能时，请将xcode工程左上角的target选择为本文件归属的target（如本demo中应该选择My3DTouchNotificationContentExtension
//     2、info.plist中的UNNotificationExtensionDefaultContentHidden字段对应的内容如果为YES，系统会用自定义xib中的布局，为NO时，用系统默认风格布局
//     3、info.plist文件中设置的UNNotificationExtensionCategory对应的内容在包含NotificationService文件中接收到推送内容的categoryIdentifier时才会调用本文件中的相关方法
//



#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface NotificationViewController () <UNNotificationContentExtension>

@property IBOutlet UIImageView *contentImgView;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
}


// 收到推送消息
- (void)didReceiveNotification:(UNNotification *)notification {
    NSDictionary *userInfo = notification.request.content.userInfo;
    NSLog(@"------contentExtension-userInfo--------\n%@",userInfo);
    
    if (notification.request.content.attachments.count > 0) {
        UNNotificationAttachment *attachment = notification.request.content.attachments.firstObject;
        self.contentImgView.image = [UIImage imageWithContentsOfFile:attachment.URL.absoluteString];
    }
}


// 播放按钮样式
- (UNNotificationContentExtensionMediaPlayPauseButtonType)mediaPlayPauseButtonType
{
    return UNNotificationContentExtensionMediaPlayPauseButtonTypeNone;
}

// 播放按钮的frame
- (CGRect)mediaPlayPauseButtonFrame
{
    return CGRectMake([UIScreen mainScreen].bounds.size.width/2.0 - 50, 100, 100, 100);
}

// 播放按钮的颜色
- (UIColor *)mediaPlayPauseButtonTintColor
{
    return [UIColor redColor];
}


// 播放
- (void)mediaPlay
{
    
}


// 暂停
- (void)mediaPause
{
    
}

@end
