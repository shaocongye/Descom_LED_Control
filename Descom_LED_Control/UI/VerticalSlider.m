//
//  VerticalSlider.m
//  Descom_LED_Control
//
//  Created by mac book on 15/5/6.
//  Copyright (c) 2015年 jinslight. All rights reserved.
//

#import "VerticalSlider.h"
#define degressToRadian(x) (M_PI * (x)/180.0)



@implementation VerticalSlider
@synthesize slider = _slider;


- (id)initWithFrame:(CGRect)frame left:(int)left
{
    self = [super initWithFrame:frame];
    if (self) {
        _left = left;
        
        float thumb_width= 24.0f,slider_width = 28.0f,lable_width= 60,left_displacement = -128, top_displacement = 131,slider_height_difference=12;
        
        float lable_interval_height=frame.size.height/5-4;
        
        //滑块图片
        UIImage *thumb = [UIImage imageNamed:@"open_button.png"];
        _thumbImage = [self OriginImage:thumb scaleToSize:CGSizeMake(thumb_width, thumb_width)];
        
        //背景
        self.backgroundColor = [UIColor clearColor];
        UIImage *background = [UIImage imageNamed:@"vertical_slider_line.png"];
        _background_image = [[UIImageView alloc] initWithImage:[self OriginImage:background scaleToSize:CGSizeMake(slider_width,frame.size.height)]];
        
        if(_left)
            _background_image.frame = CGRectMake(3, 0, slider_width-4, frame.size.height-4);
        else
            _background_image.frame = CGRectMake(lable_width+3, 0, slider_width-4, frame.size.height-4);
            
        [self addSubview:_background_image];
        
        
        
        
        
        if(_left)
            _slider = [[UISlider alloc]initWithFrame:CGRectMake(left_displacement, top_displacement+3, frame.size.height - slider_height_difference-3, slider_width)];
        else
            _slider = [[UISlider alloc]initWithFrame:CGRectMake(left_displacement+lable_width, top_displacement+3, frame.size.height - slider_height_difference-3, slider_width)];
        
        
        _stetchLeftTrack= [[UIImage imageNamed:@"nav_bg_image.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0];
        
        _stetchLeftTrack = [[UIImage imageNamed:@"nav_bg_image.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0];

        
//        _slider.backgroundColor = [UIColor purpleColor];

        _slider.value=10.0;
        _slider.minimumValue=0.0;
        _slider.maximumValue=100.0;
        //数值
        [_slider setMinimumTrackImage:_stetchLeftTrack forState:UIControlStateNormal];
        [_slider setMaximumTrackImage:_stetchRightTrack forState:UIControlStateNormal];
        
        //注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
        [_slider setThumbImage:_thumbImage forState:UIControlStateHighlighted];
        [_slider setThumbImage:_thumbImage forState:UIControlStateNormal];

        
        [self addSubview:_slider];
        
        //滑块拖动时的事件
        [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        //滑动拖动后的事件
        [_slider addTarget:self action:@selector(sliderDragUp:) forControlEvents:UIControlEventTouchUpInside];
        
        _slider.transform = CGAffineTransformMakeRotation(degressToRadian(270));
    
        if(_left){
            _persent_100 = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 55, 24)];
            _persent_100.textAlignment = NSTextAlignmentLeft;

            _persent_80 = [[UILabel alloc] initWithFrame:CGRectMake(45, lable_interval_height, 55, 24)];
            _persent_80.textAlignment = NSTextAlignmentLeft;

            _persent_60 = [[UILabel alloc] initWithFrame:CGRectMake(45, lable_interval_height+lable_interval_height, 55, 24)];
            _persent_60.textAlignment = NSTextAlignmentLeft;
            
            _persent_40 = [[UILabel alloc] initWithFrame:CGRectMake(45, lable_interval_height+lable_interval_height+lable_interval_height, 55, 24)];
            _persent_40.textAlignment = NSTextAlignmentLeft;
            
            _persent_20 = [[UILabel alloc] initWithFrame:CGRectMake(45, lable_interval_height+lable_interval_height+lable_interval_height+lable_interval_height, 55, 24)];
            _persent_20.textAlignment = NSTextAlignmentLeft;

            _persent_0 = [[UILabel alloc] initWithFrame:CGRectMake(45, lable_interval_height+lable_interval_height + lable_interval_height+lable_interval_height+lable_interval_height, 55, 24)];
            _persent_0.textAlignment = NSTextAlignmentLeft;
        }
        else{
            _persent_100 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 55, 24)];
            _persent_100.textAlignment = NSTextAlignmentRight;
            
            _persent_80 = [[UILabel alloc] initWithFrame:CGRectMake(0, lable_interval_height, 55, 24)];
            _persent_80.textAlignment = NSTextAlignmentRight;

            _persent_60 = [[UILabel alloc] initWithFrame:CGRectMake(0, lable_interval_height+lable_interval_height, 55, 24)];
            _persent_60.textAlignment = NSTextAlignmentRight;

            _persent_40 = [[UILabel alloc] initWithFrame:CGRectMake(0, lable_interval_height+lable_interval_height + lable_interval_height, 55, 24)];
            _persent_40.textAlignment = NSTextAlignmentRight;

            _persent_20 = [[UILabel alloc] initWithFrame:CGRectMake(0, lable_interval_height+lable_interval_height+lable_interval_height + lable_interval_height, 55, 24)];
            _persent_20.textAlignment = NSTextAlignmentRight;
            
            _persent_0 = [[UILabel alloc] initWithFrame:CGRectMake(0, lable_interval_height+lable_interval_height +lable_interval_height+lable_interval_height + lable_interval_height, 55, 24)];
            _persent_0.textAlignment = NSTextAlignmentRight;
        }
        
            
        _persent_100.text = @"100%";
        _persent_100.font = [UIFont boldSystemFontOfSize:13];
        _persent_100.textColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0f];
        [self addSubview:_persent_100];
        
        _persent_80.text = @"80%";
        _persent_80.font = [UIFont boldSystemFontOfSize:13];
        _persent_80.textColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0f];
        [self addSubview:_persent_80];

        _persent_60.text = @"60%";
        _persent_60.font = [UIFont boldSystemFontOfSize:13];
        _persent_60.textColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0f];
        [self addSubview:_persent_60];

        
        _persent_40.text = @"40%";
        _persent_40.font = [UIFont boldSystemFontOfSize:13];
        _persent_40.textColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0f];
        [self addSubview:_persent_40];

        
        _persent_20.text = @"20%";
        _persent_20.font = [UIFont boldSystemFontOfSize:13];
        _persent_20.textColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0f];
        [self addSubview:_persent_20];

        
        _persent_0.text = @"0%";
        _persent_0.font = [UIFont boldSystemFontOfSize:13];
        _persent_0.textColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0f];
        [self addSubview:_persent_0];
        
    }
    
    return self;
}


-(UIImage*)  OriginImage:(UIImage *)image   scaleToSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

-(void)sliderValueChanged:(UISlider *)paramSender
{
    
}


-(void)sliderDragUp:(UISlider *)paramSender
{
    
}

@end
