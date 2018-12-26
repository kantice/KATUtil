//
//  KATArray.m
//  KATFramework
//
//  Created by Kantice on 13-11-19.
//  Copyright (c) 2013年 Kantice. All rights reserved.
//

#import "KATArray.h"
#import "KATHashMap.h"
#import "KATTreeMap.h"
#import <UIKit/UIKit.h>



//筛选条件
@interface KATArrayCondition : NSObject

///属性
@property(nonatomic,copy) NSString *property;

///操作符
@property(nonatomic,copy) NSString *operator;

///参考值
@property(nonatomic,copy) NSString *value;

@end


@implementation KATArrayCondition

- (void)dealloc
{
    [_property release];
    [_operator release];
    [_value release];
    
    [super dealloc];
}

@end




@interface KATArray ()
{
    @private
    id   *_member;
    int  *_cache;//最近使用的索引缓存
}

@end



@implementation KATArray


#pragma mark - 类方法


//构造方法
+ (instancetype)array
{
    KATArray *array=[[[self alloc] init] autorelease];
    
    //初始化
    [array initData:ARRAY_CAPACITY_DEFAULT];
    
    return array;
}


//设置数组容量的构造方法
+ (instancetype)arrayWithCapacity:(int)capacity
{
    KATArray *array=[[[self alloc] init] autorelease];
    
    //初始化
    if(capacity>0)
    {
        [array initData:capacity];
    }
    else
    {
        [array initData:ARRAY_CAPACITY_DEFAULT];
    }
    
    return array;
}


//从分隔字符串中构造数组
+ (instancetype)arrayWithString:(NSString *)src andSep:(NSString *)sep
{
    KATArray *array=[self arrayWithCapacity:64];
    
    [array putFromString:src withSep:sep andBlank:NO];
    
    return array;
}


//从多个对象中构造数组(必须以nil结束)
+ (instancetype)arrayWithMembers:(id)member, ...
{
    KATArray *array=[self arrayWithCapacity:16];
    
    va_list ap;
    
    //定位不定形参列表（省略号部分）之前的一个形参
    va_start(ap, member);
    
    //如果member参数本身为空，则不去解析不定形参部分
    if(member)
    {
        [array put:member];
        
        //这里假定如果member不为空，则后续一定跟着至少一个不定实参
        id mem;
        
        //开始迭代
        do
        {
            mem=va_arg(ap, id);
            
            if(mem)
            {
                [array put:mem];
            }
        }
        while(mem);
    }
    
    //迭代结束
    va_end(ap);
    
    return array;
}


//从NSArray中构造数组
+ (instancetype)arrayWithNSArray:(NSArray *)array
{
    if(array)
    {
        KATArray *arr=[KATArray array];
        
        [arr putNSArray:array withIndex:0];
        
        return arr;
    }
    
    return nil;
}


//通过UserDefaults创建实例
+ (instancetype)arrayWithUserDefaults:(NSString *)key
{
    return [KATHashMap hashMapWithUserDefaults:key][kHashMapKeyObject];
//    return [self arrayWithNSArray:[[NSUserDefaults standardUserDefaults] objectForKey:key]];
}


//获取多个数组的并集
+ (instancetype)unionWithArrays:(KATArray<KATArray *> *)arrays
{
    KATArray *unionArray=[KATArray array];
    
    for(KATArray *array in arrays)
    {
        [unionArray putArray:array withIndex:unionArray.length];
    }
    
    return [unionArray distinctArray];
}


//获取多个数组的交集
+ (instancetype)intersectionWithArrays:(KATArray<KATArray *> *)arrays
{
    KATArray *intersectionArray=[KATArray array];
    
    if(arrays.length>0)//多个数组
    {
        //以首个数组的成员为比较对象
        for(int i=0;i<arrays[0].length;i++)
        {
            BOOL flag=YES;//标记量
            
            for(int j=1;j<arrays.length;j++)
            {
                if(![arrays[j] hasMember:arrays[0][i]])//不存在
                {
                    flag=NO;
                    
                    break;
                }
            }
            
            if(flag)
            {
                [intersectionArray put:arrays[0][i]];
            }
        }
    }
    
    return intersectionArray;
}


//获取多个数组的差集
+ (instancetype)exceptionWithArrays:(KATArray<KATArray *> *)arrays
{
    KATArray *exceptionArray=[KATArray unionWithArrays:arrays];//先获取并集
    
    KATArray *intersectionArray=[KATArray intersectionWithArrays:arrays];//再获取交集
    
    for(id member in intersectionArray)//在并集中去掉交集
    {
        [exceptionArray deleteMember:member];
    }
    
    return exceptionArray;
}


#pragma mark - 私有方法

//初始化数据
- (void)initData:(int)capacity
{
    _capacity=capacity;
    _length=0;
    _isJsonDescription=YES;
    _autoExpand=YES;
    
    //给成员分配空间
    _member=(id *)malloc(sizeof(id)*capacity);
    
    //给索引缓存分配空间
    _cache=(int *)malloc(sizeof(int)*ARRAY_CACHE_LENGTH);
    
    //初始成员变量赋空值
    for(int i=0;i<_capacity;i++)
    {
        _member[i]=nil;
    }
    
    //初始化缓存区
    for(int i=0;i<ARRAY_CACHE_LENGTH;i++)
    {
        _cache[i]=-1;
    }
}


//设置_length
- (void)setLength:(int)value
{
    _length=value;
}


//获取member指针
- (id *)member
{
    return _member;
}


//获取cache指针
- (int *)cache
{
    return _cache;
}


//存入缓存
- (void)putCacheWithIndex:(int)index
{
    //有效的索引
    if(index>=0 && _member[index])
    {
        if(index!=_cache[0])//判断是非连续缓存同一个索引
        {
            //后移
            for(int i=ARRAY_CACHE_LENGTH-1;i>0;i--)
            {
                _cache[i]=_cache[i-1];
            }
            
            _cache[0]=index;
        }
    }
}


//在缓存中寻找该数据的索引，找不到返回-1
- (int)cacheIndexWithMember:(id)member
{
    int index=-1;
    
    if(member)
    {
        for(int i=0;i<ARRAY_CACHE_LENGTH;i++)
        {
            if(_cache[i]<0)//找到末尾
            {
                break;
            }
            else if(_member[_cache[i]] && _member[_cache[i]]==member)
            {
                index=_cache[i];
                
                break;
            }
            else if(_member[_cache[i]] && [_member[_cache[i]] isKindOfClass:[NSString class]] && [member isKindOfClass:[NSString class]] && [member isEqualToString:_member[_cache[i]]])//字符串类型
            {
                index=_cache[i];
                
                break;
            }
        }
    }
    
    return index;
}



#pragma mark - 对象方法

//添加数组成员，成功则返回YES
- (BOOL)put:(id)value
{
    if(value==nil)
    {
        return NO;
    }
    
    //判断数组是否已经满员
    if(_length<_capacity)
    {
        //添加成员
        _member[_length]=[value retain];
        _length++;
        
        return YES;
    }
    else
    {
        if(_autoExpand)//自动扩容
        {            
            //保存原来的数据
            BOOL json=_isJsonDescription;
            int len=_length;
            id *members=_member;
            int *cache=_cache;
            
            //重新初始化
            [self initData:2*_capacity];
            _isJsonDescription=json;
            _length=len;
            
            //转移
//            for(int i=0;i<_length;i++)
//            {
//                _member[i]=members[i];
//            }
            
            //拷贝内存
            memcpy(_member, members, sizeof(id)*_length);
            
            free(members);
            free(cache);
            
            return [self put:value];//添加成员
        }
        
        return NO;
    }
}


//根据索引获取数组成员，失败则返回nil
- (id)get:(int)index
{
    //判断index的范围
    if(index>=0 && index<_length)
    {
        return _member[index];
    }
    else
    {
        return nil;
    }
}


//设置成员数据
- (BOOL)set:(id)value withIndex:(int)index
{
    //判断index的范围
    if(index>=0 && index<_length)
    {
        if(!value)//空值则删除
        {
            return [self deleteWithIndex:index];
        }
        
        //放入索引缓存
        [self putCacheWithIndex:index];
        
        [_member[index] release];
        _member[index]=[value retain];
        
        return YES;
    }
    else
    {
        return NO;
    }
}


//从指定的位置插入数据，成功则返回YES
- (BOOL)put:(id)value withIndex:(int)index
{
    if(!value || index<0 || index>_length)//容量已满或者index不在length范围内，则插入失败
    {
        return NO;
    }
    else if(_length>=_capacity)//容量不够
    {
        if(_autoExpand)//自动扩容
        {
            //保存原来的数据
            BOOL json=_isJsonDescription;
            int len=_length;
            id *members=_member;
            int *cache=_cache;
            
            //重新初始化
            [self initData:2*_capacity];
            _isJsonDescription=json;
            _length=len;
            
//            //转移
//            for(int i=0;i<_length;i++)
//            {
//                _member[i]=members[i];
//            }
            
            //拷贝内存
            memcpy(_member, members, sizeof(id)*_length);
            
            free(members);
            free(cache);
            
            return [self put:value withIndex:index];//添加成员
        }
        
        return NO;
    }
    else
    {
        for(int i=_length;i>index;i--)
        {
            _member[i]=_member[i-1];
        }
        
        //放入索引缓存
        [self putCacheWithIndex:index];
        
        _member[index]=[value retain];
        
        _length++;
        
        return YES;
    }
}


//从指定的位置添加数组，成功则返回YES
- (BOOL)putArray:(KATArray *)array withIndex:(int)index
{
    if(array==nil || array.length<=0 || index<0 || index>_length)//空数组或者index不在length范围内，则插入失败
    {
        return NO;
    }
    else if(_length+array.length>_capacity)//容量不够
    {
        if(_autoExpand)//自动扩容
        {
            int capacity=_capacity+array.length;
            
            //保存原来的数据
            BOOL json=_isJsonDescription;
            int len=_length;
            id *members=_member;
            int *cache=_cache;
            
            //重新初始化
            [self initData:capacity];
            _isJsonDescription=json;
            _length=len;
            
//            //转移
//            for(int i=0;i<_length;i++)
//            {
//                _member[i]=members[i];
//            }
            
            //拷贝内存
            memcpy(_member, members, sizeof(id)*_length);
            
            free(members);
            free(cache);
            
            return [self putArray:array withIndex:index];//添加成员
        }
        
        return NO;
    }
    else
    {
        for(int i=_length+array.length-1;i>=index+array.length;i--)
        {
            _member[i]=_member[i-array.length];
        }
        
        for(int i=index;i<index+array.length;i++)
        {
            _member[i]=[[array get:i-index] retain];
        }
        
        _length+=array.length;
        
        return YES;
    }
}



//从指定的位置添加NSArray，成功则返回YES
- (BOOL)putNSArray:(NSArray *)array withIndex:(int)index
{
    if(array==nil || array.count<=0 || index<0 || index>_length)//空数组或者index不在length范围内，则插入失败
    {
        return NO;
    }
    else if(_length+array.count>_capacity)//容量不够
    {
        if(_autoExpand)//自动扩容
        {
            int capacity=_capacity+(int)array.count;
            
            //保存原来的数据
            BOOL json=_isJsonDescription;
            int len=_length;
            id *members=_member;
            int *cache=_cache;
            
            //重新初始化
            [self initData:capacity];
            _isJsonDescription=json;
            _length=len;
            
//            //转移
//            for(int i=0;i<_length;i++)
//            {
//                _member[i]=members[i];
//            }
            
            //拷贝内存
            memcpy(_member, members, sizeof(id)*_length);
            
            free(members);
            free(cache);
            
            return [self putNSArray:array withIndex:index];//添加成员
        }
        
        return NO;
    }
    else
    {
        for(int i=_length+(int)array.count-1;i>=index+array.count;i--)
        {
            _member[i]=_member[i-array.count];
        }
        
        for(int i=index;i<index+array.count;i++)
        {
            //判断是否为数组或者字典，递归解析
            id value=[array objectAtIndex:i-index];
            
            if([value isKindOfClass:[NSArray class]])//数组
            {
                value=[KATArray arrayWithNSArray:value];
            }
            else if([value isKindOfClass:[NSDictionary class]])//字典
            {
                value=[KATHashMap hashMapWithDictionary:value];
            }
            
            _member[i]=[value retain];
        }
        
        _length+=array.count;
        
        return YES;
    }
}



//从一个带分隔符的字符串中添加NSString成员，如果blank值是YES则把空白也当作成员，否则则忽略空白，返回添加的成员个数
- (int)putFromString:(NSString *)src withSep:(NSString *)sep andBlank:(BOOL)blank
{
    int count=0;//添加的成员个数
    
    NSRange range={0,0};
    NSString *str;//临时存放成员
    
    //先截去第一个分隔符
//    range=[src rangeOfString:sep];//查找分隔符
//    
//    if(range.length==0)//没有找到任何分隔符则返回0
//    {
//        return 0;
//    }
//    
//    src=[src substringFromIndex:(range.location+range.length)];//截去第一个分隔符
    
    while(YES)//找到第一个分隔符后遍历查找余下的内容，直到找不到分隔符后跳出循环
    {
        range=[src rangeOfString:sep];//查找下一个分隔符
        
        if(range.length==0)//没有找到分隔符(最后一块)
        {
            str=src;//最后剩下的内容
            
            if([str isEqualToString:@""])//判断是否为空字符串
            {
                if(blank)
                {
                    [self put:str];//添加到数组
                    count++;//计数器
                }
            }
            else
            {
                [self put:str];//添加到数组
                count++;//计数器
            }
            
            break;
        }
        else//找到分隔符
        {
            str=[src substringToIndex:range.location];//截取需要的内容
            
            if([str isEqualToString:@""])//判断是否为空字符串
            {
                if(blank)
                {
                    [self put:str];//添加到数组
                    count++;//计数器
                }
            }
            else
            {
                [self put:str];//添加到数组
                count++;//计数器
            }
        
            src=[src substringFromIndex:(range.location+range.length)];//截去分隔符
        }
    }
    
    return count;
}


//根据range获取子数组
- (instancetype)subarrayWithRange:(NSRange)range
{
    KATArray *array=[KATArray arrayWithCapacity:(int)range.length];
    
    for(int i=(int)range.location,j=0;i<_length && j<range.length;i++,j++)
    {
        [array put:_member[i]];
    }
    
    return array;
}


//子数组(从0到index，不包含index)
- (instancetype)subarrayToIndex:(int)index
{
    //修正index
    if(index<0)
    {
        index=0;
    }
    
    if(index>_length)
    {
        index=_length;
    }
    
    return [self subarrayWithRange:NSMakeRange(0, index)];
}


//子数组(从index到结尾，包含index)
- (instancetype)subarrayFromIndex:(int)index
{
    //修正index
    if(index<0)
    {
        index=0;
    }
    
    if(index>_length)
    {
        index=_length;
    }
    
    return [self subarrayWithRange:NSMakeRange(index, _length-index)];
}


//去除重复元素
- (instancetype)distinct
{
    NSSet *set=[NSSet setWithArray:[self getNSMutableArray]];
    
    KATArray *array=[KATArray arrayWithCapacity:(int)set.count];
    
    [array putNSArray:[set allObjects] withIndex:0];
    
    return array;
}


//去除重复元素，并保留原有顺序
- (instancetype)distinctArray
{
    KATArray *array=[KATArray arrayWithCapacity:_length];
    
    KATTreeMap *tree=[KATTreeMap treeMap];
    tree.replace=NO;

    for(int i=0;i<_length;i++)
    {
        NSString *key=nil;

        if([_member[i] isKindOfClass:[NSString class]])//字符串
        {
            key=_member[i];
        }
        else//非字符串，key为内存地址
        {
            key=[NSString stringWithFormat:@"%p",_member[i]];
        }

        if([tree putWithKey:key andValue:@""])
        {
            [array put:_member[i]];
        }
    }
    
    return array;
}


//去除重复属性的元素，并且保留原有顺序(key为self或空则比较本身)(删除相同数据的前者)
- (instancetype)distinctArrayWithKey:(NSString *)key
{
    KATArray *array=[KATArray arrayWithCapacity:_length];
    
    KATTreeMap *tree=[KATTreeMap treeMap];
    tree.replace=NO;
    
    for(int i=0;i<_length;i++)
    {
        //属性数组
        KATArray<NSString *> *ps=[KATArray arrayWithString:key andSep:@"."];
        
        //要对比的属性
        id pv=_member[i];
        
        for(NSString *p in ps)//遍历属性
        {
            if([@"self" isEqualToString:p])//本身
            {
                //不处理
            }
            else//属性
            {
                @try
                {
                    if([pv isKindOfClass:[KATHashMap class]] || [pv isKindOfClass:[NSDictionary class]])//HashMap或字典
                    {
                        pv=pv[p];
                    }
                    else
                    {
                        //属性值(KVC)
                        pv=[pv valueForKey:p];
                    }
                }
                @catch(NSException *exception)
                {
                    pv=nil;
                    break;
                }
                @finally
                {
                    ;
                }
            }
        }
        
        if(pv)
        {
            if([pv isKindOfClass:[NSString class]] || [pv isKindOfClass:[NSNumber class]] || [pv isKindOfClass:[NSValue class]])//字符串数值类型
            {
                pv=[NSString stringWithFormat:@"%@",pv];
            }
            else//其他类型
            {
                pv=[NSString stringWithFormat:@"_%p_%@",pv,pv];//内存地址
            }
                        
            if([tree putWithKey:pv andValue:@""])
            {
                [array put:_member[i]];
            }
        }
        else//不存在该属性，不去重
        {
            [array put:_member[i]];
        }
    }
    
    return array;
}


//删除数组成员，成功则返回YES
- (BOOL)deleteWithIndex:(int)index
{
    //判断index的范围
    if(index>=0 && index<_length)
    {
        //释放内存
        [_member[index] release];
        
        //删除元素并前移数组
        for(int i=index;i<_length-1;i++)
        {
            _member[i]=_member[i+1];
        }
        
        _member[_length-1]=nil;//最后的成员赋空值
        
        _length--;
        
        return YES;
    }
    else
    {
        return NO;
    }
    
}


//替换数组成员，成功则返回YES
- (BOOL)replaceMember:(id)member withIndex:(int)index
{
    if(member==nil)
    {
        return NO;
    }
    
    //判断index的范围
    if(index>=0 && index<_length)
    {
        //放入索引缓存
        [self putCacheWithIndex:index];
        
        //释放内存
        [_member[index] release];
        
        _member[index]=[member retain];
        
        return YES;
    }
    else
    {
        return NO;
    }
}


//交换两个成员的位置
- (BOOL)changePositionWithIndexA:(int)a andIndexB:(int)b
{
    if(a>=0 && a<_length && b>=0 && b<_length && a!=b)//判断a，b下标范围
    {
        id tmp;
        
        tmp=_member[a];
        _member[a]=_member[b];
        _member[b]=tmp;
        
        return YES;
    }
    else
    {
        return NO;
    }
}


//设置头成员，在它之前的后移
- (BOOL)setHeaderMember:(id)member
{
    int index=0;
    
    for(;index<_length;index++)
    {
        if(_member[index] && _member[index]==member)//找到
        {
            //在它之前的后移
            for(int i=index-1;i>=0;i--)
            {
                _member[i+1]=_member[i];
            }
            
            _member[0]=member;//新的头成员
            
            break;
        }
        else if(_member[index] && [_member[index] isKindOfClass:[NSString class]] && [member isKindOfClass:[NSString class]] && [member isEqualToString:_member[index]])//字符串
        {
            //在它之前的后移
            for(int i=index-1;i>=0;i--)
            {
                _member[i+1]=_member[i];
            }
            
            _member[0]=member;//新的头成员
            
            break;
        }
    }
    
    if(index<_length+1)//找到
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


//设置尾成员，在它之后的前移
- (BOOL)setTailMember:(id)member
{
    int index=0;
    
    for(;index<_length;index++)
    {
        if(_member[index] && _member[index]==member)//找到
        {
            //在它之后的前移
            for(int i=index;i<_length-1;i++)
            {
                _member[i]=_member[i+1];
            }
            
            _member[_length-1]=member;//新的尾成员
            
            break;
        }
        else if(_member[index] && [_member[index] isKindOfClass:[NSString class]] && [member isKindOfClass:[NSString class]] && [member isEqualToString:_member[index]])//字符串
        {
            //在它之后的前移
            for(int i=index;i<_length-1;i++)
            {
                _member[i]=_member[i+1];
            }
            
            _member[_length-1]=member;//新的尾成员
            
            break;
        }
    }
    
    if(index<_length+1)//找到
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


//删除数组成员，成功则返回YES
- (BOOL)deleteMember:(id)member
{
    int index=0;
    
    for(;index<_length;index++)
    {
        if(_member[index] && _member[index]==member)//找到
        {
            [_member[index] release];
            _member[index]=nil;
            
            //删除元素并前移数组
            for(int i=index;i<_length-1;i++)
            {
                _member[i]=_member[i+1];
            }
            
            _member[_length-1]=nil;//最后的成员赋空值
            
            _length--;
            
            break;
        }
        else if(_member[index] && [_member[index] isKindOfClass:[NSString class]] && [member isKindOfClass:[NSString class]] && [member isEqualToString:_member[index]])//字符串
        {
            [_member[index] release];
            _member[index]=nil;
            
            //删除元素并前移数组
            for(int i=index;i<_length-1;i++)
            {
                _member[i]=_member[i+1];
            }
            
            _member[_length-1]=nil;//最后的成员赋空值
            
            _length--;
            
            break;
        }
    }
    
    if(index<_length+1)//找到
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}


//是否包含数组成员
- (BOOL)hasMember:(id)member
{
    if(member)
    {
        if([self cacheIndexWithMember:member]>=0)//先从缓存中找
        {
            return YES;
        }
        
        for(int index=0;index<_length;index++)
        {
            if(_member[index] && _member[index]==member)//找到
            {
                return YES;
            }
            else if(_member[index] && [_member[index] isKindOfClass:[NSString class]] && [member isKindOfClass:[NSString class]] && [member isEqualToString:_member[index]])//字符串
            {
                return YES;
            }
        }
    }
    
    return NO;
}



//所有成员向前移动
- (void)forwardByStep:(int)step
{
    if(_length>0)
    {
        step=step%_length;
        
        if(step>0)
        {
            id *tmp=(id *)malloc(sizeof(id)*step);//临时变量数组
            
            for(int i=0;i<step;i++)//前step个成员移动到临时数组
            {
                tmp[i]=_member[i];
            }
            
            for(int i=0;i<_length-step;i++)//从0～length-step移动
            {
                _member[i]=_member[i+step];
            }
            
            for(int i=_length-step;i<_length;i++)//把临时数组的内容移动到成员数组末尾
            {
                _member[i]=tmp[i-_length+step];
            }
            
            
            free(tmp);//临时数组释放内存
            tmp=nil;
        }
    }
}


//所有成员向后移动
- (void)backwardByStep:(int)step
{
    if(_length>0)
    {
        step=step%_length;
        
        if(step>0)
        {
            id *tmp=(id *)malloc(sizeof(id)*step);//临时变量数组
            
            for(int i=_length-1;i>=_length-step;i--)//后step个成员移动到临时数组
            {
                tmp[step+i-_length]=_member[i];
            }
            
            for(int i=_length-1;i>=step;i--)//从length~step移动
            {
                _member[i]=_member[i-step];
            }
            
            for(int i=0;i<step;i++)//把临时数组的内容移动到成员数组开头
            {
                _member[i]=tmp[i];
            }
            
            
            free(tmp);//临时数组释放内存
            tmp=nil;
        }
    }
}



//获取index
- (int)indexWithMember:(id)member
{
    int index=[self cacheIndexWithMember:member];//先从缓存中找
    
    if(index>=0)
    {
        return index;
    }
    
    index=-1;
    
    //再逐个找
    for(int i=0;i<_length;i++)
    {        
        if(_member[i] && _member[i]==member)//找到
        {
            index=i;
            
            //放入索引缓存
            [self putCacheWithIndex:index];
            
            break;
        }
        else if(_member[i] && [_member[i] isKindOfClass:[NSString class]] && [member isKindOfClass:[NSString class]] && [member isEqualToString:_member[i]])//字符串
        {
            index=i;
            
            //放入索引缓存
            [self putCacheWithIndex:index];
        }
    }
    
    return index;
}



//从指定的位置左右两侧开始寻找成员的索引
- (int)indexWithMember:(id)member fromIndex:(int)index
{
    int idx=[self cacheIndexWithMember:member];//先从缓存中找
    
    if(idx>=0)
    {
        return idx;
    }
    
    if(index<0 || index>=_length)
    {
        index=0;
    }
    
    for(int l=index,r=index;l>=0 || r<_length;l--,r++)
    {
        if(l>=0)//左边
        {
            if(_member[l] && _member[l]==member)//找到
            {
                idx=l;
                
                //放入索引缓存
                [self putCacheWithIndex:idx];
                
                break;
            }
            else if(_member[l] && [_member[l] isKindOfClass:[NSString class]] && [member isKindOfClass:[NSString class]] && [member isEqualToString:_member[l]])//字符串
            {
                idx=l;
                
                //放入索引缓存
                [self putCacheWithIndex:idx];
                
                break;
            }
        }
        
        if(r<_length)//右边
        {            
            if(_member[r] && _member[r]==member)//找到
            {
                idx=r;
                
                //放入索引缓存
                [self putCacheWithIndex:idx];
                
                break;
            }
            else if(_member[r] && [_member[r] isKindOfClass:[NSString class]] && [member isKindOfClass:[NSString class]] && [member isEqualToString:_member[r]])//字符串
            {
                idx=r;
                
                //放入索引缓存
                [self putCacheWithIndex:idx];
                
                break;
            }
        }
    }
    
    return idx;
}


//获取第一个成员
- (id)firstMember
{
    if(_length>0)
    {
        return _member[0];
    }
    else
    {
        return nil;
    }
}


//获取最后一个成员
- (id)lastMember
{
    if(_length>0)
    {
        return _member[_length-1];
    }
    else
    {
        return nil;
    }
}


//获取前几个成员
- (instancetype)fristMembers:(int)count
{
    return [self subarrayToIndex:count];
}


//获取最后几个成员
- (instancetype)lastMembers:(int)count
{
    return [self subarrayFromIndex:_length-count];
}


//获取下一个成员
- (id)nextWithMember:(id)member
{
    id mem=nil;
    
    int index=[self indexWithMember:member];
    
    if(index>=0 && index<_length-1)
    {
        mem=_member[index+1];
    }
    
    return mem;
}


//获取上一个成员
- (id)previousWithMember:(id)member
{
    id mem=nil;
    
    int index=[self indexWithMember:member];
    
    if(index>0 && index<=_length-1)
    {
        mem=_member[index-1];
    }
    
    return mem;
}


//获取随机的成员
- (id)randomMember
{
    if(_length>0)
    {
        return _member[arc4random()%_length];
    }
    else
    {
        return nil;
    }
}


//数值最大的成员
- (id)biggestMember
{
    id biggest=nil;
    double max=CGFLOAT_MIN;
    
    for(int i=0;i<_length;i++)
    {
        if([_member[i] respondsToSelector:@selector(doubleValue)])
        {
            double value=[_member[i] doubleValue];
            
            if(value>max)
            {
                max=value;
                biggest=_member[i];
            }
        }
    }
    
    return biggest;
}


//数值最小的成员
- (id)smallestMember
{
    id smallest=nil;
    double min=CGFLOAT_MAX;
    
    for(int i=0;i<_length;i++)
    {
        if([_member[i] respondsToSelector:@selector(doubleValue)])
        {
            double value=[_member[i] doubleValue];
            
            if(value<min)
            {
                min=value;
                smallest=_member[i];
            }
        }
    }
    
    return smallest;
}


//成员求和(浮点数)
- (double)floatSumOfMembers
{
    double sum=0;
    
    for(int i=0;i<_length;i++)
    {
        if([_member[i] respondsToSelector:@selector(doubleValue)])
        {
            sum+=[_member[i] doubleValue];
        }
    }
    
    return sum;
}


//成员求和(整数)
- (long long int)integerSumOfMembers
{
    long long int sum=0;
    
    for(int i=0;i<_length;i++)
    {
        if([_member[i] respondsToSelector:@selector(longLongValue)])
        {
            sum+=[_member[i] longLongValue];
        }
    }
    
    return sum;
}


//根据range删除数组成员，成功则返回YES
- (BOOL)deleteFromRange:(NSRange)range
{
    //判断range的范围
    if((range.location-1+range.length)<_length)
    {
        //释放内存
        for(int i=(int)range.location;i<range.location+range.length;i++)
        {
            [_member[i] release];
        }
        
        //删除元素并前移数组
        for(int i=(int)range.location;i<_length-range.length;i++)
        {
            _member[i]=_member[i+range.length];
        }
        
        for(int i=_length-(int)range.length;i<_length;i++)
        {
            _member[i]=nil;//最后的成员赋空值
        }
        
        _length-=range.length;
        
        return YES;
    }
    else
    {
        return NO;
    }
    
}


//通过关键词排序
- (instancetype)sortByKey:(NSString *)key
{
    return [self sortByKeys:[KATArray arrayWithMembers:key,nil]];
}


//通过关键词数组排序
- (instancetype)sortByKeys:(KATArray<NSString *> *)keys
{
    if(keys && keys.length>0)
    {
        //索引树
        KATTreeMap *tree=[KATTreeMap treeMap];
        
        for(int i=0;i<_length;i++)
        {
            //索引
            NSMutableString *index=[NSMutableString string];
            
            BOOL hasProperty=YES;
            
            for(NSString *key in keys)
            {
                //属性数组
                KATArray<NSString *> *ps=[KATArray arrayWithString:key andSep:@"."];
                
                //要对比的属性
                id pv=_member[i];
                
                for(NSString *p in ps)//遍历属性
                {
                    if([@"self" isEqualToString:p])//本身
                    {
                        //不处理
                    }
                    else//属性
                    {
                        @try
                        {
                            if([pv isKindOfClass:[KATHashMap class]] || [pv isKindOfClass:[NSDictionary class]])//HashMap或字典
                            {
                                pv=pv[p];
                            }
                            else
                            {
                                //属性值(KVC)
                                pv=[pv valueForKey:p];
                            }
                        }
                        @catch(NSException *exception)
                        {
                            pv=nil;
                            break;
                        }
                        @finally
                        {
                            ;
                        }
                    }
                }
                
                if(pv)
                {
                    if([pv isKindOfClass:[NSString class]])//字符串类型
                    {
                        [index appendString:[NSString stringWithFormat:@"%@ ",pv]];
                    }
                    else if([pv isKindOfClass:[NSNumber class]])//数字类型
                    {
                        //一律转成double类型
                        double number=[pv doubleValue];
                        
                        const char *chs=[[NSString stringWithFormat:@"%lf",number] UTF8String];
                        
                        double bias=1.0;//增量，为了去除负数
                        int base=0;//位数
                        
                        for(int i=(number>=0.0?0:1);i<strlen(chs);i++)
                        {
                            char ch=chs[i];
                            
                            if(ch=='.')//遇到小数点则跳出
                            {
                                break;
                            }
                            
                            bias*=10.0;
                            base++;
                        }
                        
                        //判断正负数
                        if(number>=0)
                        {
                            base=1000+base;
                        }
                        else
                        {
                            base=1000-base;
                        }
                        
                        number+=bias;//消除负数
                        
                        [index appendString:[NSString stringWithFormat:@"%04i %.8lf ",base,number]];
                    }
                    else//其他类型
                    {
                        [index appendString:[NSString stringWithFormat:@"%lu ",(unsigned long)[pv hash]]];
                    }
                }
                else//不存在该属性，不参与排序
                {
                    hasProperty=NO;
                    
                    break;
                }
            }
            
            if(hasProperty)//存在属性
            {
                //最后补上对象的hashCode
                [index appendString:[NSString stringWithFormat:@"%lu ",(unsigned long)[_member[i] hash]]];
                
                tree[index]=_member[i];
            }
        }
                
        return [tree allValues];
    }
    
    return nil;
}


//多条件筛选
- (instancetype)filterWithRelationshipOR:(BOOL)OR andConditions:(KATArray<NSString *> *)conditions
{
    KATArray<KATArrayCondition *> *conditionArray=[self parseConditions:conditions];
    
    if(conditionArray && conditionArray.length>0)
    {
        KATArray *result=[KATArray arrayWithCapacity:_length];
        
        for(int i=0;i<_length;i++)
        {
            //条件
            for(int j=0;j<conditionArray.length;j++)
            {
                KATArrayCondition *condition=conditionArray[j];
                
                //属性数组
                KATArray<NSString *> *ps=[KATArray arrayWithString:condition.property andSep:@"."];
                
                //要对比的属性
                id pv=_member[i];
                
                for(NSString *p in ps)//遍历属性
                {
                    if([@"self" isEqualToString:p])//本身
                    {
                        //不处理
                    }
                    else//属性
                    {
                        @try
                        {
                            if([pv isKindOfClass:[KATHashMap class]] || [pv isKindOfClass:[NSDictionary class]])//HashMap或字典
                            {
                                pv=pv[p];
                            }
                            else
                            {
                                //属性值(KVC)
                                pv=[pv valueForKey:p];
                            }
                        }
                        @catch(NSException *exception)
                        {
                            pv=nil;
                            break;
                        }
                        @finally
                        {
                            ;
                        }
                    }
                }
                
                if(pv)
                {
                    //要对比的数值
                    id vv=condition.value;
                    
                    //数值以&开头则作为属性名
                    if([(NSString *)vv hasPrefix:@"&"])
                    {
                        vv=_member[i];
                        
                        //属性数组(去掉&)
                        KATArray<NSString *> *vs=[KATArray arrayWithString:[condition.value substringFromIndex:1] andSep:@"."];
                        
                        for(NSString *v in vs)//遍历属性
                        {
                            if([@"self" isEqualToString:v])//本身
                            {
                                //不处理
                            }
                            else//属性
                            {
                                @try
                                {
                                    if([vv isKindOfClass:[KATHashMap class]] || [vv isKindOfClass:[NSDictionary class]])//HashMap或字典
                                    {
                                        vv=vv[v];
                                    }
                                    else
                                    {
                                        //属性值(KVC)
                                        vv=[vv valueForKey:v];
                                    }
                                }
                                @catch(NSException *exception)
                                {
                                    vv=nil;
                                    break;
                                }
                                @finally
                                {
                                    ;
                                }
                            }
                        }
                    }
                    else if([(NSString *)vv hasSuffix:@"\\&"])//\&开头则视为普通字符串&
                    {
                        vv=[(NSString *)vv substringFromIndex:1];
                    }
                    
                    if(vv)
                    {
                        //是否满足条件
                        BOOL fitness=NO;
                        
                        if([pv isKindOfClass:[NSNumber class]])//数字类型
                        {
                            double ori=[pv doubleValue];
                            double value=0;
                            
                            if([vv respondsToSelector:@selector(doubleValue)])
                            {
                                value=[vv doubleValue];
                            }
                            
                            if([condition.operator isEqualToString:@"=="] || [condition.operator isEqualToString:@"="])
                            {
                                if(fabs(ori-value)<=0.0000001)
                                {
                                    fitness=YES;
                                }
                            }
                            else if([condition.operator isEqualToString:@"!="])
                            {
                                if(fabs(ori-value)>0.0000001)
                                {
                                    fitness=YES;
                                }
                            }
                            else if([condition.operator isEqualToString:@">="])
                            {
                                if(fabs(ori-value)<=0.0000001 || ori>=value)
                                {
                                    fitness=YES;
                                }
                            }
                            else if([condition.operator isEqualToString:@"<="])
                            {
                                if(fabs(ori-value)<=0.0000001 || ori<=value)
                                {
                                    fitness=YES;
                                }
                            }
                            else if([condition.operator isEqualToString:@">"])
                            {
                                if(ori>value)
                                {
                                    fitness=YES;
                                }
                            }
                            else if([condition.operator isEqualToString:@"<"])
                            {
                                if(ori<value)
                                {
                                    fitness=YES;
                                }
                            }
                        }
                        else if([pv isKindOfClass:[NSString class]])//字符串类型
                        {
                            NSComparisonResult compare=NSOrderedSame;
                            
                            if([vv isKindOfClass:[NSString class]])
                            {
                                compare=[pv compare:vv];
                            }
                            else if([vv respondsToSelector:@selector(description)])
                            {
                                compare=[pv compare:[vv description]];
                            }
                            else
                            {
                                break;
                            }
                            
                            if([condition.operator isEqualToString:@"=="] || [condition.operator isEqualToString:@"="])
                            {
                                if(compare==NSOrderedSame)
                                {
                                    fitness=YES;
                                }
                            }
                            else if([condition.operator isEqualToString:@"!="])
                            {
                                if(compare!=NSOrderedSame)
                                {
                                    fitness=YES;
                                }
                            }
                            else if([condition.operator isEqualToString:@">="])
                            {
                                if(compare==NSOrderedSame || compare==NSOrderedDescending)
                                {
                                    fitness=YES;
                                }
                            }
                            else if([condition.operator isEqualToString:@"<="])
                            {
                                if(compare==NSOrderedSame || compare==NSOrderedAscending)
                                {
                                    fitness=YES;
                                }
                            }
                            else if([condition.operator isEqualToString:@">"])
                            {
                                if(compare==NSOrderedDescending)
                                {
                                    fitness=YES;
                                }
                            }
                            else if([condition.operator isEqualToString:@"<"])
                            {
                                if(compare==NSOrderedAscending)
                                {
                                    fitness=YES;
                                }
                            }
                        }
                        
                        if(fitness)//满足条件
                        {
                            if(OR)//或关系
                            {
                                [result put:_member[i]];
                                
                                break;
                            }
                            else//与关系
                            {
                                if(j==conditionArray.length-1)//满足最后一个条件则算满足
                                {
                                    [result put:_member[i]];
                                }
                            }
                        }
                        else
                        {
                            if(!OR)//与关系,不符合则直接跳出
                            {
                                break;
                            }
                        }
                    }
                    else//不存在属性
                    {
                        if(!OR)//与关系,不符合则直接跳出
                        {
                            break;
                        }
                    }
                }
            }
        }
        
        return result;
    }
    
    return nil;
}


//筛选
- (instancetype)filterWithCondition:(NSString *)condition
{
    if(condition && condition.length>1)
    {
        KATArray<KATArray *> *resultArray=[KATArray array];//结果集
        
        KATArray<NSString *> *orConditions=[KATArray arrayWithString:condition andSep:@"||"];//OR关系的条件
        
        for(NSString *andCondition in orConditions)//解析OR关系条件中的AND关系条件
        {
            [resultArray put:[self filterWithRelationshipOR:NO andConditions:[KATArray arrayWithString:andCondition andSep:@"&&"]]];
        }
        
        return [KATArray unionWithArrays:resultArray];
    }
    
    return nil;
}


//解析筛选条件
- (KATArray<KATArrayCondition *> *)parseConditions:(KATArray<NSString *> *)conditions
{
    if(conditions && conditions.length>0)
    {
        KATArray<KATArrayCondition *> *conditionArray=[KATArray arrayWithCapacity:conditions.length];
        
        for(NSString *condition in conditions)
        {
            //去掉空格
            condition=[condition stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            if(condition.length>1)
            {
                NSString *property=nil;
                NSString *operator=nil;
                NSString *value=nil;
                
                NSRange range=NSMakeRange(0, 0);
                
                //搜索操作符
                KATArray<NSString *> *opts=[KATArray arrayWithMembers:@"==",@">=",@"<=",@">",@"<",@"!=",@"=",nil];
                
                for(NSString *opt in opts)
                {
                    range=[condition rangeOfString:opt];
                    
                    if(range.length==opt.length)//找到
                    {
                        operator=opt;
                        
                        break;
                    }
                }
                
                if(operator)
                {
                    //属性
                    property=[condition substringToIndex:range.location];
                
                    //比较值
                    value=[condition substringFromIndex:range.location+range.length];
                    
                    if(property && property.length>0 && value && value.length>0)
                    {
                        //生成条件
                        KATArrayCondition *cd=[[[KATArrayCondition alloc] init] autorelease];
                        cd.property=property;
                        cd.operator=operator;
                        cd.value=value;
                        
                        //保存结果
                        [conditionArray put:cd];
                    }
                }
            }
        }
        
        return conditionArray;
    }
    
    return nil;
}



//数组反序
- (instancetype)reverse
{
    id tmp=nil;
    
    for(int i=0;i<_length/2;i++)
    {
        tmp=_member[_length-1-i];
        _member[_length-1-i]=_member[i];
        _member[i]=tmp;
    }
    
    tmp=nil;
    
    return self;
}


//数组排序，如果类型不一样则会发生错误
- (void)sort
{
    idQuickSort(_member,0,_length-1);
//    idBubbleSort(_member,_length);
}


#pragma mark - 排序算法

//快速排序
void idQuickSort(id arr[],int s,int e)
{
    if(s<e)
    {
        int m=idPartion(arr,s,e);//交换，得到中间位置
        
        idQuickSort(arr,s,m-1);//左边部分排序
        
        idQuickSort(arr,m+1,e);//右边部分排序
    }
}


int idPartion(id arr[],int s,int e)
{
    //rand
//    srand((unsigned)time( NULL));//随机数种子
//    int k=rand()%(e-s+1)+s;//随机产生数组下标，得到需要比较的数字
    int k=(e-s)/2+s;//中间数为需要比较的数字
    
    id key=arr[k];//存放需要比较的数字
    
    //将要比较的数存放在第一个位置
    arr[k]=arr[s];
    arr[s]=key;
    
    
    //    int tmp;//交换用的临时变量
    
    while(s<e)
    {
        while(s<e)
        {
            //寻找右边比tmp小的数
            if([arr[e] compare:key]==NSOrderedAscending)
            {
                arr[s]=arr[e];
                
                break;
            }
            else
            {
                e--;
            }
        }
        
        while(s<e)
        {
            //寻找左边比tmp大的数
            if([arr[s] compare:key]==NSOrderedDescending)
            {
                arr[e]=arr[s];
                
                break;
            }
            else
            {
                s++;
            }
            
        }
        
    }
    
    arr[e]=key;
    
    return e;
}


//冒泡排序
void idBubbleSort(id arr[],int length)
{
    BOOL flag=NO;
    
    id tmp;
    int j;
    
    for(int i=0;i<length;i++)
    {
        flag=YES;
        
        for (j=length-1;j>i;j--)
        {
            if([arr[j] compare:arr[j-1]]==NSOrderedAscending)  ///<arr[j-1])
            {
                tmp=arr[j-1];
                arr[j-1]=arr[j];
                arr[j]=tmp;
                
                flag=NO;
            }
        }
        
        if(flag)
        {
            break;
        }
    }
}


//清空数组
- (void)clear
{
    for(int i=0;i<_length;i++)
    {
        [_member[i] release];
        _member[i]=nil;
    }
    
    _length=0;
}


//数组乱序洗牌
- (instancetype)shuffle
{
    //让每个成员进行一次随机交换位置
    for(int i=0;i<_length;i++)
    {
        int p=arc4random()%_length;//随机交换的位置
        
        [self changePositionWithIndexA:i andIndexB:p];
    }
    
    //二次随机换位置
    for(int i=_length-1;i>=0;i--)
    {
        int p=arc4random()%_length;//随机交换的位置
        
        [self changePositionWithIndexA:i andIndexB:p];
    }
    
    return self;
}


//是否已经存满
- (BOOL)isFull
{
    if(_length<_capacity)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}


//转化成NSMutableArray
- (NSMutableArray *)getNSMutableArray
{
    NSMutableArray *array=[[[NSMutableArray alloc] init] autorelease];
    
    for(int i=0;i<_length;i++)
    {
        id value=_member[i];
        
        if([value isKindOfClass:[KATArray class]])//数组
        {
            value=[(KATArray *)value getNSMutableArray];
        }
        else if([value isKindOfClass:[KATHashMap class]])//Map
        {
            value=[(KATHashMap *)value getNSMutableDictionary];
        }
        
        [array addObject:value];
    }
    
    return array;
}


//保存到NSUserDefault
- (void)saveToUserDefaults:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:[[KATHashMap hashMapWithObject:self] getNSMutableDictionary] forKey:key];
}


//转化成字符串(带分隔符)
- (NSString *)stringWithSep:(NSString *)sep
{
    if(!sep)
    {
        sep=@"";
    }
    
    NSMutableString *string=[NSMutableString string];
    
    for(int i=0;i<_length;i++)
    {
        if(i==_length-1)
        {
            [string appendFormat:@"%@",_member[i]];
        }
        else
        {
            [string appendFormat:@"%@%@",_member[i],sep];
        }
    }
    
    return string;
}



#pragma mark - 重载方法


//带下标的方式获取数组成员
- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
    return [self get:(int)idx];
}


//带下标的方式设置数组成员
- (void)setObject:(id)anObject atIndexedSubscript:(NSUInteger)index
{
    if(index<_length)
    {
        [self set:anObject withIndex:(int)index];
    }
    else if(index==_length)
    {
        [self put:anObject];
    }
}


//快速枚举
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id  _Nullable [])buffer count:(NSUInteger)len
{
    if(state->state==0)
    {
        state->mutationsPtr=(unsigned long *)self;
        state->itemsPtr=_member;
        state->state=1;
        
        return _length;
    }
    else
    {
        return 0;
    }
}


//缓存索引数据
- (NSString *)cacheIndex
{
    NSMutableString *ms=[NSMutableString stringWithFormat:@"KATArray_Cache: len=%i \n{\n",ARRAY_CACHE_LENGTH];
    
    for(int i=0;i<ARRAY_CACHE_LENGTH;i++)
    {
        [ms appendFormat:@"   [%i] %i\n",i,_cache[i]];
    }
    
    [ms appendString:@"}"];
    
    return ms;
}


//描述
- (NSString *)description
{
    if(!_member)
    {
        return @"Null Array";
    }
    
    if(_isJsonDescription)//Json格式的描述
    {
        NSMutableString *ms=[NSMutableString stringWithFormat:@"\n[\n"];
        
        for(int i=0;i<_length;i++)
        {
            if([_member[i] isKindOfClass:[NSString class]])//string类型的带引号
            {
                [ms appendFormat:@"  \"%@\"",_member[i]];
            }
            else
            {
                if([_member[i] isKindOfClass:[KATArray class]])//数组
                {
                    ((KATArray *)_member[i]).isJsonDescription=YES;
                    
                    [ms appendFormat:@"  %@",_member[i]];
                }
                else if([_member[i] isKindOfClass:[KATHashMap class]])//字典
                {
                    ((KATHashMap *)_member[i]).isJsonDescription=YES;
                    
                    [ms appendFormat:@"  %@",_member[i]];
                }
                else if([_member[i] isKindOfClass:[NSNumber class]])//数字
                {
                    //不处理
                    [ms appendFormat:@"  %@",_member[i]];
                }
                else if([_member[i] isKindOfClass:[NSValue class]] || [_member[i] isKindOfClass:[NSData class]])//数据
                {
                    //加引号
                    [ms appendFormat:@"  \"%@\"",_member[i]];
                }
                else//其他
                {
                    //转换成HashMap
                    KATHashMap *map=[KATHashMap hashMapWithObject:_member[i]];
                    map.isJsonDescription=YES;
                    
                    [ms appendFormat:@"  %@",map];
                }
                
            }
            
            if(i<_length-1)
            {
                [ms appendFormat:@" ,\n"];
            }
            else
            {
                [ms appendFormat:@" \n"];
            }
        }
        
        [ms appendString:@"]"];
        
        return ms;
    }
    else
    {
        NSMutableString *ms=[NSMutableString stringWithFormat:@"KATArray: cap=%i, len=%i \n{\n",_capacity,_length];
        
        for(int i=0;i<_length;i++)
        {
            [ms appendFormat:@"   [%i] %@\n",i,_member[i]];
        }
        
        [ms appendString:@"}"];
        
        return ms;
    }
}


//数组复制（数组成员指向的对象地址还是同一个）
- (instancetype)copyWithZone:(NSZone *)zone
{
    KATArray *array=[[[self class] allocWithZone:zone] init];
    
    [array initData:_capacity];
    
    array.isJsonDescription=_isJsonDescription;
    array.autoExpand=_autoExpand;
    array.length=_length;
    
    id *p=[array member];//获取成员指针
    
    for(int i=0;i<_length;i++)
    {
        p[i]=[_member[i] retain];
    }
    
    //复制缓存
    int *c=[array cache];
    
    for(int i=0;i<ARRAY_CACHE_LENGTH;i++)
    {
        c[i]=_cache[i];
    }
    
    return array;
}


//内存释放
- (void)dealloc
{
    for(int i=0;i<_length;i++)
    {
        [_member[i] release];
        _member[i]=nil;
    }
    
    free(_member);
    _member=nil;
    
    free(_cache);
    _cache=nil;
    
//    NSLog(@"KATArray(%i/%i) is dealloc",_length,_capacity);
    
    [super dealloc];
}



@end
