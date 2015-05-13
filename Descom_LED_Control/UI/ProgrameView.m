//
//  ProgrameView.m
//  Descom_LED_Control
//
//  Created by mac book on 15-4-19.
//  Copyright (c) 2015年 jinslight. All rights reserved.
//

#import "ProgrameView.h"
#import "SettingView.h"
#import "UIDevice+Resolutions.h"

#define CELL_HEIGHT 60


@implementation ProgramControlBar
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:135.0f/255.0 green:175.0f/255.0 blue:247.0f/255.0 alpha:1 ];
        self.userInteractionEnabled = YES;
        
        //一共5个按钮，每个按钮25  间隔10，中间那个居中，依次排开
        int middle = frame.size.width/2;
        
        int button_width = 24,split_width = 10;
        
        _pause_btn = [[UIButton alloc] initWithFrame:CGRectMake(middle - button_width/2 - split_width*2 - button_width*2, 6, button_width, button_width)];
        [_pause_btn setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        _pause_btn.tag = 0;
        [_pause_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        
        
        _run_btn = [[UIButton alloc] initWithFrame:CGRectMake(middle - button_width/2 - button_width - split_width, 6, button_width, button_width)];
        [_run_btn setBackgroundImage:[UIImage imageNamed:@"run.png"] forState:UIControlStateNormal];
        _run_btn.tag = 1;
        [_run_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        
        
        _add_btn = [[UIButton alloc] initWithFrame:CGRectMake(middle - button_width/2, 6, button_width, button_width)];
        [_add_btn setBackgroundImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
        _add_btn.tag = 2;
        [_add_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        
        _del_btn = [[UIButton alloc] initWithFrame:CGRectMake(middle + button_width/2  + split_width, 6, button_width, button_width)];
        [_del_btn setBackgroundImage:[UIImage imageNamed:@"del.png"] forState:UIControlStateNormal];
        _del_btn.tag = 3;
        [_del_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        
        
        _refresh_btn = [[UIButton alloc] initWithFrame:CGRectMake(middle + button_width/2 + button_width + split_width * 2, 6, button_width, button_width)];
        [_refresh_btn setBackgroundImage:[UIImage imageNamed:@"refresh.png"] forState:UIControlStateNormal];
        _refresh_btn.tag = 4;
        [_refresh_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        
        
        [self addSubview:_pause_btn];
        [self addSubview:_run_btn];
        [self addSubview:_add_btn];
        [self addSubview:_del_btn];
        [self addSubview:_refresh_btn];
    }
    return self;
}

-(void)btnClick:(UIButton*)sender
{
    if( delegate)
    {
        switch (sender.tag) {
            case 0:
                [delegate pauseProgram];
                break;
            case 1:
                [delegate runProgram ];
                break;
            case 2:
                [delegate addProgram];
                break;
            case 3:
                [delegate delProgram];
                break;
            case 4:
                [delegate refreshProgram];
                break;
                
            default:
                break;
        }
    }
    
}


@end


@implementation ProgrameCell
@synthesize programe_data = _programe_data;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _low_color = [UIColor colorWithRed:189.0f/255.0f green:189.0f/255.0f blue:189.0f/255.0f alpha:1.0f];
        
        _high_color = [UIColor colorWithRed:134.0f/255.0f green:155.0f/255.0f blue:209.0f/255.0f alpha:1.0f];
        
        
        int currentResolution = (int)[UIDevice currentResolution];
        
        int image_width = 50,index_left = 10,image_height = 28;
        int title_first_top = 3,title_second_top = 30,title_first_fontsize = 20,title_second_fontsize = 16;
        if(currentResolution >= UIDevice_iPadStandardRes)
        {
            image_width = 80;
            index_left = 20;
            image_height = 43;
            title_second_top = 40;
        }
        
        
        NSLog(@"%f",self.bounds.size.height);
        //左边是序号图片,占据50个宽度
        _index_img_p = [[UIImageView alloc] initWithFrame:CGRectMake(index_left, (60 - image_height)/2 , image_height, image_height)];
        _index_img_r = [[UIImageView alloc] initWithFrame:CGRectMake(index_left, (60 - image_height)/2 , image_height, image_height)];
        
        
        //上面一行是程序名称和起止时间 比整体的小100个宽度，比如iphone5就是220个宽度，要是ipad就大了
        _programe_number = [[UILabel alloc] initWithFrame:CGRectMake(image_width, title_first_top, 70, 24)];
        _programe_number.textAlignment = NSTextAlignmentLeft;
        _programe_number.font = [UIFont fontWithName:@"Helvetica-Bold" size:title_first_fontsize];
        _programe_number.textColor = _low_color;
        
        _context_date = [[UILabel alloc] initWithFrame:CGRectMake(image_width + 70, title_first_top, 210, 25)];
        _context_date.textAlignment = NSTextAlignmentLeft;
        _context_date.font = [UIFont fontWithName:@"HelveticaNeue" size:title_first_fontsize];
        _context_date.textColor = _low_color;
        
        //下面一行小子是颜色和模式
        _color_light = [[UILabel alloc] initWithFrame:CGRectMake(image_width, title_second_top, 150, 25)];
        _color_light.textAlignment = NSTextAlignmentLeft;
        _color_light.font = [UIFont fontWithName:@"HelveticaNeue" size:title_second_fontsize];
        _color_light.textColor = _low_color;
        
        _module = [[UILabel alloc] initWithFrame:CGRectMake(image_width+150, title_second_top, 60, 25)];
        _module.textAlignment = NSTextAlignmentLeft;
        _module.font = [UIFont fontWithName:@"HelveticaNeue" size:title_second_fontsize];
        _module.textColor = _low_color;
        
        //右边是当前进行时图标占据50个宽度
        _selected_img = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width - image_width, (self.bounds.size.height - image_height)/2 , image_height, image_height)];
        [_selected_img setImage:[UIImage imageNamed:@"selected.png" ]];
        _unselected_img = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width - image_width, (self.bounds.size.height - image_height)/2 , image_height, image_height)];
        [_unselected_img setImage:[UIImage imageNamed:@"select.png" ]];
        
        
        [self addSubview:_index_img_p];
        [self addSubview:_index_img_r];
        [self addSubview:_programe_number];
        [self addSubview:_module];
        [self addSubview:_context_date];
        [self addSubview:_color_light];
        
        [self addSubview:_selected_img];
        [self addSubview:_unselected_img];
        
        
        _selected_img.hidden = YES;
        
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


- (void)awakeFromNib
{
    // Initialization code
    
}

-(void) setPrograme_data:(ProgrameData *)programe_data
{
    if(_programe_data == nil)
    {
        _programe_data = (ProgrameData *)malloc(sizeof(ProgrameData));
    }
    
    _programe_data->programe = programe_data->programe;
    _programe_data->color = programe_data->color;
    _programe_data->light = programe_data->light;
    _programe_data->startTime = programe_data->startTime;
    _programe_data->endTime = programe_data->endTime;
    _programe_data->type = programe_data->type;
    _programe_data->running = programe_data->running;
    
    _programe_number.text = [[NSString alloc] initWithFormat:@"程序 %d",_programe_data->programe];
    _module.text = _programe_data->type ? @"小夜灯" : @"普通";
    
    _context_date.text = [[NSString alloc] initWithFormat:@" %d:%d - %d:%d",_programe_data->startTime,_programe_data->startTime, _programe_data->endTime ,_programe_data->endTime ];
    _color_light.text = [[NSString alloc] initWithFormat:@"颜色 %d  亮度 %d",_programe_data->color,_programe_data->light];
    
    int index = _programe_data->programe;
    if(index > 10)
        index = 10;
    
    NSString *p_img_name = [NSString stringWithFormat:@"p%d.png",index + 1 ];
    [_index_img_p setImage:[UIImage imageNamed:p_img_name]];
    
    NSString *r_img_name = [NSString stringWithFormat:@"r%d.png",index + 1 ];
    [_index_img_r setImage:[UIImage imageNamed:r_img_name]];

    
    if(programe_data->running == 1)
    {
        _programe_number.textColor = _high_color;
        _context_date.textColor = _high_color;
        _color_light.textColor = _high_color;
        _module.textColor = _high_color;
        
        _unselected_img.hidden = YES;
        _selected_img.hidden = NO;
        _index_img_p.hidden = NO;
        _index_img_r.hidden = YES;
        
    } else {
        _programe_number.textColor = _low_color;
        _context_date.textColor = _low_color;
        _color_light.textColor = _low_color;
        _module.textColor = _low_color;
        
        _unselected_img.hidden = NO;
        _selected_img.hidden = YES;
        
        _index_img_p.hidden = YES;
        _index_img_r.hidden = NO;
        
    }
    
}


//高亮状态
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
//    if(highlighted)
//        _programe_number.textColor = [UIColor whiteColor];
//    else
//        _programe_number.textColor = [UIColor blackColor];
    
    
}

//选中状态
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if(selected)
        self.backgroundColor = [UIColor colorWithRed:40.0f/255.0f green:40.0f/255.0f blue:40.0f/255.0f alpha:0.1f];
    else
        self.backgroundColor = [UIColor clearColor];
    
    UIColor *color = [UIColor colorWithRed:155.0f/255.0f green:155.0f/255.0f blue:155.0f/255.0f alpha:1.0f];
    if(selected)
        color = [UIColor colorWithRed:51.0f/255.0f green:85.0f/255.0f blue:177.0f/255.0f alpha:0.1f];

    
    _programe_number.textColor = color;
    

    
}

@end

@implementation ProgrameView


#define _DEBUG_PROG 1

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _program_count = 0;
        _program_lists = [[NSMutableArray alloc] init];
                          
        //模式初始化
#ifdef _DEBUG_PROG
        for(int i = 0; i < 8; i++)
        {
            ProgrameData prog;
            
            prog.programe = i + 1;
            prog.light = 10 + 3 * i;
            prog.color = 20 + 5 * i;
            prog.off = 1;
            prog.type = 1;
            prog.startTime = 20 + 2 * i;
            prog.endTime = 30 + 3*i;
            
            if(i == 4)
                prog.running = 1;
            else
                prog.running = 0;
            
            [_program_lists addObject:[NSValue value:&prog withObjCType:@encode(ProgrameData)]];
            _program_count ++;
        }
#endif
      
        int bar_height = 45;
        
        //指定位置大小
        _program_view = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-bar_height)];
        _program_view.backgroundColor = [UIColor clearColor];
        _program_view.delegate = self;
        _program_view.dataSource = self;
        
        _program_view.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_program_view];

        
        _control_bar = [[ProgramControlBar alloc] initWithFrame:CGRectMake(0, frame.size.height-bar_height, frame.size.width, bar_height)];
        _control_bar.delegate = self;
        [self addSubview:_control_bar];
        
    }
    return self;
}


#pragma - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;//返回标题数组中元素的个数来确定分区的个数
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _program_count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"programeCell";
    ProgrameCell *cell = (ProgrameCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    ProgrameData p;
    [[_program_lists objectAtIndex:indexPath.row] getValue:&p];
    
    
    if(!cell) {
        cell = [[ProgrameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
    }
    
    [cell setPrograme_data:&p];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (0 == indexPath.section) {
        //[self btnActionForUserSetting:self];
        
    }
}


//-----  ProgramControlBarDelegate
//如果当前程序正在执行，就暂停一下
-(void) pauseProgram
{
    NSLog(@"pauseProgram");
}

//如果当前程序暂停了，就开始执行
-(void) runProgram
{
    NSLog(@"runProgram");
    
}

//添加一个新程序，添加以后，当前界面刷新，然后跳转到设置界面中
-(void) addProgram
{
    NSLog(@"addProgram");
    
    ProgrameData prog;
    prog.programe = _program_count + 1;
    prog.light = 1.0;
    prog.color = 1.0;
    prog.off = 1;
    prog.type = 1;
    prog.startTime = 0;
    prog.endTime = 0;
    
    [_program_lists addObject:[NSValue value:&prog withObjCType:@encode(ProgrameData)]];
    _program_count ++;
    
    [_program_view reloadData];
    
    
//    然后跳转到设置界面
    if(self.deleagte){
       [self.deleagte createPrograme:&prog];
    }
    

}


//删除程序，删除当前选择的程序，弹出删除提示对话框，选择是就删除，焦点进入到下一个程序
-(void) delProgram
{
    NSLog(@"delProgram");
    
    ProgrameData p;
    [[_program_lists objectAtIndex:[_program_view indexPathForSelectedRow].row ] getValue:&p];

    

    //弹出模式窗口，询问是否删除程序
    
    
    if(self.deleagte)
    {
        [self.deleagte dropPrograme:&p];
    }

}

//刷新功能，判断当前连接是否有效，有效就刷新，无效就连接，然后刷新，多次连接无效就弹出提示框，报告网络无效
-(void) refreshProgram
{
    NSLog(@"refreshProgram");
    //先删除所有数据
    [_program_lists removeAllObjects];
    _program_count = 0;
    
    [_program_view reloadData];
    
    //然后发布刷新指令
    if(self.deleagte)
    {
        [self.deleagte refreshPrograme];
    }
}

@end
