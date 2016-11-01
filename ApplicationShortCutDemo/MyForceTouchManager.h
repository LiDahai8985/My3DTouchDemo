//
//  MyForceTouchManager.h
//  My3DTouchDemo
//
//  Created by LiDaHai on 16/11/1.
//  Copyright © 2016年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyForceTouchManager : NSObject

+ (_Nonnull instancetype)shared;

- (void)forceTouchHandler;

- (void)performActionForShortcutItem:(nonnull UIApplicationShortcutItem *)shortcutItem completionHandler:(nonnull void(^)(BOOL succeeded))completionHandler;

@end
