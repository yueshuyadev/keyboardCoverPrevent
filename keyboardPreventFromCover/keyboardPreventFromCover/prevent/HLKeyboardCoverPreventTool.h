//
//  HLKeyboardCoverPreventTool.h
//  zzhl
//
//  Created by 陈中宝 on 15/12/7.
//  Copyright © 2015年 DuDavid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "singleton.h"
#import <UIKit/UIKit.h>

@interface HLKeyboardCoverPreventTool : NSObject


/**
 *  当前第一响应的文本框
 */
@property(nonatomic, weak) UITextField *curTextField;

@property(nonatomic, assign) CGRect preFrame;

single_interface(HLKeyboardCoverPreventTool)


@end
