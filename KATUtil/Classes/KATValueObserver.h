//
//  KATValueObserver.h
//  KATFramework
//
//  Created by Kantice on 2018/10/2.
//  Copyright © 2018年 KatApp. All rights reserved.
//  值观察者，用于防止重要的数据被直接修改内存
//  非setter或KVC方式赋值，会被认定非法改变属性值
//  需要注意在对象初始化后再添加观察者，且被观察的属性在该对象中不要出现非setter或KVC方式的赋值


#import <Foundation/Foundation.h>
#import "KATArray.h"


@class KATValueObserver;


@protocol KATValueObserverDelegate <NSObject>

@optional

///属性值被非法改变
- (void)valueObserver:(KATValueObserver *)observer didFindIllegalAlteration:(NSString *)key;

@end



@interface KATValueObserver : NSObject

///事件代理
@property(nonatomic,assign) id<KATValueObserverDelegate> eventDelegate;


#pragma -mark 类方法

///获取实例，并绑定观察对象
+ (instancetype)observerForObject:(id)object;


#pragma -mark 对象方法

///添加需要观察的属性(路径)数组
- (void)addObservedKeys:(KATArray<NSString *> *)keys;

///添加需要观察的属性(路径)
- (void)addObservedKey:(NSString *)key;

///删除观察的属性(路径)数组
- (void)removeObservedKeys:(KATArray<NSString *> *)keys;

///删除观察的属性(路径)
- (void)removeObservedKey:(NSString *)key;

///清除所有的观察属性(路径)
- (void)clearObservedKeys;

///校验属性是否非法(不监听的属性都是合法的)
- (BOOL)isIllegalForKey:(NSString *)key;

@end

