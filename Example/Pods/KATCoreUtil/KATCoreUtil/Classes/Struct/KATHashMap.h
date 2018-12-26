//
//  KATHashMap.h
//  KATFramework
//
//  Created by Kantice on 13-11-20.
//  Copyright (c) 2013年 Kantice. All rights reserved.
//  散列表，根据键值对的形式存放数据，键(索引)为字符串格式，在存放数据的时候，会自动根据hashCode值计算存放的位置(默认重复的索引能覆盖原有的值)，hashCode()函数可以重载
//  对象与字典转换时，数字类型只包含int,float,double,long long,bool类型，不支持无符号整数，会自动转换成有符号整数

#import <Foundation/Foundation.h>
#import <objc/runtime.h>


#import "KATArray.h"


///散列表默认的容量
#define HASH_MAP_CAPACITY_DEFAULT (128)

///散列表默认的最大使用率
#define HASH_MAP_MAX_USAGE_DEFAULT (60)



///散列表转对象的类名key
extern NSString * const kHashMapKeyClass;

///散列表转对象的构造方法名key
extern NSString * const kHashMapKeySelector;

///散列表转对象的构造方法参数列表名key
extern NSString * const kHashMapKeyArguments;

///散列表转对象的构造方法单个参数名key
extern NSString * const kHashMapKeyArgument;

///对象转map时对象为数组或基础数据类型时的key
extern NSString * const kHashMapKeyObject;



@interface KATHashMap<T> : NSObject<NSCopying>



#pragma mark - 属性

///所存储的元素个数
@property(nonatomic,assign,readonly) int length;

///散列表的最大容量
@property(nonatomic,assign,readonly) int capacity;

///散列表的最大使用率
@property(nonatomic,assign) int maxUsage;

///散列表的当前使用率
@property(nonatomic,assign,readonly) int usage;

///是否自动扩容
@property(nonatomic,assign) BOOL autoExpand;

///是否能用重复的索引来覆盖原来的值（默认是可以）
@property(nonatomic,assign) BOOL replaceable;

///json描述模式
@property(nonatomic,assign) BOOL isJsonDescription;

///转对象的类名key（value为字符串）
@property(nonatomic,copy) NSString *keyClass;

///转对象的构造方法(类方法)名key（value为字符串）
@property(nonatomic,copy) NSString *keySelector;

///转对象的构造方法参数key（多个参数）(value为KATArray)
@property(nonatomic,copy) NSString *keyArguments;

///转对象的构造方法参数key（单个参数）
@property(nonatomic,copy) NSString *keyArgument;

///所有的key
@property(nonatomic,readonly) KATArray<NSString *> *allKeys;

///所有的value
@property(nonatomic,readonly) KATArray<T> *allValues;


#pragma mark - 类方法

///构造方法
+ (instancetype)hashMap;

///设置散列表容量(键数组大小)和最大使用率的构造方法
+ (instancetype)hashMapWithCapacity:(int)capacity andMaxUsage:(int)maxUsage;

///从格式化的字符串获取实例
+ (instancetype)hashMapWithString:(NSString *)src andSep:(NSString *)sep andOpt:(NSString *)opt;

///从字典中创建实例
+ (instancetype)hashMapWithDictionary:(NSDictionary *)dict;

///从字符串(json格式)中创建实例
+ (instancetype)hashMapWithString:(NSString *)json;

///从文件(json格式)中创建实例
+ (instancetype)hashMapWithFile:(NSString *)path;

///从plist文件中创建实例
+ (instancetype)hashMapWithPlist:(NSString *)path;

///通过UserDefaults创建实例
+ (instancetype)hashMapWithUserDefaults:(NSString *)key;

///将对象转化为Map
+ (instancetype)hashMapWithObject:(id)obj;

///设置是否检查循环持有对象问题(全局设置，默认为YES)
+ (void)setCycleCheck:(BOOL)cycleCheck;


#pragma mark - 对象方法

///放置元素，成功则返回YES
- (BOOL)putWithKey:(NSString *)key andValue:(T)value;

///根据索引获取值，失败则返回nil
- (T)getValueWithKey:(NSString *)key;

///删除元素，若成功则返回YES
- (BOOL)deleteValueWithKey:(NSString *)key;

///直接删除元素
- (BOOL)deleteValue:(T)value;

///从一个带分隔符和操作符的字符串中添加NSString键值对成员，返回添加的成员个数
- (int)putFromString:(NSString *)src withSep:(NSString *)sep andOpt:(NSString *)opt;

///放置一个map
- (int)putWithMap:(KATHashMap *)map;

///放置一个字典
- (int)putWithDictionary:(NSDictionary *)dict;

///获取hash码
- (int)hashCode:(NSString *)key;

///获取所有节点的值
- (KATArray<T> *)allValues;

///获取所有节点的键
- (KATArray<NSString *> *)allKeys;

///转换成NSMutableDictionary
- (NSMutableDictionary *)getNSMutableDictionary;

///写入到文件(jsong格式)
- (void)saveToFile:(NSString *)path;

///写入到plist文件
- (void)saveToPlist:(NSString *)path;

///保存到NSUserDefault
- (void)saveToUserDefaults:(NSString *)key;

///转化成格式化字符串
- (NSString *)stringWithSep:(NSString *)sep andOpt:(NSString *)opt;

///是否包含某个key
- (BOOL)hasKey:(NSString *)key;

///是否包含某个value
- (BOOL)hasValue:(T)value;

///通过value获取key
- (NSString *)getKeyWithValue:(T)value;

///清空
- (void)clear;

///是否已经存满
- (BOOL)isFull;

///转换成对象(对象之间有循环引用的情况下,应避免多个线程同时调用该方法)
- (id)object;

///转换成指定的对象
- (id)objectFromMapWithClass:(Class)cls;

///用下标的方式获取
- (T)objectForKeyedSubscript:(id)key;

///用下标的方式设置
- (void)setObject:(T)object forKeyedSubscript:(id<NSCopying>)aKey;

///描述
- (NSString *)description;

///散列表复制
- (instancetype)copyWithZone:(NSZone *)zone;

///内存释放
- (void)dealloc;



@end
