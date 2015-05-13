//
//  NavigateBarView.h
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-10-20.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceProperty.h"
//#import "ReturnButton.h"

@protocol NavigateBarViewDelegate <NSObject>

- (void) leftButtonClick;
- (void) rightButtonClick;

@end


@interface NavigateBarView : UIControl <UITextViewDelegate,UIGestureRecognizerDelegate>
{
    UIButton *_left_button;
    UIButton *_right_button;
    UIImageView *_logo_image;
    UIImageView *_backgrondImage;
}

@property (weak, nonatomic) id<NavigateBarViewDelegate> delegate;

- (void) setCaptureText:(NSString *)title;
- (id)initWithDevice:(CGRect)frame device:(Device *)dev;
//- (void)leftButtonClick;

@end
