//
//  ScenceView.m
//  Descom_LED_Control
//
//  Created by mac book on 15-4-20.
//  Copyright (c) 2015年 jinslight. All rights reserved.
//

#import "ScenceView.h"

@implementation ScenceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor  clearColor];
        int top_height = 0;
        
        _color = [[MHRotaryKnob alloc] initWithFrame:CGRectMake(0, top_height, 320, 320)];
        _color.interactionStyle = MHRotaryKnobInteractionStyleRotating;
        _color.scalingFactor = 1.5f;
        _color.maximumValue = 100;
        _color.minimumValue = 0;
        _color.value = 10;
        _color.defaultValue = _color.value;
        _color.resetsToDefault = YES;
        _color.backgroundColor = [UIColor clearColor];
        
        _color.backgroundImage = [UIImage imageNamed:@"color_background.png"];
        [_color setKnobImage:[UIImage imageNamed:@"color_point22.png"] forState:UIControlStateNormal];
        _color.knobImageCenter = CGPointMake(162.0f, 200.0f);
        [_color addTarget:self action:@selector(rotaryKnobDidChange) forControlEvents:UIControlEventValueChanged];
        
        [self addSubview:_color];
        
        
        top_height += 300;
        
        _logo =[[UIImageView alloc]initWithFrame:CGRectMake(30, top_height, 45, 45)];//初始化fView
        _logo.image=[UIImage imageNamed:@"cct_logo.png"];//图片f.png 到fView
        [self addSubview:_logo];
        
        _light = [[ColorSlider alloc] initWithFrame:CGRectMake(90, top_height + 10, 180, 28)];
        [self addSubview:_light];
        
        top_height += 40;
        
        
        _off = [[DCRoundSwitch alloc] initWithFrame:CGRectMake(140, top_height, 80, 25)];
        [_off addTarget:self action:@selector(offToggled:) forControlEvents:UIControlEventValueChanged];
        
        [self addSubview:_off];
        
    }
    return self;
}



//回调，拖动事件
- (void) rotaryKnobDidChange
{
    NSLog(@"rotaryKnobDidChange      =======   %.3f ",_color.value );
    
    
}


- (void)offToggled:(id)sender
{
    //开关控制
    NSLog(@"开关控制");
}



@end
