//
//  AppDelegate.m
//  ApplicationShortCutDemo
//
//  Created by 张好志 on 15/10/22.
//  Copyright © 2015年 Andy. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()<UIAlertViewDelegate>

@property (strong, nonatomic) UITraitCollection *traitCollection;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //**********自定义相关***********
    UIApplication *app = [UIApplication sharedApplication];
    if ((floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_8_4)) {
        //判断3Dtouch权限
        if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable){
            NSLog(@"---");
            
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
                
                //根据旧的shortcutItems生成可变shortcutItems数组
                id updatedShortcutItems = [existingShortcutItems mutableCopy];
                //修改可变shortcutItems数组中对应index下的元素为新的shortcutItem
                [updatedShortcutItems replaceObjectAtIndex: 0 withObject: mutableItem];
                //修改应用程序对象的shortcutItems为新的数组
                [app setShortcutItems: updatedShortcutItems];
                NSLog(@"------updatedShortcutItems------->%@",updatedShortcutItems);
            }
            else
            {
                //第一次安装没有将shortcutItem，则添加shortcutItems
                UIApplicationShortcutItem *mutableItem1 = [[UIApplicationShortcutItem alloc] initWithType:@"UITouchText.look" localizedTitle:@"第一次添加" localizedSubtitle:@"有1了吧____00:00" icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeCompose] userInfo:nil];
                UIApplicationShortcutItem *mutableItem2 = [[UIApplicationShortcutItem alloc] initWithType:@"UITouchText.look" localizedTitle:@"第一次添加" localizedSubtitle:@"有2了吧____00:00" icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypePlay] userInfo:nil];
                UIApplicationShortcutItem *mutableItem3 = [[UIApplicationShortcutItem alloc] initWithType:@"UITouchText.look" localizedTitle:@"第一次添加" localizedSubtitle:@"有3了吧____00:00" icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeAdd] userInfo:nil];
                UIApplicationShortcutItem *mutableItem4 = [[UIApplicationShortcutItem alloc] initWithType:@"UITouchText.look" localizedTitle:@"第一次添加" localizedSubtitle:@"有4了吧____00:00" icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeLocation] userInfo:nil];
                
                NSLog(@"------mutableItem5------->%@",mutableItem1);
                
                //修改应用程序对象的shortcutItems为新的数组
                [[UIApplication sharedApplication] setShortcutItems: @[mutableItem1, mutableItem2,mutableItem3,mutableItem4,mutableItem4,mutableItem4]];
            }
            //***************end******************
            
            //如果不需要自定义，不需要在客户端里修改shortcutItem内容或类型也可以在infoPlist文件中添加，如下：
            /***
             
             在infoPlist中添加UIApplicationShortcutItems
             https://developer.apple.com/library/ios/documentation/General/Reference/InfoPlistKeyReference/Articles/iPhoneOSKeys.html#//apple_ref/doc/uid/TP40009252-SW36
             https://developer.apple.com/library/ios/documentation/General/Reference/InfoPlistKeyReference/Art/UIApplicationShortcutItems_plist_editor_2x.png
             
             ****/
            
        }
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    
    return YES;
}

- (void)application:(UIApplication *)application
performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem
  completionHandler:(void(^)(BOOL succeeded))completionHandler{
    //判断先前我们设置的唯一标识
    if([shortcutItem.type isEqualToString:@"UITouchText.share"]){
        NSArray *arr = @[@"hello 3D Touch"];
        UIActivityViewController *vc = [[UIActivityViewController alloc]initWithActivityItems:arr applicationActivities:nil];
        //设置当前的VC 为rootVC
        [self.window.rootViewController presentViewController:vc animated:YES completion:^{
        }];
    }
    else if ([shortcutItem.type isEqualToString:@"UITouchText.search"])
    {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"好想你" preferredStyle:UIAlertControllerStyleAlert];
[alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
}]];
        [self.window.rootViewController presentViewController:alertView animated:YES completion:nil];
    }
    else if ([shortcutItem.type isEqualToString:@"UITouchText.look"])
    {
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"温馨提示" delegate:nil cancelButtonTitle:@"cancle" destructiveButtonTitle:@"删除" otherButtonTitles:@"更多", nil];
        [sheet showInView:self.window];
    }
    else if ([shortcutItem.type isEqualToString:@"UITouchText.compose"])
    {
        NSLog(@"UITouchText.compose");
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark-
- (UITraitCollection *)traitCollection {
    if (!_traitCollection) {
        _traitCollection = [UITraitCollection traitCollectionWithForceTouchCapability:UIForceTouchCapabilityAvailable];
    }
    return _traitCollection;
}

@end
