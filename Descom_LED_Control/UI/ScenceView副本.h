//
//  ScenceView.h
//  Descom_LED_Control
//
//  Created by mac book on 15-4-20.
//  Copyright (c) 2015年 jinslight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHRotaryKnob.h"
#import "ColorSlider.h"
#import "DCRoundSwitch.h"

@interface ScenceView : UIView
{
    MHRotaryKnob *_color;
    ColorSlider *_light;
    DCRoundSwitch *_off;
    UIImageView *_logo;
}

@end
