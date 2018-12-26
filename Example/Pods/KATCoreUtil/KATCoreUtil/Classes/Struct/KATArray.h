//
//  KATArray.h
//  KATFramework
//
//  Created by Kantice on 13-11-19.
//  Copyright (c) 2013年 Kantice. All rights reserved.
//  存储id类型的数组

#import <Foundation/Foundation.h>


///数组默认容量
#define ARRAY_CAPACITY_DEFAULT (128)

///默认缓存大小
#define ARRAY_CACHE_LENGTH (16)



@interface KATArray<T> : NSObject <NSCopying,NSFastEnumeration>



#pragma mark - 属性

///所存储的数组长度
@property(nonatomic,assign,readonly) int length;

///数组的最大容量
@property(nonatomic,assign,readonly) int capacity;

///是否自动扩容
@property(nonatomic,assign) BOOL autoExpand;

///json描述模式
@property(nonatomic,assign) BOOL isJsonDescription;


#pragma mark - 类方法

///构造方法
+ (instancetype)array;

///设置数组容量的构造方法
+ (instancetype)arrayWithCapacity:(int)capacity;

///从分隔字符串中构造数组
+ (instancetype)arrayWithString:(NSString *)src andSep:(NSString *)sep;

///从多个对象中构造数组(必须以nil结束)
+ (instancetype)arrayWithMembers:(T)member, ... NS_REQUIRES_NIL_TERMINATION;

///从NSArray中构造数组
+ (instancetype)arrayWithNSArray:(NSArray *)array;

///通过UserDefaults创建实例
+ (instancetype)arrayWithUserDefaults:(NSString *)key;

///获取多个数组的并集
+ (instancetype)unionWithArrays:(KATArray<KATArray *> *)arrays;

///获取多个数组的交集
+ (instancetype)intersectionWithArrays:(KATArray<KATArray *> *)arrays;

///获取多个数组的差集
+ (instancetype)exceptionWithArrays:(KATArray<KATArray *> *)arrays;


#pragma mark - 对象方法

///添加数组成员，成功则返回YES
- (BOOL)put:(T)value;

///根据索引获取数组成员，失败则返回nil
- (T)get:(int)index;

///设置成员数据
- (BOOL)set:(T)value withIndex:(int)index;

///从指定的位置插入数据，成功则返回YES
- (BOOL)put:(T)value withIndex:(int)index;

///从指定的位置添加数组，成功则返回YES
- (BOOL)putArray:(KATArray *)array withIndex:(int)index;

///从指定的位置添加NSArray，成功则返回YES
- (BOOL)putNSArray:(NSArray *)array withIndex:(int)index;

///从一个带分隔符的字符串中添加NSString成员，如果blank值是YES则把空白也当作成员，否则则忽略空白，返回添加的成员个数
- (int)putFromString:(NSString *)src withSep:(NSString *)sep andBlank:(BOOL)blank;

///根据range获取子数组
- (instancetype)subarrayWithRange:(NSRange)range;

///子数组(从0到index，不包含index)
- (instancetype)subarrayToIndex:(int)index;

///子数组(从index到结尾，包含index)
- (instancetype)subarrayFromIndex:(int)index;

///去除重复元素(速度快，但顺序会打乱)
- (instancetype)distinct;

///去除重复元素，并保留原有顺序
- (instancetype)distinctArray;

///去除重复属性的元素，并且保留原有顺序(key为self或空则比较本身)(删除相同数据的前者)
- (instancetype)distinctArrayWithKey:(NSString *)key;

///删除数组成员，成功则返回YES
- (BOOL)deleteWithIndex:(int)index;

///替换数组成员，成功则返回YES
- (BOOL)replaceMember:(T)member withIndex:(int)index;

///交换成员位置
- (BOOL)changePositionWithIndexA:(int)a andIndexB:(int)b;

///设置头成员，在它之前的后移
- (BOOL)setHeaderMember:(T)member;

///设置尾成员，在它之后的前移
- (BOOL)setTailMember:(T)member;

///删除数组成员
- (BOOL)deleteMember:(T)member;

///是否包含数组成员
- (BOOL)hasMember:(T)member;

///所有成员向前移动
- (void)forwardByStep:(int)step;

///所有成员向后移动
- (void)backwardByStep:(int)step;

///获取index
- (int)indexWithMember:(T)member;

///从指定的位置两侧开始寻找成员的索引
- (int)indexWithMember:(T)member fromIndex:(int)index;

///获取第一个成员
- (T)firstMember;

///获取最后一个成员
- (T)lastMember;

///获取前几个成员
- (instancetype)fristMembers:(int)count;

///获取最后几个成员
- (instancetype)lastMembers:(int)count;

///获取下一个成员
- (T)nextWithMember:(T)member;

///获取上一个成员
- (T)previousWithMember:(T)member;

///获取随机的成员
- (T)randomMember;

///数值最大的成员
- (T)biggestMember;

///数值最小的成员
- (T)smallestMember;

///成员求和(浮点数)
- (double)floatSumOfMembers;

///成员求和(整数)
- (long long int)integerSumOfMembers;

///根据range删除数组成员，成功则返回YES
- (BOOL)deleteFromRange:(NSRange)range;

///数组排序(必须为同一类型成员对象，且实现compare方法，该方法速度较快)
- (void)sort;

///通过关键词排序(升序排列，若要降序，排序后反序即可)(关键词对应为数组成员的属性)(关键词权重按顺序，若元素不存在任意一关键词属性，则不参与排序)(若属性为数字，则以数值大小为基准，若为字符串，则已字符顺序为基准，其他对象属性以hashCode为基准)(注意:数字超过16位会丢失后面的精度,小数最多保留8位精度)
- (instancetype)sortByKey:(NSString *)key;

///通过关键词数组排序(升序排列，若要降序，排序后反序即可)(关键词对应为数组成员的属性)(关键词权重按顺序，若元素不存在任意一关键词属性，则不参与排序)(若属性为数字，则以数值大小为基准，若为字符串，则已字符顺序为基准，其他对象属性以hashCode为基准)(注意:数字超过16位会丢失后面的精度,小数最多保留8位精度)
- (instancetype)sortByKeys:(KATArray<NSString *> *)keys;

///筛选(条件格式为:属性(若自身则用self,只能是数字或字符串类型),符号(==,>=,<=,>,<,!=),参考值(若属性为数字，则参考值会转换为double类型的数字，精确6位小数，慎用等号),例如:name>=kat,age<20,self>3,son.age>=30等;若对比值为属性值,则在属性名前加&,例如:age<&money,age>&son.age等,不以&为开始则视为普通字符串;若想用以&开头的字符串,则用\&开头)(关系为'AND'或者'OR',YES则为OR,NO为AND,整个条件数组都用该关系)(为简化操作忽略所有空格,包括对比的字符串值中的空格)
- (instancetype)filterWithRelationshipOR:(BOOL)OR andConditions:(KATArray<NSString *> *)conditions;

///筛选(条件格式为:属性(若自身则用self,只能是数字或字符串类型),符号(==,>=,<=,>,<,!=),参考值(若属性为数字，则参考值会转换为double类型的数字，精确6位小数，慎用等号),AND关系运算符'&&'和OR关系运算符'||'同时存在时，优先运算AND关系,不支持括号调整优先级,例如:name>=kat || age<20 && money>100.0,self>30&&son.age>=3等)(为简化操作忽略所有空格,包括对比的字符串值中的空格)
- (instancetype)filterWithCondition:(NSString *)condition;

///数组反序
- (instancetype)reverse;

///数组乱序洗牌
- (instancetype)shuffle;

///清空数组
- (void)clear;

///是否已经存满
- (BOOL)isFull;

///转化成NSMutableArray
- (NSMutableArray *)getNSMutableArray;

///保存到NSUserDefault
- (void)saveToUserDefaults:(NSString *)key;

///转化成格式化字符串(带分隔符)
- (NSString *)stringWithSep:(NSString *)sep;

///带下标的方式获取数组成员
- (T)objectAtIndexedSubscript:(NSUInteger)idx;

///带下标的方式设置数组成员
- (void)setObject:(T)anObject atIndexedSubscript:(NSUInteger)index;

///缓存索引数据
- (NSString *)cacheIndex;

///描述
- (NSString *)description;

///数组复制
- (instancetype)copyWithZone:(NSZone *)zone;

///内存释放
- (void)dealloc;




@end
