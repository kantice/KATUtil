//
//  KATTreeMap.h
//  KATFramework
//
//  Created by Kantice on 13-11-20.
//  Copyright (c) 2013年 Kantice. All rights reserved.
//  二叉树链表类，根据键值对的形式存放数据，键(索引)为字符串格式，在存放数据的时候，会自动根据索引值计算插入的位置(默认重复的索引能覆盖原有的值)，默认为红黑树

#import <Foundation/Foundation.h>

#import "KATArray.h"




@interface KATTreeMap<T> : NSObject<NSCopying>


#pragma mark - 属性

///所存储的元素个数
@property(nonatomic,assign,readonly) int length;

///是否能用重复的索引来覆盖原来的值（默认是可以）
@property(nonatomic,assign) BOOL replace;

///是否为平衡树（红黑树）
@property(nonatomic,assign) BOOL balance;

///所有的key
@property(nonatomic,readonly) KATArray<NSString *> *allKeys;

///所有的value
@property(nonatomic,readonly) KATArray<T> *allValues;


#pragma mark - 类方法

///构造方法
+ (instancetype)treeMap;


#pragma mark - 对象方法

///放置元素，成功则返回YES
- (BOOL)putWithKey:(NSString *)key andValue:(T)value;

///根据索引获取值，失败则返回nil
- (T)getValueWithKey:(NSString *)key;

///删除元素，若成功则返回YES
- (BOOL)deleteValueWithKey:(NSString *)key;

///根据索引设置元素值
- (BOOL)setValue:(T)value withKey:(NSString *)key;

//获取所有节点元素数组
//- (id *)getValues;

///获取所有节点元素数组
- (KATArray<T> *)allValues;

///获取所有节点的键
- (KATArray<NSString *> *)allKeys;

//获取一定范围的节点元素，返回id指针，并把长度作为参数返回
//- (id *)getWithStart:(NSString *)start andEnd:(NSString *)end returnArrayLength:(int *)length;

///获取一定范围的value数组(包含begin和end)
- (KATArray<T> *)valuesFromKey:(NSString *)begin toKey:(NSString *)end;

///获取从起点到key的value数组(包含key)
- (KATArray<T> *)valuesToKey:(NSString *)key;

///获取从key到终点的value数组(包含key)
- (KATArray<T> *)valuesFromKey:(NSString *)key;

///获取首个键
- (NSString *)firstKey;

///获取首个值
- (T)firstValue;

///获取最后一个键
- (NSString *)lastKey;

///获取最后一个值
- (T)lastValue;

///清空
- (void)clear;

///用下标的方式获取
- (T)objectForKeyedSubscript:(id)key;

///用下标的方式设置
- (void)setObject:(T)object forKeyedSubscript:(id< NSCopying >)aKey;

///描述
- (NSString *)description;

///二叉树复制
- (instancetype)copyWithZone:(NSZone *)zone;

///内存释放
- (void)dealloc;




@end
