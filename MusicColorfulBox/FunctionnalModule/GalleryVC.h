//
//  GalleryVC.h
//  MusicColorfulBox
//
//  Created by jp on 2017/3/3.
//  Copyright © 2017年 Sancochip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawModel+CoreDataProperties.h"

@interface GalleryVC : UIViewController
@property (nonatomic,strong) void(^selectedModelBlock)(DrawModel *);
@end
