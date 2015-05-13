//
//  AppDelegate.h
//  Descom_LED_Control
//
//  Created by mac book on 15-4-18.
//  Copyright (c) 2015年 jinslight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "DataModuleControl.h"
#import "BLENetworkControl.h"
#import "ASIHTTPRequestDelegate.h"

#define registerURL @"http://www.jinslight.com:8080/LightServer/register"

@interface AppDelegate : UIResponder <UIApplicationDelegate,ASIHTTPRequestDelegate>
{
    DataModuleControl *_config;
    
    UIImageView  *_SplashImage;
    UIView *_SplashView;
    
    int _stop;
}


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainViewController *mainViewController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) UINavigationController *viewController;
//@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) BLENetworkControl *BLENetworkControl;
@property (strong, nonatomic) DataModuleControl *config;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (float)getIOSVersion;
- (void)savedUUID:(NSString *)uuid;

- (NSString *)fetchUUID;

-(void)reachabilityChanged:(NSNotification*)note;





@end
