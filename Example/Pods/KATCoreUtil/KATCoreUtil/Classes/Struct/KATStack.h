//
//  KATStack.h
//  KATFramework
//
//  Created by Kantice on 13-11-19.
//  Copyright (c) 2013年 Kantice. All rights reserved.
//  堆栈类，采用先进后出的形式存放和获取节点，该类是以数组的形式存放节点

#import <Foundation/Foundation.h>
#import "KATArray.h"


///默认的最大容量
#define STACK_CAPACITY_DEFAULT (128)


@interface KATStack<T> : NSObject<NSCopying>


#pragma mark - 属性

///所存储的数组长度
@property(nonatomic,assign,readonly) int length;

///数组的最大容量
@property(nonatomic,assign,readonly) int capacity;

///是否自动扩容
@property(nonatomic,assign) BOOL autoExpand;

///所有的成员
@property(nonatomic,readonly) KATArray<T> *allMembers;


#pragma mark - 类方法

///构造方法
+ (instancetype)stack;

///设置数组容量的构造方法
+ (instancetype)stackWithCapacity:(int)capacity;


#pragma mark - 对象方法

///在栈顶节点，成功则返回YES
- (BOOL)put:(T)value;

///获取栈顶节点，得到后将从堆栈中删除该节点，失败则返回nil
- (T)get;

///获取栈顶节点，但不在堆栈中删除
- (T)toper;

///判断堆栈是否为空
- (BOOL)isEmpty;

///是否包含成员
- (BOOL)hasMember:(T)member;

///从指定成员的低下插入元素
- (BOOL)insert:(T)value toMember:(T)member;

///从指定成员的上面添加元素
- (BOOL)append:(T)value toMember:(T)member;

///删除指定的成员
- (BOOL)deleteMember:(T)member;

///获取所有成员(从栈顶开始排序)
- (KATArray<T> *)allMembers;

///获取从栈顶开始的N个成员
- (KATArray<T> *)topers:(int)count;

///清除堆栈
- (void)clear;

///是否已经存满
- (BOOL)isFull;

///描述
- (NSString *)description;

///堆栈复制
- (instancetype)copyWithZone:(NSZone *)zone;

///内存释放
- (void)dealloc;



@end
