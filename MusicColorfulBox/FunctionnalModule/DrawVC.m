//
//  DrawVC.m
//  MusicColorfulBox
//
//  Created by jp on 2017/3/3.
//  Copyright © 2017年 Sancochip. All rights reserved.
//

#import "DrawVC.h"
#import "DrawView.h"
#import "GalleryVC.h"

@interface DrawVC ()
@property (weak, nonatomic) IBOutlet UIButton *clear;
@property (weak, nonatomic) IBOutlet UIButton *back;
@property (weak, nonatomic) IBOutlet UIButton *red;
@property (weak, nonatomic) IBOutlet UIButton *blue;
@property (weak, nonatomic) IBOutlet UIButton *green;
//@property (weak, nonatomic) IBOutlet DrawView *screenImage;
@property (weak, nonatomic) IBOutlet UIButton *screenShot;

//@property (nonatomic,strong) DrawView *drawView;
@property (weak, nonatomic) IBOutlet DrawView *drawView;
@property (nonatomic,strong) NSMutableArray *sendArr;//保存移动中需要发送的新数据
@end

@implementation DrawVC
{
    NSMutableArray *_totalArr;
    NSMutableArray *_currentArr;
    NSMutableArray *_saveArr;
    
    UIColor *_currentColor;
    UIControl *_backView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _currentArr = [NSMutableArray array];
    _totalArr = [NSMutableArray array];
    _saveArr = [NSMutableArray array];
    _sendArr = [NSMutableArray array];
    
    _currentColor = [UIColor blackColor];
    
    
    [self setBtnDrawingTable];
}
-(void)setBtnDrawingTable{
    
    __weak typeof(self) weakSelf = self;
    _drawView.cellChangeBlock = ^(Model *model)
    {
        if (model) {
            [weakSelf.sendArr addObject:model];
        }
    };
    _drawView.touchMoveBlock = ^()
    {
        [weakSelf controlTimeForSend];
    };
    _drawView.touchEndBlock = ^()
    {
        [weakSelf sendData];
    };
    for (int i = 0; i < 8; i++) {
        UIView *view = [self.view viewWithTag:i + 1];
        view.layer.borderWidth = 2;
        view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
}
-(void)controlTimeForSend
{
    static NSDate *intervalDate = nil;
    if (!intervalDate) {
        intervalDate = [NSDate date];
    }
    if ([intervalDate timeIntervalSinceNow] > -0.1) {
        return;
    }
    else
    {
        intervalDate = [NSDate date];
    }
    
    [self sendData];
    
    
}
-(void)sendData
{
    if (!_sendArr.count) {
        return;
    }
    //发送操作..
    NSLog(@"send >>> %@",_sendArr);
    //发送结束..
    NSLock *lock = [[NSLock alloc] init];
    if ([lock tryLock]) {
        [_sendArr removeAllObjects];
        [lock unlock];
        
        
    }
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


- (IBAction)clearClick:(id)sender {
    
    //    NSLog(@"%@",_totalArr);
    
    [_drawView clear];
}

- (IBAction)backClick:(id)sender {
    
    [_drawView back];
    
}

- (IBAction)clickColor:(UIView *)sender {
    _drawView.currentColor = sender.backgroundColor;
    for (int i = 0; i < 8; i++) {
        UIView *view = [self.view viewWithTag:i + 1];
        view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    sender.layer.borderColor = [UIColor whiteColor].CGColor;
}




- (IBAction)screenShotClick:(id)sender {
    //    _screenImage.image = [self screenShotView:_backView];
    [_drawView screen];
    
}



- (IBAction)savePic:(id)sender {
    
    
    
}





- (IBAction)saveClick:(id)sender {
    
    NSData *data = [_drawView save];
    
    //    [_screenImage loadStepWithData:data];
    
    if (!_model) {
        DrawModel *model = [DrawModel MR_createEntity]; //不对_model赋值是模仿timebox的逻辑
        model.jsonData = data;
        [model save];
    }
    else
    {
        _model.jsonData = data;
        [_model save];
    }
   
    
}
- (IBAction)loadData:(id)sender {
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    __weak typeof(self) weakSelf = self;
    GalleryVC *vc = segue.destinationViewController;
    vc.selectedModelBlock = ^(DrawModel *model)
    {
        if (model) {
            weakSelf.model = model;
            [weakSelf.drawView loadStepWithData:model.jsonData];
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
