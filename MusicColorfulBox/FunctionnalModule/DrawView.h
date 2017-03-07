//
//  DrawView.h
//  DrawDemo
//
//  Created by 吕金港 on 2017/3/6.
//  Copyright © 2017年 jp. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRowNumber 11

#define kColNumber 9

@interface Model : NSObject //记录格子数据的model，和存储无关
@property (nonatomic,strong) UIColor *color;
@property (nonatomic,assign) NSInteger tag;
@end

@interface DrawView : UIView
@property (nonatomic,assign,readonly) NSInteger rowNumber;
@property (nonatomic,assign,readonly) NSInteger colNumber;

@property (nonatomic,strong) UIColor *currentColor;

@property (nonatomic,strong) void(^touchBeginBlock)();

@property (nonatomic,strong) void(^touchMoveBlock)();

@property (nonatomic,strong) void(^cellChangeBlock)(Model *);//触摸导致格子有变化的时候才会携带model，否则为空
@property (nonatomic,strong) void(^touchEndBlock)();

-(instancetype)initWithRowNumber:(NSInteger)row ColumnNumber:(NSInteger)col;

-(void)screen;
-(void)clear;
-(void)back;
-(void)loadStepWithData:(NSData *)data;
-(NSData *)save;
@end
