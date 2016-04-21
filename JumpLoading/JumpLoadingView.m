//
//  JumpLoadingView.m
//  JumpLoading
//
//  Created by Realank on 16/4/20.
//  Copyright © 2016年 realank. All rights reserved.
//

#import "JumpLoadingView.h"

#define SPACE 35.0
#define BALL_JUMP_HEIGHT 30.0
#define BALL_WIDTH 30.0
#define SEGMENT_TIME 0.5
#define ANIMATION_DURATION 1.8
#define CIRCLE_NUM 4

@interface JumpLoadingView ()

@property (nonatomic, strong) NSMutableArray<CALayer*> *circleArray;
@property (nonatomic, strong) CALayer *ball;
@property (nonatomic, assign) NSInteger ballIndex;
@property (nonatomic, assign) BOOL forward;
@end

@implementation JumpLoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        _circleArray = [NSMutableArray array];
        
        self.backgroundColor = [UIColor clearColor];
        CGFloat circleX = (frame.size.width - CIRCLE_NUM*SPACE - BALL_WIDTH)/2 + BALL_WIDTH/2.0 ;
        CGFloat circleY = frame.size.height/2 - BALL_JUMP_HEIGHT;
        
        _ball = [CALayer layer];
        _ball.bounds = CGRectMake(0, 0, BALL_WIDTH, BALL_WIDTH);
        _ball.position = CGPointMake(circleX, circleY);
        _ball.backgroundColor = [UIColor grayColor].CGColor;
        _ball.cornerRadius = _ball.bounds.size.height / 2;
        [self.layer addSublayer:_ball];
        circleY += BALL_JUMP_HEIGHT;
        
        for (int i = 0; i < 4; i++) {
            
            circleX += SPACE;
            CALayer *circle = [CALayer layer];
            circle.bounds = CGRectMake(0, 0, BALL_WIDTH, BALL_WIDTH);
            circle.position = CGPointMake(circleX, circleY);
//            circle.position = CGPointMake(circleX + BALL_WIDTH/2.0+SPACE/2.0, circleY + BALL_WIDTH/2);
//            circle.anchorPoint = CGPointMake(-SPACE/BALL_WIDTH/2.0 + 0.5, 0.5);
            circle.backgroundColor = [UIColor clearColor].CGColor;
            circle.cornerRadius = circle.bounds.size.height / 2;
            circle.borderColor = [UIColor grayColor].CGColor;
            circle.borderWidth = 3;
            [self.layer addSublayer:circle];
            [_circleArray addObject:circle];
            
        }
        
        _ballIndex = 0;
        _forward = YES;
        
        [self addAnimation];
//         __weak __typeof(self) weakSelf = self;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [weakSelf addAnimation];
//            
//            
//        });
    }
    return self;
}

- (void)addAnimation {
    // 创建一个实现两个弧线的CGPath（一个跳弹路径）

    CGMutablePathRef ballPath = CGPathCreateMutable();
    
    CGFloat ballX = (self.frame.size.width - CIRCLE_NUM*SPACE - BALL_WIDTH)/2 + BALL_WIDTH/2.0 + _ballIndex*SPACE;
    CGFloat ballY = self.frame.size.height/2;
    
//    CGFloat ballX = BALL_WIDTH/2.0 + _ballIndex*SPACE;
//    CGFloat ballY = BALL_WIDTH/2.0;
    CGPathMoveToPoint(ballPath,NULL,ballX,ballY-BALL_JUMP_HEIGHT);
    
    for (int i = 0; i < 1; i++) {
        if (_forward) {
            CGPathAddArc(ballPath, NULL, ballX + SPACE / 2, ballY, SPACE / 2 , M_PI, 2*M_PI, YES);
            ballX += SPACE;
        }else{
            CGPathAddArc(ballPath, NULL, ballX - SPACE / 2, ballY, SPACE / 2 , 0, M_PI, NO);
            ballX -= SPACE;
        }
        
        
        CGPathAddLineToPoint(ballPath, NULL, ballX, ballY - BALL_JUMP_HEIGHT);
    }
    

    CAKeyframeAnimation * ballAnimation;
    //创建一个动画对象，指定位置属性作为键路径
    ballAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    ballAnimation.path=ballPath;
    ballAnimation.duration = ANIMATION_DURATION/_circleArray.count;
    ballAnimation.delegate = self;
    ballAnimation.removedOnCompletion = NO;
    ballAnimation.fillMode = kCAFillModeForwards;
    ballAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    CGPathRelease(ballPath);
    // 为图层添加动画
    [_ball addAnimation:ballAnimation forKey:@"ball"];
    
    CALayer* circleLayer = nil;
    NSInteger index = _ballIndex;
    if (!_forward) {
        index--;
    }
    circleLayer = _circleArray[index];
    
    CGMutablePathRef circlePath = CGPathCreateMutable();

    circleLayer.position = CGPointMake(ballX, ballY);
    if (_forward) {
        CGPathAddArc(circlePath, NULL, ballX - SPACE/2, ballY, SPACE/2, 0, M_PI, YES);
    }else{
        CGPathAddArc(circlePath, NULL, ballX + SPACE/2, ballY, SPACE/2, -M_PI, 0, NO);
    }
    
    CAKeyframeAnimation * circleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    circleAnimation.path = circlePath;
    CGFloat totalTime = ANIMATION_DURATION / _circleArray.count;
    CGFloat segment1Time = totalTime * BALL_JUMP_HEIGHT / (2 * BALL_JUMP_HEIGHT + M_PI * SPACE / 2);
    CGFloat segment2Time = totalTime * (M_PI * SPACE / 2) / (2 * BALL_JUMP_HEIGHT + M_PI * SPACE / 2);
    
    circleAnimation.duration = segment2Time;
    circleAnimation.beginTime = CACurrentMediaTime()+segment1Time;
    CGPathRelease(circlePath);
    circleAnimation.removedOnCompletion = NO;
    circleAnimation.fillMode = kCAFillModeForwards;
//    circleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    // 为图层添加动画
    [circleLayer addAnimation:circleAnimation forKey:@"circle"];
    
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if (_forward) {
        _ballIndex++;
        if (_ballIndex == _circleArray.count) {
            _forward = NO;
        }
    }else{
        _ballIndex--;
        if (_ballIndex == 0) {
            _forward = YES;
        }
    }
    
    if (_ballIndex <= _circleArray.count && self.superview) {
         __weak __typeof(self) weakSelf = self;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf addAnimation];
//        });
        
    }else{
        [_ball removeFromSuperlayer];
        [_ball removeAllAnimations];
        for (CALayer* layer in _circleArray) {
            [layer removeFromSuperlayer];
            [layer removeAllAnimations];
        }
    }
}
@end
