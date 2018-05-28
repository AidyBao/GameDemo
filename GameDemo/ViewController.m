//
//  ViewController.m
//  GameDemo
//
//  Created by lwy on 2018/5/24.
//  Copyright © 2018年 lwy1218. All rights reserved.
//

#import "ViewController.h"
#import "FruitView.h"
#import "DemoViewController.h"

@interface ViewController ()

@property (nonatomic , strong) FruitView *contentView;
@end

@implementation ViewController

#pragma mark - life
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.contentView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.contentView.frame = CGRectMake(50, 200, 200, 200);
}

#pragma mark - action
- (IBAction)push:(id)sender {
    
    DemoViewController *vc = [[DemoViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)autoStop:(id)sender {
    [self.contentView autoStopWithTimeout:5 atStopIndexs:@[@15]];
}
- (IBAction)stop:(id)sender {
    [self.contentView stopAtIndexs:@[@10]];
}



#pragma mark - getter
- (FruitView *)contentView
{
    if (!_contentView) {
        _contentView = [[FruitView alloc] initWithColumn:6];
        
//        _contentView.cheatIndexs = [NSSet setWithObjects:@10,@12,@13, nil];
    }
    return _contentView;
}

@end
