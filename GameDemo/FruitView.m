//
//  FruitView.m
//  GameDemo
//
//  Created by lwy on 2018/5/24.
//  Copyright © 2018年 lwy1218. All rights reserved.
//

#import "FruitView.h"

@interface FruitView ()
{
    UIButton *_currentButton;
}
@property (nonatomic, assign) BOOL willStop;
@property (nonatomic, assign) NSInteger stopIndex;
@property (nonatomic, assign) NSInteger slowLoop;
@property (nonatomic , copy) NSArray *items;
@property (nonatomic , assign) NSUInteger column;
@property (nonatomic , assign) BOOL isRuning;
@property (nonatomic, assign) CGFloat perSleepTime;
@property (nonatomic , assign) NSInteger currentIndex;
@property (nonatomic , strong) dispatch_queue_t processQueue;
@end

@implementation FruitView

- (instancetype)initWithColumn:(NSUInteger)col
{
    if (self = [super init]) {
        if (col < 2) {
            col = 2;
        }
        _column = col;
        _currentIndex = 0;
        
        _maxPerSleepTime = 0.2;
        _minPerSleepTime = 0.02;
        
        _selectedColor = [UIColor yellowColor];
        _normalColor = [UIColor redColor];
        
        [self setupButton];
    }
    return self;
}


- (void)start
{
    if (_isRuning) return;
    
    if (_currentButton == nil) {
        _currentButton = _items.firstObject;
        [_currentButton setBackgroundColor:_selectedColor];
    }
    
    if (!_processQueue) {
        _processQueue = dispatch_queue_create("com.lwy.fruit.run.processing",DISPATCH_QUEUE_SERIAL);
    }
    dispatch_async(_processQueue, ^{
        [self startRun];
    });
}

#pragma mark - public method
- (void)autoStopWithTimeout:(NSTimeInterval)timeout
{
    [self autoStopWithTimeout:timeout atStopIndexs:nil];
}

- (void)autoStopWithTimeout:(NSTimeInterval)timeout atStopIndexs:(NSArray <NSNumber *>*)stopIndexs
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.willStop = YES;
        self.stopIndex = [self getStopIndexFromArray:stopIndexs];
    });
}

- (void)stopAtIndexs:(NSArray <NSNumber *>*)indexs
{
    _stopIndex = [self getStopIndexFromArray:indexs];
    _willStop = YES;
}


#pragma mark - 改变速度
- (void)updatePerSleepTime
{
    if (_willStop) {
        // 减速
        _perSleepTime += 0.01;
        
        if (_perSleepTime > _maxPerSleepTime) {
            _perSleepTime = _maxPerSleepTime;
        }
    }
    else {
        if (_slowLoop <= _items.count) {
            _slowLoop++;
            return;
        }
        // 加速
        if (_slowLoop > _items.count) {
            _perSleepTime -= 0.03;
        }
        if (_perSleepTime < _minPerSleepTime) {
            _perSleepTime = _minPerSleepTime;
        }
    }
}
#pragma mark - run
- (void)startRun
{
    // 标记
    _isRuning = YES;
    _willStop = NO;
    
    _stopIndex = -1;
    _slowLoop = 0;
    _perSleepTime = _maxPerSleepTime;
    
    while (_isRuning) {
        [NSThread sleepForTimeInterval:_perSleepTime];
        [self updatePerSleepTime];
        if (_willStop && _currentIndex == _stopIndex && _perSleepTime >= _maxPerSleepTime) {
            if (_cheatIndexs && _cheatIndexs.count > 0) {
                NSMutableArray *numbers = [NSMutableArray arrayWithArray:_cheatIndexs.allObjects];
                
                __block NSNumber *currentNum = @(_currentIndex);
                __block BOOL contain = [numbers containsObject:currentNum];
                
                while (contain) {
                    
                    [numbers removeObject:currentNum];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self runNextItem];
                        currentNum = @(self.currentIndex);
                        contain = [numbers containsObject:currentNum];
                    });
                    
                    [NSThread sleepForTimeInterval:_perSleepTime];
                }
            }
            _isRuning = NO;
            _slowLoop = 0;
            break;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self runNextItem];
        });
    }
}

#pragma mark - 切换
- (void)runNextItem
{
    [_currentButton setBackgroundColor:_normalColor];
    
    NSInteger index = _currentButton.tag + 1;
    
    if (index >= _items.count) index = 0;
    
    _currentIndex = index;
    UIButton *next = _items[index];
    _currentButton = next;
    [_currentButton setBackgroundColor:_selectedColor];
}

#pragma mark - layout
- (void)layoutSubviews
{
    NSUInteger colNum = _column;
    CGFloat w = CGRectGetWidth(self.bounds) / colNum;
    for (NSUInteger i = 0; i < _items.count; i++) {
        NSInteger row = i / colNum;
        NSInteger col = i % colNum;
        UIButton *lastItem = _items[i];
        if (i < colNum) {// 第一行
            row = 0;
            col = i % colNum;
        }
        else if (i < (2 * colNum - 1)) {
            //  最后一列
            col = colNum - 1;
            row =  i - (_column - 1);
        }
        else if (i < (3 * colNum - 2)) {
            // 最后一行
            row = colNum - 1;
            col = 3 * (colNum - 1) - i;
        }
        else {
            col = 0;
            row = _items.count - i;
        }
        
        CGFloat x = col * w;
        CGFloat y = row * w;
        
        lastItem.frame = CGRectMake(x, y, w, w);
    }
    
    if (_column > 2) {
        UIButton *center = self.subviews.lastObject;
        CGFloat x = w;
        CGFloat y = w;
        CGFloat cw = (_column - 2) * w;
        center.frame = CGRectMake(x, y, cw, cw);
    }
}

#pragma mark - private method
- (void)setupButton
{
    NSMutableArray *items = @[].mutableCopy;
    NSUInteger count = _column * 4 - 4;
    for (NSInteger i = 0; i < count; i++) {
        UIButton *button = [self createButtonWithIndex:i];
        [items addObject:button];
        [self addSubview:button];
    }
    
    _items = [items copy];
    
    if (_column > 2) {
        UIButton *center = [self createButtonWithIndex:count];
        [self addSubview:center];
        [center setTitle:@"start" forState:UIControlStateNormal];
        [center addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
        [center setBackgroundColor:[UIColor greenColor]];
    }
}
- (NSInteger)getStopIndexFromArray:(NSArray <NSNumber *>*)indexs
{
    NSInteger index = 0;
    if (indexs == nil || indexs.count == 0) {
        index = arc4random() % _items.count;
    }
    else if (indexs.count == 1) {
        index = [indexs.firstObject integerValue];
    }
    else {
        NSInteger temp = arc4random() % indexs.count;
        index = [[indexs objectAtIndex:temp] integerValue];
    }
    if (index > _items.count - 1) {
        index = _items.count - 1;
    }
    return index;
}
- (UIButton *)createButtonWithIndex:(NSInteger)index
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.tag = index;
    NSString *title = [NSString stringWithFormat:@"%@",@(index)];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor redColor]];
    return button;
}
@end
