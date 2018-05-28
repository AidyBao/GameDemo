//
//  DemoViewController.m
//  GameDemo
//
//  Created by lwy on 2018/5/25.
//  Copyright © 2018年 lwy1218. All rights reserved.
//

#import "DemoViewController.h"
#import "FruitView.h"

@interface DemoViewController ()
@property (nonatomic , strong) FruitView *contentView;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.contentView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.contentView.frame = CGRectMake(50, 200, 200, 200);
}
- (IBAction)autoStop:(id)sender {
    [self.contentView autoStopWithTimeout:5 atStopIndexs:@[@15]];
}
- (IBAction)stop:(id)sender {
    [self.contentView stopAtIndexs:@[@10,@1,@14]];
}



- (void)dealloc
{
    NSLog(@" %@ dealloc ----- ", NSStringFromClass([self class]));
}

- (FruitView *)contentView
{
    if (!_contentView) {
        _contentView = [[FruitView alloc] initWithColumn:10];
    }
    return _contentView;
}
@end
