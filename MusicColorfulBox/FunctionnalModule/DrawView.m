//
//  DrawView.m
//  DrawDemo
//
//  Created by 吕金港 on 2017/3/6.
//  Copyright © 2017年 jp. All rights reserved.
//

#import "DrawView.h"



@implementation Model
-(NSString *)description
{
    return [NSString stringWithFormat:@"%ld",self.tag];
}
@end


@interface DrawView()
@property (nonatomic,strong) NSMutableArray *totalArr;
@property (nonatomic,strong) NSMutableArray *currentArr;
@property (nonatomic,strong) NSMutableArray *sendArr;//保存移动中需要发送的新数据
@property (nonatomic,strong) NSMutableArray *saveArr;

@property (nonatomic,strong) UIControl *backView;
@end
@implementation DrawView
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self createView];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self createView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}
-(instancetype)initWithRowNumber:(NSInteger)row ColumnNumber:(NSInteger)col
{
    _rowNumber = row;
    _colNumber = col;
    return [self init];
}
-(void)createView
{
    if (_backView) {
        return;
    }
    
    if (!_currentColor) {
        _currentColor = [UIColor blackColor];
    }
    if (!_rowNumber && !_colNumber) {
        _rowNumber = kRowNumber;
        _colNumber = kColNumber;
    }
    _totalArr = [NSMutableArray array];

    NSUInteger tagCount = 1;
    
    _backView = [[UIControl alloc] init];
//    _backView.backgroundColor = [UIColor lightGrayColor];
    _backView.userInteractionEnabled = NO;
    [self addSubview:_backView];
    
    for (NSInteger i = 0; i<_rowNumber * _colNumber ; i++) {
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor blackColor];
        view.tag = tagCount++;
        view.userInteractionEnabled = NO;
            
        [_backView addSubview:view];
        
    }

}
-(void)setBtnDrawingTable{
    

    
}
-(void)loadStepWithData:(NSData *)data
{
    if (!data) {
        NSLog(@">>> data is nil");
        return;
    }
    NSArray *dataArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if (dataArr.count != kRowNumber * kColNumber) {
        return;
    }
    [self clear];
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dict in dataArr) {
        Model *model = [[Model alloc] init];
        model.tag = [dict[@"index"] integerValue];
        
        model.color = [UIColor colorWithRed:[dict[@"r"] doubleValue]/255 green:[dict[@"g"] doubleValue]/255 blue:[dict[@"b"] doubleValue]/255 alpha:1];
        UIView *view = [_backView viewWithTag:model.tag + 1];
        view.backgroundColor = model.color;
        
        [arr addObject:model];
    }
    [_totalArr addObject:arr];
    
}
//添加新步骤
-(NSMutableArray *)newStepArray
{
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < kRowNumber * kColNumber; i++) {
        Model *model = [[Model alloc] init];
        model.tag = i;
        [arr addObject:model];
    }
    return arr;
}
//抬起时保存所有格子的状态
-(void)recordStep
{
    NSMutableArray *arr = _totalArr.lastObject;
    if (!arr) {
        return;
    }
    for (int i = 0; i < arr.count; i++) {
        Model *model = arr[i];
        UIView *anyView = [_backView viewWithTag:i + 1];
        model.color = anyView.backgroundColor;
        
    }
}
//处理触摸
-(void)processTouch:(NSSet<UITouch *> *)touches
{
    CGPoint point = [self getCurrentPoint:touches];
    UIView *view = [self getButtonWithCurrentPoint:point];
    
    if (view) {
       
        if (!CGColorEqualToColor(view.backgroundColor.CGColor, _currentColor.CGColor)) {//颜色不同时才执行改变颜色的相关操作
            NSMutableArray *arr = _totalArr.lastObject;
            view.backgroundColor = _currentColor;
            if (arr.count > view.tag && view.tag > 0) {
                Model *model = [arr objectAtIndex:view.tag - 1];
                model.color = _currentColor;
                if (self.cellChangeBlock) {
                    self.cellChangeBlock(model);
                }
                
            }
            
        }
        
        
    }
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_totalArr addObject:[self newStepArray]];//新的事件，加入新步骤数组
    if (self.touchBeginBlock) {
        self.touchBeginBlock();
    }
    [self processTouch:touches];
    
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.touchMoveBlock) {
        self.touchMoveBlock();
    }
    [self processTouch:touches];
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self processTouch:touches];
    [self recordStep];
    if (self.touchEndBlock) {
        self.touchEndBlock();
    }
    
}





-(CGPoint)getCurrentPoint:(NSSet *)touches
{
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    return point;
}

-(UIView *)getButtonWithCurrentPoint:(CGPoint)point
{
    for (UIView * view in _backView.subviews) {
       
        if (CGRectContainsPoint(view.frame, point)) {
            return view;
            
        }
        
    }
    return nil;
}
-(void)screen
{
    [_totalArr addObject:[self newStepArray]];
    for (UIView *view in _backView.subviews) {
        
        view.backgroundColor = _currentColor;
    }
    [self recordStep];
}
-(void)clear
{
    for (UIView *view in _backView.subviews) {
        
        view.backgroundColor = [UIColor blackColor];
                
    }
    [_totalArr removeAllObjects];
}
-(void)back
{
    [_totalArr removeLastObject];//先移除最后一步
    NSMutableArray *lastArr = _totalArr.lastObject;
    if (!lastArr) {
        [self clear];
        return;
    }
    for (int i = 0; i < lastArr.count; i++) {
        UIView *view = [_backView viewWithTag:i + 1];
        Model *model = lastArr[i];
        view.backgroundColor = model.color;
    }
}
-(NSData *)save
{
    return [self saveToJsonWithStep:_totalArr.lastObject];
}
-(NSData *)saveToJsonWithStep:(NSArray *)dataArr
{
    if (!dataArr) {
        return [NSData data];
    }
    NSMutableArray *arr = [NSMutableArray array];
    for (Model *model in dataArr) {
        UIColor *color = model.color;
        if (!color) {
            color = [UIColor blackColor];
        }
        color = [UIColor colorWithCGColor:color.CGColor];
        
        CGFloat const *colorData = CGColorGetComponents(color.CGColor);
        NSInteger number = CGColorGetNumberOfComponents(color.CGColor);
        
        CGFloat r = 0,g = 0,b = 0;
        if (number == 2) {
            r = colorData[0] * colorData[1];
            g = colorData[0] * colorData[1];
            b = colorData[0] * colorData[1];
        }
        else if (number == 4)
        {
            r = colorData[0] * colorData[3];
            g = colorData[1] * colorData[3];
            b = colorData[2] * colorData[3];
        }
        NSDictionary *dict = @{@"index":@(model.tag),@"r":@(r * 255.0),@"g":@(g * 255.0),@"b":@(b * 255.0)};
        [arr addObject:dict];
        
        
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    if (!data) {
        data = [NSData data];
    }
    return data;
}
-(void)updateFrame
{
    _backView.frame = self.bounds;
    NSUInteger tagCount = 1;
    CGFloat cellMargin = 1.0f;
    
    CGFloat btnW = CGRectGetWidth(_backView.bounds) / _colNumber - cellMargin;
    CGFloat btnH = CGRectGetHeight(_backView.bounds) / _rowNumber  - cellMargin;
    
    for (NSInteger i = 0; i<(_rowNumber * _colNumber) ; i++) {
        
        UIView *view = [_backView viewWithTag:tagCount++];
        view.frame = CGRectMake((btnW+cellMargin) * (i%_colNumber),(btnH+cellMargin) * (i/_colNumber), btnW, btnH);
        
    }
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self updateFrame];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
