//
//  HLKeyboardCoverPreventTool.m
//  zzhl
//
//  Created by 陈中宝 on 15/12/7.
//  Copyright © 2015年 DuDavid. All rights reserved.
//

#import "HLKeyboardCoverPreventTool.h"
#import "UIView+LK.h"

/**
 *  文本框和键盘之间的最小距离
 */
static const CGFloat kKeyboardCoverViewM = 0.f;

@interface HLKeyboardCoverPreventTool(){
    @private
    CGRect _keyboardFrame;
}


@property(nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property(nonatomic, strong) UIPanGestureRecognizer *panGesture;

@end

@implementation HLKeyboardCoverPreventTool

single_implementation(HLKeyboardCoverPreventTool)

- (void)loadData{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lk_keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lk_keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark 键盘将要出现
- (void)lk_keyboardWillAppear:(NSNotification *)notice{
    //获取键盘的frame
    CGRect keyboardFrame = [notice.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    [self _preventCoverWithKeyboardFrame:keyboardFrame];
    _keyboardFrame = keyboardFrame;
}

#pragma mark 阻止遮挡
- (void)_preventCoverWithKeyboardFrame:(CGRect)keyboardFrame{
    if (!_curTextField) {
        return;
    }
    UIViewController *vc = _curTextField.curVc;
    if (!vc) {
        NSLog(@"这个文本框不存在于任何控制器");
        return;
    }
    __weak UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect viewFrameInWindow = [_curTextField convertRect:_curTextField.bounds toView:window];
    viewFrameInWindow.size.height += 10.f;
    if (CGRectIntersectsRect(viewFrameInWindow, keyboardFrame)) {
        //如果覆盖，则往上推
        CGFloat coverOffset = CGRectGetMaxY(viewFrameInWindow) - keyboardFrame.origin.y + kKeyboardCoverViewM;
        CGRect containerViewFrame = vc.view.frame;
        containerViewFrame.origin.y -= coverOffset;
        vc.view.frame = containerViewFrame;
    }
}


#pragma mark 键盘将要隐藏
- (void)lk_keyboardWillDisappear:(NSNotification *)notice{
    _keyboardFrame = CGRectZero;
    [self _resumeCover];
}

#pragma mark 恢复控制器的frame
- (void)_resumeCover{
    if (!_curTextField) {
        return;
    }
    [self _resumeOperation];
}

- (void)_resumeOperation{
    UIViewController *vc = _curTextField.curVc;
    if (!vc) {
        _curTextField = nil;
        NSLog(@"这个文本框不存在于任何控制器");
        return;
    }
    [self _removeGestureFromView:vc.view];
    
    vc.view.frame = _preFrame;
    _preFrame = CGRectZero;
    _curTextField = nil;
}


- (void)setCurTextField:(UITextField *)curTextField{
    if (_curTextField == curTextField) {
        return;
    }
    if (_curTextField) {
        //原来有，则注销原来的
        if (_curTextField.curVc != curTextField.curVc) {
            [self _resumeOperation];
        }
    }
    UIViewController *vc = curTextField.curVc;
    if (vc != _curTextField.curVc) {
        _preFrame = vc.view.frame;
    }
    if (vc) {
        [self _addGesturesToView:vc.view];
    }
    _curTextField = curTextField;
    if (!CGRectIsEmpty(_keyboardFrame)) {
        [self _preventCoverWithKeyboardFrame:_keyboardFrame];
    }
}


#pragma mark 为控制器的根View添加事件
- (void)_addGesturesToView:(UIView *)view{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapListener:)];
    }
    [view addGestureRecognizer:_tapGesture];
    
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_panListener:)];
    }
    [view addGestureRecognizer:_panGesture];
}

#pragma mark 为控制器的跟根View移除事件
- (void)_removeGestureFromView:(UIView *)view{
    if (_tapGesture) {
        [view removeGestureRecognizer:_tapGesture];
    }
    if (_panGesture) {
        [view removeGestureRecognizer:_panGesture];
    }
}


#pragma mark 点击的监听
- (void)_tapListener:(UITapGestureRecognizer *)tapGesture{
    if (_curTextField) {
        [_curTextField resignFirstResponder];
    }
}

#pragma mark 拖动的监听
- (void)_panListener:(UIPanGestureRecognizer *)panGesture{
    //在拖动手势结束的时候注销键盘响应，以达到防止用户误划一次的要求
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        [_curTextField resignFirstResponder];
    }
}


#pragma mark 结束文本框的编辑
- (void)_endTextFieldEditing{
    [_curTextField resignFirstResponder];
}



- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


+ (void)load{
    HLKeyboardCoverPreventTool *instance = [HLKeyboardCoverPreventTool shareHLKeyboardCoverPreventTool];
    [instance class];
}

@end
