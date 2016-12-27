//
//  GZCLoadingView.h
//  GZCLodingView
//
//  Created by ZhongCheng Guo on 2016/12/23.
//  Copyright © 2016年 ZhongCheng Guo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GZCLoadingView : UIView

@property (nonatomic,assign,getter=isAnimation) BOOL   animation;  //是否在执行动画
@property (nonatomic,copy) NSArray * itemArray;  //飘下来的元素

@property (nonatomic,strong) UILabel * messageLabel;  //提示文字...
@property (nonatomic,strong) UIImage * boxImage;  //消失点（盒子）

- (void)beginAnimation;

- (void)stopAnimation;

@end
