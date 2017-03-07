//
//  DrawModel+CoreDataProperties.m
//  DrawDemo
//
//  Created by 吕金港 on 2017/3/6.
//  Copyright © 2017年 jp. All rights reserved.
//

#import "DrawModel+CoreDataProperties.h"

@implementation DrawModel (CoreDataProperties)

+ (NSFetchRequest<DrawModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DrawModel"];
}

@dynamic jsonData;
@dynamic imageData;
@dynamic name;

-(void)save
{
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}
@end
