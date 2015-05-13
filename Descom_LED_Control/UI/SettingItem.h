//
//  SettingItem.h
//  Descom_LED_Control
//  程序设置的每一行,每一行一个title 一个控制模块  一条下划线
//  Created by mac book on 15-4-19.
//  Copyright (c) 2015年 jinslight. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ColorSlider.h"
#import "DCRoundSwitch.h"
#import "MGConferenceDatePicker.h"
@protocol SettingItemDelegate <NSObject>

-(void) clickView:(id)sender;


@end

@interface SettingItem : UIView<UIGestureRecognizerDelegate>
{
    UILabel *_title_lab;
    BOOL _moveon;
    BOOL _enable;
    
    int _frame_resolution;

}
@property (nonatomic, retain) id<SettingItemDelegate> delegate;

@property (strong,nonatomic) UILabel *title_lab;
@property BOOL moveon;
@property BOOL enable;
@property int frame_resolution;

-(void) changMoveon;
-(UIImage*)  OriginImage:(UIImage *)image   scaleToSize:(CGSize)size;
@end

@interface SetttingNumberItem : SettingItem
{
    UILabel *_number_lab;
    int _number;
}

@property (strong,nonatomic) UILabel *number_lab;
@property (nonatomic) int number;

-(void) setNumber:(int)number;
@end

@interface SetttingDateItem : SettingItem
{
    MGConferenceDatePicker *_start_date_picker;
    MGConferenceDatePicker *_end_date_picker;
    UILabel *_separator_lab;
    int _start;
    int _end;
}

@property (strong,nonatomic) UILabel *separator_lab;

@property (nonatomic) int start;
@property (nonatomic) int end;

-(void) setStart:(int)start;
-(void) setEnd:(int)end;

@end


@interface SetttingProgressItem : SettingItem
{
    UISlider *_progress;
    UIImage *_thumbImage;
    UILabel *_persent_0;
    UILabel *_persent_100;
    
}

@property (strong,nonatomic) UISlider *progress;

@end

@interface SetttingSelectItem : SettingItem
{
    UIImageView *_uncheck_img;
    UIImageView *_checked_img;
    
    BOOL _check;
}

@property BOOL check;

- (void) unclicked;
- (void) clicked;
@end



@interface SetttingSwtichItem : SettingItem
{
    DCRoundSwitch *_off;
}

@property (strong,nonatomic) DCRoundSwitch *off;

@end
