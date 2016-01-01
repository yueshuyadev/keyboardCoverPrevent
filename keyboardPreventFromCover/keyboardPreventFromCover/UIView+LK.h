//
//  UIView+LK.h
//  Categorys
//
//  Created by 陈中宝 on 15/7/9.
//  Copyright (c) 2015年 陈中宝. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LKExtension)
@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGSize  size;
@property (assign, nonatomic) CGPoint origin;

@end

@interface UIView (LKConstraint)

/**
 *  移除高度约束
 */
-(void)removeHeightConstraint;

/**
 *  移除宽度约束
 */
-(void)removeWidthConstraint;

/**
 *  移除底部约束
 */
-(void)removeBottomConstraint;

@end


@interface UIView(LKVC)

/**
 *  当前View所属的控制器
 */
@property(nonatomic, weak, readonly) UIViewController *curVc;

@end
