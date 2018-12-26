//
//  KATHashMap.m
//  KATFramework
//
//  Created by Kantice on 13-11-20.
//  Copyright (c) 2013年 Kantice. All rights reserved.
//

#import "KATHashMap.h"
#import "KATExpressionUtil.h"
#import "KATBranch.h"
#import "KATJsonUtil.h"
#import "KATFileUtil.h"




NSString * const kHashMapKeyClass=@"key_class";
NSString * const kHashMapKeySelector=@"key_selector";
NSString * const kHashMapKeyArguments=@"key_arguments";
NSString * const kHashMapKeyArgument=@"key_argument";
NSString * const kHashMapKeyObject=@"key_object";


///节点类型
typedef struct KATHashNode
{
    NSString *key;//索引
    id value;//内容
    struct KATHashNode *next;//下一个节点
}
KATHashNode;


@interface KATHashMap ()
{
    @private
    KATHashNode *_members;//成员数组
    int _usedNodes;//已经使用的node
}

@end



@implementation KATHashMap



//是否检查循环持有对象
static BOOL _cycleCheck=YES;


#pragma mark - 类方法

//构造方法
+ (instancetype)hashMap
{
    KATHashMap *hashMap=[[[self alloc] init] autorelease];
    
    //初始化
    [hashMap initWithCapacity:HASH_MAP_CAPACITY_DEFAULT andMaxUsage:HASH_MAP_MAX_USAGE_DEFAULT];
    
    return hashMap;
}


//设置散列表容量和最大使用率的构造方法
+ (instancetype)hashMapWithCapacity:(int)capacity andMaxUsage:(int)maxUsage
{
    KATHashMap *hashMap=[[[self alloc] init] autorelease];
    
    //初始化
    if(capacity>0 && maxUsage>0 && maxUsage<=100)
    {
        [hashMap initWithCapacity:capacity andMaxUsage:maxUsage];
    }
    else
    {
        [hashMap initWithCapacity:HASH_MAP_CAPACITY_DEFAULT andMaxUsage:HASH_MAP_MAX_USAGE_DEFAULT];
    }
    
    return hashMap;
}


//从格式化的字符串获取实例
+ (instancetype)hashMapWithString:(NSString *)src andSep:(NSString *)sep andOpt:(NSString *)opt
{
    KATHashMap *hashMap=[self hashMap];
    
    [hashMap putFromString:src withSep:sep andOpt:opt];
    
    return hashMap;
}


//从字典中创建Map
+ (instancetype)hashMapWithDictionary:(NSDictionary *)dict
{
    if(dict)
    {
        KATHashMap *map=[self hashMap];
        
        [map putWithDictionary:dict];
        
        return map;
    }
    
    return nil;
}


//从字符串(json格式)中创建实例
+ (instancetype)hashMapWithString:(NSString *)json
{
    return [KATJsonUtil hashMapFromJson:json];
}


//从文件(json格式)中创建实例
+ (instancetype)hashMapWithFile:(NSString *)path
{
    if([KATFileUtil existsFile:path])
    {
        return [KATJsonUtil hashMapFromJson:[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil]];
    }
    
    return nil;
}


//从plist文件中创建Map
+ (instancetype)hashMapWithPlist:(NSString *)path
{
    if([KATFileUtil existsFile:path])
    {
        return [self hashMapWithDictionary:[[[NSMutableDictionary alloc] initWithContentsOfFile:path] autorelease]];
    }
    
    return nil;
}


//通过UserDefaults创建实例
+ (instancetype)hashMapWithUserDefaults:(NSString *)key
{
    return [self hashMapWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:key]];
}


//将对象转化为Map
+ (instancetype)hashMapWithObject:(id)obj
{
    //返回值
    KATHashMap *hashMap=nil;
    
    //检测循环持有
    KATBranch *branch=nil;
    
    if(obj)
    {
        if(_cycleCheck)
        {
            branch=[KATBranch branch];
        }
        
        if([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSValue class]] || [obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSData class]] || [obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[KATArray class]])//基础类型(包括数组和字典)
        {
            //新建字典
            KATHashMap *map=[self hashMap];
            
            map[kHashMapKeyObject]=obj;
            
            hashMap=[self _object:map withKey:nil holder:nil andBranch:branch];
        }
        else
        {
            hashMap=[self _object:obj withKey:nil holder:nil andBranch:branch];
        }
    }
    
    return hashMap;
}


//对象转map的递归方法（内部方法）,holder为持有者
+ (id)_object:(id)obj withKey:(NSString *)key holder:(NSString *)holder andBranch:(KATBranch *)branch
{
    if(obj)
    {
        //判断是否循环
        if(branch)
        {
            if([branch hasSelfParentNode:[NSString stringWithFormat:@"%p",obj] fromParent:holder])
            {
                //陷入循环则返回空
                return nil;
            }
        }
        
        //加入分支
        if(branch)
        {
            [branch addNode:[NSString stringWithFormat:@"%p",obj]];
        }

        if([obj isKindOfClass:[KATHashMap class]] || [obj isKindOfClass:[NSDictionary class]])//map
        {
            NSString *objKey=[NSString stringWithFormat:@"%p",obj];
            
            if([obj isKindOfClass:[NSDictionary class]])
            {
                obj=[KATHashMap hashMapWithDictionary:obj];
            }
            
            if(!((KATHashMap *)obj)[kHashMapKeyClass])
            {
                //存入类名
                ((KATHashMap *)obj)[kHashMapKeyClass]=@"KATHashMap";
                
                //构造方法
                ((KATHashMap *)obj)[kHashMapKeySelector]=@"hashMap";
            }
            
            KATArray *keys=[(KATHashMap *)obj allKeys];
            
            for(NSString *key in keys)
            {
                //加入分支
                if(branch)
                {
                    [branch addNode:[NSString stringWithFormat:@"%p",((KATHashMap *)obj)[key]] toParent:objKey];
                }
                
                ((KATHashMap *)obj)[key]=[self _object:((KATHashMap *)obj)[key] withKey:key holder:objKey andBranch:branch];
            }
            
            return obj;
        }
        else if([obj isKindOfClass:[KATArray class]] || [obj isKindOfClass:[NSArray class]])//array
        {
            NSString *objKey=[NSString stringWithFormat:@"%p",obj];
            
            if([obj isKindOfClass:[NSArray class]])
            {
                obj=[KATArray arrayWithNSArray:obj];
            }
            
            KATArray *arr=[KATArray arrayWithCapacity:((KATArray *)obj).length];
            
            for(id mem in (KATArray *)obj)
            {
                //加入分支
                if(branch)
                {
                    [branch addNode:[NSString stringWithFormat:@"%p",mem] toParent:objKey];
                }
                
                mem=[self _object:mem withKey:nil holder:objKey andBranch:branch];
                
                [arr put:mem];
            }
            
            return arr;
        }
        else if([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSValue class]] || [obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSData class]] || [obj isKindOfClass:[NSDate class]])//基础类型
        {
            return obj;
        }
        else//其他对象，转换map
        {
            //该对象所属的类
            Class class=[obj class];
            
            if(class)//存在该类
            {
                KATHashMap *map=[self hashMap];
                
                //存入类名
                map[kHashMapKeyClass]=NSStringFromClass(class);
                
                //获取属性列表
                u_int count;
                objc_property_t *properties=class_copyPropertyList(class, &count);
                                
                for(int i=0;i<count;i++)
                {
                    //属性
                    objc_property_t property=properties[i];
                    
                    //属性名
                    NSString *name=[NSString stringWithUTF8String:property_getName(property)];
                    
                    //属性值
                    id value=nil;
                    
                    @try
                    {
                        //属性值(KVC)
                        value=[obj valueForKey:name];
                    }
                    @catch(NSException *exception)
                    {
//                        NSLog(@"Exception:%@",exception);
                        
                        value=nil;
                    }
                    @finally
                    {
                        ;
                    }
                    
                    if(value)
                    {
                        //加入分支
                        if(branch)
                        {
                            [branch addNode:[NSString stringWithFormat:@"%p",value] toParent:[NSString stringWithFormat:@"%p",obj]];
                        }
                        
                        //递归转换
                        value=[self _object:value withKey:name holder:[NSString stringWithFormat:@"%p",obj] andBranch:branch];
                        
                        map[name]=value;
                    }
                }
                
                free(properties);
                                
                return map;
            }
        }
    }
    
    return nil;
}


//设置是否检查循环持有对象问题(全局设置，默认为NO，若为YES，则需要注意线程安全问题)
+ (void)setCycleCheck:(BOOL)cycleCheck
{
    _cycleCheck=cycleCheck;
}


#pragma mark - 私有方法

//初始化数据
- (void)initWithCapacity:(int)capacity andMaxUsage:(int)maxUsage
{
    if(_members!=NULL)
    {
        //清除内容
        [self clear];
        
        free(_members);
        _members=NULL;
        
        [_keyClass release];
        [_keySelector release];
        [_keyArguments release];
        [_keyArgument release];
    }
    
    //初始化数据
    _capacity=capacity;
    _maxUsage=maxUsage;
    _length=0;
    _usage=0;
    _usedNodes=0;
    _replaceable=YES;
    _autoExpand=YES;
    _isJsonDescription=YES;
    
    self.keyClass=kHashMapKeyClass;
    self.keySelector=kHashMapKeySelector;
    self.keyArguments=kHashMapKeyArguments;
    self.keyArgument=kHashMapKeyArgument;
    
    //分配空间
    _members=(KATHashNode *)malloc(sizeof(KATHashNode)*capacity);
    
    //初始成员变量赋空值
    for(int i=0;i<_capacity;i++)
    {
        _members[i].key=nil;
        _members[i].value=nil;
        _members[i].next=NULL;
    }
}


//递归释放链表节点内存(内部方法)
void releaseNextNode(KATHashNode *node)
{
    if(node!=NULL)
    {
        releaseNextNode(node->next);
        
        [node->key release];
        node->key=nil;
        
        [node->value release];
        node->value=nil;
        
        node->next=NULL;
        
        free(node);
    }
    
}


//获取成员数组指针
- (KATHashNode *)getMembers
{
    return _members;
}


//设置_length
- (void)setLength:(int)value
{
    _length=value;
}


//设置usage
- (void)setUsage:(int)usage
{
    _usage=usage;
}


//设置节点使用数
- (void)setUsedNodes:(int)nodes
{
    _usedNodes=nodes;
}



#pragma mark - 对象方法

//放置元素，成功则返回YES
- (BOOL)putWithKey:(NSString *)key andValue:(id)value
{
    if(key && value)
    {
        if(_usage<=_maxUsage)//判断是否达到最大使用率
        {
            int code=[self hashCode:key];//获取hash码
            
            if(_members[code].key)//该位置已经存在元素
            {
                //判断是否为重复的索引
                if([key isEqualToString:_members[code].key])//重复的索引
                {
                    if(_replaceable)//可以覆盖
                    {
                        //相同内容不做处理
                        if(_members[code].value!=value)
                        {
                            [_members[code].value release];
                            _members[code].value=[value retain];
                        }
                        
                        return YES;
                    }
                    else//不可以覆盖
                    {
                        return NO;
                    }
                }
                else//不重复的索引
                {
                    KATHashNode *preNode=&_members[code];
                    KATHashNode *nextNode=_members[code].next;
                    
                    //遍历链表
                    while(nextNode!=NULL)
                    {
                        //判断是否为重复的索引
                        if([key isEqualToString:nextNode->key])//重复的索引
                        {
                            if(_replaceable)//可以覆盖
                            {
                                //相同内容不做处理
                                if(nextNode->value!=value)
                                {
                                    [nextNode->value release];
                                    nextNode->value=[value retain];
                                }
                                    
                                return YES;
                            }
                            else//不可以覆盖
                            {
                                return NO;
                            }
                        }
                        
                        preNode=nextNode;
                        nextNode=nextNode->next;
                    }
                    
                    //没有相同，则新建node
                    KATHashNode *newNode=malloc(sizeof(KATHashNode));
                    newNode->key=[key copy];
                    newNode->value=[value retain];
                    newNode->next=NULL;
                    
                    //加入链表
                    preNode->next=newNode;
                    
                    _length++;
                }
            }
            else//该位置没有元素
            {
                _members[code].key=[key copy];
                _members[code].value=[value retain];
                
                _length++;
                _usedNodes++;
                
                _usage=_usedNodes*100/_capacity;//重新计算使用率
            }
            
            return YES;
        }
        else
        {
            if(_autoExpand)//自动扩容
            {                
                //保存原有数据
                BOOL json=_isJsonDescription;
                BOOL replaceable=_replaceable;
                KATHashMap *oldMap=[self copy];
                
                //重新申请空间及还原
                [self initWithCapacity:_capacity*2 andMaxUsage:_maxUsage];
                _replaceable=replaceable;
                _isJsonDescription=json;
                
                [self putWithMap:oldMap];
                [oldMap release];
                
                return [self putWithKey:key andValue:value];
            }
            
            return NO;
        }
    }
    else if(key && !value)//value为空则删除
    {
        return [self deleteValueWithKey:key];
    }
    
    return NO;
}


//根据索引获取值，失败则返回nil
- (id)getValueWithKey:(NSString *)key
{
    if(!key)
    {
        return nil;
    }
    
    int code=[self hashCode:key];//获取hash码
    
    if(_members[code].key)//该位置存在节点
    {
        if([key isEqualToString:_members[code].key])//找到索引
        {
            return _members[code].value;
        }
        else//未找到索引
        {
            KATHashNode *nextNode=_members[code].next;
            
            //遍历链表
            while(nextNode!=NULL)
            {
                if([key isEqualToString:nextNode->key])//找到索引
                {
                    return nextNode->value;
                }
                
                nextNode=nextNode->next;
            }
        }
    }
    else//该位置不存在节点
    {
        return nil;
    }
    
    return nil;
}


//删除元素，若成功则返回YES
- (BOOL)deleteValueWithKey:(NSString *)key
{
    if(!key)
    {
        return NO;
    }
    
    int code=[self hashCode:key];//获取hash码
    
    if(_members[code].key)//该位置存在节点
    {
        if([key isEqualToString:_members[code].key])//找到索引
        {
            //释放内存
            [_members[code].key release];
            [_members[code].value release];
            _members[code].key=nil;
            _members[code].value=nil;
            
            //存在下一个节点
            if(_members[code].next!=NULL)
            {
                //节点替换
                KATHashNode *nextNode=_members[code].next;
                _members[code].key=nextNode->key;
                _members[code].value=nextNode->value;
                _members[code].next=nextNode->next;
                
                free(nextNode);
            }
            
            _length--;
            _usedNodes--;
            
            _usage=_usedNodes*100/_capacity;//重新计算使用率
            
            return YES;
        }
        else//未找到索引
        {
            KATHashNode *preNode=&_members[code];
            KATHashNode *nextNode=_members[code].next;
            
            //遍历链表
            while(nextNode!=NULL)
            {
                if([key isEqualToString:nextNode->key])//找到索引
                {
                    //释放内存
                    [nextNode->key release];
                    [nextNode->value release];
                    nextNode->key=nil;
                    nextNode->value=nil;
                    
                    //连接下一节点(是否为空都一样)
                    preNode->next=nextNode->next;
                    
                    //释放节点
                    free(nextNode);
                    
                    _length--;
                    
                    return YES;
                }
                
                preNode=nextNode;
                nextNode=nextNode->next;
            }
        }
    }
    else//该位置不存在节点
    {
        return NO;
    }
    
    return NO;
}


//直接删除元素
- (BOOL)deleteValue:(id)value
{
    NSString *key=[self getKeyWithValue:value];
    
    if(key)
    {
        return [self deleteValueWithKey:key];
    }
    
    return NO;
}


//从一个带分隔符和操作符的字符串中添加NSString键值对成员，返回添加的成员个数
- (int)putFromString:(NSString *)src withSep:(NSString *)sep andOpt:(NSString *)opt
{
    if(!src || src.length<=0 || !sep || sep.length<=0 || !opt || opt.length<=0)//格式不符合
    {
        return 0;
    }
    
    int count=0;//添加的成员个数
    
    //临时变量
    NSRange range={0,0};
    NSString *key;//临时存放key
    NSString *val;//临时存放value
    
    while(YES)//开始解析内容
    {
        //取操作符
        range=[src rangeOfString:opt];
        
        if(range.length==0)//没有操作符则停止解析
        {
            break;
        }
        else
        {
            key=[src substringToIndex:range.location];
            src=[src substringFromIndex:range.location+range.length];
            
            //判断key中是否还存在分隔符，若存在，则截取最后一段内容
            range=[key rangeOfString:sep options:NSBackwardsSearch];
            
            if(range.length>0)
            {
                key=[key substringFromIndex:range.location+range.length];
            }
        }
        
        //取分隔符
        range=[src rangeOfString:sep];
        
        if(range.length==0)//没有分隔符说明是最后一条数据，在操作完之后解析结束
        {
            val=src;//余下的内容
            
            [self putWithKey:key andValue:val];
            count++;
            
            break;
        }
        else//有分隔符则在操作后继续解析
        {
            val=[src substringToIndex:range.location];
            
            [self putWithKey:key andValue:val];
            count++;
            
            src=[src substringFromIndex:range.location+range.length];
        }
        
    }
    
    return count;
}


//放置一个map
- (int)putWithMap:(KATHashMap *)map
{
    if(map && map.length>0)
    {
        KATArray *keys=[map allKeys];
        int count=0;
        
        for(int i=0;i<keys.length;i++)
        {
            if([self putWithKey:[keys get:i] andValue:[map getValueWithKey:[keys get:i]]])
            {
                count++;
            }
        }
        
        return count;
    }
    
    return -1;
}


//放置一个字典
- (int)putWithDictionary:(NSDictionary *)dict
{
    if(dict && dict.count>0)
    {
        NSArray *keys=[dict allKeys];
        int count=0;
        
        for(int i=0;i<keys.count;i++)
        {
            //判断是否为数组或者字典，递归解析
            id value=[dict valueForKey:[keys objectAtIndex:i]];
            
            if([value isKindOfClass:[NSArray class]])//数组
            {
                value=[KATArray arrayWithNSArray:value];
            }
            else if([value isKindOfClass:[NSDictionary class]])//字典
            {
                value=[KATHashMap hashMapWithDictionary:value];
            }
            
            if([self putWithKey:[keys objectAtIndex:i] andValue:value])
            {
                count++;
            }
        }
        
        return count;
    }
    
    return -1;
}


//获取所有节点的值
- (KATArray *)allValues
{
    if(_length>0)
    {
        KATArray *array=[KATArray arrayWithCapacity:_length];
        
        for(int i=0;i<_capacity;i++)
        {
            if(_members[i].key)
            {
                [array put:_members[i].value];
                
                KATHashNode *nextNode=_members[i].next;
                
                //遍历链表
                while(nextNode!=NULL)
                {
                    [array put:nextNode->value];
                    
                    nextNode=nextNode->next;
                }
            }
        }
        
        return array;
    }
    else
    {
        return nil;
    }
}


//获取所有节点的键
- (KATArray *)allKeys
{
    if(_length>0)
    {
        KATArray *array=[KATArray arrayWithCapacity:_length];
        
        for(int i=0;i<_capacity;i++)
        {
            if(_members[i].key)
            {
                [array put:_members[i].key];
                
                KATHashNode *nextNode=_members[i].next;
                
                //遍历链表
                while(nextNode!=NULL)
                {
                    [array put:nextNode->key];
                    
                    nextNode=nextNode->next;
                }
            }
        }
        
        return array;
    }
    else
    {
        return nil;
    }
}


//转换成NSMutableDictionary
- (NSMutableDictionary *)getNSMutableDictionary
{
    NSMutableDictionary *dictionary=[NSMutableDictionary dictionary];
    KATArray *keys=[self allKeys];
    KATArray *values=[self allValues];
    
    if(keys && values && keys.length==values.length)
    {
        for(int i=0;i<keys.length;i++)
        {
            id value=[values get:i];
            
            if([value isKindOfClass:[KATArray class]])//数组
            {
                value=[(KATArray *)value getNSMutableArray];
            }
            else if([value isKindOfClass:[KATHashMap class]])//Map
            {
                value=[(KATHashMap *)value getNSMutableDictionary];
            }
            
            [dictionary setObject:value forKey:[keys get:i]];
        }
    }
    
    return dictionary;
}


//写入到文件(jsong格式)
- (void)saveToFile:(NSString *)path
{
    //要保存的临时map
    KATHashMap *map=[KATHashMap hashMapWithCapacity:_capacity andMaxUsage:_maxUsage];
    map.isJsonDescription=YES;
    
    KATArray<NSString *> *keys=[self allKeys];
    
    for(NSString *key in keys)
    {
        id obj=self[key];
        
        if([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSValue class]] || [obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSData class]] || [obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[KATArray class]])//基础类型(包括数组和字典)
        {
            map[key]=obj;
        }
        else
        {
            map[key]=[KATHashMap hashMapWithObject:obj];
        }
    }
    
    [[map description] writeToFile:path atomically:NO encoding:NSUTF8StringEncoding error:nil];
}


//写入到plist文件
- (void)saveToPlist:(NSString *)path
{
    [[[KATHashMap hashMapWithObject:self] getNSMutableDictionary] writeToFile:path atomically:YES];
}


//保存到NSUserDefault
- (void)saveToUserDefaults:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:[[KATHashMap hashMapWithObject:self] getNSMutableDictionary] forKey:key];
}


//转化成格式化字符串
- (NSString *)stringWithSep:(NSString *)sep andOpt:(NSString *)opt
{
    if(!sep)
    {
        sep=@"";
    }
    
    if(!opt)
    {
        opt=@"";
    }
    
    NSMutableString *string=[NSMutableString string];
    
    KATArray *keys=[self allKeys];
    
    for(int i=0;i<keys.length;i++)
    {
        if(i==keys.length-1)
        {
            [string appendFormat:@"%@%@%@",keys[i],opt,self[keys[i]]];
        }
        else
        {
            [string appendFormat:@"%@%@%@%@",keys[i],opt,self[keys[i]],sep];
        }
        
    }
    
    return string;
}


//是否包含某个key
- (BOOL)hasKey:(NSString *)key
{
    if([self getValueWithKey:key])
    {
        return YES;
    }
    
    return NO;
}


//是否包含某个value
- (BOOL)hasValue:(id)value
{
    if([self getKeyWithValue:value])
    {
        return YES;
    }
    
    return NO;
}


//通过value获取key
- (NSString *)getKeyWithValue:(id)value
{
    if(!value)
    {
        return nil;
    }
    
    //遍历数组
    for(int i=0;i<_capacity;i++)
    {
        if(_members[i].value)
        {
            if(_members[i].value==value)
            {
                return _members[i].key;
            }
            else if([value isKindOfClass:[NSString class]] && [_members[i].value isKindOfClass:[NSString class]] && [value isEqualToString:_members[i].value])//字符串类型
            {
                return _members[i].key;
            }
            else
            {
                KATHashNode *nextNode=_members[i].next;
                
                //遍历链表
                while(nextNode!=NULL)
                {
                    if(nextNode->value==value)
                    {
                        return nextNode->key;
                    }
                    else if([value isKindOfClass:[NSString class]] && [nextNode->value isKindOfClass:[NSString class]] && [value isEqualToString:nextNode->value])//字符串类型
                    {
                        return nextNode->key;
                    }
                    
                    nextNode=nextNode->next;
                }
            }
        }
    }
    
    return nil;
}


//清空
- (void)clear
{
    for(int i=0;i<_capacity;i++)
    {
        if(_members[i].key)
        {
            releaseNextNode(_members[i].next);
            
            [_members[i].key release];
            _members[i].key=nil;
            
            [_members[i].value release];
            _members[i].value=nil;
            
            _members[i].next=NULL;
        }
    }
    
    _length=0;
    _usage=0;
    _usedNodes=0;
}


//是否已经存满
- (BOOL)isFull
{
    if(_usage<_maxUsage)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}


//转换成指定的对象
- (id)objectFromMapWithClass:(Class)cls
{
    [self putWithKey:_keyClass andValue:NSStringFromClass(cls)];
    
    return [self object];
}



//转换成对象
- (id)object
{
    //返回值
    id object=nil;
    
    //检测循环持有
    KATBranch *branch=nil;
    
    if(_cycleCheck)
    {
        branch=[KATBranch branch];
    }
    
    if(branch)
    {
        [branch addNode:[NSString stringWithFormat:@"%p",self]];
    }
    
    if(!self[_keyClass])//没有指定类名，则用HahsMap
    {
        self[_keyClass]=@"KATHashMap";
        self[_keySelector]=@"hashMap";
    }
    
    object=[self _objectFromMapWithHolder:[NSString stringWithFormat:@"%p",self] andBranch:branch];
    
    return object;
}


//转换成对象递归方法(内部方法)
- (id)_objectFromMapWithHolder:(NSString *)holder andBranch:(KATBranch *)branch
{
    id object=nil;
    
    if(_keyClass && self[_keyClass] && [self[_keyClass] isKindOfClass:[NSString class]])
    {
        //类名
        const char *className=[self[_keyClass] cStringUsingEncoding:NSUTF8StringEncoding];
        
        //从一个字符串返回一个Class
        Class class=objc_getClass(className);
        
        if(class)//存在该类
        {
            id obj;
            
            if(self[_keySelector] && [self[_keySelector] isKindOfClass:[NSString class]])//用构造函数
            {
                //获取方法
                SEL sel=NSSelectorFromString(self[_keySelector]);
                NSMethodSignature *signature=[class methodSignatureForSelector:sel];//类方法签名，若是实例方法，则用instanceMethodSignatureForSelector
                
                if(signature)//检查是否实现了该方法
                {
                    NSInvocation *invocation=[NSInvocation invocationWithMethodSignature:signature];
                    long count=[signature numberOfArguments];//参数个数
                    
                    //先设置0，1参数
                    [invocation setArgument:&class atIndex:0];
                    [invocation setArgument:&sel atIndex:1];
                    
                    if(count>2)//大于2，则说明有参数(除了2个隐藏参数)
                    {
                        KATArray *args=nil;
                        
                        if(_keyArgument && self[_keyArgument])//单个参数
                        {                            
                            args=[KATArray arrayWithCapacity:1];
                            
                            [args put:self[_keyArgument]];
                        }
                        else if(_keyArguments && self[_keyArguments] && [self[_keyArguments] isKindOfClass:[KATArray class]])
                        {                            
                            args=(KATArray *)self[_keyArguments];
                        }
                        
                        if(args && args.length>0)
                        {
                            //设置参数
                            for(int i=0;i<args.length && i<count-2;i++)
                            {
                                const char *type=[signature getArgumentTypeAtIndex:i+2];
                                
                                if(*type=='B')//BOOL类型
                                {
                                    BOOL arg=[args[i] boolValue];
                                    
                                    [invocation setArgument:&arg atIndex:i+2];
                                }
                                else if(*type=='c')//char类型
                                {
                                    char arg=[args[i] intValue];
                                    
                                    [invocation setArgument:&arg atIndex:i+2];
                                }
                                else if(*type=='s')//short类型
                                {
                                    short arg=[args[i] intValue];
                                    
                                    [invocation setArgument:&arg atIndex:i+2];
                                }
                                else if(*type=='i')//int类型
                                {
                                    int arg=[args[i] intValue];
                                    
                                    [invocation setArgument:&arg atIndex:i+2];
                                }
                                else if(*type=='l')//long类型
                                {
                                    long arg=(long)[args[i] longLongValue];
                                    
                                    [invocation setArgument:&arg atIndex:i+2];
                                }
                                else if(*type=='q')//long long类型
                                {
                                    long long arg=[args[i] longLongValue];
                                    
                                    [invocation setArgument:&arg atIndex:i+2];
                                }
                                else if(*type=='C')//U char类型
                                {
                                    unsigned char arg=[args[i] intValue];
                                    
                                    [invocation setArgument:&arg atIndex:i+2];
                                }
                                else if(*type=='I')//U int类型
                                {
                                    unsigned int arg=[args[i] intValue];
                                    
                                    [invocation setArgument:&arg atIndex:i+2];
                                }
                                else if(*type=='S')//U short类型
                                {
                                    unsigned short arg=[args[i] intValue];
                                    
                                    [invocation setArgument:&arg atIndex:i+2];
                                }
                                else if(*type=='L')//U long类型
                                {
                                    unsigned long arg=(unsigned long)[args[i] longLongValue];
                                    
                                    [invocation setArgument:&arg atIndex:i+2];
                                }
                                else if(*type=='Q')//U long long类型
                                {
                                    unsigned long long arg=[args[i] longLongValue];
                                    
                                    [invocation setArgument:&arg atIndex:i+2];
                                }
                                else if(*type=='f')//float类型
                                {
                                    float arg=[args[i] floatValue];
                                    
                                    [invocation setArgument:&arg atIndex:i+2];
                                }
                                else if(*type=='d')//double类型
                                {
                                    double arg=[args[i] doubleValue];
                                    
                                    [invocation setArgument:&arg atIndex:i+2];
                                }
                                else if(*type=='@')//id类型
                                {
                                    id arg=args[i];
                                                                        
                                    [invocation setArgument:&arg atIndex:i+2];
                                }
                                else if(*type=='#')//class类型
                                {
                                    Class arg=[args[i] class];
                                    
                                    [invocation setArgument:&arg atIndex:i+2];
                                }
                            }
                        }
                        
                    }
                    
                    [invocation setTarget:class];//设置执行目标
                    
                    [invocation invoke];
                    
                    [invocation getReturnValue:&obj];//获取返回值
                }
                else//未实现该方法，用通用构造方法
                {
                    obj=[[[class alloc] init] autorelease];
                }
            }
            else//默认构造方法
            {
                obj=[[[class alloc] init] autorelease];
            }
            
            //解析
            if(class==[KATHashMap class] && [obj isKindOfClass:[KATHashMap class]])//map
            {
                KATArray *keys=[self allKeys];
                
                for(NSString *key in keys)
                {
                    id value=self[key];
                    
                    if([value isKindOfClass:[KATHashMap class]])
                    {
                        ((KATHashMap *)value)[_keyClass]=@"KATHashMap";
                        ((KATHashMap *)value)[_keySelector]=@"hashMap";
                        
                        //加入分支
                        if(branch)
                        {
                            [branch addNode:[NSString stringWithFormat:@"%p",value] toParent:holder];
                        }
                        
                        //判断是否循环
                        if(branch && [branch hasSelfParentNode:[NSString stringWithFormat:@"%p",value] fromParent:holder])
                        {
                            value=nil;
                        }
                        else
                        {
                            value=[(KATHashMap *)value _objectFromMapWithHolder:[NSString stringWithFormat:@"%p",value] andBranch:branch];
                        }
                    }
                    else if([value isKindOfClass:[KATArray class]])//数组
                    {
                        KATArray *array=[KATArray arrayWithCapacity:((KATArray *)value).length];
                        
                        for(int i=0;i<((KATArray *)value).length;i++)
                        {
                            id mem=((KATArray *)value)[i];
                            
                            if(mem && [mem isKindOfClass:[KATHashMap class]])
                            {
                                //加入分支
                                if(branch)
                                {
                                    [branch addNode:[NSString stringWithFormat:@"%p",mem] toParent:holder];
                                }
                                
                                //判断是否循环
                                if(branch && [branch hasSelfParentNode:[NSString stringWithFormat:@"%p",mem] fromParent:holder])
                                {
                                    mem=nil;
                                }
                                else
                                {
                                    mem=[(KATHashMap *)mem _objectFromMapWithHolder:[NSString stringWithFormat:@"%p",mem] andBranch:branch];
                                }
                            }
                            
                            [array put:mem];
                        }
                        
                        value=array;
                    }
                    
                    ((KATHashMap *)obj)[key]=value;
                }
                
                object=obj;
            }
            else//一般对象
            {
                //获取属性列表
                u_int count;
                objc_property_t *properties=class_copyPropertyList(class, &count);
                
                for(int i=0;i<count;i++)
                {
                    //获取属性
                    objc_property_t property=properties[i];
                    
                    //属性详情
                    const char *attr=property_getAttributes(property);//属性：如Ti,R,N,V_length，第二个字符i表示具体类型int
                    
                    //类名正则表达式(在双引号之间)(效率低)
//                    NSString *exp=[KATExpressionUtil expressionWithStart:@"\"" andEnd:@"\""];
//                    
//                    //类名(用于判断是否为HashMap或者Array，以便于继续解析)
//                    NSString *className=[KATExpressionUtil contentsWithExpression:exp inString:[NSString stringWithUTF8String:attr]][0];
//                    
//                    //类名去掉引号
//                    if(className && className.length>1)
//                    {
//                        className=[className substringWithRange:NSMakeRange(1, className.length-2)];
//                    }
                    
                    //类型字符
                    char type=attr[1];
                    
                    //用c字符数组解析，提高效率
                    char clsName[256]="";
                    int startPoint=-1;//引号位置
                    
                    if(type=='@')
                    {
                        for(int x=0;x<strlen(attr);x++)
                        {
                            char ch=attr[x];
                            
                            if(startPoint>=0)
                            {
                                clsName[x-startPoint-1]=ch;
                            }
                            
                            if(ch=='"')
                            {
                                if(startPoint>=0)
                                {
                                    clsName[x-startPoint-1]='\0';
                                    
                                    break;
                                }
                                else
                                {
                                    startPoint=x;
                                }
                            }
                        }
                    }
                    
                    NSString *className=[NSString stringWithUTF8String:clsName];
                    
                    //属性名
                    NSString *name=[NSString stringWithUTF8String:property_getName(property)];
                                        
                    //获取对映的值
//                    id arg=self[name];
                    id arg=[self getValueWithKey:name];
                    
                    if(arg)
                    {
                        //赋值
                        if(type=='B')//BOOL类型
                        {
                            BOOL v=[arg boolValue];
                            
                            [obj setValue:@(v) forKey:name];
                        }
                        else if(type=='c')//char类型
                        {
                            char v=[arg intValue];
                            
                            [obj setValue:@(v) forKey:name];
                        }
                        else if(type=='s')//short类型
                        {
                            short v=[arg intValue];
                            
                            [obj setValue:@(v) forKey:name];
                        }
                        else if(type=='i')//int类型
                        {
                            int v=[arg intValue];
                            
                            [obj setValue:@(v) forKey:name];
                        }
                        else if(type=='l')//long类型
                        {
                            long v=(long)[arg longLongValue];
                            
                            [obj setValue:@(v) forKey:name];
                        }
                        else if(type=='q')//long long类型
                        {
                            long long v=[arg longLongValue];
                            
                            [obj setValue:@(v) forKey:name];
                        }
                        else if(type=='C')//U char类型
                        {
                            unsigned char v=[arg intValue];
                            
                            [obj setValue:@(v) forKey:name];
                        }
                        else if(type=='I')//U int类型
                        {
                            unsigned int v=[arg intValue];
                            
                            [obj setValue:@(v) forKey:name];
                        }
                        else if(type=='S')//U short类型
                        {
                            unsigned short v=[arg intValue];
                            
                            [obj setValue:@(v) forKey:name];
                        }
                        else if(type=='L')//U long类型
                        {
                            unsigned long v=(unsigned long)[arg longLongValue];
                            
                            [obj setValue:@(v) forKey:name];
                        }
                        else if(type=='Q')//U long long类型
                        {
                            unsigned long long v=[arg longLongValue];
                            
                            [obj setValue:@(v) forKey:name];
                        }
                        else if(type=='f')//float类型
                        {
                            float v=[arg floatValue];
                            
                            [obj setValue:@(v) forKey:name];
                        }
                        else if(type=='d')//double类型
                        {
                            double v=[arg doubleValue];
                            
                            [obj setValue:@(v) forKey:name];
                        }
                        else if(type=='@')//id类型
                        {
                            //Array和MAP继续解析
                            if([arg isKindOfClass:[KATHashMap class]])
                            {
                                if([@"NSDictionary" isEqualToString:className] || [@"NSMutableDictionary" isEqualToString:className])//处理NSDictionay
                                {
                                    //还原成NSDictionary
                                    arg=[(KATHashMap *)arg getNSMutableDictionary];
                                }
                                else
                                {
                                    //添加类名
                                    if(className && className.length>0)
                                    {
                                        ((KATHashMap *)arg)[((KATHashMap *)arg).keyClass]=className;
                                    }
                                    
                                    if([@"KATHashMap" isEqualToString:className])
                                    {
                                        ((KATHashMap *)arg)[((KATHashMap *)arg).keySelector]=@"hashMap";
                                    }
                                    
                                    //加入分支
                                    if(branch)
                                    {
                                        [branch addNode:[NSString stringWithFormat:@"%p",arg] toParent:holder];
                                    }
                                    
                                    //判断是否循环
                                    if(branch && [branch hasSelfParentNode:[NSString stringWithFormat:@"%p",arg] fromParent:holder])
                                    {
                                        arg=nil;
                                    }
                                    else
                                    {
                                        arg=[(KATHashMap *)arg _objectFromMapWithHolder:[NSString stringWithFormat:@"%p",arg] andBranch:branch];
                                    }
                                }
                            }
                            else if([arg isKindOfClass:[KATArray class]])
                            {
                                KATArray *array=[KATArray arrayWithCapacity:((KATArray *)arg).length];
                                                                
                                for(int i=0;i<((KATArray *)arg).length;i++)
                                {
                                    id mem=((KATArray *)arg)[i];
                                    
                                    if(mem && [mem isKindOfClass:[KATHashMap class]])
                                    {
                                        //加入分支
                                        if(branch)
                                        {
                                            [branch addNode:[NSString stringWithFormat:@"%p",mem] toParent:holder];
                                        }
                                        
                                        //!此处不能获取泛型，所以只能靠json带的key_class属性判断类型，若无该属性，则解析成nil

                                        
                                        //判断是否循环
                                        if(branch && [branch hasSelfParentNode:[NSString stringWithFormat:@"%p",mem] fromParent:holder])
                                        {
                                            mem=nil;
                                        }
                                        else
                                        {
                                            mem=[(KATHashMap *)mem _objectFromMapWithHolder:[NSString stringWithFormat:@"%p",mem] andBranch:branch];
                                        } 
                                    }
                                    
                                    [array put:mem];
                                }
                                
                                arg=array;
                                
                                if([@"NSArray" isEqualToString:className] || [@"NSMutableArray" isEqualToString:className])//处理NSArray
                                {
                                    //还原成NSArray
                                    arg=[(KATArray *)arg getNSMutableArray];
                                }
                            }
                                                        
                            if([arg isKindOfClass:NSClassFromString(className)])//判断是否为同一类型
                            {
                                [obj setValue:arg forKey:name];
                            }
                        }
                        else if(type=='#')//class类型
                        {
                            Class v=[arg class];
                            
                            [obj setValue:v forKey:name];
                        }
                    }
                 
                }
                
                //释放属性列表
                free(properties);
                
                object=obj;
            }
        }
    }
    
    return object;
}



//获取hash码
- (int)hashCode:(NSString *)key
{
    return [key hash]%_capacity;
}



#pragma mark - 重载方法

//用下标的方式获取
- (id)objectForKeyedSubscript:(id)key
{
    if(!key)
    {
        return nil;
    }
    
    if([self getValueWithKey:key])//直接返回
    {
        return [self getValueWithKey:key];
    }
    else//分段处理
    {
        NSRange range=[key rangeOfString:@"."];
        
        if(range.length>0)//带点
        {
            //判断是否带分隔符
            if([KATExpressionUtil matchExpression:kExpressionUri inString:key])
            {
                //路径数组
                KATArray *keys=[KATArray arrayWithString:[NSString stringWithFormat:@".%@.",key] andSep:@"."];
                
                if(keys && keys.length>1)
                {
                    KATHashMap *map=self;//解析过程中遇到的map(根为self)
                    KATArray *array=nil;//解析过程中可能遇到array
                    
                    BOOL isArray=NO;//是否解析到数组
                    
                    //循环遍历路径
                    for(int i=0;i<keys.length;i++)
                    {
                        id next;
                        
                        if(isArray)//上层是array
                        {
                            next=[array get:[keys[i] intValue]];
                        }
                        else//上层是map
                        {
                            next=[map getValueWithKey:keys[i]];
                        }
                        
                        if(next)
                        {                        
                            if(i<keys.length-1)//非末尾
                            {
                                if([next isKindOfClass:[KATHashMap class]])//是map，继续解析
                                {
                                    map=next;
                                    isArray=NO;
                                    
                                    continue;
                                }
                                else if([next isKindOfClass:[KATArray class]])//是array，继续解析
                                {
                                    array=next;
                                    isArray=YES;
                                    
                                    continue;
                                }
                                else//非map，停止解析
                                {
                                    break;
                                }
                                
                            }
                            else//末尾
                            {
                                return next;
                            }
                        }
                        
                        break;
                    }
                }
            }
        }
    }
    
    return nil;
}


//用下标的方式设置
- (void)setObject:(id)object forKeyedSubscript:(id< NSCopying >)aKey
{
    if(aKey)
    {
        if(object)
        {
            [self putWithKey:(NSString *)aKey andValue:object];
        }
        else
        {
            [self deleteValueWithKey:(NSString *)aKey];
        }
    }
}


//描述
- (NSString *)description
{
    if(_members==NULL)
    {
        return @"Null HashMap";
    }
    
    if(_isJsonDescription)//Json格式的描述
    {
        NSMutableString *ms=[NSMutableString stringWithFormat:@"\n{\n"];
        
        int count=0;
        
        for(int i=0;i<_capacity;i++)
        {
            if(_members[i].key)
            {
                NSString *key=_members[i].key;//key
                
                if([key isKindOfClass:[NSString class]])//字符串类型判断
                {
                    //转义字符引号
                    key=[key stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
                }

                if([_members[i].value isKindOfClass:[NSString class]])//string类型的带引号
                {
                    [ms appendFormat:@"  \"%@\" : \"%@\" ",key,[_members[i].value stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]];
                }
                else
                {
                    if([_members[i].value isKindOfClass:[KATArray class]])//数组
                    {
                        ((KATArray *)_members[i].value).isJsonDescription=YES;
                        
                        [ms appendFormat:@"  \"%@\" : %@ ",key,_members[i].value];
                    }
                    else if([_members[i].value isKindOfClass:[KATHashMap class]])//字典
                    {
                        ((KATHashMap *)_members[i].value).isJsonDescription=YES;
                        
                        [ms appendFormat:@"  \"%@\" : %@ ",key,_members[i].value];
                    }
                    else if([_members[i].value isKindOfClass:[NSNumber class]])//数字
                    {
                        //不处理
                        [ms appendFormat:@"  \"%@\" : %@ ",key,_members[i].value];
                    }
                    else if([_members[i].value isKindOfClass:[NSValue class]] || [_members[i].value isKindOfClass:[NSData class]])//数据
                    {
                        //加引号
                        [ms appendFormat:@"  \"%@\" : \"%@\" ",key,_members[i].value];
                    }
                    else//其他对象
                    {
                        //转换成HashMap
                        KATHashMap *map=[KATHashMap hashMapWithObject:_members[i].value];
                        
                        if([map isKindOfClass:[KATHashMap class]])
                        {
                            map.isJsonDescription=YES;
                        }
                        
                        [ms appendFormat:@"  \"%@\" : %@ ",key,map];
                    }
                }
                
                if(count<_length-1)
                {
                    [ms appendString:@",\n"];
                }
                else//最后一行
                {
                    [ms appendString:@"\n"];
                }
                
                count++;
                
                KATHashNode *nextNode=_members[i].next;
                
                //遍历链表
                while(nextNode!=NULL)
                {
                    NSString *key=nextNode->key;//key
                    
                    if([key isKindOfClass:[NSString class]])//字符串类型判断
                    {
                        //转义字符引号
                        key=[key stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
                    }
                    
                    if([nextNode->value isKindOfClass:[NSString class]])//string类型的带引号
                    {
                        [ms appendFormat:@"  \"%@\" : \"%@\" ",key,[nextNode->value stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]];
                    }
                    else
                    {
                        if([nextNode->value isKindOfClass:[KATArray class]])//数组
                        {
                            ((KATArray *)nextNode->value).isJsonDescription=YES;
                            
                            [ms appendFormat:@"  \"%@\" : %@ ",key,nextNode->value];
                        }
                        else if([nextNode->value isKindOfClass:[KATHashMap class]])//字典
                        {
                            ((KATHashMap *)nextNode->value).isJsonDescription=YES;
                            
                            [ms appendFormat:@"  \"%@\" : %@ ",key,nextNode->value];
                        }
                        else if([nextNode->value isKindOfClass:[NSNumber class]])//数字
                        {
                            //不处理
                            [ms appendFormat:@"  \"%@\" : %@ ",key,nextNode->value];
                        }
                        else if([nextNode->value isKindOfClass:[NSValue class]] || [nextNode->value isKindOfClass:[NSData class]])//数据
                        {
                            //加引号
                            [ms appendFormat:@"  \"%@\" : \"%@\" ",key,nextNode->value];
                        }
                        else//其他对象
                        {
                            //转换成HashMap
                            KATHashMap *map=[KATHashMap hashMapWithObject:nextNode->value];
                            
                            if([map isKindOfClass:[KATHashMap class]])
                            {
                                map.isJsonDescription=YES;
                            }
                            
                            [ms appendFormat:@"  \"%@\" : %@ ",key,map];
                        }
                    }
                    
                    if(count<_length-1)
                    {
                        [ms appendString:@",\n"];
                    }
                    else//最后一行
                    {
                        [ms appendString:@"\n"];
                    }
                    
                    count++;
                    
                    nextNode=nextNode->next;
                }
            }
        }
        
        [ms appendString:@"}"];
        
        return ms;
    }
    else
    {
        NSMutableString *ms=[NSMutableString stringWithFormat:@"KATHashMap: cap=%i, nodes=%i, max=%i, len=%i, usage=%i\n{\n",_capacity,_usedNodes,_maxUsage,_length,_usage];
        
        for(int i=0;i<_capacity;i++)
        {
            if(_members[i].key)
            {
                [ms appendFormat:@"   [%@] %@ \n",_members[i].key,_members[i].value];
                
                KATHashNode *nextNode=_members[i].next;
                
                //遍历链表
                while(nextNode!=NULL)
                {
                    [ms appendFormat:@"   [%@] %@ \n",nextNode->key,nextNode->value];
                    
                    nextNode=nextNode->next;
                }
            }
        }
        
        [ms appendString:@"}"];
        
        return ms;
    }

}


//散列表复制
- (instancetype)copyWithZone:(NSZone *)zone
{
    KATHashMap *hashMap=[[[self class] allocWithZone:zone] init];
    
    [hashMap initWithCapacity:_capacity andMaxUsage:_maxUsage];
    
    hashMap.length=_length;
    [hashMap setUsedNodes:_usedNodes];
    [hashMap setUsage:_usage];
    hashMap.replaceable=_replaceable;
    hashMap.maxUsage=_maxUsage;
    hashMap.isJsonDescription=_isJsonDescription;
    
    KATHashNode *p=[hashMap getMembers];
    
    for(int i=0;i<_capacity;i++)
    {
        p[i].key=[_members[i].key copy];
        p[i].value=[_members[i].value retain];
        p[i].next=NULL;
        
        KATHashNode *preNode=&p[i];
        KATHashNode *nextNode=_members[i].next;
        
        while(nextNode)
        {
            KATHashNode *newNode=malloc(sizeof(KATHashNode));
            newNode->key=[nextNode->key copy];
            newNode->value=[nextNode->value retain];
            newNode->next=NULL;
            
            preNode->next=newNode;
            preNode=newNode;
            
            nextNode=nextNode->next;
        }
    }
    
    return hashMap;
}


//内存释放
- (void)dealloc
{
    [self clear];
    
    free(_members);
    _members=NULL;
    
    [_keyClass release];
    [_keySelector release];
    [_keyArguments release];
    [_keyArgument release];
    
//    NSLog(@"KATHashMap(%i/%i) is dealloc",_length,_capacity);
    
    [super dealloc];
}


@end
