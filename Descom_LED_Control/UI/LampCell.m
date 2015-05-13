//
//  LampCell.m
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-12-25.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import "LampCell.h"

@implementation LampCell

@synthesize device;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createWithDeive:nil];
    }
    return self;
}

- (id)initWithDevice:(Device *)dev
{
    self = [super init];
    if (self) {
        [self createWithDeive:dev];
    }
    return self;
}

-(void)createWithDeive:(Device *)dev
{
    _device = dev;
    
//    self.backgroundColor = [UIColor greenColor];
    
    //整个显示区域 高度是Iphone下 为100 宽度为140
    //上面是标题
    if(_title)
        return;
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(
                                                       0,
                                                       80,
                                                       self.bounds.size.width - 20,
                                                       24)];
    
    _title.text = @"添加";
    _title.font = [UIFont boldSystemFontOfSize:20];
    _title.textColor = [UIColor blackColor];
    _title.textAlignment = NSTextAlignmentCenter;
    _title.alpha = 0.5f;
    _title.backgroundColor = [UIColor clearColor];
    [self addSubview:_title];
    
    //上面是图片
    switch(dev.type)
    {
        case 0:
            _newlineImage = [UIImage imageNamed:@"D3.png"];
            _onlineImage = [UIImage imageNamed:@"l3.png"];
            _offlineImage = [UIImage imageNamed:@"D3.png"];
            break;
        case 1:
            _newlineImage = [UIImage imageNamed:@"D2.png"];
            _onlineImage = [UIImage imageNamed:@"l2.png"];
            _offlineImage = [UIImage imageNamed:@"D2.png"];
            break;
        case 2:
            _newlineImage = [UIImage imageNamed:@"D4.png"];
            _onlineImage = [UIImage imageNamed:@"l4.png"];
            _offlineImage = [UIImage imageNamed:@"D4.png"];
            break;
        case 3:
            _newlineImage = [UIImage imageNamed:@"D1.png"];
            _onlineImage = [UIImage imageNamed:@"l1.png"];
            _offlineImage = [UIImage imageNamed:@"D1.png"];
            break;
            
        default:
            _newlineImage = [UIImage imageNamed:@"D3.png"];
            _onlineImage = [UIImage imageNamed:@"l3.png"];
            _offlineImage = [UIImage imageNamed:@"D3.png"];
            break;
    }
    
    _button = [[UIButton  alloc] initWithFrame:CGRectMake(self.bounds.size.width/2 - 45, 10, 70, 70)];
    [_button setImage:_newlineImage forState:UIControlStateNormal];
    
    
    //添加点按处理
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
    singleTap.numberOfTapsRequired = 1;
    
    
    //添加长按处理
    UILongPressGestureRecognizer* singleLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleLongPress:)];
    singleLongPress.delegate = self;
    singleLongPress.cancelsTouchesInView = NO;
    
    [singleTap requireGestureRecognizerToFail:singleLongPress];
    [_button addGestureRecognizer:singleTap];
    [_button addGestureRecognizer:singleLongPress];
    
    [self addSubview:_button];
}

-(Device*)getDevice
{
    return _device;
}

-(void)setDevice:(Device *)dev
{
    if(dev)
    {
        _device = dev;
    
        //根据类型设定图片
        [self setTitle:dev.name];
        [self Changeonline:dev.online];
        
    }
    
}

-(void)OnButton:(UIButton *)sender
{
    NSLog(@"button %d touch down!",(int)self.tag);
    if(self.delegate)
    {
        [self.delegate didSelectButton:(int)self.tag];
    }
}

-(void)Changeonline:(BOOL)online
{
    if(online)
    {
        [_button setImage:_onlineImage forState:UIControlStateNormal];
    } else {
        [_button setImage:_offlineImage forState:UIControlStateNormal];
    }
    
}
-(void)setTitle:(NSString*)title
{
    _title.text = title;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{    
    if(self.delegate){
        [self.delegate didSelectButton:(int)self.tag];
    }
}


-(void)handleSingleLongPress:(UITapGestureRecognizer *)sender
{
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        if(self.delegate){
            [self.delegate didEditButton:(int)self.tag];
        }
    }
}

@end
