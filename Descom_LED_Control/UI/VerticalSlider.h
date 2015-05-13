//
//  VerticalSlider.h
//  Descom_LED_Control
//
//  Created by mac book on 15/5/6.
//  Copyright (c) 2015年 jinslight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerticalSlider : UIControl
{
    UISlider *_slider;              //滑块
    UIImage *_stetchLeftTrack;   //左轨的图片
    UIImage *_stetchRightTrack;  //右轨的图片

    UIImage *_thumbImage;        //滑块图片

    UIImageView *_background_image;//背景
    UILabel *_persent_0;
    UILabel *_persent_20;
    UILabel *_persent_40;
    UILabel *_persent_60;
    UILabel *_persent_80;
    UILabel *_persent_100;

    int _left;
}

@property (nonatomic,retain) UISlider *slider;

- (id)initWithFrame:(CGRect)frame left:(int)left;



@end
