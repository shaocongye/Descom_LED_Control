//
//  SettingView.m
//  Descom_LED_Control
//
//  Created by mac book on 15-4-19.
//  Copyright (c) 2015年 jinslight. All rights reserved.
//

#import "SettingView.h"
#import "UIDevice+Resolutions.h"

@implementation SettingView
@synthesize prog = _prog;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _frame_resolution = (int)[UIDevice currentResolution];

        self.backgroundColor = [UIColor  clearColor];
        int top_height = 1;
        _prog_number = [[SetttingNumberItem alloc] initWithFrame:CGRectMake(2, top_height, frame.size.width - 4, 50) ];
        
        _prog_number.title_lab.text = NSLocalizedString(@"programCaption", nil);
        _prog_number.tag = 1;
        _prog_number.delegate = self;
        [self addSubview:_prog_number];
        top_height += 50;
        
        
        _date = [[SetttingDateItem alloc] initWithFrame:CGRectMake(2, top_height, frame.size.width - 4, 90)];
        _date.title_lab.text = NSLocalizedString(@"timeCaption", nil);
        _date.tag = 2;
        _date.delegate = self;
        [self addSubview:_date];
        top_height += 90;
        
        _light = [[SetttingProgressItem alloc] initWithFrame:CGRectMake(2, top_height, frame.size.width - 4, 50)];
        _light.title_lab.text = NSLocalizedString(@"brightnessCaption", nil);
        

        _light.tag = 3;
        _light.delegate = self;
        [self addSubview:_light];
        top_height += 50;
        
        _color = [[SetttingProgressItem alloc] initWithFrame:CGRectMake(2, top_height, frame.size.width - 4, 50) ];
        _color.title_lab.text = NSLocalizedString(@"ambienceCaption", nil);
        _color.tag = 4;
        _color.delegate = self;
        [self addSubview:_color];
        top_height += 50;
        
        _mode = [[SetttingSelectItem alloc] initWithFrame:CGRectMake(2, top_height, frame.size.width - 4, 50) ];
        _mode.title_lab.text = NSLocalizedString(@"moodCaption", nil);
        _mode.tag = 5;
        _mode.delegate = self;
        [self addSubview:_mode];
        top_height += 50;
        
        _off = [[SetttingSwtichItem alloc] initWithFrame:CGRectMake(2, top_height, frame.size.width - 4, 50) ];
        _off.title_lab.text = NSLocalizedString(@"SwitchLable", nil);
        _off.tag = 6;
        _off.delegate = self;
        [self addSubview:_off];
        top_height += 50;
        
        //按钮

        _clear_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _clear_btn.frame = CGRectMake(frame.size.width/2 - 90, top_height + 15, 80, 40);
        
        [_clear_btn.layer setMasksToBounds:YES];
        [_clear_btn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
        [_clear_btn.layer setBorderWidth:1.0]; //边框宽度
        CGColorSpaceRef colorSpace1 = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref1 = CGColorCreate(colorSpace1,(CGFloat[]){ 1, 0, 0, 1 });
        
        [_clear_btn.layer setBorderColor:colorref1];//边框颜色
        
        [_clear_btn setTitle:NSLocalizedString(@"deleteButtonCaption", nil) forState:UIControlStateNormal];//button title
        
        [_clear_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//title color
        
        [_clear_btn addTarget:self action:@selector(clearClick:) forControlEvents:UIControlEventTouchUpInside];//button 点击回调方法
        
        _clear_btn.backgroundColor = [UIColor whiteColor];

        
        _clear_btn.tag = 11;
        
        [self addSubview:_clear_btn];
        
        
        _save_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _save_btn.frame = CGRectMake(frame.size.width/2 + 30, top_height + 15, 80, 40);

        
        [_save_btn.layer setMasksToBounds:YES];
        [_save_btn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
        [_save_btn.layer setBorderWidth:1.0]; //边框宽度
        CGColorSpaceRef colorSpace2 = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref2 = CGColorCreate(colorSpace2,(CGFloat[]){ 1, 0, 0, 1 });
        
        [_save_btn.layer setBorderColor:colorref2];//边框颜色
        
        [_save_btn setTitle:NSLocalizedString(@"saveButtonCaption", nil) forState:UIControlStateNormal];//button title
        
        [_save_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//title color
        
        [_save_btn addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];//button 点击回调方法
        
        _save_btn.backgroundColor = [UIColor clearColor];
        _save_btn.tag = 12;
        [self addSubview:_save_btn];
    
        
    }
    return self;
}


-(void) clickView:(id)sender
{
    
    SettingItem * btn = (SettingItem*)sender;
    
    for(UIView * view in self.subviews)
    {
        if(view.tag < 7 && view.tag != btn.tag)
        {
            SettingItem * ttl = (SettingItem*)view;
            
            if(ttl.moveon)
               [ttl changMoveon];
        }
        
    }
    
    if(btn.tag == 5)
    {
        //呼吸灯，那么作选择用
        SetttingSelectItem *ctn = (SetttingSelectItem*)btn;
        
        if(ctn.check)
        {
            [ctn unclicked];
        } else
        {
            [ctn clicked];
        }
    }
}


-(void)clearClick:(UIButton*)sender
{
    if(self.delegate)
        [self.delegate removePrograme:_prog];
}

-(void)saveClick:(UIButton*)sender
{
    if(self.delegate)
        [self.delegate savePrograme:_prog];
    
}


@end
