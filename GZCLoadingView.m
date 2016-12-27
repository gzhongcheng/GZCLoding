//
//  GZCLoadingView.m
//  GZCLodingView
//
//  Created by ZhongCheng Guo on 2016/12/23.
//  Copyright © 2016年 ZhongCheng Guo. All rights reserved.
//

#import "GZCLoadingView.h"

@implementation GZCLoadingView{
    NSMutableArray *animationLayers;
    UIView *animationBox;
    UIImageView *boxImageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:46/255.f green:69/255.f blue:82/255.f alpha:1.0f];
        [self createBox];
        [self createMessage];
        [self createAnimationLayers];
        [self beginAnimation];
    }
    return self;
}

- (void)createBox{
    boxImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"box"]];
    boxImageView.frame = CGRectMake((self.frame.size.width-60)/2, self.frame.size.height/2-15, 60, 15);
    [self addSubview:boxImageView];
    
    animationBox = [[UIView alloc]initWithFrame:CGRectMake((self.frame.size.width-60)/2, self.frame.size.height/2-70, 60, 70)];
    animationBox.clipsToBounds = YES;
    [self addSubview:animationBox];
}

- (void)createMessage{
    _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(boxImageView.frame) + 10 , self.frame.size.width, 30)];
    _messageLabel.text = @"LOADING STUFF...";
    _messageLabel.textColor = [UIColor whiteColor];
    _messageLabel.font = [UIFont boldSystemFontOfSize:15];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_messageLabel];
}

- (void)createAnimationLayers{
    if (animationLayers==nil) {
        animationLayers = [NSMutableArray array];
    }else{
        [animationLayers removeAllObjects];
    }
    for (int i = 0; i < 4; i ++) {
        UILabel *label = [[UILabel alloc]init];
        label.text = [NSString stringWithFormat:@"%d",i%2];
        label.font = [UIFont systemFontOfSize:20];
        label.textColor = [UIColor whiteColor];
        [label sizeToFit];
        label.layer.opacity = 0;
        [animationBox addSubview:label];
        [animationLayers addObject:label.layer];
    }
}

- (void)beginAnimation{
    _animation = YES;
    for (CALayer *layer in animationLayers) {
        CGFloat delay = [self getRandomDelay];
        [self performSelector:@selector(addAnimationToLayer:) withObject:layer afterDelay:delay];
    }
}

- (void)stopAnimation{
    _animation = NO;
}

- (void)addAnimationToLayer:(CALayer*)layer{
    //获取随机参数
    CGFloat duration = [self getRandomDuration];
    CGFloat rotation = [self getRandomRotation];
    CGPoint beginPoint = [self getRandomBeginPoint];
    CGPoint endPoint = [self getRandomEndPoint];
    
    //平移
    CABasicAnimation *positionAnim = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnim.duration = duration;
    positionAnim.fromValue = [NSValue valueWithCGPoint:beginPoint];
    positionAnim.toValue = [NSValue valueWithCGPoint:endPoint];
    positionAnim.fillMode = kCAFillModeForwards;
    
    //旋转
    CABasicAnimation *transformAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnim.duration = duration;
    // 绕着(0, 0, 1)这个向量轴顺时针旋转rotation
    transformAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(rotation, 0, 0, 1)];
    
    //透明度
    CABasicAnimation *opacityAnimation =[CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @0.f;
    opacityAnimation.toValue = @1.f;
    opacityAnimation.duration = duration;
    opacityAnimation.fillMode = kCAFillModeForwards;
    
    [layer addAnimation:positionAnim forKey:@"lposition"];
    [layer addAnimation:transformAnim forKey:@"ltransform"];
    [layer addAnimation:opacityAnimation forKey:@"lopacity"];
    layer.opacity = 0;
    
    //循环动画
    if (_animation) {
        [self performSelector:@selector(addAnimationToLayer:) withObject:layer afterDelay:duration];
    }
}

//获取起点坐标
- (CGPoint)getRandomBeginPoint{
    return [self getRandomFrameInRect:CGRectMake(10, 0, animationBox.bounds.size.width - 10 , 1)];
}

//获取终点坐标
- (CGPoint)getRandomEndPoint{
    //终点坐标比起点坐标集中一些，看起来才有汇集的效果
    return [self getRandomFrameInRect:CGRectMake(20, animationBox.bounds.size.height + 20 , animationBox.bounds.size.width-40, 1)];
}

//获取随机的动画时间
- (CGFloat)getRandomDuration{
    //产生随机数（这里我们定义的动画时间为0.5s～1.0s）
    int time = arc4random()%50 + 50;
    CGFloat duration = time/100.f;
    return duration;
}

//获取随机的延后时间
- (CGFloat)getRandomDelay{
    //产生随机数（这里我们定义的动画时间为0s～0.5s）
    int time = arc4random()%50;
    CGFloat duration = time/100.f;
    return duration;
}

//获取随机的角度
- (CGFloat)getRandomRotation{
    //产生随机数（这里我们定义的旋转角度范围为 -180度～180度）
    int angle = arc4random()%360 - 180;
    CGFloat rotation = angle*M_PI/180;
    return rotation;
}

//方形区域内产生随机点
- (CGPoint)getRandomFrameInRect:(CGRect)rect{
    CGFloat minX = rect.origin.x;
    CGFloat width = rect.size.width;
    CGFloat minY = rect.origin.y;
    CGFloat height = rect.size.height;
    //产生随机数
    CGFloat randomX = minX + (float)(arc4random() % (int)width);
    CGFloat randomY = minY + (float)(arc4random() % (int)height);
    return CGPointMake(randomX, randomY);
}

@end
