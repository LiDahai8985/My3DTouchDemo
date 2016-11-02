//
//  NotificationService.m
//  My3DTouchNotificationServiceExtension
//
//  Created by LiDaHai on 16/11/2.
//  Copyright © 2016年 Andy. All rights reserved.
//
//  ***注***
//  1、联机调试此功能时，请将xcode工程左上角的target选择为本文件归属的target（如本demo中应该选择My3DTouchNotificationServiceExtension）
//  2、选完正确的target后点击运行后，根据提示，选择对应的程序（如本demo中应该选的是3DTouchDemo）
//  3、想要实现远程推送推新版推送消息类型样式，推送内容中aps对应的字典中一定要包含"mutable-content":"1"和"alert":"..."两个字段内容，其他字段可以自定义


#import "NotificationService.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    //根据推送内容获取附件信息
    NSDictionary *userInfo = self.bestAttemptContent.userInfo;
    NSDictionary *apsDic = userInfo[@"aps"];
    NSString *contentUrl = [NSString stringWithFormat:@"%@",apsDic[@"url"]];
    
    // Modify the notification content here...
    self.bestAttemptContent.title = @"";
    self.bestAttemptContent.subtitle = @"";
    self.bestAttemptContent.body = request.content.body;
    
    // 设置categoryIdentifier，对应notificationContentExtension的plist文件中设置的categoryIdentifier，若无对应其中设置后的id，则不会调用NotificationViewController中的方法
    self.bestAttemptContent.categoryIdentifier = @"category12";
    
    if (!contentUrl.length) {
        // 不执行下面这句，不会弹出推送提醒框
        self.contentHandler(self.bestAttemptContent);
    }
    
    // 加载附件内容
    [self loadAttachmentContentWithUrl:contentUrl
                                  type:@"png"
                     completionHandler:^(UNNotificationAttachment *attachment) {
        if (attachment) {
            self.bestAttemptContent.attachments = @[attachment];
        }
        
        // 通知
        self.contentHandler(self.bestAttemptContent);
    }];
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}


// 加载附件内容
- (void)loadAttachmentContentWithUrl:(NSString *)url
                                type:(NSString *)type
                   completionHandler:(void (^)(UNNotificationAttachment *attachment))completionHandler
{
    
    __block UNNotificationAttachment *attachment = nil;
    NSURL *attachmentURL = [NSURL URLWithString:url];
    NSString *fileExt = [self fileExtensionForMediaType:type];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session downloadTaskWithURL:attachmentURL
                completionHandler:^(NSURL *temporaryFileLocation, NSURLResponse *response, NSError *error) {
                    if (error != nil) {
                        NSLog(@"%@", error.localizedDescription);
                    } else {
                        NSFileManager *fileManager = [NSFileManager defaultManager];
                        NSURL *localURL = [NSURL fileURLWithPath:[temporaryFileLocation.path stringByAppendingString:fileExt]];
                        [fileManager moveItemAtURL:temporaryFileLocation toURL:localURL error:&error];
                        
                        NSError *attachmentError = nil;
                        attachment = [UNNotificationAttachment attachmentWithIdentifier:@"" URL:localURL options:nil error:&attachmentError];
                        if (attachmentError) {
                            NSLog(@"%@", attachmentError.localizedDescription);
                        }
                    }
                    
                    completionHandler(attachment);
                    
                    
                }] resume];
    
    
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"9" ofType:@".png"];
//    UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"123"
//                                                                                          URL:[NSURL fileURLWithPath:path]
//                                                                                      options:nil
//                                                                                        error:nil];
//    completionHandler(attachment);
}


- (NSString *)fileExtensionForMediaType:(NSString *)type {
    NSString *ext = type;
    
    
    if ([type isEqualToString:@"image"]) {
        ext = @"jpg";
    }
    
    if ([type isEqualToString:@"video"]) {
        ext = @"mp4";
    }
    
    if ([type isEqualToString:@"audio"]) {
        ext = @"mp3";
    }
    
    return [@"." stringByAppendingString:ext];
}


@end
