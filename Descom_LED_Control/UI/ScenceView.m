//
//  ScenceView.m
//  Descom_LED_Control
//
//  Created by mac book on 15/5/6.
//  Copyright (c) 2015年 jinslight. All rights reserved.
//

#import "ScenceView.h"
#import "UIDevice+Resolutions.h"


@implementation ScenceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor  clearColor];
        
        int top_height = 15,left_image=30,left_light = 85,left_color=180;//,right_button=0;
        int top_sun_light = 50, image_width=40,light_height=280,light_width=60;
        
        int currentResolution = (int)[UIDevice currentResolution];
        
        switch (currentResolution) {
            // iPhone 1,3,3GS 标准像素(320x480px) @1x  分辨率 320x480px
            case UIDevice_iPhoneStandardRes:
                break;
                
            // iPhone 4,4S 高清像素(320x480px)  @2x 分辨率 640x960px
            case UIDevice_iPhoneHiRes:
                break;
                
            // iPhone 5,5S 高清像素(320x568px)   @2x 分辨率 640x1136px
            case UIDevice_iPhoneTallerHiRes:
                break;
                
            //iPhone 6 高清像素(375x667px)  @2x 分辨率 750x1334px。
            case UIDevice_iPhone6:
                light_height = 380;
                break;
                
            //iPhone 6 Plus 高清像素(424x736px)  @3x  分辨率 1242x2208px。
            case UIDevice_iPhonePlus:
                break;
                
                
            // iPad 1,2   标准像素(768*1024px)  @1x  分辨率 320x480px。
            case UIDevice_iPadStandardRes:
                break;
                
            // iPad 3  Retina  高清像素(768x1024px)  (@2x 分辨率 1536*2048。
            case UIDevice_iPadHiRes:
                break;

                
            default:
                break;
        }
        
        
        _brightness = [[UILabel alloc]initWithFrame:CGRectMake(left_image+30, top_height, 100, 25)];
        _brightness.textColor =  [UIColor colorWithRed:106.0f/255.0f green:119.0f/255.0f blue:190.0f/255.0f alpha:1.0f];
        _brightness.textAlignment = NSTextAlignmentLeft;
        _brightness.text = NSLocalizedString(@"brightnessCaption", nil);
        [_brightness setFont:[UIFont fontWithName:@"HelveticaNeue" size:18]];
        [self addSubview:_brightness];
        
        _ambience = [[UILabel alloc]initWithFrame:CGRectMake(left_color, top_height, 100, 25)];
        _ambience.textColor =  [UIColor colorWithRed:106.0f/255.0f green:119.0f/255.0f blue:190.0f/255.0f alpha:1.0f];
        _ambience.textAlignment = NSTextAlignmentLeft;
        _ambience.text = NSLocalizedString(@"ambienceCaption", nil);
        [_ambience setFont:[UIFont fontWithName:@"HelveticaNeue" size:18]];
        [self addSubview:_ambience];
        
        
        
        _sun_light = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sun_light.png"]];
        _sun_light.frame = CGRectMake(left_image, top_sun_light, image_width, image_width);
        [self addSubview:_sun_light];
        
        _moon_light = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sun_night.png"]];
        _moon_light.frame = CGRectMake(left_image, top_sun_light + light_height, image_width, image_width);
        [self addSubview:_moon_light];
        
        _add_light_button = [[UIButton alloc] initWithFrame:CGRectMake(left_image, top_sun_light+100, image_width, image_width)];
    
        [_add_light_button setBackgroundImage:[UIImage imageNamed:@"add_button.png"] forState:UIControlStateNormal];
        [_add_light_button addTarget:self action:@selector(add_light:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_add_light_button];
        

        _del_light_button = [[UIButton alloc] initWithFrame:CGRectMake(left_image, top_sun_light+200, image_width, image_width)];
        
        [_del_light_button setBackgroundImage:[UIImage imageNamed:@"del_button.png"] forState:UIControlStateNormal];
        [_del_light_button addTarget:self action:@selector(del_light:) forControlEvents:UIControlEventTouchDown];
        
        [self addSubview:_del_light_button];
        
        
        _light_slider = [[VerticalSlider alloc] initWithFrame:CGRectMake(left_light, top_sun_light+10, image_width+light_width, light_height+20) left:1];

        [self addSubview:_light_slider];

        _color_slider = [[VerticalSlider alloc] initWithFrame:CGRectMake(left_color-20, top_sun_light+10, image_width+light_width, light_height+20) left:0];
        
        [self addSubview:_color_slider];

        _add_color_button = [[UIButton alloc] initWithFrame:CGRectMake(left_color+80, top_sun_light+100, image_width, image_width)];
        
        [_add_color_button setBackgroundImage:[UIImage imageNamed:@"add_button.png"] forState:UIControlStateNormal];
        [_add_color_button addTarget:self action:@selector(add_color:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_add_color_button];
        
        
        _del_color_button = [[UIButton alloc] initWithFrame:CGRectMake(left_color + 80, top_sun_light+200, image_width, image_width)];
        
        [_del_color_button setBackgroundImage:[UIImage imageNamed:@"del_button.png"] forState:UIControlStateNormal];
        [_del_color_button addTarget:self action:@selector(del_color:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_del_color_button];

        
        
        _cool = [[UILabel alloc]initWithFrame:CGRectMake(left_color + 80, top_sun_light, light_width, image_width)];
        _cool.textColor =  [UIColor colorWithRed:106.0f/255.0f green:119.0f/255.0f blue:190.0f/255.0f alpha:1.0f];
        _cool.textAlignment = NSTextAlignmentLeft;
        _cool.text = NSLocalizedString(@"coolLable", nil);
        [_cool setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
        [self addSubview:_cool];
        
        
        _warm = [[UILabel alloc]initWithFrame:CGRectMake(left_color + 80, top_sun_light + light_height, light_width, image_width)];
        _warm.textColor =  [UIColor colorWithRed:106.0f/255.0f green:119.0f/255.0f blue:190.0f/255.0f alpha:1.0f];
        _warm.textAlignment = NSTextAlignmentLeft;
        _warm.text = NSLocalizedString(@"warmLable", nil);
        _warm.textColor = [UIColor colorWithRed:255.0f/255.0f green:205.0f/255.0f blue:0.0f alpha:1.0f];
        [_warm setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
        [self addSubview:_warm];
        
        
        
        _open_button = [UIButton buttonWithType:UIButtonTypeCustom];
        _open_button.frame = CGRectMake(frame.size.width/2 - 30, top_sun_light + light_height + 50, 50, 50);
        
        
        [_open_button.layer setMasksToBounds:YES];
        [_open_button.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
        [_open_button.layer setBorderWidth:1.0]; //边框宽度
        CGColorSpaceRef colorSpace2 = CGColorSpaceCreateDeviceRGB();
//        CGColorRef colorref2 = CGColorCreate(colorSpace2,(CGFloat[]){ 1, 0, 0, 1 });
//        CGColorRef colorref2 = CGColorCreateGeneric
        
        CGColorRef colorref2 = CGColorCreate(colorSpace2,(CGFloat[]){ 200.0f/255.0f, 200.0f/255.0f, 200.0f/255.0f, 1.0f });
//        [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0f];
        
        [_open_button.layer setBorderColor:colorref2];//边框颜色
        
        [_open_button setBackgroundImage:[UIImage imageNamed:@"close_button.png"] forState:UIControlStateNormal];
        
        [_open_button addTarget:self action:@selector(open_click:) forControlEvents:UIControlEventTouchUpInside];//button 点击回调方法
        
        _open_button.backgroundColor = [UIColor clearColor];
        _open_button.tag = 12;
        [self addSubview:_open_button];
        
    }
    
    return self;
}


-(void)open_click:(UIButton*)sender
{
    
}


-(void)add_color:(UIButton*)sender
{
    _color_slider.slider.value += 10.0f;
    
}
-(void)del_color:(UIButton*)sender
{
    _color_slider.slider.value -= 10.0f;
    
}
-(void)add_light:(UIButton*)sender
{
    
    _light_slider.slider.value += 10.0f;

}
-(void)del_light:(UIButton*)sender
{
    _light_slider.slider.value -= 10.0f;
    
}

@end
