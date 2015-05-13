//
//  MGConferenceDatePicker.h
//  MGConferenceDatePicker
//
//  Created by Matteo Gobbi on 09/02/14.
//  Copyright (c) 2014 Matteo Gobbi. All rights reserved.
//

#import <UIKit/UIKit.h>


//Protocol to return the date
@protocol MGConferenceDatePickerDelegate <NSObject>

@optional
//- (void)conferenceDatePicker:(MGConferenceDatePicker*)datePicker;
//                    saveDate:(NSDate *)date;

@end


//Button for save
@interface MGPickerButton : UIButton

@end


//滚动组件   Scroll view
@interface MGPickerScrollView : UITableView

@property NSInteger tagLastSelected;

@property (nonatomic, strong) NSArray *arrValues;
@property (nonatomic, strong) UIFont *cellFont;

- (void)dehighlightLastCell;
- (void)highlightCellWithIndexPathRow:(NSUInteger)indexPathRow;

@end


//时间选择器
@interface MGConferenceDatePicker : UIView <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    int _cell_height;
    int _hour_width;
    int _minute_width;
    
    
    int _hour;
    int _minute;
}

@property (nonatomic, weak) id <MGConferenceDatePickerDelegate>delegate;
@property (nonatomic) int hour;
@property (nonatomic) int minute;

@end
