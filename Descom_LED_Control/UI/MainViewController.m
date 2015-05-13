//
//  MainViewController.m
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-9-3.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import "MainViewController.h"
#import "ProgramViewController.h"
#import "AppDelegate.h"
#import "XYAlertViewHeader.h"
#import "UIDevice+Resolutions.h"
//#import <SystemConfiguration/SystemConfiguration.h>
//#import <Reachability.h>
#import "MainWindowNavbar.h"


#define _DEBUGLAMB 1

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      
        
        int currentResolution = (int)[UIDevice currentResolution];
        
        _GetModeulInfoQuenue = [[NSOperationQueue alloc] init];
        
        CGRect screen = [ UIScreen mainScreen ].bounds;
        
        int topLine = 0;
        int advertHeight = 240;
        //广告导航，广告列表
        if(currentResolution >= UIDevice_iPadStandardRes)
        {
            topLine = 20;
            advertHeight = 430;
        }
        
        CGRect rect = CGRectMake(0, topLine, screen.size.width, advertHeight);
        _flashs = [[FlashViewController alloc] initWithPlistName:@"FlashPanel" frame:rect];
        [self.view addSubview:_flashs];

        topLine += advertHeight;
        
        CGRect r1 = CGRectMake(0, topLine, screen.size.width, screen.size.height - topLine - 100);
        _lamps = [[LampListView alloc] initWithFrame:r1];
        _lamps.delegate = self;
        
        [self.view addSubview:_lamps];

#ifdef _DEBUGLAMB
        for(int i = 0; i < 20; i++)
        {
            Device *dev = [[Device alloc] initWithName:1 name:NSLocalizedString(@"lampName", nil) it:0 type:2  seg:4 uuid:@"12333" sid:@"" pwd:@"" ipaddr:@"" maddr:@"" md:0 st:0 to:1 tc:1];
            [_lamps addDevice:dev];
        }
#endif
        

        //启动扫描
        NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
            [self scanModuleInfoAction:@"scan Operation"];
        }];
        
        [_GetModeulInfoQuenue addOperation:op];

    }
    
    return self;
}

//扫描设备
-(void)scanModuleInfoAction:(id)obj
{
    //    延迟2秒
    [NSThread sleepForTimeInterval:2.0f];
    
    AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(apd)
    {
        [apd.BLENetworkControl ScanBLEPrepharal ];
    }
}


//只有一个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}


//加载
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self.navigationItem setNewTitle:@"ShowLight"];
    
//    [self.navigationItem setNewTitleImage:[UIImage imageNamed:@"bar_logo.png"]];
    [self.navigationItem setRightItemWithTarget:self action:@selector(refresh) title:@"refresh"];
    
    
}

//设置config，更新数据
-(void) setConfig:(DeviceProperty*) cfg
{
    _config = cfg;
    
}

//打开对话框
-(void) dismissAlertShowMessage:(NSString*)text
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"stringMessage", nil)  message:text delegate:self cancelButtonTitle:NSLocalizedString(@"CancelButton", nil)  otherButtonTitles:NSLocalizedString(@"OKButton", nil) , nil];
    
    [alert show];
}


//打开控制窗口
-(void)dismissAlertShowSceneControl:(Device*)dev
{
    
//
//    if(!_sceneView)
//    {
//        _sceneView = [[SceneControlView alloc] init];
//        _sceneView.delegate = self;
//    }
//    
//    
    //if(_sceneView)
    {
        
        AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
#ifndef _DEBUGLAMB
        if( apd && apd.BLENetworkControl.cbConnected)
#endif
        {
            ProgramViewController *progview = [[ProgramViewController alloc] initWithDevice:dev ble:apd.BLENetworkControl];

            
//            [_sceneView setBLENetwork:apd.BLENetworkControl];
//            
//            [_sceneView setDevice:dev];
            [self presentViewController:progview animated:FALSE completion:nil];
        }
    }
    
}
- (void) didEditPanel:(int)index
{
}

- (void) didSelectPanel:(int)index
{
}

-(void) didEditLamp:(int)index
{
    Device *dev = [_lamps getDeviceByIndex:index];
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"setupDeviceName", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"CnacelButton", nil) otherButtonTitles:NSLocalizedString(@"ModifyButton", nil) ,nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    _nameedit = [alert textFieldAtIndex:0];
    
    if(dev)
        _nameedit.text = dev.name;
    else
        _nameedit.text = @"";
    
    alert.tag = 88 + index;
    [alert show];
}

//选择设备进行链接
-(void) didSelectLamp:(int) index
{
    NSLog(@"panel %d is selected.",index);
    
    
    
    //Device *dev = [_config.getDeviceList objectAtIndex:index];
    Device *dev = [_lamps getDeviceByIndex:index];
//    AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
#ifdef _DEBUGLAMB
    [self dismissAlertShowSceneControl:dev];
    return;
#endif
    

    
    
   
}

//修改名称以后保存到配置文件中
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag > 87)
    {
        if(buttonIndex > 0)
        {
            Device * dev = [_lamps getDeviceByIndex:(int)alertView.tag - 88];
            
            if(dev){
                dev.name = _nameedit.text;
                
                [_lamps setDeviceByIndex:dev index:(int)alertView.tag - 88];
                [_config addDevice:dev];
                [_config saveConfig];
            }
        }
    }
}

-(void) changeSwitch:(BOOL) _switch
//- (void)changeSwitch:(int)_switch index : (int) tag
{
//    NSLog(@"改变开关 %d",_switch);
    AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(apd)
    {
        unsigned char data[20] = {0};
        _Comm *command = (_Comm *)data;
        command->version = 1;
        
        if(!_switch)
            command->command = (char)APP_COMMAND_SWITCH_ON;
        else
            command->command = (char)APP_COMMAND_SWITCH_OFF;
        
        [apd.BLENetworkControl SendDataToPrepharal:(unsigned char *)data];
    }
}

- (void)changeName:(NSString *)_name index :(int) tag
{
//    NSLog(@"改变名称 %@,%d",_name,tag);
}

-(void) changeColor:(float)_value
{
    AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(apd)
    {
        unsigned char data[20] = {0};
        _Comm *command = (_Comm *)data;
        float v = _value * 255 / 100;
        memset(command, (unsigned char)(int)v, sizeof(_Comm));

        command->version = 1;
        command->command = (char)APP_COMMAND_SET_COLOR;
        
//        NSLog(@"改变颜色 %f   %2x",_value,command->red);
        [apd.BLENetworkControl SendDataToPrepharal:data];
    }
}

- (void)changeLight:(float)_light
{
    AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(apd)
    {
        unsigned char data[20] = {0};
        _Comm *command = (_Comm *)data;
        
        if(_light == 2.0)
        {//小夜灯模式
            memset(command, (unsigned char)(int)2, sizeof(_Comm));
        } else {
            memset(command, (unsigned char)(int)(_light * 255), sizeof(_Comm));
        }

        command->version = 1;
        command->command = (char)APP_COMMAND_SET_LIGHT;

//        NSLog(@"改变亮度 %f   %2x",_light,command->red);
        [apd.BLENetworkControl SendDataToPrepharal:data];
    }
}

- (void)changeMode:(int)mode
{
//    NSLog(@"改变模式 %d",mode);
    AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(apd)
    {
        unsigned char data[20] = {0};
        _Comm *command = (_Comm *)data;
        memset(command, (unsigned char)mode, sizeof(_Comm));

        command->version = 1;
        command->command = (char)APP_COMMAND_SET_LIGHTCHANGE;
        
        [apd.BLENetworkControl SendDataToPrepharal:data];
    }

}

-(void) changeDelay:(int) delay{
//    NSLog(@"设置延时 %d",delay);
    AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(apd)
    {
        
        unsigned char data[20] = {0};
        _Comm *command = (_Comm *)data;
        memset(command, (unsigned char)delay, sizeof(_Comm));
        
        command->version = 1;
        command->command = (char)APP_COMMAND_SET_DELAY_ON;

        [apd.BLENetworkControl SendDataToPrepharal:data];
    }
}

/**
 //        Light    亮度  0-255
 //        One     开为1，关为0
 //        Two     开为1，关为0
 //        Three    开为1，关为0
 //        Four     开为1，关为0
 //        FIve     开为1，关为0
 **/
-(void) changeSegment:(int) light oneseg :(int) one twoseg :(int) two threeseh :(int) three fourseg :(int) four fiveseg :(int) five
{
    //    NSLog(@"设置分段开关 %d",delay);
    AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(apd)
    {
        unsigned char data[20] = {0};
        _Comm *command = (_Comm *)data;

        command->version = 1;
        command->command = (char)APP_COMMAND_SET_MUTISEG;
        command->value1 = (unsigned char)light; //        Light    亮度  0-255
        command->value2 = (unsigned char)one; //        One     开为1，关为0
        command->value3 = (unsigned char)two;  //        Two     开为1，关为0
        command->value4 = (unsigned char)three;//        Three    开为1，关为0
        command->value5 = (unsigned char)four; //        Four     开为1，关为0
        command->value6 = (unsigned char)five; //        FIve     开为1，关为0
        
        [apd.BLENetworkControl SendDataToPrepharal:data];
    }
}



/**
 //     type        灯泡、吸顶灯、天花灯 （0,1，2）
 //     亮度         0-255
 //     颜色          0-255
 //     多路选择       0000 0000  （只在天花灯使用）使用低4位表示，如第一路，第三路开为（0000 0101 = 5）
 **/
-(void) saveSetting:(int) type light:(int)light color:(int)color segment:(int) seg
{
    AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(apd)
    {
    
        unsigned char data[20] = {0};
        _Comm *command = (_Comm *)data;
    
    
        command->version = 1;
        command->command = (char)APP_COMMAND_SAVE;
        command->value1 = (unsigned char)type;      //  类型   灯泡、吸顶灯、天花灯 （0,1，2）
        command->value2 = (unsigned char)light;     //	亮度         0-255
        command->value3 = (unsigned char)color;     //	颜色          0-255
        command->value4 = (unsigned char)seg;       //  多路选择       0000 0000  （只在天花灯使用）使用低4位表示，如第一路，第三路开为（0000 0101 = 5）

        NSLog(@"APP_COMMAND_SAVE %x",seg);
        [apd.BLENetworkControl SendDataToPrepharal:data];
    }
    
}


//返回模块查询的数据
-(void) ReturnPeriopheralData:(unsigned char*)data slen:(int) len
{
    //以后会很多这种数据
    
    NSLog(@"ReturnPeriopheralData  %s",data);
    
    
    switch (*(data+1)) {
        case RESULT_TYPE_SAVE: //保存指令返回标志
        {
            
//            [_sceneView saveOK];
            //显示保存好了
        }
            break;
        case RESULT_TYPE_STATUS: //查询状态返回指令
        {
//            PResultData result = (PResultData)data;
            
            //将数据传递给控制界面
//            [_sceneView setStatus:result];
            
            
            
        }
            case RESULT_TYPE_PROGRAM:
        {
            //            PResultData result = (PResultData)data;
            
            //将数据传递给控制界面
            //            [_sceneView setStatus:result];
            
        }
            
            
            break;
        default:
            break;
    }
    
}

//获取当前运行状态
-(void)queryModuleInfoAction:(id)obj
{
    NSLog(@"%@----obj : %@ ",[NSThread currentThread], obj);
    
//    延迟2秒
    [NSThread sleepForTimeInterval:2.0f];
    

    AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(apd)
    {
        [apd.BLENetworkControl ReadDataFromPrepharal ];
    }
};

//获取程序列表
-(void)queryProgramInfoAction:(id)obj
{
    NSLog(@"%@----obj : %@ ",[NSThread currentThread], obj);
    
    //    延迟2秒
    [NSThread sleepForTimeInterval:2.0f];
    
    
    AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(apd)
    {
        [apd.BLENetworkControl ReadDataFromPrepharal ];
    }
};


//    连接设备,连接以后立马获取一个当前状态
-(void) ConnectedBLEDevice:(NSUUID*) uuid
{
//    NSLog(@"连接设备 uuid： %@",uuid);
    
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        [self queryModuleInfoAction:@"state Block Operation"];
    }];
    [_GetModeulInfoQuenue addOperation:op];

}

 //设备断开链接
-(void) DisconnectedBLEDevice:(NSUUID*) uuid
{
//    NSLog(@"断开设备 uuid:  %@",uuid);
    [_lamps Changeonline:NO uuid:uuid];
}

//发现设备
-(void) DiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData
{
    Device *dev = [_config getDeviceFromUUID:[peripheral.identifier UUIDString]];
                   
    if(dev == nil){
        NSString *title = (NSString*)[advertisementData objectForKey:@"kCBAdvDataLocalName"];
        NSLog(@" kCBAdvDataLocalName %@",title);
        
        NSString *name = @"ShowLightLED";
        
        NSRange range = [title rangeOfString:name];

        int typeint = 0;
        int segint = 0;
        if(range.location != NSNotFound)
        {
            NSString *typestr = [title substringFromIndex:(range.location + range.length)];
            
            if(typestr != nil)
                typeint = [typestr intValue];
            else
                typeint = 0;
            
            const char *char_title = [title cStringUsingEncoding:NSASCIIStringEncoding];
            char segchar = *(char_title+2);
            
            if(segchar == 'o')
            {
                segint = 0;
            } else {
                NSLog(@"%x",segchar);
                segint = (int) segchar;
            }
        }
//        else {
            //找不到数据  默认，不用管了
//        }
        
        //添加设备到配置文件中，下次使用
        NSLog(@"device type : %d,  seg : %d",typeint,segint);
        dev = [[Device alloc] initWithName:1 name:NSLocalizedString(@"lampName", nil) it:0 type:typeint seg:segint uuid:[peripheral.identifier UUIDString] sid:@"" pwd:@"" ipaddr:@"" maddr:@"" md:0 st:0 to:1 tc:1];
        
        [_config addDevice:dev];
        [_config saveConfig];
    }
    
    [_lamps addDevice:dev];
}

-(void) retuenMainView
{
//    NSLog(@"关闭控制界面");
    AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(apd)
    {
        [apd.BLENetworkControl ConnectedBLEPrepharal:FALSE];
    }
}


//二维码扫描结果
-(void)scanQRcodedidFinish:(NSString*)url
{
    NSLog(@"scanQRcodedidFinish : %@",url);
    
    //url = @"GoldenLightApp:lamp1:C7480F77-4A1B-0F91-AD1D-9F0A5BE36DA1:1";
    //判断是否正确的二维码，是正确的二维码，就截取设备信息，根据设备信息，判断是否新设备，如果是已有的设备信息，就不做添加，如果是新设备就添加到设备列表，保存到配置文件中，并刷新主界面，令蓝牙链接线程，动态搜索设备
    
    if(url)
    {
        NSArray *suburl = [url componentsSeparatedByString:@":"];
        
        if([suburl count] == 4  && [[suburl objectAtIndex:0] isEqualToString:@"GoldenLightApp"])
        {
        
            NSString *sname = [suburl objectAtIndex:1];
            NSString *suuid = [suburl objectAtIndex:2];
            NSString *stype = [suburl objectAtIndex:3];
            int itype = [stype intValue];
            
            Device *newDev = [[Device alloc] initWithName:0 name:sname it:0 type:itype seg:0 uuid:suuid sid:@"" pwd:@"" ipaddr:@"" maddr:@"" md:0 st:0 to:0 tc:0];
            
            [_config addDevice:newDev];
            [_config saveConfig];
            
            //重新刷新界面
            //[_buttons setDeviceList:[_config getDeviceList]];
        }
    }
}

//刷新设备信息
- (void)refresh
{
//    NSLog(@"scanLinkButtonscanLinkButtonscanLinkButtonscanLinkButton");
    
    AppDelegate *apd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(apd)
    {
        [apd.BLENetworkControl ScanBLEPrepharal];
        XYLoadingView *loadingView = XYShowLoading(NSLocalizedString(@"wait5minusMessage", nil));
        
        [loadingView performSelector:@selector(dismiss) withObject:nil afterDelay:5];
        [_lamps clearDevice];
    }
}


- (void)alertViewCancel:(UIAlertView *)alertView
{
    
}


- (void) leftButtonClick
{
    NSLog(@"- (void) leftButtonClick;- (void) leftButtonClick;- (void) leftButtonClick;- (void) leftButtonClick;");
}

- (void) rightButtonClick
{
    
}


@end
