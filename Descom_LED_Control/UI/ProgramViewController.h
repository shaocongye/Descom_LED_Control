//
//  ProgramViewController.h
//  Descom_LED_Control
//  主控制界面
//  Created by mac book on 15-4-19.
//  Copyright (c) 2015年 jinslight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgramControlView.h"
#import "NavigateBarView.h"

@interface ProgramViewController : UIViewController<NavigateBarViewDelegate>
{
    ProgramControlView *_control;
    
    NavigateBarView *_navigateBar;
}


- (id)initWithDevice:(Device*)device ble:(BLENetworkControl*)ble;

@end
