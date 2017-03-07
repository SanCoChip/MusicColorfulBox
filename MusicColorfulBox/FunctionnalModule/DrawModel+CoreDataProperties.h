//
//  DrawModel+CoreDataProperties.h
//  DrawDemo
//
//  Created by 吕金港 on 2017/3/6.
//  Copyright © 2017年 jp. All rights reserved.
//

#import "DrawModel+CoreDataClass.h"
#import <MagicalRecord/MagicalRecord.h>

NS_ASSUME_NONNULL_BEGIN

@interface DrawModel (CoreDataProperties)

+ (NSFetchRequest<DrawModel *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSData *jsonData;
@property (nullable, nonatomic, retain) NSData *imageData;
@property (nullable, nonatomic, copy) NSString *name;

-(void)save;
@end

NS_ASSUME_NONNULL_END
