//
//  ProgramViewController.m
//  Descom_LED_Control
//
//  Created by mac book on 15-4-19.
//  Copyright (c) 2015年 jinslight. All rights reserved.
//

#import "ProgramViewController.h"
#import "NBTabController.h"
#import "NBTabButton.h"
#import "UINavigationBar+customBar.h"




@interface ProgramViewController ()

@end

@implementation ProgramViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id)initWithDevice:(Device*)device ble:(BLENetworkControl*)ble
{
    self = [super init];
    if (self) {
    }
    return self;

}

-(void) commonInit
{
    int top = 20;

    
    _navigateBar = [[NavigateBarView alloc] initWithDevice:CGRectMake(0, top, self.view.frame.size.width, 44) device:nil];
    [_navigateBar setCaptureText:@"Room"];
    _navigateBar.delegate = self;
    [self.view addSubview:_navigateBar];
    top += 45;
    
    
    _control = [[ProgramControlView alloc] initWithFrame:CGRectMake( 0, top, self.view.frame.size.width, self.view.frame.size.height)];
    _control.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_control];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self commonInit];
}

-(void)rightButtonClick:(UIButton* )sender
{
    NSLog(@"navigationBackButton");
}

- (void) saveButton : (id)sender
{
    NSLog(@"saveButton");
}

- (void) leftButtonClick
{
//    [self.delegate  retuenMainView];
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void) rightButtonClick
{
    
}

@end
