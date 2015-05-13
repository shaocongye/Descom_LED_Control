//
//  NavigateBarView.m
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-10-20.
//  Copyright (c) 2014年 mac book. All rights reserved.
//
#import "UIKit/UIkit.h"
#import "NavigateBarView.h"
//#import "UIKit/UITapGestureRecognizer.h"

@implementation NavigateBarView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:50.0f/255.0 green:85.0f/255.0 blue:180.0f/255.0 alpha:1];
    }
    return self;
}

- (id)initWithDevice:(CGRect)frame device:(Device *)dev
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.backgroundColor = [UIColor colorWithRed:50.0f/255.0 green:85.0f/255.0 blue:180.0f/255.0 alpha:1];

        //增加底色
        _backgrondImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, frame.size.width, frame.size.height)];
        [_backgrondImage setImage:[UIImage imageNamed:@"navigate_bar_backgound.png"]];

        [self addSubview:_backgrondImage];
        
        //添加左边按钮
        _left_button = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 32, 32)];
        [_left_button setBackgroundImage:[UIImage imageNamed:@"return_btn_bck.png"] forState:UIControlStateNormal];
        
        [_left_button addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_left_button];

        

//        _logo_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigate_bar_backgound.png"]];
//        _logo_image.frame = CGRectMake(frame.size.width/2-70, frame.size.height/2 - 12, 140, 24);
//        
//        [self addSubview:_logo_image];
    }
    
    return self;
}

- (void) resignRespond
{
    NSLog(@"sssssss");
}

- (void) setCaptureText:(NSString *)title
{
//    _title.text = title;

}


-(void)leftButtonClick:(UIButton* )sender
{

    if(delegate)
        [delegate leftButtonClick];
    
}
-(void)rightButtonClick:(UIButton* )sender
{
    if(delegate)
        [delegate rightButtonClick];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    
    return YES;
}



@end
