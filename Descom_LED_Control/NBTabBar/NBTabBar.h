//
//  NBTabBar.h
//  NB2
//
//  Created by kohn on 13-11-16.
//  Copyright (c) 2013年 Kohn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NBTabController;
@protocol NBTabBarDelegate <NSObject>

- (void)switchViewController:(NBTabController *)viewController;

@end


@interface NBTabBar : UIView
@property (nonatomic,assign)id<NBTabBarDelegate> delegate;


- (id)initWithItems:(NSArray *)items;

- (void)showDefauls;
- (void)showIndex:(NSInteger)index;

- (void)touchDownForButton:(UIButton *)button;
- (void)touchUpForButton:(UIButton *)button;
@end
