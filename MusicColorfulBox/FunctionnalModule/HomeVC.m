//
//  HomeVC.m
//  MusicColorfulBox
//
//  Created by jp on 2017/3/3.
//  Copyright © 2017年 Sancochip. All rights reserved.
//

#import "HomeVC.h"
#import "ScanVC.h"

@interface HomeVC ()

@end

@implementation HomeVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self refreshNavigationBar];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ScanVC presentScanVC];
    
    
}







-(void)refreshNavigationBar{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}











@end
