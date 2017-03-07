//
//  GalleryVC.m
//  MusicColorfulBox
//
//  Created by jp on 2017/3/3.
//  Copyright © 2017年 Sancochip. All rights reserved.
//

#import "GalleryVC.h"
#import "GalleryCell.h"

@interface GalleryVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation GalleryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArray = [NSMutableArray arrayWithArray:[DrawModel MR_findAll]];
    [self createView];
}
-(void)createView
{
    
}
-(void)longPressWithImage:(DrawModel *)model
{
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    if (self.selectedModelBlock) {
        self.selectedModelBlock(weakSelf.dataArray[indexPath.row]);
    }
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    GalleryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GalleryCell" forIndexPath:indexPath];
    cell.draw.userInteractionEnabled = NO;
    DrawModel *model = _dataArray[indexPath.row];
    [cell.draw loadStepWithData:model.jsonData];
    
    WS(weakSelf, self);
    WS(weakModel, model);
    cell.longPressBlock = ^(){
        [weakSelf longPressWithImage:model];
    };
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 110);
}



@end
