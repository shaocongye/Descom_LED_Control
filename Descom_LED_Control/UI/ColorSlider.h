//
//  ColorSlider.h
//  Descom_LED_Control
//
//  Created by mac book on 15-4-19.
//  Copyright (c) 2015年 jinslight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorSlider : UISlider
{
    UIImage *_stetchLeftTrack;   //左轨的图片
    UIImage *_stetchRightTrack;  //右轨的图片
    UIImage *_thumbImage;        //滑块图片
}

@end
