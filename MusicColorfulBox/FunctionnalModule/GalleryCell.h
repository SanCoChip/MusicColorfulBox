//
//  LoadImageCell.h
//  DrawDemo
//
//  Created by 吕金港 on 2017/3/6.
//  Copyright © 2017年 jp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawView.h"

@interface GalleryCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet DrawView *draw;
@property (nonatomic,strong) void(^longPressBlock)();
@end
