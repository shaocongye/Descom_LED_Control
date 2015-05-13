//
//  ProgrameView.h
//  Descom_LED_Control
//  程序列表view  用来展示有多少个程序的
//  Created by mac book on 15-4-19.
//  Copyright (c) 2015年 jinslight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingView.h"

@protocol  ProgramControlBarDelegate <NSObject>

-(void) pauseProgram;
-(void) runProgram;
-(void) addProgram;
-(void) delProgram;
-(void) refreshProgram;

@end

@interface ProgramControlBar : UIView
{
    UIButton *_pause_btn;
    UIButton *_run_btn;
    UIButton *_add_btn;
    UIButton *_del_btn;
    UIButton *_refresh_btn;
}


@property (weak,nonatomic) id<ProgramControlBarDelegate> delegate;



@end

@interface ProgrameCell : UITableViewCell
{
    UILabel *_programe_number;
    UILabel *_module;
    UILabel *_context_date;
    UILabel *_color_light;
    
    UIImageView *_index_img_p;
    UIImageView *_index_img_r;
    UIImageView *_selected_img;
    UIImageView *_unselected_img;
    
    UIColor *_low_color;
    UIColor *_high_color;
    
    ProgrameData *_programe_data;
    
}

@property (nonatomic) ProgrameData * programe_data;

-(void) setPrograme_data:(ProgrameData *)programe_data;
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;



@end

@protocol ProgrameViewDelegate <NSObject>
-(void) createPrograme:(ProgrameData *)data;
-(void) dropPrograme:(ProgrameData *)data;
-(void) refreshPrograme;
@end


@interface ProgrameView : UIView<UITableViewDataSource,UITableViewDelegate,ProgramControlBarDelegate>
{
    NSMutableArray *_program_lists;     //程序列表
    int _program_count;                 //程序总数
    ProgramControlBar *_control_bar;    //控制条
    
    UITableView *_program_view;
}

@property (nonatomic,retain) id<ProgrameViewDelegate> deleagte;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

@end
