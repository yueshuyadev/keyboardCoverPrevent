//
//  UITextField+HL.m
//  zzhl
//
//  Created by duyongjian on 15/10/28.
//  Copyright © 2015年 DuDavid. All rights reserved.
//

#import "UITextField+HL.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "HLKeyboardCoverPreventTool.h"

@implementation UITextField (HL)

#pragma mark 电话号码
-(void)phoneNum:(NSString *)url placeholder:(NSString *)imagePath{

}



/**
 *  为文本框防键盘遮挡做内应
 *
 */
- (BOOL)lk_becomeFirstResponder{
    [[HLKeyboardCoverPreventTool shareHLKeyboardCoverPreventTool] setCurTextField:self];
    return [self lk_becomeFirstResponder];
}

+ (void)load{
    Method preMethod = class_getInstanceMethod([self class], @selector(becomeFirstResponder));
    Method swizzleMethod = class_getInstanceMethod([self class], @selector(lk_becomeFirstResponder));
    IMP swizzleImp = method_getImplementation(swizzleMethod);
    const char *swizzleType = method_getTypeEncoding(swizzleMethod);
    if (class_addMethod([self class], @selector(becomeFirstResponder), swizzleImp, swizzleType)) {
        IMP preImp = method_getImplementation(preMethod);
        const char *preType = method_getTypeEncoding(preMethod);
        class_addMethod([self class], @selector(lk_becomeFirstResponder), preImp, preType);
    }else{
        method_exchangeImplementations(preMethod, swizzleMethod);
    }
}

@end
