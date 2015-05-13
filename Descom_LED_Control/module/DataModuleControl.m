//
//  DataModuleDelegate.m
//  Demo LED lamp Control
//
//  Created by book mac on 14-7-30.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "DataModuleControl.h"
#import "AppDelegate.h"

#define DEFAULT_PORT 8001

@implementation DataModuleControl
@synthesize config = _config;
//@synthesize socket = _socket;

-(id) init {
    self = [super init];
    
    _config = [[DeviceProperty alloc] initWithConfig:@"DeviceProperty"];
    [self loadConfig];
    
    
//    _socket = [[CommandSendReciver alloc]init:self];
//    [_socket SocketOpen:_config.route.ip port:DEFAULT_PORT];
    
    
    return self;
}

//-(void) dealloc
//{
//    [_socket setDone:YES];
//    [_socket release];
//    _socket = nil;
//    
//    [_config release];
//    _config = nil;
//    
//    [super dealloc];
//}

//创建了一个新的自定义模式
-(void) createCustomMode:(CustomMode *)mode
{
    [_config.mode_list addObject:mode];
    [self saveConfig];
    
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [appDelegate updateCustomMode];
}

//删除了一个自定义模式
-(void) dropCustomMode:(CustomMode *)mode
{
    NSUInteger index = (NSUInteger)mode.mid;
    [_config.mode_list removeObjectAtIndex:index];
    [self saveConfig];
    
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [appDelegate updateCustomMode];
    
    
}

//更新了一个自定义模式
-(void) updateCustomMode:(CustomMode *)mode
{
    NSLog(@"update a custom mode %@.",mode.name);
    
    NSUInteger index = (NSUInteger)mode.mid;
    [_config.mode_list replaceObjectAtIndex:index withObject:mode];
    [self saveConfig];
    
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [appDelegate updateCustomMode];
    
}

//创建一个新的设备
-(void) createNewDevice:(Device *) _device
{
    //[_config.device_list addObject:_device];
    [self saveConfig];
    
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [appDelegate updateDeviceList];
    
    
}
//删除一个设备
-(void) dropDevice:(Device *) _device
{
    //[_config.device_list  removeObjectAtIndex:_device.mid];
    [self saveConfig];
}
//更新修改了一个设备
-(void) updateDevice:(Device *) _device
{
    //[_config.device_list replaceObjectAtIndex:_device.mid withObject:_device];
    [self saveConfig];
    
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [appDelegate updateDeviceList];
    
    
}
//打开关闭设备
-(void) changeDeviceOpenClose : (NSString *)mac option : (int) open
{
    NSLog(@"Device %@ is %d",mac,open);
    [self saveConfig];
}

//设备改名
-(void) changeDeviceName : (NSString *)mac devname : (NSString *)name
{
    NSLog(@"Device %@ name is changed by %@",mac,name);
    [self saveConfig];
}
//更改亮度
-(void) changeLightValue : (float) value
{
    NSLog(@"Device  light is changed by %f",value);
    [self saveConfig];
    
}

//更改闪动频率
-(void) changeStrobeValue : (float) value
{
    NSLog(@"Device  strobe is changed by : %f",value);
    [self saveConfig];
    
}

//开关设备
-(void) changeSwitchValue : (BOOL) open
{
    if (open) {
        NSLog(@"Device is opned.");
    }else {
        NSLog(@"Device is closed.");
    }
    
}

-(void) changeTimeValue : (int64_t) open
{
    
}

//变幻当前颜色
-(void) changeColor : (UIColor*) color
{
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    NSLog(@"Coor %@, Red: %f Green: %f Blue : %f", color,components[0],components[1],components[2]);
    [self saveConfig];
}

//变幻当前模式
-(void) changeMode : (int) index{
    
    NSLog(@"Select mode index %d",index);
}

//修改主路由设置
-(void) changeRoute:(Route *) _route
{
    //NSLog(@"Route was changed!");
    
    [self saveConfig];
}


-(void)loadConfig
{
    if(_config)
        [_config loadConfig];
}

-(void)saveConfig
{
    if(_config)
        [_config saveConfig];
    
}

@end
