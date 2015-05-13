//
//  AppDelegate.m
//  Descom_LED_Control
//
//  Created by mac book on 15-4-18.
//  Copyright (c) 2015年 jinslight. All rights reserved.
//
#import <Foundation/Foundation.h>

#import "AppDelegate.h"
#import "Reachability.h"
#import "ASIHTTPRequest.h"
#import "NSString+SBJSON.h"
#import "ServerData.h"
#import "MainWindowNavbar.h"
#import "ServerDataPaser.h"
#import "SSKeychain.h"


@implementation AppDelegate
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize config = _config;
@synthesize mainViewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _stop = 0;
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    _config = [[DataModuleControl alloc]init];
    
    //然后添加一个视图进去，否则导航栏也没有意义的
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.mainViewController = [[MainViewController alloc] initWithNibName:@"MainView_IPhone" bundle:nil];
    } else {
        self.mainViewController = [[MainViewController alloc] initWithNibName:@"MainView_IPad" bundle:nil];
    }
    
    [self.mainViewController setConfig: _config.config];
    
    
    
    UINavigationController *nav = [[UINavigationController alloc] initWithNavigationBarClass:[MainWindowNavbar class] toolbarClass:nil];
    
    nav.viewControllers = @[mainViewController];

    self.viewController.navigationBarHidden = NO;
    
    self.window.rootViewController = nav;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    
    //初始化蓝牙
    self.BLENetworkControl = [[BLENetworkControl alloc] initWithUUID:nil];
    self.BLENetworkControl.delegate = self.mainViewController;
    
    _SplashImage =[[UIImageView alloc]initWithFrame:self.window.frame];//初始化fView
    _SplashImage.image=[UIImage imageNamed:@"splash.png"];//图片f.png 到fView
    
    
    _SplashView = [[UIView alloc]initWithFrame:self.window.frame];//初始化rView
    
    [_SplashView addSubview:_SplashImage];//add 到rView
    
    [self.window addSubview:_SplashView];//add 到window
    
    [self performSelector:@selector(TheAnimation) withObject:nil afterDelay:2];//动画，2秒钟后切换到主界面
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    
    return YES;
}


//从活动状态到后台
- (void)applicationWillResignActive:(UIApplication *)application
{
    _stop =1;
}

//程序进入后台状态的时候
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    _stop = 1;
    
    [self.BLENetworkControl ConnectedBLEPrepharal:FALSE];
}

//程序从后台进入活动状态
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

//程序从挂起状态进入活动状态
- (void)applicationDidBecomeActive:(UIApplication *)application
{
   
    NSLog(@"applicationDidBecomeActive");
    
    _stop = 0;
    //启动网络线程，如果没有连接上，一直连
    [self.BLENetworkControl ScanBLEPrepharal];
    
    [self performSelector:@selector(TheAnimation) withObject:nil afterDelay:2];//动画，2秒钟后切换到主界面
    
    
    //然后检测网络状态
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.jinslight.com"];
    
    //线程块  如果有连线消息就打印连线
    reach.reachableBlock = ^(Reachability * reachability)
    {
        //异步线程
        dispatch_async(dispatch_get_main_queue(), ^{
            //blockLabel.text = @"Block Says Reachable";
            
            NSLog(@"Block Says Reachable");
            
            //启动沟通线程进行工作
            //            _stop = 0;
        });
    };
    
    //线程块  如果有断线消息就打印断线
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //blockLabel.text = @"Block Says Unreachable";
            NSLog(@"Block Says Unreachable");
            
            //关闭沟通线程
            _stop = 1;
            
        });
    };
    
    [reach startNotifier];
}

//退出的时候自动保存配置文件
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    
    NSLog(@"applicationWillEnterForeground");
    
    [self saveContext];
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Descom_LED_Control" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Descom_LED_Control.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}




//动画，2秒钟后切换到主界面
- (void)TheAnimation{
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.7 ;  // 动画持续时间(秒)
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionFade;//淡入淡出效果
    
    [UIView animateWithDuration:0.7 //速度0.7秒
                     animations:^{//修改rView坐标
                         _SplashView.frame = CGRectMake(self.window.frame.origin.x,
                                                        -self.window.frame.size.height,
                                                        self.window.frame.size.width,
                                                        self.window.frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }];
    
}



static void uncaughtExceptionHandler(NSException *exception) {
    
    NSLog(@"CRASH: %@",exception);
    
    NSLog(@"Stack Trace: %@",[exception callStackSymbols]);
    
    // Internal error reporting
}


-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        //        notificationLabel.text = @"Notification Says Reachable";
        NSLog(@"Notification Says Reachable");
        _stop = 0;
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            //启动沟通线程进行工作
            _stop = 0;
            
            [self listenServer];
        });
    }
    else
    {
        //        notificationLabel.text = @"Notification Says Unreachable";
        NSLog(@"Notification Says Unreachable");
        _stop = 1;
    }
}



//与服务器沟通，下载数据，注册，上传数据等
-(void) listenServer{
    for(int i = 0; i < 1; i++)
    {
        //后台的时候不干活
        if(_stop)
            return;
        
        //如果是第一次登录就注册
        NSString *uuid = [self fetchUUID ];
        if(uuid == nil)
        {
            //if(!_config.config.route.first)
            
            //构造链接
            NSMutableString *URL = [NSMutableString stringWithString:registerURL];
            //获取版本号
            [URL appendString:@"?version=1.2.1000"];
            
            //获取os
            NSString *os = [NSString stringWithFormat:@"&os=ios%f",[self getIOSVersion]];
            [URL appendString:os];
            
            //获取uuid
            NSString *uuidstr = [self createUUID];
            
            if(uuidstr.length>0)
            {
                [URL appendString:@"&uuid="];
                [URL appendString:uuidstr];
            }
            
            //获取mobile number
            NSString *mobile = [[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"];
            
            if(mobile.length>0){
                [URL appendString:@"&mobile="];
                [URL appendString:mobile];
            }
            
            //获取用户类型
            [URL appendString:@"&type=1"];
            
            
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:URL]];
            
            request.delegate = self;
            [request startAsynchronous];
        }
        
        
        //上传新设备mac或uuid
        //....
        
        //检查新广告版本
        
        [NSThread sleepForTimeInterval:30];
    }
}

#pragma mark - ASIHTTPRequestDelegate
//获取版本号
- (float)getIOSVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}


-(NSString*) createUUID {
    CFUUIDRef  uuidObj = CFUUIDCreate(nil);//create a new UUID
    NSString  *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString ;
}


- (void)savedUUID:(NSString *)uuid {
    SSKeychainQuery *query = [[SSKeychainQuery alloc] init];
    NSError *error;
	query.password = uuid;
    query.service = @"jinslight";
    query.account = @"shaocong_ye";
    query.synchronizationMode  = SSKeychainQuerySynchronizationModeYes;
    
    [query save:&error];
}


- (NSString *)fetchUUID {
    SSKeychainQuery *query = [[SSKeychainQuery alloc] init];
    NSError *error;
    
    query.service = @"jinslight";
    query.account = @"shaocong_ye";
    query.synchronizationMode  = SSKeychainQuerySynchronizationModeYes;
    
    query.password = nil;
    
    if ([query fetch:&error]) {
        return query.password;
    }
    return nil;
}

//解析JSON
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSMutableDictionary *jsonDict = [request.responseString  JSONValue];
    NSLog(@"request  : %@",request.responseString);
    
    
    //解析注册信息
    ServerDataPaser *paser =  [[ServerDataPaser alloc] init];
    
    MobileUser *user =[paser loadMobileUserRegister:jsonDict];
    if(user != nil)
    {
        
        //注册完以后需要保存到配置文件中
        [self savedUUID:user.uuid];
        
        _config.config.route.first = 1;
        _config.config.route.uuid = user.uuid;
        _config.config.route.serial = user.mid;
        [_config saveConfig];
    }
    
    
    
    //    NSMutableDictionary *userArray = [jsonDict objectForKey:@"MobileUser"];
    
    //    if(userArray)
    {
        
        
        //注册完以后需要保存到配置文件中
        //_config
    }
    
    //解析广告版本信息
    
    //解析控制信息
    
    
    
}

//接收数据失败,失败了就停止线程工作
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"请求失败");
    _stop = 1;
}



@end
