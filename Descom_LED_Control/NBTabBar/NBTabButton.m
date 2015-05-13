//
//  NBTabButton.m
//  NB2
//
//  Created by kohn on 13-11-16.
//  Copyright (c) 2013年 Kohn. All rights reserved.
//

#import "NBTabButton.h"
@interface NBTabButton()

@property (nonatomic,strong) NSMutableArray *notifications;
@property (nonatomic,strong) NBTabNotification *light;

@end

@implementation NBTabButton
@synthesize notifications = _notifications;
@synthesize viewController = _viewController;
@synthesize light = _light;
@synthesize icon;
@synthesize highlightedIcon;
@synthesize tag = _tag;


- (id)initWithIcon:(UIImage *)nIcon {
    self = [super init];
    if (self) {
        self.icon = nIcon;
//        self.light = [[NBTabNotification alloc] initWithFrame:CGRectMake(0, 0, 24, 27)];
        self.notifications = [[NSMutableArray alloc]init];
    }
    return self;
}
- (void)setViewController:(NBTabController *)viewController {
    _viewController = viewController;
    self.viewController.tabBarButton = self;
}

- (NBTabNotification *)notificationView {
    return self.light;
}

- (void)addNotification:(NSDictionary *)notification {
    [self.notifications insertObject:notification atIndex:0];
    [self.light addNotifications:1];
}
- (void)removeNotification:(NSUInteger)index {
    if ([self.notifications count] > 0) {
        [self.notifications removeObjectAtIndex:index];
        [self.light removeNotifications:1];
    }
}
- (void)clearNotifications {
    [self.light removeNotifications:[self.notifications count]];
    [self.notifications removeAllObjects];
}
- (NSInteger)notificationCount {
    return [self.notifications count];
}
@end
