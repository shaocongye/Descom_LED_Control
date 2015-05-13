//
//  ScenceView.h
//  Descom_LED_Control
//
//  Created by mac book on 15/5/6.
//  Copyright (c) 2015年 jinslight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerticalSlider.h"

@interface ScenceView : UIView
{
    VerticalSlider *_color_slider;
    VerticalSlider *_light_slider;
    
    UILabel *_brightness;
    UILabel *_ambience;
    UILabel *_cool;
    UILabel *_warm;
    
    UIButton *_add_light_button;
    UIButton *_del_light_button;
    
    UIButton *_add_color_button;
    UIButton *_del_color_button;
    
    UIButton *_open_button;
    
    UIImageView *_sun_light;
    UIImageView *_moon_light;
    
    
}



@end
