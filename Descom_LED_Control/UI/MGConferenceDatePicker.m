//
//  MGConferenceDatePicker.m
//  MGConferenceDatePicker
//
//  Created by Matteo Gobbi on 09/02/14.
//  Copyright (c) 2014 Matteo Gobbi. All rights reserved.
//

#import "MGConferenceDatePicker.h"

//Check screen macros
#define IS_WIDESCREEN (fabs ( (double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 )
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

//Editable macros
#define TEXT_COLOR [UIColor colorWithWhite:0.5 alpha:1.0]
#define SELECTED_TEXT_COLOR [UIColor whiteColor]
#define LINE_COLOR [UIColor colorWithWhite:0.80 alpha:1.0]
#define SAVE_AREA_COLOR [UIColor colorWithWhite:0.95 alpha:1.0]
#define BAR_SEL_COLOR [UIColor colorWithRed:76.0f/255.0f green:172.0f/255.0f blue:239.0f/255.0f alpha:0.8]

//Editable constants
//static const float VALUE_HEIGHT = 30.0;
//static const float SV_HOURS_WIDTH = 50.0;
//static const float SV_MINUTES_WIDTH = 50.0;

//Editable values
float PICKER_HEIGHT = 80.0;
NSString *FONT_NAME = @"HelveticaNeue";

//Static macros and constants
#define SELECTOR_ORIGIN (PICKER_HEIGHT/2.0-VALUE_HEIGHT/2.0)
#define SAVE_AREA_ORIGIN_Y self.bounds.size.height-SAVE_AREA_HEIGHT
#define PICKER_ORIGIN_Y SAVE_AREA_ORIGIN_Y-SAVE_AREA_MARGIN_TOP-PICKER_HEIGHT
#define BAR_SEL_ORIGIN_Y PICKER_HEIGHT/2.0-_cell_height/2.0


//Custom UIButton
@implementation MGPickerButton

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setTitleColor:BAR_SEL_COLOR forState:UIControlStateNormal];
        [self setTitleColor:SELECTED_TEXT_COLOR forState:UIControlStateHighlighted];
        [self.titleLabel setFont:[UIFont fontWithName:FONT_NAME size:18.0]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat outerMargin = 5.0f;
    CGRect outerRect = CGRectInset(self.bounds, outerMargin, outerMargin);
    CGFloat radius = 6.0;
    
    CGMutablePathRef outerPath = CGPathCreateMutable();
    CGPathMoveToPoint(outerPath, NULL, CGRectGetMidX(outerRect), CGRectGetMinY(outerRect));
    CGPathAddArcToPoint(outerPath, NULL, CGRectGetMaxX(outerRect), CGRectGetMinY(outerRect), CGRectGetMaxX(outerRect), CGRectGetMaxY(outerRect), radius);
    CGPathAddArcToPoint(outerPath, NULL, CGRectGetMaxX(outerRect), CGRectGetMaxY(outerRect), CGRectGetMinX(outerRect), CGRectGetMaxY(outerRect), radius);
    CGPathAddArcToPoint(outerPath, NULL, CGRectGetMinX(outerRect), CGRectGetMaxY(outerRect), CGRectGetMinX(outerRect), CGRectGetMinY(outerRect), radius);
    CGPathAddArcToPoint(outerPath, NULL, CGRectGetMinX(outerRect), CGRectGetMinY(outerRect), CGRectGetMaxX(outerRect), CGRectGetMinY(outerRect), radius);
    CGPathCloseSubpath(outerPath);
    
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, (self.state != UIControlStateHighlighted) ? BAR_SEL_COLOR.CGColor : SELECTED_TEXT_COLOR.CGColor);
    CGContextAddPath(context, outerPath);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self setNeedsDisplay];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [self setNeedsDisplay];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    [self setNeedsDisplay];
}

@end


//Custom scrollView

@implementation MGPickerScrollView

//Constants
const float LBL_BORDER_OFFSET = 8.0;

//Configure the tableView
- (id)initWithFrame:(CGRect)frame andValues:(NSArray *)arrayValues
      withTextAlign:(NSTextAlignment)align andTextSize:(float)txtSize {
    
    if(self = [super initWithFrame:frame]) {
        [self setScrollEnabled:YES];
        [self setShowsVerticalScrollIndicator:NO];
        [self setUserInteractionEnabled:YES];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        //控制可以滚动的区域
        [self setContentSize:CGSizeMake(frame.size.width, frame.size.height * 9)];
        
        //设置停留位置
        //当前显示区域顶点相对于frame顶点的偏移量
        [self setContentOffset: CGPointMake(0,0)];
        
        //scrollview的contentview的顶点相对于scrollview的位置
        [self setContentInset:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
        
        _cellFont = [UIFont fontWithName:FONT_NAME size:txtSize];
        
        if(arrayValues)
            _arrValues = [arrayValues copy];
    }
    return self;
}


//重新加载数据,这是响应开始拖动后的操作
- (void)dehighlightLastCell {
    NSArray *paths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:_tagLastSelected inSection:0], nil];
    
    [self setTagLastSelected:-1];
    [self beginUpdates];
    [self reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
    [self endUpdates];
}

//中间行高亮
- (void)highlightCellWithIndexPathRow:(NSUInteger)indexPathRow {
    [self setTagLastSelected:indexPathRow];
    
    NSArray *paths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:_tagLastSelected inSection:0], nil];
    [self beginUpdates];
    [self reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
    [self endUpdates];
}

@end


//Custom Data Picker
@interface MGConferenceDatePicker ()

@property (nonatomic, strong) NSArray *arrHours;
@property (nonatomic, strong) NSArray *arrMinutes;

@property (nonatomic, strong) MGPickerScrollView *svHours;
@property (nonatomic, strong) MGPickerScrollView *svMins;

@end


@implementation MGConferenceDatePicker
@synthesize  hour = _hour;
@synthesize  minute = _minute;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
        [self buildControl];

    }
    return self;
}

-(void)drawRect:(CGRect)rect {
}

- (void)initialize {
    
    _cell_height = 30;
    _hour_width = 50;
    _minute_width = 50;
    _hour = 0;
    _minute = 0;

    //小时列表  24小时
    NSMutableArray *arrHours = [[NSMutableArray alloc] initWithCapacity:26];
    [arrHours addObject:@""];
    for(int i=1; i<25; i++) {
        [arrHours addObject:[NSString stringWithFormat:@"%2d",i]];
    }
    
    [arrHours addObject:@""];
    _arrHours = [NSArray arrayWithArray:arrHours];
    
    //分钟列表  最小单位10分钟
    NSMutableArray *arrMinutes = [[NSMutableArray alloc] initWithCapacity:8];
    [arrMinutes addObject:@""];
    for(int i=0; i<6; i++) {
        [arrMinutes addObject:[NSString stringWithFormat:@"%d",i * 10]];
    }
    [arrMinutes addObject:@""];
    _arrMinutes = [NSArray arrayWithArray:arrMinutes];
    
}


- (void)buildControl {

    //创建选择器
    //创建选择条，灰色背景   BAR_SEL_ORIGIN_Y
    UIView *barSel = [[UIView alloc] initWithFrame:CGRectMake(0.0, _cell_height, _hour_width + _minute_width, _cell_height)];
    [barSel setBackgroundColor:BAR_SEL_COLOR];
    
    //创建小时列
    _svHours = [[MGPickerScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, _hour_width, self.frame.size.height) andValues:_arrHours withTextAlign:NSTextAlignmentRight andTextSize:16.0];
    _svHours.tag = 0;
    [_svHours setDelegate:self];
    [_svHours setDataSource:self];
    
    //分钟列
    _svMins = [[MGPickerScrollView alloc] initWithFrame:CGRectMake(_hour_width, 0.0, _minute_width, self.frame.size.height) andValues:_arrMinutes withTextAlign:NSTextAlignmentCenter andTextSize:16.0];
    _svMins.tag = 2;
    [_svMins setDelegate:self];
    [_svMins setDataSource:self];

    //竖线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1.0, self.frame.size.height)];
    [line setBackgroundColor:LINE_COLOR];

    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(_hour_width - 1.0, 0.0, 1.0, self.frame.size.height)];
    [line2 setBackgroundColor:LINE_COLOR];

    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(_hour_width + _minute_width -1.0, 0.0, 1.0, self.frame.size.height)];
    [line3 setBackgroundColor:LINE_COLOR];

    //横线
    CAGradientLayer *gradientLayerTop = [CAGradientLayer layer];
    gradientLayerTop.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height/2.0);
    gradientLayerTop.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor, (id)self.backgroundColor.CGColor, nil];
    gradientLayerTop.startPoint = CGPointMake(0.0f, 0.7f);
    gradientLayerTop.endPoint = CGPointMake(0.0f, 0.0f);
    
    CAGradientLayer *gradientLayerBottom = [CAGradientLayer layer];
    gradientLayerBottom.frame = CGRectMake(0.0, self.frame.size.width/2.0, self.frame.size.width, self.frame.size.height/2.0);
    gradientLayerBottom.colors = gradientLayerTop.colors;
    gradientLayerBottom.startPoint = CGPointMake(0.0f, 0.3f);
    gradientLayerBottom.endPoint = CGPointMake(0.0f, 1.0f);
    
    //Add the bar selector
    [self addSubview:barSel];
    
    //Add scrollViews
    [self addSubview:_svHours];
    [self addSubview:_svMins];
    
    [self addSubview:line];
    [self addSubview:line2];
    [self addSubview:line3];
    
    //Add gradients
    [self.layer addSublayer:gradientLayerTop];
    [self.layer addSublayer:gradientLayerBottom];
    
}



#pragma mark - Other methods


//中间位置处理   Center the value in the bar selector
- (void)centerValueForScrollView:(MGPickerScrollView *)scrollView {
    
    //Takes the actual offset
    float offset = scrollView.contentOffset.y;
    
    //Removes the contentInset and calculates the prcise value to center the nearest cell
    offset += scrollView.contentInset.top;
    int mod = (int)offset%(int)_cell_height;
    float newValue = (mod >= _cell_height/2.0) ? offset+(_cell_height-mod) : offset-mod;
    
    //Calculates the indexPath of the cell and set it in the object as property
    NSInteger indexPathRow = (int)(newValue/_cell_height);
    
    //Center the cell
    [self centerCellWithIndexPathRow:indexPathRow forScrollView:scrollView];
}

//定位每个cell的中间位置
- (void)centerCellWithIndexPathRow:(NSUInteger)indexPathRow forScrollView:(MGPickerScrollView *)scrollView {
    
    if(indexPathRow >= [scrollView.arrValues count]) {
        indexPathRow = [scrollView.arrValues count]-1;
    }
    
    float newOffset = indexPathRow*_cell_height;
    
    //Re-add the contentInset and set the new offset
    newOffset -= BAR_SEL_ORIGIN_Y;
    [scrollView setContentOffset:CGPointMake(0.0, newOffset) animated:YES];
    
    //当前行高亮
    [scrollView highlightCellWithIndexPathRow:indexPathRow];
    
    //计算当前位置，修改时间数据
}


//返回当前选择的时间
- (int)createDateWithFormat:(NSString *)format andDateString:(NSString *)dateString {
    int time;
    
    int hour=0,minute=0;
    
    NSArray *array = [format componentsSeparatedByString:@":"];
    if([array count] >1)
    {
        hour = [[array objectAtIndex:0] intValue];
        minute = [[array objectAtIndex:1] intValue]/10;
        
        time = (hour << 3) + minute;
    }
    
    return time;
}


//时间到 字符串
- (NSString *)stringFromDate:(int)time withFormat:(NSString *)format {
    int hour=0,minute=0;
    minute = time & 0x07;
    hour = time >> 3;
    
    return [NSString stringWithFormat:@"%d:%d",hour,minute];
}

//设置时间
- (void)setTime:(NSString *)time {
    //Get the string
    NSString *strTime = (NSString *)time;
    
    //Split
    NSArray *comp = [strTime componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" :"]];
    
    //Set the tableViews
    [_svHours dehighlightLastCell];
    [_svMins dehighlightLastCell];
    
    //Center the other fields
    [self centerCellWithIndexPathRow:([comp[0] intValue]%24)-1 forScrollView:_svHours];
    [self centerCellWithIndexPathRow:[comp[1] intValue] forScrollView:_svMins];
}


#pragma mark - UIScrollViewDelegate


//减速停止后最终确定定位到那一行
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    [self centerValueForScrollView:(MGPickerScrollView *)scrollView];
}

//开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    MGPickerScrollView *sv = (MGPickerScrollView *)scrollView;
    [sv dehighlightLastCell];
}
//拖动结束，那么就要确定位置，不能显示混乱
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (![scrollView isDragging]) {
        [self centerValueForScrollView:(MGPickerScrollView *)scrollView];
    }
}

#pragma - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MGPickerScrollView *sv = (MGPickerScrollView *)tableView;
    return [sv.arrValues count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"reusableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    MGPickerScrollView *sv = (MGPickerScrollView *)tableView;
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.textLabel setFont:sv.cellFont];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    //在控制区间内就显示白色，映衬底色，否则就显示灰色
    [cell.textLabel setTextColor:(indexPath.row == sv.tagLastSelected) ? SELECTED_TEXT_COLOR : TEXT_COLOR];
    [cell.textLabel setText:(NSString *)[sv.arrValues objectAtIndex:indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cell_height;
}

@end
