//
//  SettingItem.m
//  Descom_LED_Control
//
//  Created by mac book on 15-4-19.
//  Copyright (c) 2015年 jinslight. All rights reserved.
//

#import "SettingItem.h"
#import "UIDevice+Resolutions.h"

@implementation SettingItem
@synthesize title_lab = _title_lab;
@synthesize moveon = _moveon;
@synthesize enable = _enable;
@synthesize frame_resolution = _frame_resolution;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _moveon = NO;
        _enable = YES;
        
        self.backgroundColor = [UIColor clearColor];
        //确定屏幕大小
        _frame_resolution = (int)[UIDevice currentResolution];

        //左边的标题栏
        _title_lab = [[UILabel alloc] initWithFrame:CGRectMake(10, (frame.size.height/2 - 14),
                        100, 28)];
        _title_lab.text = @"标题";
        _title_lab.backgroundColor = [UIColor clearColor];
        _title_lab.textColor = [UIColor colorWithRed:154.0f/255.0f green:154.0f/255.0f blue:154.0f/255.0f alpha:1.0f];
        [self addSubview:_title_lab];
        
        
        //添加点按处理
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.delegate = self;
        singleTap.cancelsTouchesInView = NO;
        singleTap.numberOfTapsRequired = 1;
        
        [self addGestureRecognizer:singleTap];

    }
    
    return self;
}


- (void)drawRect:(CGRect)rect
{
    //画下分割线
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0x40/255, 0x40/255, 0x40/255, 0.1);//线条颜色
    CGContextSetLineWidth(context, 1.0);//线的宽度
    CGContextMoveToPoint(context, 0, rect.size.height-2);
    CGContextAddLineToPoint(context, rect.size.width,rect.size.height-2);
    CGContextMoveToPoint(context, 0, rect.size.height-1);
    CGContextAddLineToPoint(context, rect.size.width,rect.size.height-1);
    CGContextStrokePath(context);
    
}

-(UIImage*)  OriginImage:(UIImage *)image   scaleToSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}


-(void) handleSingleTap:(id) sender
{
    _moveon = !_moveon;

    if(_moveon)
    {
        self.backgroundColor = [UIColor colorWithRed:0x40/255 green:0x40/255 blue:0x40/255 alpha:0.1];
    } else {
        self.backgroundColor = [UIColor  clearColor];
    }

    if(self.delegate)
       [self.delegate clickView:self];
    
}


-(void) changMoveon
{
    _moveon = !_moveon;
    
    if(_moveon)
    {
        self.backgroundColor = [UIColor colorWithRed:0x40/255.0f green:0x40/255 blue:0x40/255 alpha:0.1];
    } else {
        self.backgroundColor = [UIColor  clearColor];
    }
 
}

@end




@implementation SetttingNumberItem
@synthesize number_lab = _number_lab;
@synthesize number = _number;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //右边的文字栏
        _number_lab = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-90, (frame.size.height/2 - 14),
                                                               50, 28)];
        _number_lab.text = @"0";
        [self addSubview:_number_lab];

    }
    return self;
}

-(void) setNumber:(int)number
{
    _number = number;
    
    _number_lab.text = [[NSString alloc] initWithFormat:@"%d",number];
}

@end

@implementation SetttingDateItem
@synthesize start = _start;
@synthesize end = _end;
@synthesize separator_lab = _separator_lab;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        _start_date_picker = [[MGConferenceDatePicker alloc] initWithFrame:CGRectMake(frame.size.width-230.0f, 0.0f,100, frame.size.height)];
        
        [_start_date_picker setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_start_date_picker];
        

        _separator_lab = [[UILabel alloc] initWithFrame:CGRectMake(185.0f, frame.size.height/2 - 12,30, 24)];
        
        _separator_lab.text = @"--";
        _separator_lab.textAlignment = NSTextAlignmentCenter;
        _separator_lab.textColor = [UIColor greenColor];
        [self addSubview:_separator_lab];
        
        _end_date_picker = [[MGConferenceDatePicker alloc] initWithFrame:CGRectMake(frame.size.width-100.0f, 0.0f,100.0f, frame.size.height)];
        
        //        [datePicker setDelegate:self];
        
        [_end_date_picker setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_end_date_picker];
        
    }
    return self;
}

-(void) dataClick:(id)sender
{
    NSLog(@"data click");
    
//    [_data setClick];
}

-(void) setStart:(int)start
{
    _start = start;
    
//    _start_time.text = [[NSString alloc] initWithFormat:@"%d:%d",start,start];
}

-(void) setEnd:(int)end
{
    _end = end;
    
//    _end_time.text = [[NSString alloc] initWithFormat:@"%d:%d",end,end];
    
}


@end


@implementation SetttingProgressItem
@synthesize progress = _progress;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        int componentwidth = 200,thumb_width = 22;
        switch (_frame_resolution) {
                // iPhone 1,3,3GS 标准分辨率(320x480px)
            case UIDevice_iPhoneStandardRes:
                break;
                // iPhone 4,4S 高清分辨率(640x960px)
            case UIDevice_iPhoneHiRes:
                // iPhone 5 高清分辨率(640x1136px)
            case UIDevice_iPhoneTallerHiRes:
                break;
                
                // iPad 1,2 标准分辨率(1024x768px)
            case UIDevice_iPadStandardRes:
                componentwidth = 400;
                break;
                
                // iPad 3 High Resolution(2048x1536px)
            case UIDevice_iPadHiRes:
                componentwidth = 800;
                break;
                
            default:
                break;
        }
        
        _progress = [[UISlider alloc] initWithFrame:CGRectMake(frame.size.width-componentwidth, (frame.size.height/2 - 12),componentwidth, 22)];
        _progress.value = 0.5;
        //滑块图片
        UIImage *thumb = [UIImage imageNamed:@"open_button.png"];
        _thumbImage = [self OriginImage:thumb scaleToSize:CGSizeMake(thumb_width, thumb_width)];

        
        //注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
        [_progress setThumbImage:_thumbImage forState:UIControlStateHighlighted];
        [_progress setThumbImage:_thumbImage forState:UIControlStateNormal];

        
        [self addSubview:_progress];
        

        _persent_0 = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-componentwidth, (frame.size.height/2 + 4),30, 16)];
        _persent_0.text = @"0%";
        _persent_0.backgroundColor = [UIColor clearColor];
        _persent_0.textColor = [UIColor colorWithRed:154.0f/255.0f green:154.0f/255.0f blue:154.0f/255.0f alpha:1.0f];
        _persent_0.textAlignment = NSTextAlignmentLeft;
        _persent_0.font = [UIFont boldSystemFontOfSize:11];
        [self addSubview:_persent_0];

        
        _persent_100 = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-40, (frame.size.height/2 + 4),40, 16)];
        _persent_100.text = @"100%";
        _persent_100.backgroundColor = [UIColor clearColor];
        _persent_100.textColor = [UIColor colorWithRed:154.0f/255.0f green:154.0f/255.0f blue:154.0f/255.0f alpha:1.0f];
        _persent_100.textAlignment = NSTextAlignmentRight;
        _persent_100.font = [UIFont boldSystemFontOfSize:11];
        [self addSubview:_persent_100];

        
        
    }
    return self;
}


@end


@implementation SetttingSelectItem
@synthesize check = _check;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _check = NO;
        
        _uncheck_img = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - 48, (frame.size.height - 28)/2 ,
                                                                     24, 24)];
        [_uncheck_img setImage:[UIImage imageNamed:@"select.png"]];
        [self addSubview:_uncheck_img];
        
        _checked_img = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_checked_img setImage:[UIImage imageNamed:@"selected.png"]];
        [self addSubview:_checked_img];

    }
    return self;
}



- (void) unclicked
{
    _check = NO;
    
    [_checked_img setFrame:CGRectZero];
    
    
    [_uncheck_img setFrame: CGRectMake(self.frame.size.width - 48, (self.frame.size.height - 24)/2 ,
                                       24, 24)];
}

- (void) clicked
{
    _check = YES;
    
    [_uncheck_img setFrame:CGRectZero];

    [_checked_img setFrame: CGRectMake(self.frame.size.width - 48, (self.frame.size.height - 24)/2 ,
                                       24, 24)];
    
}


@end



@implementation SetttingSwtichItem
@synthesize off = _off;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _off = [[DCRoundSwitch alloc] initWithFrame:CGRectMake(self.frame.size.width - 80, (frame.size.height-30)/2, 60, 24)];
        
        [_off addTarget:self action:@selector(offToggled:) forControlEvents:UIControlEventValueChanged];

        [self addSubview:_off];
    }
    return self;
}

-(void)offToggled:(id) sender
{
    
}

@end

