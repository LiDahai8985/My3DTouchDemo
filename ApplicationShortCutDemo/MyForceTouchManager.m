//
//  MyForceTouchManager.m
//  My3DTouchDemo
//
//  Created by LiDaHai on 16/11/1.
//  Copyright © 2016年 Andy. All rights reserved.
//

#import "MyForceTouchManager.h"
#import "AppDelegate.h"

@interface MyForceTouchManager ()

@property (strong, nonatomic) UITraitCollection *traitCollection;

@end

@implementation MyForceTouchManager

+ (_Nonnull instancetype)shared
{
    __strong static id sharedObj = nil;
    
    static dispatch_once_t p = 0;
    dispatch_once(&p, ^{
        sharedObj = [[self alloc] init];
    });
    
    return sharedObj;
}

- (UITraitCollection *)traitCollection {
    if (!_traitCollection) {
        _traitCollection = [UITraitCollection traitCollectionWithForceTouchCapability:UIForceTouchCapabilityAvailable];
    }
    return _traitCollection;
}

- (void)forceTouchHandler
{
    //**********自定义相关***********
    UIApplication *app = [UIApplication sharedApplication];
    
    if ((floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_8_4)) {
        //判断3Dtouch权限
        if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable){
            NSLog(@"---3DTouch可用---");
            
            //获取一个应用程序对象的shortcutItem列表
            id existingShortcutItems = [app shortcutItems];
            
            
            NSLog(@"-----existingShortcutItems0----->%@",existingShortcutItems);
            
            if ([existingShortcutItems count] > 0) {
                
                NSLog(@"------existingShortcutItems1------->%@",existingShortcutItems);
                
                //获取第0个shortcutItem
                id oldItem = [existingShortcutItems objectAtIndex: 0];
                //将旧的shortcutItem改变为可修改类型shortcutItem
                id mutableItem = [oldItem mutableCopy];
                
                NSLog(@"------mutableItem1------->%@",mutableItem);
                
                //修改shortcutItem的显示标题
                [mutableItem setLocalizedTitle: @"Click Lewis"];
                [mutableItem setLocalizedSubtitle:[NSString stringWithFormat:@"换%@",[NSDate date]]];
                [mutableItem setIcon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeLove]];
                [mutableItem setUserInfo:nil];
                
                NSLog(@"------mutableItem2------->%@",mutableItem);
                
                // 根据旧的shortcutItems生成可变shortcutItems数组
                id updatedShortcutItems = [existingShortcutItems mutableCopy];
                // 修改可变shortcutItems数组中对应index下的元素为新的shortcutItem
                [updatedShortcutItems replaceObjectAtIndex: 0 withObject: mutableItem];
                // 修改应用程序对象的shortcutItems为新的数组
                [app setShortcutItems: updatedShortcutItems];
                NSLog(@"------updatedShortcutItems------->%@",updatedShortcutItems);
            }
            else
            {
                // 第一次安装没有将shortcutItem，则添加shortcutItems
                UIApplicationShortcutItem *mutableItem1 = [[UIApplicationShortcutItem alloc] initWithType:@"UITouchText.look" localizedTitle:@"第一次添加" localizedSubtitle:@"有1了吧____00:00" icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeCompose] userInfo:nil];
                UIApplicationShortcutItem *mutableItem2 = [[UIApplicationShortcutItem alloc] initWithType:@"UITouchText.look" localizedTitle:@"第一次添加" localizedSubtitle:@"有2了吧____00:00" icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypePlay] userInfo:nil];
                UIApplicationShortcutItem *mutableItem3 = [[UIApplicationShortcutItem alloc] initWithType:@"UITouchText.look" localizedTitle:@"第一次添加" localizedSubtitle:@"有3了吧____00:00" icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeAdd] userInfo:nil];
                UIApplicationShortcutItem *mutableItem4 = [[UIApplicationShortcutItem alloc] initWithType:@"UITouchText.look" localizedTitle:@"第一次添加" localizedSubtitle:@"有4了吧____00:00" icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeLocation] userInfo:nil];
                
                NSLog(@"------mutableItem5------->%@",mutableItem1);
                
                // 修改应用程序对象的shortcutItems为新的数组
                [[UIApplication sharedApplication] setShortcutItems: @[mutableItem1, mutableItem2,mutableItem3,mutableItem4,mutableItem4,mutableItem4]];
            }
            //***************end******************
            
            // 如果不需要自定义，不需要在客户端里修改shortcutItem内容或类型也可以在infoPlist文件中添加，如下：
            /***
             
             在infoPlist中添加UIApplicationShortcutItems
             https://developer.apple.com/library/ios/documentation/General/Reference/InfoPlistKeyReference/Articles/iPhoneOSKeys.html#//apple_ref/doc/uid/TP40009252-SW36
             https://developer.apple.com/library/ios/documentation/General/Reference/InfoPlistKeyReference/Art/UIApplicationShortcutItems_plist_editor_2x.png
             
             ****/
            
        }
    }

}

- (void)performActionForShortcutItem:(nonnull UIApplicationShortcutItem *)shortcutItem completionHandler:(nonnull void(^)(BOOL succeeded))completionHandler{
    // 判断先前我们设置的唯一标识
    if([shortcutItem.type isEqualToString:@"UITouchText.share"]){
        NSArray *arr = @[@"hello 3D Touch"];
        UIActivityViewController *vc = [[UIActivityViewController alloc]initWithActivityItems:arr applicationActivities:nil];
        // 设置当前的VC 为rootVC
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:^{
        }];
    }
    else if ([shortcutItem.type isEqualToString:@"UITouchText.search"])
    {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"好想你" preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertView animated:YES completion:nil];
    }
    else if ([shortcutItem.type isEqualToString:@"UITouchText.look"])
    {
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"温馨提示" delegate:nil cancelButtonTitle:@"cancle" destructiveButtonTitle:@"删除" otherButtonTitles:@"更多", nil];
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
    }
    else if ([shortcutItem.type isEqualToString:@"UITouchText.compose"])
    {
        NSLog(@"UITouchText.compose");
    }
}

@end
