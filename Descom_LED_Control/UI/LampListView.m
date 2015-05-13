//
//  LampListView.m
//  LED_light_bulbs_for_network_control
//
//  Created by mac book on 14-12-25.
//  Copyright (c) 2014年 mac book. All rights reserved.
//

#import "LampListView.h"
#import "LampCell.h"

@implementation LampListView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _device_list = [[NSMutableArray alloc] init];

        _flowLayout= [[KRLCollectionViewGridLayout alloc]init];
        _flowLayout.numberOfItemsPerLine = 2;
        _flowLayout.aspectRatio = 1;
        _flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 30);
        _flowLayout.interitemSpacing = 5;
        _flowLayout.lineSpacing = 5;

        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:_flowLayout];
        [self addSubview:_collectionView];
        [_collectionView registerClass:[LampCell class]
            forCellWithReuseIdentifier:@"Cell"];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
    }
    return self;
}

- (id)initWithDevice:(NSArray *)devices frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if(_device_list == nil)
            _device_list = [[NSMutableArray alloc] init];
        
        [_device_list addObjectsFromArray:devices];
        
        
        // Initialization code
        _device_list = [[NSMutableArray alloc] init];
        
        _flowLayout= [[KRLCollectionViewGridLayout alloc]init];
        _flowLayout.numberOfItemsPerLine = 2;
        _flowLayout.aspectRatio = 1;
        _flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 30);
        _flowLayout.interitemSpacing = 7;
        _flowLayout.lineSpacing = 7;
        
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:_flowLayout];
        [self addSubview:_collectionView];
        [_collectionView registerClass:[LampCell class]
            forCellWithReuseIdentifier:@"Cell"];
        _collectionView.delegate=self;
        _collectionView.dataSource=self;

    }
    
    return self;
}

//行间距
//-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 50;
//}

- (UICollectionViewFlowLayout *)layout
{
    return (id)_collectionView.collectionViewLayout;
}

         
         
//只有一种可能
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _device_list.count;
}

//构建每一个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LampCell *lamp = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
  
    Device *dev = [_device_list objectAtIndex:indexPath.row];
    
    
    if(lamp.device == nil)
        [lamp setDevice:dev];
    lamp.tag = indexPath.row;
    
    lamp.delegate = self;
    
    return lamp;
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LampCell * cell = (LampCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if(cell)
    {
        
    }
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}




- (void)addDevice:(Device *)device
{
    
    if(_device_list == nil)
        _device_list = [[NSMutableArray alloc] init];
    
    if(_device_list)
    {
        BOOL has = FALSE;
        
        for(Device *dev in _device_list)
        {
            if([dev.uuid isEqualToString: device.uuid]){
                has = TRUE;
                
                break;
            }
        }
        
        if(!has)
            [_device_list addObject:device];
    }
    
    [_collectionView reloadData];
}

- (void)removeButtonByIndex:(int)index
{
    [_device_list removeObjectAtIndex:index];
    [_collectionView reloadData];
}

- (void)clearDevice
{
    [_device_list removeAllObjects];
    [_collectionView reloadData];
}

//连接设备
-(void)didSelectButton:(int)index
{
    if(self.delegate)
    {
        [self.delegate didSelectLamp:index];
    }
}

//编辑设备名
-(void)didEditButton:(int)index
{
    if(self.delegate)
    {
        [self.delegate didEditLamp:index];
    }
}

- (Device*)getDeviceByIndex:(int)index
{
    return [_device_list objectAtIndex:index];
}


//- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation NS_AVAILABLE_IOS(3_0);
//{
//    NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:1 inSection:0];
//    NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
//    [regTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
//    
//}


- (void)setDeviceByIndex:(Device *)device index:(int)index
{
    if(index > ([_device_list count] - 1))
        return;
    
    [_device_list replaceObjectAtIndex:index withObject:device];
    
    [_collectionView reloadData];
}

- (void)Changeonline:(BOOL)online uuid:(NSUUID *) uuid
{
    int index = 0;
    
    for(Device * dev in _device_list)
    {
        if([dev.uuid isEqualToString:[uuid UUIDString]])
        {
            
            dev.online = online;
            [_collectionView reloadData];
        }
        
        index++;
    }
}


-(void)didSelectLamp :(int) index
{
        NSLog(@"didSelectLamp");
}

-(void)didEditLamp : (int)index
{
        NSLog(@"didEditLamp");
}

@end
