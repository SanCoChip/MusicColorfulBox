//
//  LoadImageCell.m
//  DrawDemo
//
//  Created by 吕金港 on 2017/3/6.
//  Copyright © 2017年 jp. All rights reserved.
//

#import "GalleryCell.h"

@implementation GalleryCell

-(void)awakeFromNib
{
    [super awakeFromNib];

    [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)]];
}
-(void)longPress
{
    if (self.longPressBlock) {
        self.longPressBlock();
    }
}
@end
