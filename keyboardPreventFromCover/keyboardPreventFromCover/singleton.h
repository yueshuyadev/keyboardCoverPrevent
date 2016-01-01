//
//  singleton.h
//  美丽说DIY
//
//  Created by 陈中宝 on 15/5/22.
//  Copyright (c) 2015年 czb. All rights reserved.
/**
     made by chenzhongbao
 */


//.h
#define single_interface(class) +(id)share##class;


#warning 这个实现方法里面需要手动创建一个方法:-(void)loadData{} 用于初始化数据

//.m
#define single_implementation(class) \
\
static id _instance;\
-(id)init{\
    static dispatch_once_t initOnce;\
    dispatch_once(&initOnce, ^{\
        _instance = [super init];\
        if (_instance) {\
            [self loadData];\
        }\
    });\
    return _instance;\
}\
\
+(id)share##class{\
    if (_instance == nil) {\
        _instance = [[class alloc] init];\
    }\
    return _instance;\
}\
\
+(id)allocWithZone:(struct _NSZone *)zone{\
    static dispatch_once_t shareOnce;\
    dispatch_once(&shareOnce, ^{\
        _instance = [super allocWithZone:zone];\
        \
    });\
    return _instance;\
}