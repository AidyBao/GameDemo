//
//  FruitView.h
//  GameDemo
//
//  Created by lwy on 2018/5/24.
//  Copyright © 2018年 lwy1218. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FruitView : UIView

@property (nonatomic, assign, readonly) NSInteger stopIndex;
/**
 停止时 不会停止到该集合中的下标 到达该数组中的下标时 会停到下一个 用于游戏作弊
 */
@property (nonatomic , copy) NSSet <NSNumber *>*cheatIndexs;

@property (nonatomic , strong) UIColor *normalColor;
@property (nonatomic , strong) UIColor *selectedColor;


@property (nonatomic , assign) CGFloat maxPerSleepTime;
@property (nonatomic , assign) CGFloat minPerSleepTime;

/**
 初始化方法

 @param col 视图有多少列 (列数等于行数) 最少应该是2列
 @return return value description
 */
- (instancetype)initWithColumn:(NSUInteger)col;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;

- (instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;


/**
 开始
 */
- (void)start;

/**
 在timeOut时间后停止

 @param timeout 时间
 */
- (void)autoStopWithTimeout:(NSTimeInterval)timeout;


/**
  在timeOut时间后停止

 @param timeout 时间
 @param stopIndexs 停止时的下标 传入多个下标 随机停在其中一个 用于作弊
 */
- (void)autoStopWithTimeout:(NSTimeInterval)timeout
               atStopIndexs:(NSArray <NSNumber *>*)stopIndexs;


/**
 立即停止

 @param indexs 停止时的下标 传入多个下标 随机停在其中一个 用于作弊
 */
- (void)stopAtIndexs:(NSArray <NSNumber *>*)indexs;

@end
