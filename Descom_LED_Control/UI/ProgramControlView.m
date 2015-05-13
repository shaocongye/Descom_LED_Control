//
//  ProgramControlView.m
//  Descom_LED_Control
//
//  Created by mac book on 15-4-24.
//  Copyright (c) 2015年 jinslight. All rights reserved.
//

#import "ProgramControlView.h"
#import "NBTabButton.h"

@implementation ProgramControlView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}

- (id)initWithDevice:(Device*)device ble:(BLENetworkControl*)ble
{
    
    self = [super init];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}

-(void) commonInit
{
    int top = 0;
    
    _programeview = [[ProgrameView alloc] initWithFrame:CGRectMake(0, top, self.frame.size.width , self.frame.size.height - 100)];
    _programeview.deleagte = self;
    
    _scenceview = [[ScenceView alloc] initWithFrame:CGRectMake(0, top, self.frame.size.width , self.frame.size.height - 100)];
    
    _settingview = [[SettingView alloc] initWithFrame:CGRectMake(0, top, self.frame.size.width , self.frame.size.height - 100)];
    _settingview.delegate = self;
    
    
    //构建容器
    NBTabController *program_tc = [[NBTabController alloc]init];
    program_tc.view.backgroundColor = [UIColor clearColor];
    [program_tc.view addSubview:_programeview];
    
    NBTabController *scence_tc = [[NBTabController alloc]init];
    scence_tc.view.backgroundColor = [UIColor clearColor];
    [scence_tc.view addSubview:_scenceview];
    
    NBTabController *setting_tc = [[NBTabController alloc]init];
    setting_tc.view.backgroundColor = [UIColor clearColor];
    [setting_tc.view addSubview:_settingview];
    
    _currentView = scence_tc;
    
    [self insertSubview:program_tc.view belowSubview:_tabbar];
    [self insertSubview:scence_tc.view belowSubview:_tabbar];
    [self insertSubview:setting_tc.view belowSubview:_tabbar];
    
    //构建切换按钮
    NBTabButton *program_tb = [[NBTabButton alloc] initWithIcon:[UIImage imageNamed:@"program_bar.png"]];
    program_tb.highlightedIcon = [UIImage imageNamed:@"program_bar_low.png"];
    program_tb.tag = 1;
    program_tb.viewController = program_tc;
    
    NBTabButton *scence_tb = [[NBTabButton alloc] initWithIcon:[UIImage imageNamed:@"scence_bar.png"]];
    scence_tb.highlightedIcon = [UIImage imageNamed:@"scence_bar_low.png"];
    scence_tb.tag = 2;
    scence_tb.viewController = scence_tc;
    
    NBTabButton *setting_tb = [[NBTabButton alloc] initWithIcon:[UIImage imageNamed:@"setting_bar.png"]];
    setting_tb.tag = 3;
    setting_tb.highlightedIcon = [UIImage imageNamed:@"setting_bar_low.png"];
    setting_tb.viewController = setting_tc;
    
    NSArray *tabs = [NSArray arrayWithObjects:program_tb, scence_tb,setting_tb, nil];
    _tabbar = [[NBTabBar alloc] initWithItems:tabs];
    _tabbar.delegate = self;
    
    [self addSubview:_tabbar];
    [_tabbar showIndex:1];
}


-(void)switchViewController:(NBTabController *)viewController {
    
    UIView *currentView = [self viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
    [currentView removeFromSuperview];
    currentView = nil;

    viewController.view.frame = CGRectMake(0,0,self.bounds.size.width, self.bounds.size.height - _tabbar.frame.size.height);
    
    viewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;

    [self insertSubview:viewController.view belowSubview:_tabbar];
    if (_currentView == viewController) {
        [viewController.tabBarButton addNotification:[NSDictionary dictionary]];
    }else{
        [_currentView.tabBarButton clearNotifications];
        
        [viewController.tabBarButton addNotification:[NSDictionary dictionary]];
        _currentView = viewController;
    }
    
}

//--------------

- (void) createPrograme:(ProgrameData *)data
{
    [_settingview setProg:data];
    
    [_tabbar showIndex:2];

}

-(void) refreshPrograme
{
    
}

-(void) dropPrograme:(ProgrameData *)data
{
    
}

-(void) savePrograme:(PPD)programe
{
    
}
-(void) editPrograme:(PPD)programe
{
    
}
-(void) removePrograme:(PPD)programe
{
    
}


@end
