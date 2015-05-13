//
//  ProgramControlView.h
//  Descom_LED_Control
//
//  Created by mac book on 15-4-24.
//  Copyright (c) 2015年 jinslight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingView.h"
#import "ProgrameView.h"
#import "BLENetworkControl.h"
#import "DeviceProperty.h"
#import "NBTabBar.h"
#import "ScenceView.h"


#define SELECTED_VIEW_CONTROLLER_TAG 98456345
#define NOTIFICATION_IMAGE_VIEW_TAG 98456346



@interface ProgramControlView : UIView<NBTabBarDelegate,ProgrameViewDelegate,SettingViewDelegate>
{
    ProgrameView *_programeview;   //程序列表
    ScenceView *_scenceview;     //场景控制
    SettingView *_settingview;    //设置程序
    
    
    NBTabBar *_tabbar;                  //标签页
    NBTabController * _currentView;     //当前页
    
}

- (id)initWithDevice:(Device*)device ble:(BLENetworkControl*)ble;


@end
