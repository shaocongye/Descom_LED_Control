//
//  SettingView.h
//  Descom_LED_Control
//
//  Created by mac book on 15-4-19.
//  Copyright (c) 2015年 jinslight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingItem.h"

typedef struct programe_data
{
    int programe;
    int startTime;
    int endTime;
    int color;
    int light;
    int type;
    int off;
    int check;
    int running;
}ProgrameData,*PPD;


@protocol SettingViewDelegate <NSObject>

-(void) savePrograme:(PPD)programe;
-(void) editPrograme:(PPD)programe;
-(void) removePrograme:(PPD)programe;

@end

@interface SettingView : UIView<SettingItemDelegate>
{
    ProgrameData  *_prog;
    
    SetttingNumberItem *_prog_number;
    SetttingDateItem *_date;
    SetttingProgressItem *_light;
    SetttingProgressItem *_color;
    SetttingSelectItem *_mode;
    SetttingSwtichItem *_off;
    
    UIButton *_clear_btn;
    UIButton *_save_btn;
    
    int _frame_resolution;
    
    
}

@property ProgrameData *prog;
@property (nonatomic,retain) id<SettingViewDelegate> delegate;


@end
