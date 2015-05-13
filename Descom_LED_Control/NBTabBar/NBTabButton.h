//
//  NBTabButton.h
//  NB2
//
//  Created by kohn on 13-11-16.
//  Copyright (c) 2013年 Kohn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NBTabController.h"
#import "NBTabNotification.h"

@interface NBTabButton : NSObject {
    UIImage *icon;
    UIImage *highlightedIcon;
    int _tag;
    NSMutableArray *_notifications;
    NBTabNotification *_notification;
}
@property (nonatomic,strong) UIImage *icon;
@property (nonatomic,strong) UIImage *highlightedIcon;
@property (nonatomic,strong) NBTabController *viewController;
@property (nonatomic) int tag;

- (id)initWithIcon:(UIImage *)icon;
- (void)addNotification:(NSDictionary *)notification;
- (void)removeNotification:(NSUInteger)index;
- (void)clearNotifications;

- (NSInteger)notificationCount;

- (NBTabNotification *)notificationView;
@end
