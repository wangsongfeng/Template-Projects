//
//  Singleton.h
//  Huobucuo
//
//  Created by hudan on 16/9/8.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#ifndef Singleton_h
#define Singleton_h

#define SingletonH(name) + (instancetype)shared##name;

#define SingletonM(name) \
static id _instance; \
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
\
+ (instancetype)shared##name \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return _instance; \
}\
\
- (id)mutableCopyWithZone:(NSZone *)zone { \
return _instance; \
}

#endif /* Singleton_h */
